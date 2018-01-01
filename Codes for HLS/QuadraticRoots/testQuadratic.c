#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "quadratic.h"
int main(int argc, char **argv)
{
	double a = 1;
	double b = -5;
	double c = 6;
	double result[2] = {0};
	uint16_t sqrts[20][2]={0};
	for(int i=0;i<20;i++)
	{
	
		sqrts[i][0]=i*i;
		sqrts[i][1]=i;
		
	}
	findRoots(a,b,c,result,sqrts);
	printf("The roots of %fx^2 + %fx + %f are %f and %f\n", a,b,c,result[0],result[1]);

}