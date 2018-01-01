//sorting n bit strings

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
using namespace std;
int main(int argc, char **argv)
{
	ap_int<4> toBeSorted[5]={1001,0010,1100,0100,0111};
	ap_int<4> upperHalf[5]={0};
	ap_int<4> lowerHalf[5]={0};
	sortArrays(toBeSorted,upperHalf,lowerHalf);
}
void sortArrays(ap_int<4> toBeSorted[5],ap_int<4> upperHalf[5],ap_int lowerHalf[5], ap_int<4> k)
{
	if(k==0000) return;
	int j,k=0;
	for(int i=0;i<5;i++)
	{
		result = toBeSorted[i] & k;
		if(result>>3 == 1)
		{
			upperHalf[j]=toBeSorted[i];
			j++;
		}
		else
		{
			lowerHalf[l]=toBeSorted[l];
			l++;
		}
	}
}