#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "quadratic.h"

void findRoots(double a,double b,double c,double result[2],uint16_t sqrts[20][2])
{
	//find the roots of the equation ax^2+bx+c=0
	#pragma HLS DATAFLOW
	#pragma HLS PIPELINE
	#pragma HLS ARRAY_PARTITION variable=result complete
	double sqroot;
	for(int i=0;i<20;i++)
	{
		#pragma HLS UNROLL
		if(sqrts[i][0]==((b*b)-(4*a*c)))
			sqroot=sqrts[i][1];
	}
	//sqroot=sqrt((b*b)-(4*a*c));
	result[0]= (-b+sqroot)/(2*a);
	result[1]= (-b-sqroot)/(2*a);

}
