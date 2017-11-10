#include <iostream>
#include <vector>

using namespace std;
int vector_prod(int d1[3],int d2[3]){
	int res = 0;
	for (int i=0;i < 3;i++) {
		res = res + d1[i] * d2[i];
	}
	return res;
}

int vector_prod2(vector <double> d1, vector <double> d2){
	double res = 0;
	for (int i=0;i < d1.size();i++) {
		res = res + d1[i] * d2[i];
	}
	return res;
}


vector <double> add (const vector<double>& a,const vector<double>& b) {
	vector<double> c(a.size(),0);
	for (int i=0,i<a.size();i++) {
		c[i] = a[i] +b[i];
	}
	return c;
}

// Erlaubt mehrere "Ausgaben"
void add2 (const vector<double>& a,const vector<double>& b, vector<double>& c,vector<double>& d ) {
	vector<double> c(a.size(),0);
	for (int i=0,i<a.size();i++) {
		c[i] = a[i] + b[i];
		d[i] = a[i] * b[i];
	}
}

// Nutzung von Iteratoren für bessere Laufzeit
void add3 (const vector<double>& a,const vector<double>& b, vector<double>& c,vector<double>& d ) {
	vector<double> c(a.size(),0);
	vector<double>::const_iterator ia = a.begin(),ib=b.begin(),ic=c.begin();
	for (;ia!=a.end(),ib!=b.end(), ic!=c.end();ia++,ib++,ic++) {
		*ic = *ia + *ib;
		d+= *ia**ib;
	}
}

int main() {
	int d_1[3] = {1,3,5};
	int d_2[3] = {2,4,6};
	vector <double> d_3 = {1,3,5};
	vector <double> d_4 = {2,4,6};
	cout << vector_prod2(d_3,d_4) << std::endl;
	return 0;
}


