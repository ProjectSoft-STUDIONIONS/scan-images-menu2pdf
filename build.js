const fs = require('fs'),
		path = require('path'),
		{ unlink } = require('fs/promises'),
		{ spawn } = require('child_process'),
		config = require('./package.json'),
		author = config.author.split(" ")[0],
		app_manifest = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
	<assemblyIdentity version="${config.version}.0" name="${config.product}.app"/>
	<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">
		<security>
 			<requestedPrivileges xmlns="urn:schemas-microsoft-com:asm.v3">
				<requestedExecutionLevel level="asInvoker" uiAccess="false"/>
			</requestedPrivileges>
		</security>
	</trustInfo>
</assembly>`,
		assemblyinfo_cs = `using System.Reflection;

[assembly: AssemblyProduct("${config.product}")]
[assembly: AssemblyCompany("${author}")]
[assembly: AssemblyCopyright("Copyright © ${author} 2008 - all right reserved")]
[assembly: AssemblyTrademark("® ${author}")]
[assembly: AssemblyVersion("${config.version}.0")] 
[assembly: AssemblyFileVersion("${config.version}.0")]
[assembly: AssemblyTitle("${config.description} v${config.version}")]
[assembly: AssemblyDescription("${config.description} v${config.version}")]`,
	normalize = function(args) {
		return path.normalize(path.join.apply(null, args));
	},
	compile = function() {
		return new Promise(function(resolve, reject){
			let app = `csc.exe`,
				args = [
					`/win32icon:${normalize([__dirname, "app", "favicon.ico"])}`,
					`/resource:${normalize([__dirname, "app", "programm.resource"])}`,
					`/out:bin\\${config.product}.exe`,
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
					resolve(`Compiled ${config.product}.exe`);
				}else{
					reject('csc.exe ' + args.join(' '));
					reject(`Error ${config.product}.exe: ${code}`);
				}
			});
		});
	};

(async function(){
	let prg = normalize([__dirname, `${config.product}.exe`]);
	try { await unlink(`${normalize([__dirname, "app", "app.manifest"])}`); } catch (error) { }
	try { await unlink(`${normalize([__dirname, "app", "AssemblyInfo.cs"])}`); } catch (error) { }
	fs.writeFileSync(`${normalize([__dirname, "app", "app.manifest"])}`, app_manifest, {encoding: "utf8"});
	fs.writeFileSync(`${normalize([__dirname, "app", "AssemblyInfo.cs"])}`, assemblyinfo_cs, {encoding: "utf8"});
	try { await unlink(`${prg}`); } catch (error) { }
	compile().then(async function(data_a){
		console.log(data_a);
	}).catch(async function(error){
		console.log(error);
	});
})();
