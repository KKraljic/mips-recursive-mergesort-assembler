#include <stdio.h>
#include <stdlib.h>

void seed(uint32_t r){
	//Initializes random generator; r is start value
}

uint32_t rand(){
	uint32_t random_number;
	random_number = 0;
	//Generates positive integers between 0 and 2^(31)-1 as random number
	return random_number
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
    data_comp_counter++;
    if (hi > lo)
    {
        mid = (lo + hi)/2; // divide the list into two halfs
        recursive_merge(a,lo,mid,aux); // sort the left half recursively
        recursive_merge(a,mid+1,hi,aux); // sort the right half recursively
        merge(a,lo,mid,hi,aux); // merge both halves to one sorted half
    }
}
void recursive_merge_sort(int a[], int n)
{
    int *aux = (int *) malloc(n * sizeof(int));
    recursive_merge(a,0,n-1,aux);
	printf("The sorted list is:");
    free(aux);
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
        array_acess_counter += 2;
    }

    // merge everything back to the original array a
    for(k = lo; k <= hi; k++)
    {
        data_comp_counter++;
        if(i > mid)  // the first half is already merged in aux, but the second not yet
        {
            a[k] = aux[j];
            j++;
            array_acess_counter += 2;
        }
        else  // the first half isn't empty
        {
            data_comp_counter++;
            if(j > hi)  // the second half has been already merged
            {
                a[k]=aux[i]; // add the rest of the first half to the array
                i++;
                array_acess_counter += 2;
            }
            else
            {
                array_acess_counter +=2;
                data_comp_counter++;
                if(aux[j] < aux[i])  // compare the values currently under consideration
                {
                    a[k]= aux[j];
                    j++;
                    array_acess_counter += 2;
                }
                else
                {
                    a[k]=aux[i];
                    i++;
                    array_acess_counter +=2;
                }
            }
        }
    }
}

void fsort(float *data, unsigned int n){
	//Sorts n floating point numbers stored in memory starting from *data
	
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
