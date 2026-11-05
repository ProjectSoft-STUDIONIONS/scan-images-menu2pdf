'use strict';

const fs = require('fs');
const path = require('path');
const pack = require('./package.json');

const ISS_DIR = path.join(__dirname, 'inno_setup');
const FILES_OUT = path.join(ISS_DIR, 'files.iss');

// Что пакуем: папки (рекурсивно) и отдельные файлы, пути от корня проекта
console.log(pack.version);
const SOURCES = [...fs.readdirSync('node_modules').filter(file => {
			return file != 'innosetup';
		}).map(file => {
			return path.join('node_modules', file);
		}),
		...fs.readdirSync('modules').map(file => {
			return path.join('modules', file);
		})
	],
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
		console.warn('[WARN] Не найден, пропущен:', src);
		continue;
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
	entries.join('\r\n') + '\r\n'
);
console.log('Список файлов: %s (%d записей)', FILES_OUT, entries.length);
