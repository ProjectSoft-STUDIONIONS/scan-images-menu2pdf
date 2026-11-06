/**
 * Генерация списка файлов files.iss для InnoSetup
 * Сюда попадут файлы из modules и node_modules
 * кроме директории innosetup
 */

'use strict';
const fs = require('fs');
const path = require('path');
const { exec, spawn } = require("child_process");
const innosetup = require('innosetup');
const pack = require('./package.json');

const ISS_DIR     = path.join(__dirname, 'inno_setup');
const FILES_OUT   = path.join(ISS_DIR, 'files.iss');
const VERSION_OUT = path.join(ISS_DIR, 'version.iss');

const normalize = function(args) {
	return path.normalize(path.join.apply(null, args));
},
compileFiles = () => {
	return new Promise((resolve, reject) => {
		// Что пакуем: папки (рекурсивно) и отдельные файлы, пути от корня проекта
		// Пройдём по директориям
		const SOURCES = [
				// Директория node_modules. Всё кроме innosetup
				...fs.readdirSync('node_modules')
					.filter(file => file != 'innosetup')
					.map(file => path.join('node_modules', file)),
				// Директория modules
				...fs.readdirSync('modules')
					.map(file => path.join('modules', file))
			],
			// Пройдём рекурсивно по субдиректориям и сформируем путь до файлов и директорий
			collectFiles = (target) => {
				const st = fs.statSync(target);
				if (st.isFile()) return [target];
				const out = [];
				for (const name of fs.readdirSync(target)) {
					out.push(...collectFiles(path.join(target, name)));
				}
				return out;
			},
			entries = [];
			for (const src of SOURCES) {
			const abs = path.join(__dirname, src);
			if (!fs.existsSync(abs)) {
				//console.warn('[WARN] Не найден, пропущен:', src);
				// Это ошибка. Завершаем
				return reject(`[ERROR] Не найден, пропущен: ${src}`);
			}
			for (const file of collectFiles(abs)) {
				const rel = path.relative(__dirname, file); // напр. bin\modules\foo.js
				const dir = path.dirname(rel);
				const dest = dir === '.' ? '{app}' : '{app}\\' + dir;
				entries.push(`Source: "..\\${rel}"; DestDir: "${dest}"; Flags: ignoreversion`);
			}
		}
		fs.writeFileSync(
			FILES_OUT,
			'; Автогенерируется compile.js — не редактировать вручную\r\n' +
			entries.join('\r\n') + '\r\n',
			{encoding: 'utf8'}
		);
		fs.writeFileSync(
			VERSION_OUT,
			`#define MyAppVersion "${pack.version.split('.').slice(0, -1).join('.')}"\n`,
			{encoding: 'utf8'}
		)
		resolve(`Список файлов: ${FILES_OUT} (${entries.length} записей)`);
	});
},
compileProgramm = function() {
	return new Promise(function(resolve, reject){
		let app = `csc.exe`,
			args = [
				`/win32icon:${normalize([__dirname, "app", "favicon.ico"])}`,
				`/resource:${normalize([__dirname, "app", "programm.resource"])}`,
				`/out:bin\\programm.exe`,
				`/win32manifest:${normalize([__dirname, "app", "app.manifest"])}`,
				`/target:exe`,
				`${normalize([__dirname, "app", "img_menu2pdf.cs"])}`,
				`${normalize([__dirname, "app", "img_ini.cs"])}`,
				`${normalize([__dirname, "app", "AssemblyInfo.cs"])}`
			],
			ls = spawn( app, args );
		ls.stdout.on('data', (data) => {});
		ls.stderr.on('data', (data) => { reject(data); });
		ls.on('close', (code) => {
			if(code == 0){
				resolve(`Compiled: programm.exe`);
			}else{
				reject(`Error: csc.exe ${args.join(' ')}`);
			}
		});
	});
},
compilePlayBeep = () => {
	return new Promise(function(resolve, reject){
		let app = `csc.exe`,
			args = [
				`/win32icon:${path.join(__dirname, "modules", "playbeep", "windows", "playbeep.ico")}`,
				`/resource:${path.join(__dirname, "modules", "playbeep", "windows", "playbeep.resource")}`,
				`/out:modules\\playbeep\\playbeep.exe`,
				`/win32manifest:${path.join(__dirname, "modules", "playbeep", "windows", "playbeep.manifest")}`,
				`/target:exe`,
				`${path.join(__dirname, "modules", "playbeep", "windows", "playbeep.cs")}`,
				`${path.join(__dirname, "modules", "playbeep", "windows", "AssemblyInfo.cs")}`
			],
			ls = spawn( app, args );
		ls.stdout.on('data', (data) => { });
		ls.stderr.on('data', (data) => { reject(data); });
		ls.on('close', (code) => {
			if(code == 0){
				resolve(`Compiled: playbeep.exe`);
			}else{
				reject(`Error: csc.exe ${args.join(' ')}`);
			}
		});
	});
},
execDownload = () => {
	return new Promise((resolve, reject) => {
		const child = exec(path.join(ISS_DIR, 'node-download.bat'), {cwd: ISS_DIR});
		child.stdout.on('data', data => {
			process.stdout.write(data); // можно выводить сразу в консоль
		});
		child.stderr.on('data', data => {
			process.stderr.write(data);
		});
		child.on('error', reject);
		child.on('close', code => {
			if (code === 0) {
				resolve();
			} else {
				reject(new Error(`Команда завершилась с кодом ${code}`));
			}
		});
	});
},
execInnoSetup = () => {
	return new Promise((resolve, reject) => {
		// Запустить InnoSetup
		innosetup(path.join(ISS_DIR, 'ConvertMenu2pdf_setup.iss'), {
			verbose: true,
			colors: true,
			arch: 'x64'
		})
			.then(() => resolve('Compile: ConvertMenu2pdf_setup.exe'))
			.catch(e => reject(e));
	})
};

// Понеслась
[
	// Компилируем программу programm.exe
	compileProgramm,
	// Компилируем playbeep.exe для модуля playbeep
	compilePlayBeep,
	// Обновляем nodejs установщик node-x64.msi
	execDownload,
	// Подготавливаем данные для сценария ConvertMenu2pdf_setup.iss
	compileFiles,
	// Запускаем сборку ConvertMenu2pdf_setup.iss установщика
	execInnoSetup
]
	.reduce((previosPromise, nextFunction) => {
		return previosPromise.then(nextFunction);
	}, Promise.resolve())
	.then(result => {
		console.log(result);
	});
