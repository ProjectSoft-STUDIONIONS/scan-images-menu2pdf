using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

using img_ini;

namespace Runner
{
	class Program
	{

		#region "Unmanaged"

		[DllImport("user32.dll")]
		static extern bool EnableMenuItem(IntPtr hMenu, uint uIDEnableItem, uint uEnable);

		[DllImport("user32.dll")]
		static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);

		[DllImport("user32.dll")]
		static extern IntPtr RemoveMenu(IntPtr hMenu, uint nPosition, uint wFlags);

		internal const int GWL_STYLE = -16;
		internal const uint WS_THICKFRAME = 0x00040000;

		internal const uint SC_CLOSE = 0xF060;
		internal const uint MF_GRAYED = 0x00000001;
		internal const uint MF_BYCOMMAND = 0x00000000;
		internal const uint SC_MAXIMIZE = 0xF030;
		internal const uint SC_MINIMIZE = 0xF020;
		internal const uint SC_RESTORE = 0xF120;

		#endregion

		static void Main(string[] args)
		{
			// System.Diagnostics.
			// Если программа запущена
			// Имя окна приложения
			string App = "Конвертирование отсканированных изображений меню в PDF файлы v2.8.3";
			String dir = Environment.CurrentDirectory;
			// Удаляем возможность закрытия приложения из интнрфейса
			IntPtr hMenu = Process.GetCurrentProcess().MainWindowHandle;
			IntPtr hSystemMenu = GetSystemMenu(hMenu, false);

			EnableMenuItem(hSystemMenu, SC_CLOSE, MF_GRAYED);
			RemoveMenu(hSystemMenu, SC_CLOSE, MF_BYCOMMAND);
			
			EnableMenuItem(hSystemMenu, SC_MAXIMIZE, MF_GRAYED);
			RemoveMenu(hSystemMenu, SC_MAXIMIZE, MF_BYCOMMAND);

			EnableMenuItem(hSystemMenu, SC_MINIMIZE, MF_GRAYED);
			RemoveMenu(hSystemMenu, SC_MINIMIZE, MF_BYCOMMAND);

			EnableMenuItem(hSystemMenu, SC_RESTORE, MF_GRAYED);
			RemoveMenu(hSystemMenu, SC_RESTORE, MF_BYCOMMAND);
			// Устанавливаем цвет окна консоли в Чёрный цвет
			Console.BackgroundColor = System.ConsoleColor.Black;
			Console.Clear();
			// Читаем настройки из файла
			String ini = dir + "\\" + "programm.ini";
			IniFile iniFile = new IniFile(ini);
			String pad = iniFile.Read("pad", "Programm", "4");
			// Применяем аргументы
			// Аргумент pause ОБЯЗАТЕЛЕН!
			String arguments = "index.js" + " --pad=" + pad + " --runing=True && pause";
			// Готовим к запуску NodeJS
			Process p = new Process();
			p.StartInfo = new ProcessStartInfo("node.exe");
			// Передаём аргументы
			p.StartInfo.Arguments = arguments;
			// Устанавливаем рабочую директорию
			p.StartInfo.WorkingDirectory = dir;
			// Остальные параметры...
			p.StartInfo.ErrorDialog = false;
			p.StartInfo.CreateNoWindow = false;
			p.StartInfo.UseShellExecute = false;
			// Запускаем NodeJS
			p.Start();
			// Меняем title
			Console.Title = App;
			// Если ini файл не существует
			if (File.Exists(ini) == false){
				// Записываем параметры в файл
				iniFile.Write("pad", pad, "Programm");
			}
		}
	}
}