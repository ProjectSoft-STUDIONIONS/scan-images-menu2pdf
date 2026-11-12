const fs = require('fs'),
		path = require('path'),
		{ unlink } = require('fs/promises'),
		{ spawn } = require('child_process'),
		colors = require('colors'),
		config = require('./package.json'),
	normalize = function(args) {
		return path.normalize(path.join.apply(null, args));
	},
	compileProgramm = function() {
		return new Promise(function(resolve, reject){
			let app = `csc.exe`,
				args = [
					`/win32icon:${normalize([__dirname, "app", "favicon.ico"])}`,
					`/resource:${normalize([__dirname, "app", "programm.resource"])}`,
					`/out:bin\\scanmenu2pdf.exe`,
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
					console.log(`Compiled: scanmenu2pdf.exe`);
					resolve();
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
					console.log(`Compiled: playbeep.exe`);
					resolve();
				}else{
					reject(`Error: csc.exe ${args.join(' ')}`);
				}
			});
		});
	};

// Понеслась
console.log(' ');
[
	// Компилируем программу programm.exe
	compileProgramm,
	// Компилируем playbeep.exe для модуля playbeep
	compilePlayBeep
]
.reduce((previousPromise, nextFunction) => previousPromise.then(nextFunction), Promise.resolve())
.then(() => {
	console.log(' ');
	console.log('End Build.');
}).catch(e => console.error('Build failed:', e));
