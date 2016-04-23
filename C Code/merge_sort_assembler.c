#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void seed(uint32_t r){
	//Initializes random generator; r is start value
}

uint32_t rand(){
	//Source:
   uint64_t t;
   uint32_t x = random_integer_value;
   uint32_t y = 181218000;
   uint32_t z = 260644314,5;
   uint32_t c = 3827160,5;
   // Linear congruential generator
   x = 69069 * x + 12345;

   // Xorshift
   y ^= y << 13;
   y ^= y >> 17;
   y ^= y << 5;

   // Multiply-with-carry
   t = 349384534 * z + c; //Not using the ULL variant due to simplification reasons
   c = t >> 32;
   z = (uint32_t) t;

   return x + y + z;
}

float frand(){
	//Generates floating point number between 0 and 1 and uses rand()
	float random_float_number;
	random_float_number = 0;
	//rand --> Makes use of rand() function
	//print generated floating numbers to debug...
}

void recursive_merge(int a[], int lo, int hi, int aux[])
{
    int mid;
    if (hi > lo)
    {
        mid = (lo + hi)/2; // divide the list into two halfs
        recursive_merge(a,lo,mid,aux); // sort the left half recursively
        recursive_merge(a,mid+1,hi,aux); // sort the right half recursively
        merge(a,lo,mid,hi,aux); // merge both halves to one sorted half
    }
}

// function that merges two sub lists
void merge(int a[],int lo, int mid, int hi, int aux[])
{
    int i = lo;
    int j = mid + 1;
    int k;
    // copy the string to the aux at the exactly same positions
    for(k = lo; k <= hi; k++)
    {
        aux[k] = a[k];
    }

    // merge everything back to the original array a
    for(k = lo; k <= hi; k++)
    {
        if(i > mid)  // the first half is already merged in aux, but the second not yet
        {
            a[k] = aux[j];
            j++;
        }
        else  // the first half isn't empty
        {
            if(j > hi)  // the second half has been already merged
            {
                a[k]=aux[i]; // add the rest of the first half to the array
                i++;
            }
            else
            {
                if(aux[j] < aux[i])  // compare the values currently under consideration
                {
                    a[k]= aux[j];
                    j++;
                }
                else
                {
                    a[k]=aux[i];
                    i++;
                }
            }
        }
    }
}

void fsort(float data[], unsigned int n){
	//Sorts n floating point numbers stored in memory starting from *data
    int *aux = (int *) malloc(n * sizeof(int));
    recursive_merge(a,0,n-1,aux);
		printf("The sorted list is:");
    free(aux);
}


void main(){
	int n;
	int min_value;
	int max_value;
//Ask for n
	printf("Please enter here the amount of numbers that should be generated:");
	scanf("%i", &n)

	printf("\nPlease enter the min value of the wished data range:");
	scanf("%i", &min_value);
    //Ask for datarange
	printf("\nPlease eter the max value of the wished data range:");
	scanf("%i", &max_value)
	//error checking
	if(min_value >= max_value){
	printf("Error: Your min and max value are either in wrong order or they are the same.");
	}

	//generate floating points
	fsort(*data, n);
	//print sorted array

}
