#include <avr/io.h>

#include <util/delay.h>

#include <stdint.h>

#define F_CPU 16000000 UL

#define PIN_W 6
#define PIN_X 7
#define PIN_Y 0
#define PIN_Z 1
#define PIN_A 2
#define PIN_B 3
#define PIN_C 4
#define PIN_D 5
#define PIN_CLK 5

int main(void) {
  DDRD |= (1 << PIN_A) | (1 << PIN_B) | (1 << PIN_C) | (1 << PIN_D);
  DDRD &= ~((1 << PIN_W) | (1 << PIN_X));
  DDRB |= (1 << PIN_CLK);
  DDRB &= ~((1 << PIN_Y) | (1 << PIN_Z));

  TCCR0A = (1 << WGM01); //CTC
  TCCR0B = 0b00000101; // Prescaler
  OCR0A = 156; //compare
  while (1) {
    uint8_t w = ((PIND >> PIN_W) & 1);
    uint8_t x = ((PIND >> PIN_X) & 1);
    uint8_t y = ((PINB >> PIN_Y) & 1);
    uint8_t z = ((PINB >> PIN_Z) & 1);

    uint8_t a = !w;
    uint8_t b = ((w ^ x) & !z);
    uint8_t c = ((y ^ (w & x)) & !z);
    uint8_t d = ((w & x & y & !z) | (!w & !x & !y & z));

    uint8_t curr = PORTD;
    curr &= ~((1 << PIN_A) | (1 << PIN_B) | (1 << PIN_C) | (1 << PIN_D));
    uint8_t new = (a << PIN_A) | (b << PIN_B) | (c << PIN_C) | (d << PIN_D);
    PORTD = curr | new; //again, do NOT TOUCH OTHER BITS

    PORTB |= (1 << PIN_CLK);
    PORTB &= ~(1 << PIN_CLK);
    for (int i = 0; i < 100; i++) {
      while (!(TIFR0 & (1 << OCF0A))); //timer done
      TIFR0 |= (1 << OCF0A); //clear
    }
  }
  return 0;
}
