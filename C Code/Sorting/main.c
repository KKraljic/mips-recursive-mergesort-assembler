#include <stdio.h>
#include <stdlib.h>



void swap(int* r, int* i)
{
    int temp;
    temp = *i;
    *i = *r;
    *r = temp;
}

void print_array(int array[], int length)
{
    int i;
    for(i = 0; i < length; i++ )
    {
        printf("_%d",array[i]);
    }
    printf("\n");
}

int low(int x, int y)
{
    return x < y ? x:y;
}




// The Knuth shuffle algorithm
void shuffle(int a[], int n)
{
    int i,r;
    for(i = 0; i < n-1; i++)
    {
        r = i + (rand() % (n-i-1))+1;
        swap(&a[r],&a[i]);
    }
}

// Quicksort section --------------------------------------------------------------------------------------------------------

// simple quicksort with randomised data
void quicksort_1(int a[], int from, int to)
{
    int i, pivot, temp;
    // set array reference to the pivot
    pivot = from;
    if (from < to)
    {
        for(i = from; i <= to; i++)
        {
            // save the current value under consideration
            temp = a[i];
            if(temp < a[pivot]) // check if the current value belongs to the left of the pivot
            {
                // rearrange the array
                // shift values to the right
                a[i] = a[pivot + 1];
                a[pivot + 1] = a[pivot];
                a[pivot] = temp;
                pivot++;
            } // else a[i] stays on the right

        }
        quicksort_1(a,from,pivot-1); // left partition
        quicksort_1(a,pivot+1,to); // right partition
    }
} // end quicksort

/*
    quicksort with median values

*/
void quicksort_2(int a[], int from, int to)
{
    // Median calculation, the median will be at position one
    int m=(from+to)/2;

    if( a[from] < a[m])
    {
        swap(&a[from],&a[m]);
    }
    if ( a[m] < a[to])
    {
        swap(&a[m],&a[to]);
    }
    if(a[from] > a[m])
    {
        swap(&a[from],&a[m]);
    }

// now use the the original quicksort as the median is at position one in the array
    int i, pivot, temp;
    // set array reference to the pivot
    pivot = from;
    if (from < to)
    {
        for(i = from; i <= to; i++)
        {
            // save the current value under consideration
            temp = a[i];
            if(temp < a[pivot]) // check if the current value belongs to the left of the pivot
            {
                // rearrange the array
                // shift values to the right
                a[i] = a[pivot + 1];
                a[pivot + 1] = a[pivot];
                a[pivot] = temp;
                pivot++;
            } // else a[i] stays on the right

        }
        quicksort_1(a,from,pivot-1); // left partition
        quicksort_1(a,pivot+1,to); // right partition
    }
}


// call quicksort with randomized array chose first as pivot
void sort_quick()
{
    // get the randomize array here
    int a[5] = {1,2,3,4,5};
    print_array(a,5);
    shuffle(a,5);
    print_array(a,5);
    quicksort_2(a,0,4);
    print_array(a,5);

    // call quicksort_1 here
}

// MergeSort section -----------------------------------------------------------------------------------------------

/* an in_place merge function
   lo -> start index of first list
   mid -> end of first ( but belongs to it)
   hi -> end of second list
*/
void in_place_merge(int a[], int lo, int mid, int hi) // quite inefficient since in_place is forced
{
    // pointers to the first element of each list
    int i = lo;
    int border = mid + 1;

    // just a container for temporary things
    int shiftvalue,tmp;
    // just a iterator for moving the elements to the correct position
    int j;

    while( border < hi)
    {
        while( i < border)
        {
            // check if left element already in place
            if (a[i] <= a[border])
            {
                // the left element stays in place
                i++;
                //print_array(a,8);
            }
            else
            {
                // the elements need to be rearranged
                shiftvalue = a[i];
                a[i] = a[border];
                a[border] = shiftvalue;

                // shift the tmp from its position to the correct position in the left list
                // move the border so you merge two sorted lists again
                j = border;
                while(a[j-1] > a[j])
                {
                    tmp = a[j-1];
                    a[j-1] = shiftvalue;
                    a[j] = tmp;
                    j--;
                }
                border++;
                //print_array(a,8);
            }

        }
        // change the position of i
        //i = lo;
        border++;
    }

}

// normal merge -----------------------------------------
void merge(int a[],int lo, int mid, int hi, int aux[])
{
    int i = lo;
    int j = mid + 1;
    int k;
    // copy the string to the aux at the exactly same positions
    for(k = lo; k <= hi; k++)
    {
        aux[k] = a[k];
        printf("Your are at position 1 k(s6) = %d, j(s5) = %d, i(s7) = %d\n\n",k,j,i);
    }

    // merge everything back to the original array a
    for(k = lo; k <= hi; k++)
    {
        if(i > mid)  // the first half is already merged in aux, but the second not yet
        {
            a[k] = aux[j];
            printf("Your are at position 2 k(s6) = %d, j(s5) = %d i(s7)= %d\n\n",k,j,i);
            j++;
        }
        else  // the first half isn't empty
        {
            if(j > hi)  // the second half has been already merged
            {
                a[k]=aux[i]; // add the rest of the first half to the array
                printf("Your are at position 3 k(s6) = %d, i(s7) = %d, j(s5) = %d\n\n",k,i,j);
                i++;
            }
            else
            {
                if(aux[j] < aux[i])  // compare the values currently under consideration
                {
                    a[k]= aux[j];
                    printf("Your are at position 4 with i(s7) = %d, j(s5) = %d, k(s6) = %d\n\n",i,j,k);
                    j++;
                }
                else
                {
                    a[k]=aux[i];
                    printf("Your are at position 5 with i(s7) = %d, k(s6) = %d j(s5) = %d\n\n",i,k,j);
                    i++;
                }
            }
        }
    }
}

// natural merge sort --------
void natural_merge_sort(int a[], int n)
{
    int lo, hi, check, mid, str1,str2,finished;
    finished = 0; // means false
    while(!finished)
    {
        // comes back to merge the bigger strings
        check = 0;
        lo = 0;
        while (lo < n) // while there are strings to merge
        {
            // the first string that is in natural order contains at least one element
            str1 = 1;
            /* first argument checks if str1 does not exceed the whole array the second if the right neigthbour is greater*/
            while((lo + str1) < n && a[lo + str1 -1] <= a[lo + str1] )
            {
                str1++; // extend the string to this amount
            }
            // do the same procedure for the second string
            str2 = 1;
            while((lo + str2) < n && a[lo +str2 -1]<= a[lo + str2])
            {
                str2++;
            }

            mid = lo + str1 - 1;
            hi = low((lo + str1 + str2 -1),n-1); // check for end of the array
            in_place_merge(a,lo,mid,hi);
            // now start withe merging the next two strings
            lo = lo +str1 + str2; // start with the next pair of strings
            check++;

        }
        finished = check <= 1; // is there a string left to merge? yes or no?
        // if the algorithm merged more than one string we go to the super level merging the strings we merged just before
    }

}
// recursive merge_sort -----------------------------------------

void recursive_merge(int a[], int lo, int hi, int aux[]){
    int mid;
    if (hi > lo){
        mid = (lo + hi)/2; // divide the list into two halfs
        recursive_merge(a,lo,mid,aux); // sort the left half recursively
        recursive_merge(a,mid+1,hi,aux); // sort the right half recursively
        merge(a,lo,mid,hi,aux); // merge both halves to one sorted half
    }
}
void recursive_merge_sort(int a[], int n){
    int *aux = (int *) malloc(n * sizeof(int));
    recursive_merge(a,0,n-1,aux);
    free(aux);
}

// import data from file --------------------------------------------------------------------------
void importDataFromFile(int a[], int n)
{
    FILE *datafile;
    datafile =  fopen("random_data.txt", "r");
    //read file into array
    int i;
    for (i = 0; i < n; i++)
    {
        fscanf(datafile, "%d", &a[i]);
    }
    fclose(datafile);
}



// main part -------------------------------------------------------------------------------------------------------
int main()
{
    printf("Hello world!\n");
    int a[5] = {3,2,4,1,5};
    //int a[8];
    //importDataFromFile(a,8);
    print_array(a,5);
    recursive_merge_sort(a,5);
    print_array(a,5);
    return 0;
}






