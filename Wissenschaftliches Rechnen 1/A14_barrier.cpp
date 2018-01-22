// Zwei Variablen werden hochgezählt und deren Summe ausgegeben. Die Barriere ist
// notwendig, damit die Summe nicht ausgegeben wird, bevor beide Threads ihre 
// Ergebnisse geschrieben haben

#include <iostream>
#include <thread>
#include <atomic>

std::atomic<int> barrier_count;
const int num_threads = 2;

void count_up(int start, int end, int* res){
	for(int i=0;i<end;++i){
		start+=1;
	}
	*res = start;
	barrier_count+=1;
}

int main(){
	
	barrier_count = 0;
	int n = 20;
	int x = 0;
	int res_1 = 0;
	int res_2 = 0;

	std::thread t1(count_up, x, n, &res_1);
	std::thread t2(count_up, x, n, &res_2);
	
	// Barriere
	while (barrier_count!=num_threads){
		true;	
	}

	int res_total = res_1+res_2;

	//t1.join();
	//t2.join();


	std::cout << "Summe:" << res_total << std::endl;

}
