using System;
using System.Runtime.InteropServices;

namespace Runner
{
	class Playbeep
	{
		#region "Unmanaged"

		[DllImport("kernel32.dll")]
		static extern bool Beep(uint frequency, uint duration);

		#endregion

		static void Main(string[] args)
		{
			/**
			 * Программа только для данного приложения
			 * Поэтому я просто не парюсь с передачей переменных и их проверкой на соответствие типов
			 */
			 // A4 = 1760
			uint frequency = 1760;
			uint duration = 500;
			if (args.Length >= 1) {
				frequency = Convert.ToUInt32(args[0]);
			}
			if (args.Length >= 2) {
				duration = Convert.ToUInt32(args[1]);
			}
			Beep(frequency, duration);
		}
	}
}