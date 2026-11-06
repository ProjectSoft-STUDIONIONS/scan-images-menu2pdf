using System;
using System.Runtime.InteropServices;

namespace Runner
{
	class Program
	{

		[DllImport("kernel32.dll", SetLastError = true)]
		private static extern bool Beep(uint dwFreq, uint dwDuration);

		private static int Main(string[] args)
		{
			uint tone     = 1760;
			uint duration = 500;

			uint t;
			uint d;

			if (args.Length > 0 && uint.TryParse(args[0], out t))
				tone = t;
			if (args.Length > 1 && uint.TryParse(args[1], out d))
				duration = d;

			return Beep(tone, duration) ? 0 : 1;
		}
	}
}
