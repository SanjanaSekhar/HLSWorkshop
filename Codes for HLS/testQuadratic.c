#include <stdint.h>
#include <stdio.h>

#include "quadratic.h"
int main(int argc, char **argv)
{
	double a = 1;
	double b = -5;
	double c = 6;
	double result[2] = {0};
	findRoots(a,b,c,result);
	printf("The roots of %fx^2 + %fx + %f are %f and %f\n", a,b,c,result[0],result[1]);

}