#include <windows.h>

int main(int argc,char **argv) {
	DWORD frequency;
	DWORD duration;
	frequency = atol("1760");
	duration = atol("500");
	if(argc > 1) {
		frequency = atol( argv[1] );
	}
	if(argc > 2) {
		duration = atol( argv[2] );
	}
    Beep(frequency, duration);
}
