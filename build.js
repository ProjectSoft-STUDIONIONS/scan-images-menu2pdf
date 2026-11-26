const fs = require('fs'),
		{ normalize, join } = require('path'),
		{ unlink } = require('fs/promises'),
		{ spawn } = require('child_process'),
	compileProgramm = function() {
		return new Promise(function(resolve, reject){
			let app = `csc.exe`,
				args = [
					`/win32icon:${join(__dirname, "app", "favicon.ico")}`,
					`/resource:${join(__dirname, "app", "programm.resource")}`,
					`/out:bin\\scanmenu2pdf.exe`,
					`/win32manifest:${join(__dirname, "app", "app.manifest")}`,
					`/target:exe`,
					`${join(__dirname, "app", "img_menu2pdf.cs")}`,
					`${join(__dirname, "app", "AssemblyInfo.cs")}`
				],
				ls = spawn( app, args );
			ls.stdout.on('data', (data) => {});
			ls.stderr.on('data', (data) => { reject(data); });
			ls.on('close', (code) => {
				if(code == 0){
					//console.log(`Compiled: scanmenu2pdf.exe`);
					resolve(`Compiled: scanmenu2pdf.exe`);
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
					`/win32icon:${join(__dirname, "modules", "playbeep", "windows", "playbeep.ico")}`,
					`/resource:${join(__dirname, "modules", "playbeep", "windows", "playbeep.resource")}`,
					`/out:modules\\playbeep\\playbeep.exe`,
					`/win32manifest:${join(__dirname, "modules", "playbeep", "windows", "playbeep.manifest")}`,
					`/target:exe`,
					`${join(__dirname, "modules", "playbeep", "windows", "playbeep.cs")}`,
					`${join(__dirname, "modules", "playbeep", "windows", "AssemblyInfo.cs")}`
				],
				ls = spawn( app, args );
			ls.stdout.on('data', (data) => { });
			ls.stderr.on('data', (data) => { reject(data); });
			ls.on('close', (code) => {
				if(code == 0){
					// console.log(`Compiled: playbeep.exe`);
					resolve(`Compiled: playbeep.exe`);
				}else{
					reject(`Error: csc.exe ${args.join(' ')}`);
				}
			});
		});
	};

// Понеслась
[
	// Компилируем программу programm.exe
	compileProgramm,
	// Компилируем playbeep.exe для модуля playbeep
	compilePlayBeep
]
.reduce((previousPromise, nextFunction) => previousPromise.then(text => {
	text && console.log(text);
	return nextFunction(); 
}), Promise.resolve())
.then((text) => {
	console.log(text);
	console.log('End Build.');
}).catch(e => console.error('Build failed:', e));
