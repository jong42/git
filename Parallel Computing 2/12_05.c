#include <iostream>
#include <stdio.h>
#include <omp.h>
#include <vector>

using namespace std;

int sum(vector<int> nums) {
	int ret = 0;
	for (int i=0; i < nums.size();i++)
		ret +=nums[i]
	return ret;
}

int recursive_sum (vector<int> nums) {
	int half = nums.size()/2;
	return sum(nums_half1, nums_half2);
}

int main (void) {
	std::cout << "Hello, World!" << std::endl;
	return 0;
}

