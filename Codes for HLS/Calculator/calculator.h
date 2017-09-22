#ifndef calculator_h
#define calculator_h
#include <stdint.h>

extern double LUT_mul[20][3];
extern double LUT_div[20][3];
extern double LUT_div2[20][3];

void calculate(double A[20],double B[20],double C[20],int select,double LUT_mul[20][3],double LUT_div[20][3],double LUT_div2[20][3]);

#endif