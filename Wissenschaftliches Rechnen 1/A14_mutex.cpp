//Eine Variable wird von 2 Threads hochgezählt; Mutex soll gewährleisten, dass keine
// Iteration übersprungen wird (funktioniert noch nicht)

#include <iostream>
#include <thread>
#include <atomic>

std::atomic<int> barrier_count;
std::atomic<int> mutex;
const int num_threads = 2;

void count_up(int end, int* res){
	for(int i=0;i<end;++i){
		while(mutex==1){
			std::cout << "waiting for mutex "<< std::endl;		
		}
		// Begin of Mutex
		mutex = 1;		
		*res+=1;
		mutex = 0;
		// End of Mutex
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


	// Barriere
	while (barrier_count < num_threads){
		std::cout << "barrier count: " << barrier_count << std::endl; 
	}

	//t1.join();
	//t2.join();

	std::cout << "Summe:" << res << std::endl;	

	
}
