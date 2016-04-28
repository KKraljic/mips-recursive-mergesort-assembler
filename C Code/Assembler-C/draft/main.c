#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>

// get time - $9 register in mips
clock_t timeclock;
void start_time()
{
    timeclock = clock();
}
// return time since beginning of program execution
int stop_time()
{
    timeclock = clock() - timeclock;
    int time_taken = ( (double) timeclock ) /CLOCKS_PER_SEC;
    return time_taken;
}
// gloabal variables - constants
int const_max_value = 2147483647; // 2^31 -1
int const_a = 1103515245; // init a value for 32 bit CPU
int const_b = 12345;      // init b
int const_b = 2147483648; // 2^31

int x; 

// random generator functions
void seed(int n) { // generate random x 
    int execution_time = stop_time();
    int random_addr[1]; // some random address allocation
    unsigned int random_number = (uintptr_t) random_addr * execution_time;
    x = random_number / n;
}
// conflicting with rand of stdlib
int rand_1(){
    
    int y = 181218000;
    int z = 260644315;
    int c = 38271601;
    
   // Calculate linear congruential generator
   x = 69069 * x + const_b; // int a = 69069
   
   // Xor Shift
   y ^= y << 13;
   y ^= y >> 17;
   y ^= y << 5;
   
   // multiply with carry
   
   /* The Assembler implementation might differ in that place
      to simplify things e.g. no 64 bit calculation.
   */
   uint64_t t;
   t = 698769069ULL * z + c;
   int c = t >> 32;
   int z = (uint32_t) t;
   x = x + y + z;
   x = x % const_max_value;
   return x;
}
// retrun float value 0 > x < 1
float frand(){
  unsigned int current_rand = rand_1();
  float result = (float) current_rand / max_random;
  return result;
}

int generate_list_item(int min_value, int max_value){
    return frand() * (max_value - min_value);
}

/* a contains the adress on the heap, in ASSEMBLER the $fp register
   can be used and incremented
 */
void generate_list(int n, int min, int max, int* a){
    while(n != 0){
        n--;
        *a = generate_list_item( min, max );
        a++; // increment integer pointer
        printf("%i\n", *a);
    }
}
/* This functions realizes the simple array assignment, assembler should 
   handle in a subroutine
*/
void assign_array_content(int* a, int* aux, int k, int j ){
    a[k] = aux[j];
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
        assign_array_content(&aux[0], &a[0],k,k);
        //aux[k] = a[k];
    }

    // merge everything back to the original array a
    for(k = lo; k <= hi; k++)
    {
        if(i > mid)  // the first half is already merged in aux, but the second not yet
        {   
            assign_array_content(&a[0], &aux[0],k,j);
            //a[k] = aux[j];
            j++;
        }
        else  // the first half isn't empty
        {
            if(j > hi)  // the second half has been already merged
            {
                assign_array_content(&a[0], &aux[0],k,i);
                //a[k]=aux[i]; // add the rest of the first half to the array
                i++;
            }
            else
            {
                if(aux[j] < aux[i])  // compare the values currently under consideration
                {
                    assign_array_content(&a[0], &aux[0],k,j);
                    //a[k]= aux[j];
                    j++;
                }
                else
                {
                    assign_array_content(&a[0], &aux[0],k,i);
                    //a[k]=aux[i];
                    i++;
                }
            }
        }
    }
}

// split and merge recursive
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
void fsort(float data[], unsigned int n){
	//Sorts n floating point numbers stored in memory starting from *data
    int *aux = (int *) malloc(n * sizeof(int));
    recursive_merge(a,0,n-1,aux);
		printf("The sorted list is:");
    free(aux);
}

void print_sorted_array(float data[], int n){
    for(int temp = 0; temp < n, temp++ ){
        printf("%f", data[temp] );    
    }
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
    //generate floating point numbers in array
    int[n] data = malloc(n * sizeof(int));
    // call fsort
	fsort(data, n);
	//print sorted array
    print_sorted_array(data, n);
}

