#include "mylib.h"
#include "mylib.cuh"
#include "opencv2/opencv.hpp"
#include <cuda_runtime.h>


int main(int, char**)
{ 	
	VideoCapture cap(0); // open the default camera
	if(!cap.isOpened())  // check if we succeeded
		return -1;
	
	while(1){
		Mat frame;
	    	cap >> frame;
	    	char c=(char)waitKey(25);
		if(c == '1'){				// if '1' est appuye
			Mat NB = noirBlanc(frame);
	    		imshow("NoirEtBlanc", NB);
		}
		else if(c == '2'){			// if '2' est appuye
			Mat seuil = seuillage(frame);
	    		imshow("seuillage", seuil);
		}
		else if (c == '3'){			// if '3' est appuye
			Mat cont = contour(frame);
	    		imshow("contour", cont);
		}
		else if (c == '4'){			// if '4' est appuye
			Mat seuilgpu = seuillageGPU(frame);
	    		imshow("seuillage GPU",seuilgpu);
		}
		else if(c == '0') destroyAllWindows();	// if '0' est appuye

		else imshow("frame", frame);
			
	    	if(c==27)				// if 'esc' est appuye
	      		break;
	}
  	// When everything done, release the video capture object
	cap.release();

	// Closes all the frames
	destroyAllWindows();

	return 0;
}
