# scan-images-menu2pdf
Конвертирование отсканированных изображений меню в PDF файлы.

### Параметры сканирования:
| Наименование     | Значение         |
| ---------------- | ---------------- |
| Цветовой формат  | Цветное          |
| Тип файла        | JPG (Файл "JPG") |
| Разрешение (DPI) | 300              |

### Описание
Обрабатывается два типа меню. Каждодневное и Двухнедельное.

#### Формат данных в JSON
Каждодневное меню одного файла включает в себя два файла изображений. Двухнедельное состоит из одиннадцати файлов изображений. Править можно под себя.   
Файл для правки [menu.json](https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf/blob/main/menu.json).   
<details>
	<summary><u><strong>Формат данных в JSON</strong>s</u></summary>

```json
[
	{
		"name": "Каждодневное меню",
		"files": 2,
		"size": "portrait",
		"author": "ООО «КДП «Здоров и Сыт»",
		"produser": "ГБОУ СОШ пос. Комсомольский",
		"format": "%y.%m.%d",
		"multidir": true,
		"items": [
			{
				"title": "Меню рациона питания для детей учащихся 1-4 классов",
				"sufix": "-01",
				"saveNoSufix": false
			},
			{
				"title": "Меню рациона питания для детей с ОВЗ",
				"sufix": "-02",
				"saveNoSufix": false
			},
			{
				"title": "Индивидуальное меню рациона питания",
				"sufix": "-03",
				"saveNoSufix": true
			},
			{
				"title": "Меню рациона питания для учащихся",
				"sufix": "-04",
				"saveNoSufix": false
			},
			{
				"title": "Меню рациона питания для детей мобилизованных родителей 1-4 классов",
				"sufix": "-05",
				"saveNoSufix": false
			},
			{
				"title": "Меню рациона питания для детей мобилизованных родителей 5-11 классов",
				"sufix": "-06",
				"saveNoSufix": false
			}
		]
	},
	{
		"name": "Двухнедельное меню",
		"files": 11,
		"size": "landscape",
		"author": "ООО «КДП «Здоров и Сыт»",
		"produser": "ГБОУ СОШ пос. Комсомольский",
		"format": "%y.%m.%d",
		"multidir": false,
		"items": [
			{
				"title": "Примерное двухнедельное меню рациона питания для детей учащихся 1-4 класса",
				"sufix": "-01",
				"saveNoSufix": false
			},
			{
				"title": "Примерное двухнедельное меню рациона питания для детей c ОВЗ",
				"sufix": "-02",
				"saveNoSufix": false
			},
			{
				"title": "Примерное двухнедельное индивидуальное меню рациона питания",
				"sufix": "-03",
				"saveNoSufix": false
			},
			{
				"title": "Примерное двухнедельное меню рациона питания для учащихся",
				"sufix": "-04",
				"saveNoSufix": false
			},
			{
				"title": "Примерное двухнедельное меню рациона питания для детей мобилизованных родителей 1-4 классов",
				"sufix": "-05",
				"saveNoSufix": false
			},
			{
				"title": "Примерное двухнедельное меню рациона питания для детей мобилизованных родителей 5-11 классов",
				"sufix": "-06",
				"saveNoSufix": false
			}
		]
	}
]
```
</details>

Согласно JSON данных можно добавить ещё типы меню не правя код самого модуля, а правя только код файла `menu.json`. Внимательно следите за форматом JSON файла!!!

Подключена обработка отсканированных изображений (ресайз) с помощью [**ImageMagick**](https://imagemagick.org/script/download.php) (скачать и установить от имени Администратора, проверить запуск `magick`, `convert`)

Обязательные опции при установке **ImageMagick**: 

![Обязательные опции при установке ImageMagick](/assets/screenshots/0000.png?raw=true "Выбор даты")

Создание PDF файлов посредством библиотеки [**pdf-lib**](https://pdf-lib.js.org/) *(Устанавливается при развёртывании проекта)*

### Установка:

Обязательно!
```Batchfile
$ git clone https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf.git
$ cd scan-images-menu2pdf
$ npm run inst
```

### Запуск

```Batchfile
$ npm run test
```
Или запуск `programm.exe`

### Дополнительные установки для сборки проекта и диалога
Установить **.NET 8.0 SDK** для компилирования `programm.exe`
```
https://dotnetwebsite.azurewebsites.net/en-us/download/dotnet/8.0
```
<ins>**Добавить запись к PATH**<ins>
```
C:\Windows\Microsoft.NET\Framework\v3.5
```
В данной папке находится компилятор `csc.exe`

Установить **RAD Studio 11** для компилирования `dialogs.exe`
```
https://altd.embarcadero.com/download/radstudio/11.0/RADStudio_11_3_esd_61_3236.exe
```

### Сборка `programm.exe`

```Batchfile
$ npm run build
```
## Этапы работы программы

Запуск программы

![Запуск программы](/assets/screenshots/0001.png?raw=true "Запуск программы")

Выбор папки с изображениями

![Выбор папки с изображениями](/assets/screenshots/0002.png?raw=true "Выбор папки с изображениями")

Выполнение программы. Обработка изображений. Генерация PDF файлов

![Выполнение программы. Обработка изображений. Генерация PDF файлов](/assets/screenshots/0003.png?raw=true "Выполнение программы. Обработка изображений. Генерация PDF файлов")

Завершение работы программы

![Завершение работы программы](/assets/screenshots/0004.png?raw=true "Директория с полученными PDF файлами")
