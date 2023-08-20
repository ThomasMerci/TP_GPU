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

#include "seuillage.h"

__global__ void seuillage_kernel(float d_image_in[][SIZE_J][SIZE_I],float d_image_out[][SIZE_J][SIZE_I])
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

////////////////////////////////////////////////////////////////////////////////
//! Run a simple test for CUDA
////////////////////////////////////////////////////////////////////////////////
void
runTest( int argc, char** argv) 
{
	cudaError_t error;

	if (argc<2)
		printf("indiquer le chemin du repertoire contenant les images\n");

	const unsigned int mem_size = sizeof(float) * 3* SIZE_J * SIZE_I;
	// allocate host memory
	float* h_image_in = (float*) malloc(mem_size);


	//Initilaisation du volume d'entr�e
	FILE *file_ptr;
	char name_file_in[512];
	sprintf(name_file_in,"%s/ferrari.raw",argv[1]);
	printf("%s",name_file_in);
	file_ptr=fopen(name_file_in,"rb");
	fread(h_image_in,sizeof(float),3*SIZE_J*SIZE_I,file_ptr);
	fclose(file_ptr);


	////////////////////////////////////////////////////////////////////////////////
	// EXECUTION SUR LE CPU
	///////////////////////////////////////////////////////////////////////


	// Image trait�e sur le CPU
	float* h_image_out_CPU = (float*) malloc( mem_size);

	printf("Seuillage CPU d'une image couleur \n");

	cudaEvent_t start,stop;
	error = cudaEventCreate(&start);
	error = cudaEventCreate(&stop);

	// Record the start event
	error = cudaEventRecord(start, NULL);
	error = cudaEventSynchronize(start);
	//Seuillage sur CPU
	seuillage_C( (float (*)[SIZE_J][SIZE_I])h_image_out_CPU, (float (*)[SIZE_J][SIZE_I])h_image_in);

	// Record the start event
	error = cudaEventRecord(stop, NULL);
	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop);
	float msecTotal = 0.0f;
	error = cudaEventElapsedTime(&msecTotal, start, stop);


	printf("CPU execution time %f\n",msecTotal);

	//Sauvegarde de l'image resultat
	char name_file_out_CPU[512];
	sprintf(name_file_out_CPU,"%s/ferrari_out_CPU.raw",argv[1]);
	file_ptr=fopen(name_file_out_CPU,"wb");
	fwrite(h_image_out_CPU,sizeof(float),3*SIZE_J*SIZE_I,file_ptr);
	fclose(file_ptr);


	////////////////////////////////////////////////////////////////////////////////
	// EXECUTION SUR LE GPU
	///////////////////////////////////////////////////////////////////////

	cudaEvent_t start_mem,stop_mem;
	error = cudaEventCreate(&start_mem);
	error = cudaEventCreate(&stop_mem);

	error = cudaEventRecord(start, NULL);
	error = cudaEventSynchronize(start);


	float* h_image_out_GPU = (float*) malloc(mem_size);

	// images on device memory
	float* d_image_in;
	float* d_image_out;



	// Alocation mémoire de d_image_in et d_image_out sur la carte GPU
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
	// INDICATION : pour les parametres de la fonction kernel seuillage_kernel, vous ferez un changement de type (float *) vers  (float (*)[SIZE_J][SIZE_I])
	// inspirez vous du lancement de la fonction seuillage_C dans le main.

	// Record the start event



	error = cudaEventRecord(start_mem, NULL);
	error = cudaEventSynchronize(start_mem);

	// copy result from device to    host
	// A VOUS DE CODER


	// cleanup device memory
	//ENLEVEZ LES COMMENTAIRES
	//cudaFree(d_image_in);
	//cudaFree(d_image_out);


	error = cudaEventRecord(stop, NULL);
	// Wait for the stop event to complete
	error = cudaEventSynchronize(stop);
	msecTotal = 0.0f;
	error = cudaEventElapsedTime(&msecTotal, start, stop);
	float msecMem2 =0.0f;
	error = cudaEventElapsedTime(&msecMem2, start_mem, stop);
	msecMem+=msecMem2;

	printf("GPU execution time %f ms (memory management %2.2f \%)\n",msecTotal,(msecMem)/(msecTotal)*100);

	// Enregistrement de l'image de sortie sur un fichier
	char name_file_out_GPU[512];
	sprintf(name_file_out_GPU,"%s/ferrari_out_GPU.raw",argv[1]);
	file_ptr=fopen(name_file_out_GPU,"wb");
	fwrite(h_image_out_GPU,sizeof(float),3*SIZE_J*SIZE_I,file_ptr);
	fclose(file_ptr);


	// cleanup memory
	free(h_image_in);
	free(h_image_out_GPU);
	free(h_image_out_CPU);




}
