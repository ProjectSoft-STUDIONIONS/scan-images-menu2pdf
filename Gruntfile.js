module.exports = (grunt) => {
	process.removeAllListeners('warning');
	require('dotenv').config();

	const running = process.env.DEVELOPMENT == "1" ? false : true,
		pkg = grunt.file.readJSON('package.json'),
		path = require('path'),
		uniqid = function () {
			let result = URL.createObjectURL(new Blob([])).slice(-36).replace(/-/g, '');
			return result;
		};

	require('load-grunt-tasks')(grunt);
	require('time-grunt')(grunt);

	grunt.initConfig({
		globalConfig: {},
		pkg: pkg,
		clean: {
			options: {
				force: true
			},
			docs: [
				"docs/**/*",
				'test/'
			],
		},
		copy: {
			docs: {
				files: [
					{
						expand: true,
						cwd: 'src/fonts',
						src: ['**'],
						dest: 'docs/fonts',
					},
					{
						expand: true,
						cwd: 'src/images',
						src: ['**'],
						dest: 'docs/images',
					},
					{
						expand: true,
						cwd: 'src',
						src: ['*.ico', '*.png', '*.html'],
						dest: 'docs',
					}
				]
			}
		},
		/*ttf2woff2: {
			docs: {
				src: ["src/font/*"],
				dest: "docs/fonts",
			},
		},*/
		less: {
			docs: {
				options: {
					compress: false,
					ieCompat: false,
					plugins: [
						
					]
				},
				files: {
					'test/css/page-main.css': [
						'src/less/main.less',
					]
				}
			}
		},
		cssmin: {
			options: {
				mergeIntoShorthands: false,
				roundingPrecision: -1
			},
			docs: {
				files: {
					'docs/css/main.css': [
						//'bower_components/fancybox/dist/jquery.fancybox.css',
						'test/css/page-main.css'
					]
				}
			}
		},
		concat: {
			options: {
				separator: ';',
			},
			docs: {
				src: [
					//'bower_components/jquery/dist/jquery.js',
					//'bower_components/fancybox/dist/jquery.fancybox.js',
				],
				dest: 'test/js/plugins.js',
			},
		},
		uglify : {
			options: {
				ASCIIOnly: true,
				compress: false,
				//beautify: true
			},
			docs: {
				files: {
					/*'docs/js/plugins.js': [
						'test/js/plugins.js'
					],*/
					'docs/js/main.js': [
						'src/js/main.js'
					]
				},
			},
		},
		pug: {
			docs: {
				options: {
					pretty: "", //'\t',
					separator: "", //'\n',
					data: function(dest, src) {
						return {
							"hash": uniqid(),
							"repo": "projectsoft-studionions.github.io",
							"userName": "ProjectSoft-STUDIONIONS",
							"page": "scan-images-menu2pdf",
							"download": "ConvertMenu2pdf_setup.exe",
							"title": "Отсканированная коллекция изображений меню в PDF файлы | ProjectSoft GitHub Pages",
							"h1title": "Отсканированная коллекция изображений меню в PDF файлы",
							"description": "В работе очень часто приходится конвертировать отсканированные изображения меню в PDF файлы и этот процесс довольно трудоёмкий, а приходится делать это два - три раза в неделю.",
							"keywords": "ProjectSoft, STUDIONIONS, ProjectSoft-STUDIONIONS, Отсканированная коллекция изображений меню в PDF файлы, меню питания в PDF файлы, мониторинг питания в школах",
							"nickname": "ProjectSoft",
							"logotype": "projectsoft.png",
							"copyright": "2008 - all right reserved",
							"open_graph": {
								"image_16x9": "image16x9.jpg",
								"image_16x9_width": "1920",
								"image_16x9_height": "1080",
								"image_1x1": "image1x1.jpg",
								"image_1x1_width": "1080",
								"image_1x1_height": "1080",
							}
						}
					},
				},
				files: {
					"docs/index.html": [
						"src/pug/index.pug"
					]
				},
			},
		},
	});

	grunt.registerTask('default', [
		"clean",
		"copy",
		//"ttf2woff2",
		"less",
		"cssmin",
		//"concat",
		"uglify",
		"pug",
	]);
}