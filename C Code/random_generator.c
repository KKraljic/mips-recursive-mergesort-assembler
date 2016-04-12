#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int r; // ongoing rn value
int n; // number of items in list
float max_random; // maximum generated number of rand()

/* generates a positive integer r;
   n is the given number of items in the list
*/
void seed(int n) {
  int random_addr[1]; // used to get an arbitrary address on 32 bit maschine -> 4 byte
  printf("random address is: %p\n",random_addr);
   r = (uintptr_t) random_addr * n; // random_addr is a vector i.e. a random address
}
/*
  linear congruential generator
  rn = (a * rn-1 + b) mod m
  for a 32 bit CPU we use fixed values
  a = 1103515245, b = 12345, m = 2^(31)
*/
unsigned int rand_1() {
  int a = 1103515245; // init a
  int b = 12345; // init b
  unsigned int m = 2147483648; // equals 2^(31)
  unsigned int result = ((a * r) + b) % m; // formula for rn
  r = result; // adjust rn
  printf("The rand function returned rand = %d\n", result);
  return result;
}
/*
  generates a random number
  between 0.0 and 1.0
*/
float frand() {
  unsigned int current_rand = rand_1();
  float result = (float) current_rand / max_random;
  return result;
}

int main() {
  n = 12; // set gloabl value n
  seed(n); // generate initial random number for calculation
  max_random = 2147483647; // equals 2^(31) - 1
  // sample test
  float frandom = frand();
  printf("The following random number was gnerated %f\n", frandom);
  return 0;
}
