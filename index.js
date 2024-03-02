(async function(){
	
	const argv = (() => {
			const args = {};
			process.argv.slice(2).map( (element) => {
				const matches = element.match( '--([a-zA-Z0-9-]+)(?:=(.*))?');
				if ( matches ){
					args[matches[1]] = matches[2]
						.replace(/^['"]/, '').replace(/['"]$/, '');
				}
			});
			return args;
		})(),
		fs = require('fs'),
		path = require('path'),
		colors = require('colors'),
		cliProgress = require('cli-progress'),
		{ spawn, exec } = require('child_process'),
		{ PDFDocument } =  require('pdf-lib'),
		dialogs =  require('./modules/dialogs/dialogs.js'),
		config = require('./package.json'),
		strLength = 40,
		fMenu = 'menu.json';

	config.description = config.description.trim();
	process.title = (process.title != config.description) ? config.description : process.title;

	require('events').EventEmitter.defaultMaxListeners = 15;

	let barPdf,
		locale = (Intl.DateTimeFormat().resolvedOptions().locale.match(/^(\w+)/) || ['ru'])[0],
		/**
		 * Дефолтный язык
		 * 
		 * После сохранения дефолтного языка в файл, перевод в файле language.ваша_локаль.json можно изменить.
		 * В данном блоке ничего нельзя менять. Это ДЕФОЛТ.
		 */
		langOld = {
			"start"                      : "ЗАПУСК",
			"error"                      : "Ошибка",
			"processing_will_end"        : "Обработка закончится через",
			"closing_in"                 : "Закрытие через",
			"generating_pdf_files"       : "Генерация PDF файлов",
			"directory_is_empty"         : "Директория пустая",
			"error_reading_json"         : "Ошибка при чтении JSON",
			"closing_the_program"        : "Закрытие программы",
			"completed_by_user"          : "Завершено пользователем",
			"selected_menu_type"         : "Выбранный тип меню",
			"selected_directory"         : "Выбранная директория",
			"selected_date"              : "Выбранная Дата",
			"deleting_pdf_files"         : "Удаляем содержимое директории с PDF файлами",
			"deleting_img_files"         : "Удаляем директорию с обработанными изображениями",
			"image_optimization"         : "Оптимизация изображений",
			"time_spent_in_seconds"      : "Затраченное время в секундах",
			"error_generating_pdf"       : "Ошибка при генерации PDF",
			"file_menu_error"            : "Файл `%s` поврежден или не существует",
			"error_close"                : "Для продолжения нажмите любую клавишу..."
		},

		langLoad = fs.existsSync(`./language.${Intl.DateTimeFormat().resolvedOptions().locale}.json`) ? require(`./language.${Intl.DateTimeFormat().resolvedOptions().locale}.json`) : langOld,
		indexStr = '',
		indexArr = [];

	const pad = argv["pad"] ? (parseInt(argv["pad"]) ? parseInt(argv["pad"]) : 4) : 4,
		log = function(...args) {
			console.log.apply(null, args);
		},
		timeRun = "0.00s",
		lang = Object.fromEntries(Object.entries(Object.assign(langOld, langLoad)).sort()),
		fsPromises = fs.promises,
		// Опции для создания прогресс бара
		optionsBar = {
			barsize: strLength - 2, // Длина прогресс бара в символах 
			autopadding: true, // Символы заполнения к отформатированному времени и процентам, чтобы обеспечить фиксированную ширину
			autopaddingChar: '000', // Последовательность символов, используемая для автозаполнения
			format: `  {bar}  ` + (`{percentage}% | {value}/{total} | {timeRun} | ${lang.processing_will_end}: {eta}s`).bold.yellow, // Шаблон прогресс бара
			barCompleteChar: '\u2588', // Символ для использования в качестве индикатора завершения
			barIncompleteChar: '\u2591', // Символ для использования в качестве индикатора незавершенности
			hideCursor: true, // Скрыть курсор
			emptyOnZero: true, // Отображать прогресс бара с итоговым значением, равным нулю (0), как пустые, а не полные
			forceRedraw: true // Запускать перерисовку в каждом кадре, даже если прогресс остается прежним
		},
		// Основная пауза закрытия 20 сек.
		pauseDelay = 20000,
		// На сколько сократить основную паузу при удачном завершении.
		// Не более значения pauseDelay.
		pauseAwait = 15000, // 20 сек. - 15 сек. = 5 сек.
		// На сколько сократить основную паузу при ошибке.
		// Не более значения pauseDelay.
		pauseError = 17000, // 20 сек. - 17 сек. = 3 сек.
		// Сепаратор в пути директории
		separator = function() {
			/**
			 * Сепаратор по умалчанию
			 */
			let sep = "/";
			switch (require(`os`).platform().toLowerCase().replace(/[0-9]/g, ``).replace(`darwin`, `macos`)) {
				case `win`:
					/**
					 * Сепаратор в Windows
					 */
					sep = "\\";
					break;
			}
			return sep;
		},
		closeDelay = function(ms, rtn = true) {
			if (rtn) {
				let value = 0,
					mms = Math.ceil(ms / 1000);
				barPdf = new cliProgress.Bar({
					barsize: strLength - 2,
					autopadding: true,
					autopaddingChar: '000',
					format: `  {bar}  ` + (`{percentage}% | ${lang.closing_in}: {eta}s/${mms}s`).bold.yellow,
					barCompleteChar: '\u2588',
					barIncompleteChar: '\u2591',
					hideCursor: true,
					emptyOnZero: true,
					forceRedraw: true
				});
				barPdf.start(mms, value);
				let inCal = setInterval(function(){
					value += 0.1;
					barPdf.update(value);
					if(value > mms){
						barPdf.terminal.cursor(true);
						barPdf.stop();
						clearInterval(inCal);
					}
				}, 100);
				return new Promise(resolve => setTimeout(resolve, ms + 1050));
			}
			return new Promise(resolve => setTimeout(resolve, ms));
		},
		emptyDir = function(dirPath) {
			let dirContents = fs.readdirSync(dirPath);
			for (let fileOrDirPath of dirContents) {
				try {
					let fullPath = path.join(dirPath, fileOrDirPath);
					let stat = fs.statSync(fullPath);
					if (stat.isDirectory()) {
						if (fs.readdirSync(fullPath).length) {
							emptyDir(fullPath);
						}
						fs.rmdirSync(fullPath);
					} else {
						fs.unlinkSync(fullPath);
					}
				} catch (ex) {
					console.error(ex.message);
				}
			}
		},
		start = function(){
			return new Promise(function(st_resolve, st_reject){
				let menuFile = path.normalize(path.join(__dirname, fMenu));
				var date,
					jsonPars,
					json,
					startTime, 
					endTime,
					jsonType = [],
					dir = '',
					typeMenu = false,
					mapsFiles;
				try{
					try {
						// Ошибка чтения
						json = fs.readFileSync(menuFile);
					}catch(ee){
						let arr = lang.file_menu_error.split('|');
						arr[0] = arr[0].bold.yellow;
						arr[1] = menuFile.bold.red;
						arr[2] = arr[2].bold.yellow;
						log(" ");
						log(arr.join(""));
						log(" ");
						log(lang.error_close);
						st_reject(" ");
						return;
					}
					// Ошибка парсинга
					jsonPars = JSON.parse(json);
					for(let jsn of jsonPars){
						if(jsn["name"]) {
							jsonType.push({"name": jsn["name"]});
						}
					}
				}catch(EX) {
					log(" ");
					log(lang.error_reading_json.bold.red);
					log(" ");
					log(lang.error_close);
					appClose();
					return;
				}
				
				const sp = separator();
				
				const openExplorerin = function(paths, callback) {
					var cmd = ``;
					switch (require(`os`).platform().toLowerCase().replace(/[0-9]/g, ``).replace(`darwin`, `macos`)) {
						case `win`:
							paths = paths || '=';
							paths = paths.replace(/\//g, `\\`).replace(/\\$/, ``);
							cmd = `explorer`;
								break;
							case `linux`:
								paths = paths || '/';
								cmd = `xdg-open`;
								break;
							case `macos`:
								paths = paths || '/';
								cmd = `open`;
								break;
						}
						let p = require(`child_process`).spawn(cmd, ['/e,','/root,', paths]);
						callback(p);
					},

					isDir = function(dir_read){
						return new Promise(function(resolve, reject){
							try {
								let stats = fs.lstatSync(dir_read);
								if (stats.isDirectory()) {
									resolve(true);
								}else{
									resolve(false);
								}
							}catch (e) {
								resolve(false);
							}
						});
					},

					readDirectory = function(dir_read){
						return new Promise(function(resolve, reject) {
							let files = fs.readdirSync(dir_read).filter(function(fn) {
									if(fn.endsWith('.jpg') || fn.endsWith('.jpeg') || fn.endsWith('.png') || fn.endsWith('.JPG') || fn.endsWith('.JPEG') || fn.endsWith('.PNG')){
										return true;
									}
									return false;
								});
							resolve(files);
						})
					},

					resize = function(input, output, width, height) {
						return new Promise(function(resolve, reject){
							let app = `convert`,
								args = [
									input,
									"-quality",
									"80",
									"-filter",
									"Lanczos",
									"-thumbnail",
									`${width}x`,
									output
								],
								ls = spawn(app, args);
							ls.stdout.on('data', (data) => {
								//log(`stdout: ${data}`);
							});

							ls.stderr.on('data', (data) => {
								//log(`stderr: ${data}`);
							});

							ls.on('close', (code) => {
								if(code == 0){
									resolve(output);
								}else{
									reject(code);
								}
							});
						});
					},
					pdfGenerator = function (outDir, imgs) {
						return new Promise(async function(resolve, reject){
							/**
							 * Если директория для PDF не существует - создать
							 */
							let pdfDirs = await isDir(outDir);
							let startsTime = (new Date()).getTime();
							if(!pdfDirs){
								fs.mkdirSync(outDir);
							}
							try {
								var files = await readDirectory(imgs);
								if(files.length){
									let tmpArray = jsonPars[typeMenu]["items"];
									let day;
									mapsFiles = [];
									/**
									 * created.
									 */
									//mapsFiles = jsonPars[typeMenu]["items"];
									indexArr.forEach(function(a, b, c){
										mapsFiles.push(tmpArray[parseInt(a)]);
									});
									/**
									 * done.
									 */
									let i = 0;
									// Кол-во файлов в файле PDF
									// Зависит от типа меню
									let c = jsonPars[typeMenu]["files"];
									const format = jsonPars[typeMenu]["format"];
									let k = 0;
									// Количество пунктов меню
									let f = mapsFiles.length;
									let pdfDoc;
									/**
									 * Прогресс PDF
									 */
									log(`${lang.generating_pdf_files}...`.bold.yellow);
									let progressPDfIndex = 0;
									let progressPdfTotal = parseInt(files.length / jsonPars[typeMenu]["files"]);
									barPdf = new cliProgress.Bar(optionsBar, cliProgress.Presets.shades_classic);
									barPdf.start(progressPdfTotal, progressPDfIndex);
									barPdf.update(progressPDfIndex, {
										timeRun: timeRun,
										eta: 0
									});
									/**
									 * Бежим по файлам
									 */
									for(let file of files){
										/**
										 * Формируем маску имени файла и директории файла
										 * Формат: dd-mm-yyyy
										 */
										let d = date.getDate(),
											m = date.getMonth() + 1,
											y = date.getFullYear(),
											dd = d < 10 ? `0${d}` : d;
										m = m < 10 ? `0${m}` : m;
										/**
										 * Формируем путь и имя файла
										 */
										// Имя директории
										let mask = `${dd}.${m}.${y}`,
											// Имя файла
											frm = format.replace("%d", dd).replace("%m", m).replace("%y", y),
											pdfFile = `${frm}${mapsFiles[k].sufix}.pdf`,
											/**
											 * Если директория не существует и multidir включен - создаём директорию
											 */
											pdfDir = await isDir(path.join(outDir, mask)),
											fImage = path.join(imgs, file),
											/**
											 * Читаем изображение в буффер
											 */
											image = await fs.readFileSync(fImage),
											ext = path.extname(file);
											
										ext = ext.toLowerCase();
										/**
										 * Если счётчик страниц на старте i == 0
										 * Создаём PDF документ 
										 */
										// Сделать сохранении в соответствии с индексами
										if(i == 0){
											
											if(!pdfDir && jsonPars[typeMenu]["multidir"]){
												fs.mkdirSync(path.join(outDir, mask));
											}
											pdfDoc = await PDFDocument.create();
										}
										/**
										 * Загружаем изображение в PDF файл
										 */
										let pdfImage;
										if(ext == '.jpg' || ext == '.jpeg'){
											pdfImage = await pdfDoc.embedJpg(image);
										}else if(ext == '.png'){
											pdfImage = await pdfDoc.embedPng(image);
										}
										if(pdfImage){
											/**
											 * Масштабируем страницу
											 * При сканировании страниц в формате 300dpi
											 * Изображение нужно уменьшить до ~ 27.44%  (1 - 0.2744)
											 * Приблизительно выставил 0.7
											 */
											let pdfDims = pdfImage.scale(0.7),
												/**
												 * Добавляем страницу по рамерам полученного изображения
												 */
												page = pdfDoc.addPage([pdfDims.width, pdfDims.height]);
											/**
											 * Рисуем изображение на странице
											 */
											page.drawImage(pdfImage, {
												x: 0,
												y: 0,
												width: pdfDims.width,
												height: pdfDims.height,
											});
										}
										/**
										 * Увеличиваем счётчик страниц
										 */
										++i;
										/**
										 * Если счётчик страниц в PDF равен установленному количеству
										 */
										if(i == c){
											/**
											 * Автор
											 * Создатель
											 * Продюсер
											 */
											/**
											 * Автор документа - откуда получили документ.
											 * Проще говоря, кто организовывает питание в школе
											 */
											pdfDoc.setAuthor(jsonPars[typeMenu]["author"]);
											/**
											 * Кто создаёт документ
											 * Проще говоря - это школа и т. п.
											 */
											pdfDoc.setProducer(jsonPars[typeMenu]["produser"]);
											/**
											 * Приложение, которое создаёт документ.
											 * Данную строчку по лицензии MIT удалять нельзя ни в коем случае!!!
											 * Производителем файла должна быть программа, которая является официальной версией!
											 * Мы сюда так же добавляем ссылку на библиотеку pdf-lib
											 */
											pdfDoc.setCreator("pdf-lib, ProjectSoft®");
											/**
											 * Заполнение метатегов документа
											 * Это обязательное действие.
											 **
											 * Заголовок
											 * Ключевые слова
											 * Тема (Описание)
											 */
											pdfDoc.setTitle(mapsFiles[k].title + " на " + mask);
											pdfDoc.setKeywords([mapsFiles[k].title + " на " + mask]);
											pdfDoc.setSubject(mapsFiles[k].title + " на " + mask);
											/**
											 * Время создания файла
											 * Время модификации файла
											 */
											pdfDoc.setCreationDate(new Date());
											pdfDoc.setModificationDate(new Date());
											/**
											 * Сохраняем
											 */
											let pdfBytes = await pdfDoc.save();
											/**
											 * Прогресс PDF
											 */
											++progressPDfIndex;
											let eta = parseFloat(((new Date()).getTime() - startsTime) / 1000).toFixed(2) + 's';
											barPdf.update(progressPDfIndex, {
												timeRun: eta
											});
											/**
											 * Пишем в файл
											 */
											/**
											 * Если multidir включен, то mask не меняет значение и директория создана
											 * Иначе оно пустое и файлы сохраняются в pdf директорию
											 */
											mask = !jsonPars[typeMenu]["multidir"] ? `` : `${mask}${sp}`;
											fs.writeFileSync(path.join(outDir, mask, pdfFile), pdfBytes);
											/**
											 * Без суффикса
											 */
											if(mapsFiles[k].saveNoSufix){
												pdfFile =  `${frm}.pdf`;
												fs.writeFileSync(path.join(outDir, mask, pdfFile), pdfBytes);
											}
											/**
											 * Увеличиваем счётчик типов меню
											 */
											++k;
											/**
											 * Если счётчик равен кол-ву типов меню
											 * Увеличиваем дату
											 * Счётчик обнуляем
											 */
											if(k == f){
												day = date.getDay();
												/**
												 * Если пятница - увеличиваем на 3 дня
												 * или увеличиваем на один (следующий день).
												 */
												if(day == 5){
													day = 3
												}else{
													day = 1;
												}
												k = 0;
												date.setDate(d + day);
											}
											i = 0;
											/**
											 * Для красоты
											 * Сделаем маленькую паузу без прогрессбара
											 */
											await closeDelay(25, false);
										}
									}
									barPdf.terminal.cursor(true);
									barPdf.stop();
									resolve();
								}else{
									reject(String(`${lang.directory_is_empty}:`).bold.red + " " + imgs);
								}
							}catch(e){
								reject(e);
							}
						});
					};

				let fileName = path.join(__dirname, 'menu.json');

				dialogs(fileName).then(async function(data){
					/**
					 * Запуск
					 */
					startTime = new Date().getTime();
					/**
					 * Проверить полученные данные
					 */
					try {
						data = JSON.parse(data);
					} catch(err_json){
						log(`${lang.error_reading_json}!`.bold.red);
						log(err_json);
						log(" ");
						log(`${lang.closing_the_program}...`.bold.yellow);
						log(" ");
						st_resolve(" ");
						return;
					}
					if(parseInt(data.typemenu) > -1 && data.directory != "None" && data.data.length) {
						typeMenu = parseInt(data.typemenu);
						dir = data.directory;
						/**
						 * Самый лучший вариант даты представленной как число.
						 * Преобразуем строку "1703289600", например, в число,
						 * обязательно умножив на 1000 (миллисекунды), 
						 * и применяем его в конструкторе даты
						 */
						let intDate = parseInt(data.data) * 1000;
						date = new Date(intDate);
						let day = date.getDay();
						if(day == 6){
							day = 2
						}else if(day == 0){
							day = 1;
						}else{
							day = 0
						}
						lang.selected_menu_type = (" ".repeat(strLength) + lang.selected_menu_type).slice(-strLength);
						lang.selected_directory = (" ".repeat(strLength) + lang.selected_directory).slice(-strLength);
						lang.selected_date      = (" ".repeat(strLength) + lang.selected_date).slice(-strLength);
						log(`${lang.selected_menu_type}: `.bold.yellow + jsonPars[typeMenu]["name"].bold.red);
						log(`${lang.selected_directory}: `.bold.yellow + dir.bold.red);
						log(`${lang.selected_date}: `.bold.yellow + date.toLocaleDateString().bold.red);
						log(" ");
						const resize_dir = path.join(dir, `opimization`),
							pdf_dir = path.join(dir, `pdf`);
						date.setDate(date.getDate() + day);
						indexStr = data.index;
						indexArr = indexStr.split(',');
						//log(indexArr);
						let is_dir = await isDir(dir);
						if(is_dir) {
							/**
							 * Ресайз изображения
							 * Каждодневное  меню width = 1134
							 * Десятидневное меню width = 1604
							 */
							readDirectory(dir).then(async function(images){
								if(await isDir(pdf_dir)){
									log(`${lang.deleting_pdf_files}`.bold.yellow);
									emptyDir(pdf_dir);
									log(" ");
								}
								/**
								 * Директория изображений
								 */
								if(await isDir(resize_dir)){
									log(`${lang.deleting_img_files}`.bold.yellow);
									fs.rmSync(resize_dir, { recursive: true, force: true });
									log(" ");
								}
								fs.mkdirSync(resize_dir);
								/**
								 * Ресайз изображений
								 * portrait     - книжная    (1130 x 1600)
								 * landscape    - альбомная  (1600 x 1130)
								 * по умолчанию - книжная    (1130 x 1600)
								 *
								 * Если надо добавить, то добавляем новые условия.
								 * Размер страниц PDF строится только от размера полученных изображений.
								 * Для изображений мы задаём только ширину страницы. Высота изменяется пропорционально.
								 * Но теперь в функции resize удалив параметр -thumbnaul и 
								 * раскомментировав аргументы для -thumbnail и последующие
								 * мы можем ресайзить под конкретные размеры.
								 * Может где-то пригодится...
								 */
								let sizeW, sizeH;
								switch(jsonPars[typeMenu]["size"]){
									case 'portrait':
										sizeW = 1130;
										sizeH = 1600;
										break;
									case 'landscape':
										sizeW = 1600;
										sizeH = 1130;
										break;
									default:
										sizeW = 1130;
										sizeH = 1600;
								}

								log(`${lang.image_optimization}...`.bold.yellow);
								/**
								 * Прогресс по изображениям
								 */
								let startsTime = (new Date()).getTime(),
									progressImgIndex = 0,
									progressImgTotal = images.length;
								barPdf = new cliProgress.Bar(optionsBar, cliProgress.Presets.shades_classic);
								barPdf.start(progressImgTotal, progressImgIndex);
								barPdf.update(progressImgIndex, {
									timeRun: timeRun,
									eta: 0
								});
								for(let image of images){
									++progressImgIndex;
									let inputFile = path.join(dir, image),
										ext = path.extname(image).toLowerCase(),
										outF = ("0".repeat(pad) + progressImgIndex).slice(-pad) + ext,
										outputFile = path.join(resize_dir, outF);
									await resize(inputFile, outputFile, sizeW, sizeH);
									/**
									 * Прогресс Изображений
									 */
									let eta = parseFloat(((new Date()).getTime() - startsTime) / 1000).toFixed(2) + 's';
									barPdf.update(progressImgIndex, {
										timeRun: eta
									});
								}
								barPdf.terminal.cursor(true);
								barPdf.stop();
								log(" ");
								/**
								 * Генерация PDF файлов
								 */
								pdfGenerator(pdf_dir, resize_dir).then(async function(str){
									// clear
									if(await isDir(resize_dir)){
										log(" ");
										log(`${lang.deleting_img_files}`.bold.yellow);
										fs.rmSync(resize_dir, { recursive: true, force: true });
									}
									endTime = new Date().getTime();
									let time = endTime - startTime;
									time = parseFloat(time / 1000).toFixed(2);
									lang.time_spent_in_seconds = (" ".repeat(strLength) + lang.time_spent_in_seconds).slice(-strLength);
									lang.open_file_explorer = (" ".repeat(strLength) + lang.open_file_explorer).slice(-strLength);
									log(" ");
									log((`${lang.time_spent_in_seconds}:`).bold.yellow + ' ' + (time + "s").bold.red);
									log(" ");
									log(`${lang.closing_the_program}...`.bold.yellow);
									log(" ");
									st_resolve(" ");
								}).catch(async function(err){
									log(" ");
									log(`${lang.error_generating_pdf}!`.bold.red);
									log(err);
									// clear
									if(await isDir(resize_dir)){
										log(`${lang.deleting_img_files}`.bold.yellow);
										fs.rmSync(resize_dir, { recursive: true, force: true });
									}
									log(" ");
									log(`${lang.closing_the_program}...`.bold.yellow);
									log(" ");
									st_resolve(" ");
								});
							}).catch(async function(err){
								log(" ");
								log(`${lang.error}!: ${dir}`.bold.red);
								log(err);
								// clear
								if(await isDir(resize_dir)){
									log(" ");
									log(`${lang.deleting_img_files}`.bold.yellow);
									fs.rmSync(resize_dir, { recursive: true, force: true });
								}
								log(" ");
								log(`${lang.closing_the_program}...`.bold.yellow);
								log(" ");
								st_resolve(" ");
							})
						}
					} else {
						log(" ");
						log(`${lang.completed_by_user}`.bold.yellow);
						log(" ");
						log(`${lang.closing_the_program}...`.bold.yellow);
						log(" ");
						st_resolve(" ");
					}
				}).catch(async function(error) {
					log(" ");
					log(`${lang.error}!`.bold.red);
					log(error);
					log(" ");
					log(`${lang.closing_the_program}...`.bold.yellow);
					log(" ");
					st_resolve(" ");
				});
			});
		};
	/**
	 * Перезапишем файл языка
	 */
	fs.writeFileSync(`./language.${locale}.json`, JSON.stringify(lang, null, "\t"), {encoding: "utf8"});
	/**
	 * Очищаем консоль
	 */
	// process.stdin.resume();
	// console.clear();
	/**
	 * Запускаем диалоги
	 */
	// Имя, версия
	log(" ");
	config.description = (" ".repeat(75) + config.description).slice(-75);
	log(config.description.bold.cyan + (' v' + config.version).bold.yellow);
	// Старт
	log(" ");
	lang.start = (" ".repeat(50) + lang.start).slice(-50);
	log(`${lang.start}...`.bold.yellow);
	log(" ");
	process.stdin.setRawMode(true);
	process.stdin.setEncoding('utf8');
	let ddr;
	start().then(async function(data) {
		log(data);
		process.stdin.setRawMode(false);
		process.stdin.pause();
		ddr = spawn( 'taskkill', [
			'/F',
			'/IM',
			'cmd.exe'
		]);
		await closeDelay(pauseDelay - pauseError);
		log(" ");
	}).catch(async function(error) {
		log(error);
		process.stdin.setRawMode(false);
		process.stdin.pause();
		ddr = spawn( 'taskkill', [
			'/F',
			'/IM',
			'cmd.exe' 
		]);
		await closeDelay(pauseDelay - pauseError);
		log(" ");
	});
})();