const fs = require('fs'),
		path = require('path'),
		{ unlink } = require('fs/promises'),
		{ spawn } = require('child_process'),
		colors = require('colors'),
		config = require('./package.json'),
	normalize = function(args) {
		return path.normalize(path.join.apply(null, args));
	},
	compile = function() {
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
	};

(async function(){
	compile().then(async function(data_a){
		console.log(data_a);
	}).catch(async function(error){
		console.log(error);
	});
})();
