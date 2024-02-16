const fs = require('fs'),
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
[assembly: AssemblyTitle("${config.description}")]
[assembly: AssemblyDescription("${config.description}")]`,
	compile = function(input, output, width, height) {
		return new Promise(function(resolve, reject){
			let app = `csc.exe`,
				args = [
					"/win32icon:favicon.ico",
					"/resource:programm.resource",
					"/out:" + config.product + ".exe",
					"/win32manifest:app.manifest",
					"/target:exe",
					"img_menu2pdf.cs",
					"img_ini.cs",
					"AssemblyInfo.cs"
				],
				ls = spawn( app, args );
			ls.stdout.on('data', (data) => {});
			ls.stderr.on('data', (data) => { reject(data); });
			ls.on('close', (code) => {
				if(code == 0){
					resolve("Compiled programm.exe");
				}else{
					reject(code);
				}
			});
		});
	};

(async function(){
	try { await unlink(`./app.manifest`); } catch (error) { }
	try { await unlink(`./AssemblyInfo.cs`); } catch (error) { }
	fs.writeFileSync(`./app.manifest`, app_manifest, {encoding: "utf8"});
	fs.writeFileSync(`./AssemblyInfo.cs`, assemblyinfo_cs, {encoding: "utf8"});
	try { await unlink(`./${config.product}.exe`); } catch (error) { }
	compile().then((data) => {
		console.log("successfully compiled");
	}).catch((error) => {
		console.log(error);
	});
})();
