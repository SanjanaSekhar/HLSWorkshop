#ifndef quadratic_h
#define quadratic_h
#include <stdint.h>

extern uint16_t sqrts[20][2];

void findRoots(double a,double b,double c,double result[2], uint16_t sqrts[20][2]);

#endif