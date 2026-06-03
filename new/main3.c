#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>
#define F_CPU 16000000UL
//volatile uint8_t w=0,x=0,y=0,z=0;
//volatile uint8_t a=0,b=0,c=0,d=0;


 
int main (void)
{  
	DDRD    |= ((1 << PD2));
	DDRD    |= ((1 << PD3));
  	DDRD    |= ((1 << PD4));
	DDRD    |= ((1 << PD5));
	DDRD    &= ~(1 << PD6);
	DDRD    &= ~(1 << PD7);
	DDRB    &= ~(1 << PB0);
	DDRB    &= ~(1 << PB1);
	DDRB    |= ((1 << PB5));	
	while (1) {
		uint8_t w = (PIND >> PD6 ) & 1;
	        uint8_t x = (PIND >> PD7) & 1;
	        uint8_t y = (PINB >> PB0) & 1;
		uint8_t z = (PINB >> PB1) & 1;

		uint8_t a = (!w);
		uint8_t b = (w & (!x) & (!z)) | ((!w) & x);
		uint8_t c = ((!x) & y) | ((!w) & y) | (w & x & (!y));
		uint8_t d = ((!w) & z) | (w & x & y);

//		PORTD |= (a << PD2);
//		PORTD |= (b << PD3);
//		PORTD |= (c << PD4);
//		PORTD |= (d << PD5);
    uint8_t curr = PORTD;
    curr &= ~((1 << PD2) | (1 << PD3) | (1 << PD4) | (1 << PD5));
    uint8_t new = (a << PD2) | (b << PD3) | (c << PD4) | (d << PD5);
    PORTD = curr | new; //again, do NOT TOUCH OTHER BITS

                _delay_ms(500);
	    	PORTB |= ((1 <<  PB5));
	    	_delay_ms(500);
		PORTB &= ~((1 <<  PB5));
 	 }
}
