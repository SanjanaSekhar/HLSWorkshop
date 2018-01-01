#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "calculator.h"

void display(double to_print[20],const char *name)
{
	printf("\n%s is ",name);
	for(int i=0;i<20;i++)
		printf("%f,",to_print[i]);
	printf("\n");
}

int main(int argc, char **argv)
{
	double A[20] = {2,34,1,3,4,5,77,0,21,8,9,1,2,3,4,5,67,8,9,10};
	double B[20] = {1,2,3,4,5,6,7,8,9,0,12,34,56,45,31,40,44,67,21,20};
	double C[20] = {0};
	double LUT_mul[20][3]={0};
	double LUT_div[20][3]={0};
	double LUT_div2[20][3]={0};
	const char *op[6] = {"A+B","A-B","B-A","A*B","A/B","B/A"};
	//uint16_t sqrts[20][2]={0};
	for(int i=0;i<20;i++)
	{
	
		LUT_mul[i][0]=A[i];
		LUT_mul[i][1]=B[i];
		LUT_mul[i][2]=A[i]*B[i];	
	}
	for(int i=0;i<20;i++)
	{
	
		LUT_div[i][0]=A[i];
		LUT_div[i][1]=B[i];
		LUT_div[i][2]=A[i]/B[i];
	}
	for(int i=0;i<20;i++)
	{
	
		LUT_div2[i][0]=A[i];
		LUT_div2[i][1]=B[i];
		LUT_div2[i][2]=B[i]/A[i];
	}
	display(A,"A");
	display(B,"B");
	for(int i=0;i<6;i++)
	{
		calculate(A,B,C,i+1,LUT_mul,LUT_div,LUT_div2);
		printf("\nIf operation is %s\n",op[i]);
		display(C,"C");
	}
}
