/* try the following: 
-no default/default-- no diff
-no directives/directives-- clock needed to be adjusted
--UNROLL-- look in comments
--ARRAY_PARTITION-- 33 to 21 on 9.09 clock, 70 to 58 in 4.16 clock, w/o increases estimated clock, with decreases
--PIPELINE-- max latency w/o this is 501, with this is 33, II changes nothing
--DEPENDENCE-- no diff
--DATAFLOW-- reverses effects of pipeline
-no LUT/LUT for mul,div-- LATENCY DECREASES FROM 58 TO 8!!!
*/
#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "calculator.h"

void calculate(double A[20],double B[20],double C[20],int select,double LUT_mul[20][3],double LUT_div[20][3],double LUT_div2[20][3])
{
	//calculate the sum/difference/product/quotient of 2 arrays based on select.
	int i;
	#pragma HLS PIPELINE
	//Note: unable to load B array for select=6 warning goes away after ARRAY_PARTITION
	//Note: unable to load parts of LUT arrays goes away by partitioning, (why does it ask to increase II)?
	#pragma HLS ARRAY_PARTITION variable=A complete
	#pragma HLS ARRAY_PARTITION variable=B complete
	#pragma HLS ARRAY_PARTITION variable=C complete
	#pragma HLS ARRAY_PARTITION variable=LUT_mul complete dim=0
	#pragma HLS ARRAY_PARTITION variable=LUT_div complete dim=0
	#pragma HLS ARRAY_PARTITION variable=LUT_div2 complete dim=0
	//#pragma HLS DEPENDENCE
	//#pragma HLS DATAFLOW
	//#pragma HLS UNROLL-- made no diff, applied automatically?
	switch(select)
	{
		case 1:
		{
			for(i=0;i<20;i++)
			{
				//#pragma HLS UNROLL-- made no diff
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
			#pragma HLS UNROLL //these make no diff
			for(i=0;i<20;i++)
			{
				#pragma HLS UNROLL
				for(int j=0;j<20;j++)
				{
					if(LUT_mul[j][0]==A[i])
					{
						if(LUT_mul[j][1]==B[i])
							C[i]=LUT_mul[j][2];
						else continue;
					}
				}
			}
			break;
		}
		case 5:
		{
			#pragma HLS UNROLL
			for(i=0;i<20;i++)
			{
				#pragma HLS UNROLL
				for(int j=0;j<20;j++)
				{
					if(LUT_div[j][0]==A[i])
					{
						if(LUT_div[j][1]==B[i])
							C[i]=LUT_div[j][2];
						else continue;
					}
				}
			}
			break;
		}
		case 6:
		{
			#pragma HLS UNROLL
			for(i=0;i<20;i++)
			{
				#pragma HLS UNROLL
				for(int j=0;j<20;j++)
				{
					if(LUT_div2[j][0]==A[i])
					{
						if(LUT_div2[j][1]==B[i])
							C[i]=LUT_div2[j][2];
						else continue;
					}
				}
			}
			break;
		}
		//default: printf("nope");

	}
}

