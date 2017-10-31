all:
	nvcc -O3 -Xptxas -dlcm=ca -arch=sm_35 performance.cu -o performance

debug:
	nvcc -g -G -arch=sm_35 performance.cu -o performance
