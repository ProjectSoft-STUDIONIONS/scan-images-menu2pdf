using System;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;

namespace Runner
{
	class Program
	{

		//#region "Unmanaged"

		[DllImport("user32.dll")]
		static extern bool EnableMenuItem(IntPtr hMenu, uint uIDEnableItem, uint uEnable);

		[DllImport("user32.dll")]
		static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);

		[DllImport("user32.dll")]
		static extern IntPtr RemoveMenu(IntPtr hMenu, uint nPosition, uint wFlags);

		// P/Invoke для работы с заголовком консоли
		[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
		static extern int GetConsoleTitle(StringBuilder text, int size);

		[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
		static extern bool SetConsoleTitle(string text);

		[DllImport("kernel32.dll", SetLastError = true)]
		private static extern bool Beep(uint dwFreq, uint dwDuration);

		internal const int GWL_STYLE = -16;
		internal const uint WS_THICKFRAME = 0x00040000;

		internal const uint SC_CLOSE = 0xF060;
		internal const uint MF_GRAYED = 0x00000001;
		internal const uint MF_BYCOMMAND = 0x00000000;
		internal const uint SC_MAXIMIZE = 0xF030;
		internal const uint SC_MINIMIZE = 0xF020;
		internal const uint SC_RESTORE = 0xF120;

		//#endregion

		static void Main(string[] args)
		{
			// 1. Сохраняем текущий заголовок ДО запуска Node
			var oldTitle = new StringBuilder(512);
			GetConsoleTitle(oldTitle, oldTitle.Capacity);
			// System.Diagnostics.
			// Если программа запущена
			// Имя окна приложения
			string App = "Конвертирование отсканированных изображений меню в PDF файлы";
			String dir = Path.GetDirectoryName(Environment.CurrentDirectory);
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
			Console.ForegroundColor = System.ConsoleColor.Yellow;
			Console.OutputEncoding = System.Text.Encoding.UTF8;
			// Применяем аргументы
			// Аргумент pause ОБЯЗАТЕЛЕН!
			String arguments = dir + "\\index.js" + " --runing=True";
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
			// 2. Ждём окончания процесса
			p.WaitForExit();
			// 3. Возвращаем заголовок
			SetConsoleTitle(oldTitle.ToString());
			// Сигнал
			Beep(1760, 500);
		}
	}
}
