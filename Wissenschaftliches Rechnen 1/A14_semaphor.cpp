//Eine Variable wird von 3 Threads hochgezählt; Semaphor...

#include <iostream>
#include <thread>
#include <atomic>

std::atomic<int> barrier_count;
std::atomic<int> semaphor;
const int num_threads = 3;

void count_up(int end, int* res){
	for(int i=0;i<end;++i){
		while(semaphor >= 1){
			std::cout << "waiting for semaphor "<< std::endl;		
		}
		// Begin of Semaphor
		semaphor += 1;		
		*res+=1;
		semaphor -= 1;
		// End of Semaphor
	barrier_count+=1;
	}
}

int main(){
	
	barrier_count = 0;
	mutex = 0;
	int n = 20;
	int res = 0;

	std::thread t1(count_up, n, &res);
	std::thread t2(count_up, n, &res);
	std::thread t3(count_up, n, &res);


	// Barriere
	while (barrier_count < num_threads){
		std::cout << "barrier count: " << barrier_count << std::endl; 
	}

	//t1.join();
	//t2.join();
	//t3.join();
	std::cout << "Summe:" << res << std::endl;	

	
}
