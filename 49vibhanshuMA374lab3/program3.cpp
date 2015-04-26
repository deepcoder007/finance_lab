#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<set>
#include<vector>
#include<map>
#include<cmath>
#include<climits>
using namespace std;


float S0=100;
float K=100;
float T=1;
float r=0.08;
float sigma=0.2;
int M=100;

float max(float a,float b)
{
	if( a>b ) return a;
	else return b;
}

double max( double a, double b)
{
	if( a> b) return a;
	else return b;
}

float u(float delta_t)
{
	return exp(sigma*sqrt(delta_t));
}

float u2(float delta_t)
{
	return exp( sigma*sqrt(delta_t) + (r-0.5*sigma*sigma )*delta_t );
}
	
float d(float delta_t)
{
	return exp(-sigma*sqrt(delta_t));
}

float d2(float delta_t)
{
	return exp( -sigma*sqrt(delta_t) + ( r-0.5*sigma*sigma )*delta_t );
}

	
double discount_rate(double t)
{
	return exp(r*t);
}

float p(float delta_t)
{
	return ( exp(r*delta_t) - d(delta_t) )/ ( u(delta_t) -d(delta_t) ) ;
}

float q(float delta_t)
{
	return ( u(delta_t) - exp(r*delta_t) )/ ( u(delta_t) - d(delta_t) );
}

/// Calculated using u2,d2
double p2(double delta_t)
{
	return ( exp(r*delta_t) - d2(delta_t) )/ ( u2(delta_t) -d2(delta_t) ) ;
}

double q2(double delta_t)
{
	return ( u2(delta_t) - exp(r*delta_t) )/ ( u2(delta_t) - d2(delta_t) );
}

// This is for the call option(recursive)
// maxpath -> it is used to store the max value until now
double get_lookback(double t,double S,double delta_t,double mx_path)    // returns the price of the option at time t if the price os stock is S )
{
	if(t>=T)
	{
		return (mx_path - S);
	}
	else
	{
		double t1=get_lookback(t+delta_t , S*u2(delta_t) , delta_t, max( S*u2(delta_t), mx_path) );
		double t2=get_lookback(t+delta_t , S*d2(delta_t) , delta_t, max( S*d2(delta_t), mx_path) );
		return  ( p2(delta_t)*t1 +q2(delta_t)*t2)/discount_rate(delta_t) ;
	}
}
		

// This function returns a Brownian path
vector<double> get_path(double delta_t,double S0)
{
	double U= u2(delta_t);
	double D= d2(delta_t);
	double P = p2(delta_t);
	vector<double> out;  // the output to be appended;
	double i=0;
	double curr;
	curr=S0;
	for(i=0; i<=1 ; i+=delta_t ) 
	{
		if( ((double)rand()/RAND_MAX ) <  P )  // i.e. stock going up
		{
			curr = curr*U;
			out.push_back( curr );
		}
		else
		{
			curr = curr*D;
			out.push_back( curr );
		}
	}
	return out;
}

double get_price( vector<double> path )   // return the price of the option according to the vector
{
	double mx = 0;  // 
	vector<double>::iterator it;
	for(it= path.begin() ; it!=path.end() ; it++)
	{
		mx = max( mx, *it );
	}
	return (mx - path[ path.size()-1 ] );
}


double get_lookback_price(double delta_t, double S0 )  // Generates thousands of path and then take their average
{
	double price =0;
	int count =0;
	for(count =0 ;count < 1000000; count++)
		price += get_price( get_path(delta_t, S0 ));
	return (price/count)/discount_rate(1.0);
}

FILE* ptr;

int main()
{
	double delta_t;

	// Part (a)
	S0=100;
	K=100;
	T=1;
	r=0.08;
	sigma=0.2;



	M=5;
	delta_t=T/M;
	cout<<"For M = 5 : "<< get_lookback_price(delta_t, S0 )<<endl;


	M=10;
	delta_t=T/M;
	cout<<"For M = 10 : "<< get_lookback_price(delta_t, S0 )<<endl;


	M=25;
	delta_t=T/M;
	cout<<"For M = 25 : "<< get_lookback_price( delta_t, S0 )<<endl;


	M=50;
	delta_t=T/M;
	cout<<"For M = 50 : "<< get_lookback_price( delta_t, S0 )<<endl;

	return 0;
}
	
