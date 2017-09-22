/* try the following: 
-no default/default
-no directives/directives
--UNROLL
--ARRAY_PARTITION
--PIPELINE
--DEPENDENCE
--DATAFLOW
-no LUT/LUT for mul
-no LUT/LUT for div
*/
#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "calculator.h"

void calculate(double A[20],double B[20],double C[20],int select)
{
	//calculate the sum/difference/product/quotient of 2 arrays based on select.
	int i;
	switch(select)
	{
		case 1:
		{
			for(i=0;i<20;i++)
			{
				C[i]=A[i]+B[i];
			}
			break;
		}
		case 2:
		{
			for(i=0;i<20;i++)
			{
				C[i]=A[i]-B[i];
			}
			break;
		}
		case 3:
		{
			for(i=0;i<20;i++)
			{
				C[i]=-A[i]+B[i];
			}
			break;
		}
		case 4:
		{
			for(i=0;i<20;i++)
			{
				C[i]=A[i]*B[i];
			}
			break;
		}
		case 5:
		{
			for(i=0;i<20;i++)
			{
				C[i]=A[i]/B[i];
			}
			break;
		}
		case 6:
		{
			for(i=0;i<20;i++)
			{
				C[i]=B[i]/A[i];			
			}
			break;
		}
	}
}

