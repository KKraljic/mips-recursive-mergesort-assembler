#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>

time_t start;
time_t end;
void start_time()
{
    start = time(NULL);
}
// return time since beginning of program execution register $9 in MIPS
int stop_time()
{
    end = time(NULL) - start;
    return end;
}

// gloabal variables - constants
uint32_t const_max_value = 2147483647; // 2^31 -1
int const_a = 1103515245; // init a value for 32 bit CPU
int const_b = 12345;      // init b
uint32_t const_m = 2147483648; // 2^31,

uint32_t x;

// random generator functions
void seed(int n) { // generate random x
    int execution_time = stop_time() * 3600; //seconds are to small
    int random_addr[1]; // some random address allocation
    uint32_t random_number = (uintptr_t) random_addr * execution_time;
    x = random_number / n;
}


// conflicting with rand of stdlib
uint32_t rand_1(){

    uint32_t y = 181218000;
    uint32_t z = 260644315;
    uint32_t c = 38271601;

    // Calculate linear congruential generator
    x = 69069 * x + const_b; // int a = 69069

    // Xor Shift
    y ^= y << 13;
    y ^= y >> 17;
    y ^= y << 5;

    // multiply with carry - custom

    /* The Assembler implementation might differ in that place
       to simplify things e.g. no 64 bit calculation
    */

    uint64_t t;
    t = 698769069ULL * z + c;
    c = t >> 32;
    z = (uint32_t) t;
    x = x + y +z;

    x = x % const_m;
    return x;
}

// retrun float value 0 > x < 1
float frand(){
    unsigned int current_rand = rand_1();
    float random_number = (float) current_rand / (float) const_max_value;
    return random_number;
}

float generate_list_item(int min_value, int max_value){
    float random_value = frand();
    float t = min_value + (random_value * ( max_value - min_value));
    printf("List item = %f\n",t);
    return t;
}

void generate_list(int n, int min, int max, float a[]){
    // This can be implemented with heap pointers incrementation in assembler and by decrementing n while n != 0
    int t = 0;
    while(t < n){
        a[t] = generate_list_item( min, max );
        printf("%f\n",a[t]);
        t++;
    }
}

// function that merges two sub lists
void merge(float a[],int lo, int mid, int hi, float aux[])
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

void recursive_merge(float a[], int lo, int hi, float aux[])
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

void print_sorted_array(float data[], int n){
    int temp;
    for(temp = 0; temp < n; temp++ ){
        printf("%f\n", data[temp] );
    }
}

void fsort(float data[], unsigned int n){
    //Sorts n floating point numbers stored in memory starting from *data
    float *aux =  malloc(n * sizeof(float)); // allocate memory on the heap
    recursive_merge(data,0,n-1,aux);
    printf("The sorted list is:");
    free(aux);
}
int main(){
    start_time();
    int n;
    int min_value;
    int max_value;
    //Ask for n

    printf("Please enter here the amount of numbers that should be generated:");
    scanf("%i", &n);
    if(n < 0){
        printf("The wanted amount of numbers is negative");
        return 0;
    }
    //Ask for datarange

    printf("\nPlease enter the min value of the wished data range:");
    scanf("%i", &min_value);

    printf("\nPlease enter the max value of the wished data range:");
    scanf("%i", &max_value);

    //error checking
    if(min_value >= max_value){
        printf("Error: Your min and max value are either in wrong order or they are the same.");
        return 0;
    }

    if((min_value > const_max_value) || (max_value > const_max_value) ){
        printf("We don't support such high numbers");
        return 0;
    }
    seed(n); // initialize seed
    float* data = malloc(n * sizeof(float));
    generate_list(n,min_value,max_value,data); // generate with random items
    fsort(data,n);             // sort the given items
    print_sorted_array(data,n);
    return 0;
}