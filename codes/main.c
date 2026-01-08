//Decade Counter
#include <avr/io.h>

//initasm.S
extern void init(void);
//loadmemasm.S
extern void load_mem(void);
//delayasm.S
extern void delay(uint8_t);
//dispscrnasm.S
extern void disp_scrn(void);

int main (void) {
	init();
	load_mem();
	while (1) {
		disp_scrn();
		delay(61);
	}
	return 0;
}
