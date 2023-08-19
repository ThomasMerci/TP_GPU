/*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

/* Template project which demonstrates the basics on how to setup a project 
 * example application.
 * Host code.
 */

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <iostream>
using namespace std;

// includes CUDA
#include <cuda_runtime.h>

#include "saxpy.h"

__global__ void saxpy_kernel(float *vector_SAXPY, float A, float *vector_X, float *vector_Y, int N)
{
	// A VOUS DE CODER

}



////////////////////////////////////////////////////////////////////////////////
// declaration, forward
void runTest( int argc, char** argv);




////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main( int argc, char** argv) 
{

	runTest( argc, argv);
}

__host__ static int iDivUp(int a, int b) {
	return ((a % b != 0) ? (a / b + 1): (a/b));
}

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest( int argc, char** argv) 
{
	cudaError_t error;

	unsigned long int N=256*1024;

	const unsigned int mem_size = N*sizeof(float);
	// allocate host memory
	float* h_vector_X = (float*) malloc(mem_size);
	float* h_vector_Y = (float*) malloc(mem_size);

	//Initilaisation des données d'entrée
	float A=1.0;

	for (int i=0;i<N;i++){
		h_vector_X[i]=(float)rand();
		h_vector_Y[i]=(float)rand();
	}


	////////////////////////////////////////////////////////////////////////////////
	// EXECUTION SUR LE CPU
	///////////////////////////////////////////////////////////////////////


	// Image trait�e sur le CPU
	float* h_vector_SAXPY_CPU = (float*) malloc( mem_size);

	printf("SAXPY CPU\n");

	cudaEvent_t start,stop;
	error = cudaEventCreate(&start);
	error = cudaEventCreate(&stop);

	// Record the start event
	error = cudaEventRecord(start, NULL);
	error = cudaEventSynchronize(start);
	//Seuillage sur CPU
	// A VOUS DE CODER

	// Record the start event
	error = cudaEventRecord(stop, NULL);
	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop);
	float msecTotal = 0.0f;
	error = cudaEventElapsedTime(&msecTotal, start, stop);


	printf("CPU execution time %f\n",msecTotal);



	////////////////////////////////////////////////////////////////////////////////
	// EXECUTION SUR LE GPU
	///////////////////////////////////////////////////////////////////////

	printf("SAXPY GPU\n");

float* h_vector_SAXPY_GPU = (float*) malloc(mem_size);

	// images on device memory
	float* d_vector_X;
	float* d_vector_Y;
	float* d_vector_SAXPY;


	cudaEvent_t start_mem,stop_mem;
	error = cudaEventCreate(&start_mem);
	error = cudaEventCreate(&stop_mem);

	error = cudaEventRecord(start, NULL);
	error = cudaEventSynchronize(start);



	
	// Alocation mémoire de d_vector_X, d_vector_Y et d_vector_SAXPY sur la carte GPU
	// A VOUS DE CODER

	// copy host memory to device
	// A VOUS DE CODER


	error = cudaEventRecord(stop_mem, NULL);
	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop_mem);
	float msecMem = 0.0f;
	error = cudaEventElapsedTime(&msecMem, start, stop_mem);

	// setup execution parameters -> découpage en threads
	// A VOUS DE CODER


	// lancement des threads executé sur la carte GPU
	// A VOUS DE CODER

	error = cudaEventRecord(start_mem, NULL);
	error = cudaEventSynchronize(start_mem);

	// copy result from device to host
	// A VOUS DE CODER

	// cleanup device memory
	// COMMENTAIRES A ENLEVER
	//cudaFree(d_vector_X);
	//cudaFree(d_vector_Y);
	//cudaFree(d_vector_SAXPY);


	error = cudaEventRecord(stop, NULL);
	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop);
	msecTotal = 0.0f;
	error = cudaEventElapsedTime(&msecTotal, start, stop);
	float msecMem2 =0.0f;
	error = cudaEventElapsedTime(&msecMem2, start_mem, stop);
	msecMem+=msecMem2;

	printf("GPU execution time %f ms (memory management %2.2f \%)\n",msecTotal,(msecMem)/(msecTotal)*100);

	float sum_diff=0;
for(int i=0;i<N;i++)
	sum_diff+= h_vector_SAXPY_GPU[i]-h_vector_SAXPY_CPU[i];

	printf("sum_diff = %f\n",sum_diff);

	// cleanup memory
	free(h_vector_X);
	free(h_vector_Y);
	free(h_vector_SAXPY_GPU);
	free(h_vector_SAXPY_CPU);
}
