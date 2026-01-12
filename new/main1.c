/* * Decade Counter - High Efficiency Version
 * Single File Implementation
 */
#include <avr/io.h>

#define F_CPU 16000000UL

// Macros for raw bit access to inputs
#define IN_W ((PIND >> 6) & 1)
#define IN_X ((PIND >> 7) & 1)
#define IN_Y ((PINB >> 0) & 1)
#define IN_Z ((PINB >> 1) & 1)

int main(void) {
    // Setup Ports: PD2-PD5 Output, PD6-PD7 Input; PB5 Output, PB0-PB1 Input
    DDRD = (DDRD & 0x03) | 0x3C;
    DDRB = (DDRB & 0xFC) | 0x20;

    // Setup Timer0: CTC Mode, Prescaler 1024, OCR0A = 155 (~10ms)
    TCCR0A = (1 << WGM01);
    TCCR0B = (1 << CS02) | (1 << CS00);
    OCR0A  = 155;

    uint8_t delay_cnt = 0;

    while (1) {
        // 1. Logic Calculation (Inline)
        uint8_t w = IN_W, x = IN_X, y = IN_Y, z = IN_Z;

        uint8_t a = !w;
        uint8_t b = ((w ^ x) & !z);
        uint8_t c = ((y ^ (w & x)) & !z);
        uint8_t d = ((w & x & y & !z) | (!w & !x & !y & z));

        // 2. Output Write (Masking to preserve PD0/PD1/PD6/PD7)
        PORTD = (PORTD & 0xC3) | (d << 5) | (c << 4) | (b << 3) | (a << 2);

        // 3. LED Blink & Delay Logic
        // This state machine handles the blink without blocking logic execution if needed,
        // though here we use a simple blocking wait for the specific 700ms/10ms pattern.

        PORTB |= (1 << 5);      // LED ON
        delay_cnt = 70;         // 700ms
        while(delay_cnt--) {
            while (!(TIFR0 & (1 << OCF0A))); TIFR0 |= (1 << OCF0A); // Wait & Clear Flag
        }

        PORTB &= ~(1 << 5);     // LED OFF
        delay_cnt = 1;          // 10ms
        while(delay_cnt--) {
            while (!(TIFR0 & (1 << OCF0A))); TIFR0 |= (1 << OCF0A);
        }
    }
}
