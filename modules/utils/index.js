// Консольные утилиты

// ESC-символ, с которого начинается любая ANSI-команда (код 27)
const ESC = String.fromCharCode(27);

//
const width = process.stdout.columns || 100;

// Шаблон ANSI-команды: ESC + [ + параметры (цифры и ; ) + буква-команда.
// g-флаг — заменить ВСЕ вхождения, не только первое.
// Внимание: слэш-шаблон собирается из частей, чтобы не зависеть от записи \u001B.
const ANSI_RE = new RegExp(ESC + "\\[[?0-9;]*[mKFJhJl]", "g");

// Убирает из строки все ANSI-команды (цвета, очистку, позиционирование).
// На выходе — только видимый текст.
const stripAnsi = (s) => s.replace(ANSI_RE, "");

// "Настоящая" длина строки: сколько колонок она займёт на экране.
const visibleLength = (s) => stripAnsi(s).length;

// Центрирование строки в окне терминала.
// Считает отступ по видимой длине, цвет в строке не мешает.
const centerText = (text = "") => {
	const pad = Math.max(10, Math.floor((width - visibleLength(text)) / 2));
	return " ".repeat(pad) + text;
};

// Выравнивание "ключ: значение" — двоеточие ровно по центру экрана
const alignToCenter = (pairs) => {
	const colonPos = Math.floor(width / 2); // колонка, в которую встанет ":"
	return pairs.map(p => {
		const key = String(p.key);
		const pad = Math.max(0, colonPos - visibleLength(key));
		return ' '.repeat(pad) + key + ' ' + String(p.value);
	}).join('\n');
};

// Поведение курсора
const cursor = (type = false) => process.stdout.write(`${ESC}[?25${type ? 'h' : 'l'}`);

// Очистка строки (ВСЯ строка)
const clearLine = () => process.stdout.write(`${ESC}[1K${ESC}[K`);

// Очистка экрана
const clearScreen = () => process.stdout.write(`${ESC}[2J${ESC}[H`);

// Текст: Окрашивание/Подчёркивание/Зачёркивание/Инверсия
const decorationText = (text, color) => {
	text = String(text);
	color = String(color);
	switch(color) {
		case "red":
			text = `${ESC}[31m${text}${ESC}[39m`;
			break;
		case "green":
			text = `${ESC}[32m${text}${ESC}[39m`;
			break;
		case "yellow":
			text = `${ESC}[33m${text}${ESC}[39m`;
			break;
		case "blue":
			text = `${ESC}[34m${text}${ESC}[39m`;
			break;
		case "magenta":
			text = `${ESC}[35m${text}${ESC}[39m`;
			break;
		case "cyan":
			text = `${ESC}[36m${text}${ESC}[39m`;
			break;
		case "white":
			text = `${ESC}[37m${text}${ESC}[39m`;
			break;
		case "brightRed":
			text = `${ESC}[91m${text}${ESC}[39m`;
			break;
		case "brightGreen":
			text = `${ESC}[92m${text}${ESC}[39m`;
			break;
		case "brightYellow":
			text = `${ESC}[93m${text}${ESC}[39m`;
			break;
		case "brightBlue":
			text = `${ESC}[94m${text}${ESC}[39m`;
			break;
		case "brightMagenta":
			text = `${ESC}[95m${text}${ESC}[39m`;
			break;
		case "brightCyan":
			text = `${ESC}[96m${text}${ESC}[39m`;
			break;
		case "brightWhite":
			text = `${ESC}[97m${text}${ESC}[39m`;
			break;
		case "under":
		case "underline":
		case "stress":
			text = `${ESC}[4m${text}${ESC}[24m`;
			break;
		case "strike":
		case "strikeout":
		case "strikethrough":
			text = `${ESC}[9m${text}${ESC}[29m`;
			break;
		case "inverse":
			text = `${ESC}[7m${text}${ESC}[27m`;
			break;
		default:
			break;
	}
	return text;
}

module.exports = {
	stripAnsi: stripAnsi,
	visibleLength: visibleLength,
	centerText: centerText,
	decorationText: decorationText,
	cursor: cursor,
	clearLine: clearLine,
	clearScreen: clearScreen,
	alignToCenter: alignToCenter
};
