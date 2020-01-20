#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cmath>

// To size tou pinaka
#define size 3

__global__ void dinami(int* a, int* b, int* c) {
	
	for (int i = 0; i < size; i++) {
		c[threadIdx.x * size + i] = pow((double)a[threadIdx.x * size + i] - b[threadIdx.x * size + i],3);
	}
	
}

int main(void) {
	int A[size][size];      //Dimiourgo tous pinakes A,B,C
	int B[size][size];
	int C[size][size];
	int* dev_a;      //Dimiourgoume device copies tou a,b,c (pointers)
	int* dev_b;		//gia na stiloume ta dedomena stin GPU
	int* dev_c;
	int i = 0, j = 0;

	// Gemizo tous Pinakes A & B
	for ( i = 0; i < size; i++) {
		for ( j = 0; j < size; j++) {
			A[i][j] = rand() % 10;
			B[i][j] = rand() % 10;
			printf("A[%i][%i]: %i ", i, j, A[i][j]);
			printf("B[%i][%i]: %i \n", i, j, B[i][j]);
		}
		printf("\n");
	}

	// Dilonoume to megethos tou pinaka pou 8a xriastoume
	int size_2d = size * size * sizeof(int);

	// Desmeuo mnimi sto sistima
	cudaMalloc(&dev_a, size_2d);
	cudaMalloc(&dev_b, size_2d);
	cudaMalloc(&dev_c, size_2d);

	// Copy ton dedomenon stin mnimi tis GPU (meso pointers)
	cudaMemcpy(dev_a, A, size_2d, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, B, size_2d, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c, C, size_2d, cudaMemcpyHostToDevice);

	// Kalo tin kernel
	dinami << < size, size >> > (dev_a, dev_b, dev_c);

	// Travao to output piso stin CPU
	cudaMemcpy(C, dev_c, size_2d, cudaMemcpyDeviceToHost);

	// Ta emfanizo
	printf("\n");
	for (i = 0; i < size; i++) {
		for (j = 0; j < size; j++) {
			printf("C[%i][%i]: %i \n", i, j, C[i][j]);
		}
	}

	// Eleutherono tin mnimi
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
}