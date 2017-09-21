#include <stdint.h>
#include <stdio.h>
#include <math.h>

void findRoots(double a,double b,double c,double result[2])
{
	//find the roots of the equation ax^2+bx+c=0

	double sqroot;
	sqroot=sqrt((b*b)-(4*a*c));
	result[0]= (-b+sqroot)/(2*a);
	result[1]= (-b-sqroot)/(2*a);

}
