//Decade Counter
#include <avr/io.h>

//initasm.S
extern void init(void);
//loadmemasm.S
extern void load_mem(void);
//delayasm.S
extern void delay(uint8_t);
//dispscrnasm.S
extern void disp_scrn(uint8_t);

int main (void) {
	init();
	load_mem();
	while (1) {
		short t = 10;
		while (t--) {
			disp_scrn(9-t);
			delay(61);
		}
	}
	return 0;
}
