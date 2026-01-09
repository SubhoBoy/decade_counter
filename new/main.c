#include <avr/io.h>

// initasm.S
extern void init(void);

// decadeasm.S
extern void logic(void);
extern void clk(uint8_t);

// delayasm.S
extern void del(uint8_t);

int main(void) {
    init();
    while (1) {
        logic();

        clk(1);
        del(20);
        clk(0);
    }
    return 0;
}
