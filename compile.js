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

const compileFiles = () => {
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
			entries = ['; Автогенерация files.iss — не редактировать вручную'];
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
			entries.push(``);
		fs.writeFileSync(
			FILES_OUT,
			entries.join('\n'),
			{encoding: 'utf8'}
		);
		fs.writeFileSync(
			VERSION_OUT,
			`#define MyAppVersion "${pack.version.split('.').slice(0, -1).join('.')}"\n`,
			{encoding: 'utf8'}
		);
		console.log(` `);
		console.log(`Список файлов: ${FILES_OUT} (${entries.length} записей)`);
		console.log(` `);
		resolve();
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
console.log(' ');
[
	// Обновляем nodejs установщик node-x64.msi
	execDownload,
	// Подготавливаем данные для сценария ConvertMenu2pdf_setup.iss
	compileFiles,
	// Запускаем сборку ConvertMenu2pdf_setup.iss установщика
	execInnoSetup
]
.reduce((previousPromise, nextFunction) => previousPromise.then(nextFunction), Promise.resolve())
.then(result => {
	console.log(result);
});
