const path = require('path'),
	InnoSetup = require("innosetup-compiler"),
	normalize = function(args) {
		return path.normalize(path.join.apply(null, args));
	},
	iss = normalize([__dirname, "inno_setup", "ConvertMenu2pdf_setup.iss"]);
InnoSetup(iss, {
	gui: false,
	verbose: true,
}).then(function(){
	console.log(`DONE!`);
}).catch(function(error){
	console.log(`ERROR!`);
});