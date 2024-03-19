const {spawn, exec} = require('child_process');
const path = require('path');
const root = __dirname;

function dialogs(fileJsonMenu) {
	var promise = new Promise((resolve, reject) => {
		/**
		 * Под Linux будут другие пути и команды
		 */
		// Windows exe
		const bat = exec(path.normalize(path.join(root, 'dist/dialogs.exe')) + ' --typemenu "' + fileJsonMenu + '"', (error, stdout, stderr) => {
			if (stdout) {
				if (!stdout.trim())
					reject(`None`);
				else
					resolve(stdout.trim())
			} else if (error) {
				reject(error);
			} else if (stderr) {
				reject(stderr);
			}
		});
	})
	return promise;
}
module.exports = dialogs