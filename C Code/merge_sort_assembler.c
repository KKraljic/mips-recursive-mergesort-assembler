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

void fsort(float *data, unsigned int n){
	//Sorts n floating point numbers stored in memory starting from *data
	
}


void main(){
	//Ask for n
	//error_check_amount_numbers_input
	//Ask for datarange
	//error_check_datarange_input
	//generate floating points
	fsort(*data, n);
	
}
