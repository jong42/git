#include <iostream>
#include <stdio.h>
#include <omp.h>
#include <vector>

using namespace std;

//int sum(vector<int> nums) {
//	int ret = 0;
//	for (int i=0; i < nums.size();i++)
//		ret +=nums[i];
//	return ret;
//}

int recursive_sum (int* nums, int size) {
	int half = size/2;
	int ret = 0;
	if (size==0) return 0;
	if (size==1) return nums[0];
	int ret1 = 0, ret2 = 0;
	ret1 = recursive_sum(nums, half);
	ret2 = recursive_sum(nums + half, size - half);
	ret = ret1 + ret2;
	}

int omp_recursive_sum (int* nums, int size) {
	int half = size/2;
	int ret = 0;
	if (size==0) return 0;
	if (size==1) return nums[0];
	int ret1 = 0, ret2 = 0;
#pragma omp parallel
	{
#pragma omp task shared(ret1)	
	ret1 = recursive_sum(nums, half);
#pragma omp task shared(ret2)
	ret2 = recursive_sum(nums + half, size - half);
	ret = ret1 + ret2;
	}
}


int main() {
	int arr[] = {1, 2, 3, 4, 5};
	cout << recursive_sum(arr,5) << endl;
	cout << omp_recursive_sum (arr,5)
}


//void test() {
//	int a = 1;
//#pragma omp task shared(a)
//	{
//#pragma omp critical
//		cout << "a" << a << endl;
//	}
//}

//int main() {
//	omp_set_num_threads(10);
//#pragma omp parallel
//	{
//		test();
//	}
//}

//int main () {
//#pragma omp  parallel shared(x)
//	{
//		int x = 0;
//#pragma omp single
//	{
//		{
//#pragma omp task 
//	x = x+1;
//	std::cout << "x von task 1: " << x << std::endl;
//		}
//#pragma omp taskwait
//		{
//#pragma omp task
//	x = x+1;
//	std::cout << "x von task 2: " << x << std::endl;
//		}
//	}
//}
//	return 0;
//}

