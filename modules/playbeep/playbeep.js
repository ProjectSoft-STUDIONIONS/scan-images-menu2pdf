const {spawn, exec} = require('child_process');
const path = require('path');
const root = __dirname;

function playbeep(frequency = 1760, duration = 500) {
	var promise = new Promise((resolve, reject) => {
		/**
		 * Под Linux будут другие пути и команды
		 */
		// Windows exe
		let bat = spawn(path.normalize(path.join(root, 'playbeep.exe')), [
				frequency,
				duration
			], {
			windowsHide: true
		});
		
		bat.stderr.on('data', (data) => {
			reject(`${data}`);
		});

		bat.on('close', (code) => {
			resolve(`${code}`);
		});
	})
	return promise;
}
module.exports = playbeep;