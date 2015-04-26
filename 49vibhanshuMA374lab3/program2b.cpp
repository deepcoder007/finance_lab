#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cmath>
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

	
float discount_rate(float t)
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
float p2(float delta_t)
{
	return ( exp(r*delta_t) - d2(delta_t) )/ ( u2(delta_t) -d2(delta_t) ) ;
}

float q2(float delta_t)
{
	return ( u2(delta_t) - exp(r*delta_t) )/ ( u2(delta_t) - d2(delta_t) );
}

// This is for the call option(recursive)
// maxpath -> it is used to store the max value until now
float get_lookback(float t,float S,float delta_t,float mx_path=-1)    // returns the price of the option at time t if the price os stock is S )
{
	if( mx_path==-1 )  mx_path=S ;    // i.e. the starting point of the loop
	if(t>=T)
	{
		return (mx_path - S);
	}
	else
	{
		float t1=get_lookback(t+delta_t , S*u2(delta_t) , delta_t, max( S*u2(delta_t), mx_path) );
		float t2=get_lookback(t+delta_t , S*d2(delta_t) , delta_t, max( S*d2(delta_t), mx_path) );
		return  ( p2(delta_t)*t1 +q2(delta_t)*t2)/discount_rate(delta_t) ;
	}
}
		
FILE* ptr;


int main()
{
	float delta_t;

	// Part (a)
	S0=100;
	K=100;
	T=1;
	r=0.08;
	sigma=0.2;

	cout<<"All the intermediate values for M = 5 "<<endl;
	M=5;
	delta_t=T/M;
	cout<<"At i=0 "<< get_lookback(0,S0, delta_t, S0 )<<endl;
	cout<<"At i=1 "<< get_lookback(delta_t , S0*u2(delta_t), delta_t, S0*u2(delta_t) )<<"   "<< get_lookback(delta_t , S0*d2(delta_t) , delta_t, S0*d2(delta_t) )<<endl;
	cout<<"At i=2 "<< get_lookback(delta_t*2 , S0*pow(u2(delta_t),2) ,delta_t )<<"   "<<get_lookback(delta_t*2, S0*pow(u2(delta_t),1)*pow(d2(delta_t),1) , delta_t ) << "  "<< get_lookback( delta_t*2 , S0*pow(d2(delta_t),2) ,delta_t ) <<endl;
	cout<<"At i=3 "<< get_lookback(delta_t*3 , S0*pow(u2(delta_t),3) ,delta_t )<<"   "<<get_lookback(delta_t*3, S0*pow(u2(delta_t),2)*pow(d2(delta_t),1) , delta_t ) <<"   "<< get_lookback(delta_t*3 , S0*pow(u2(delta_t),1)*pow(d2(delta_t),2) , delta_t )<<"   "<<get_lookback( delta_t*4, S0*pow(d2(delta_t),3) , delta_t )<<endl;

	cout<<"At i=4 "<< get_lookback(delta_t*4 , S0*pow(u2(delta_t),4) ,delta_t )<<"   "<<get_lookback(delta_t*4, S0*pow(u2(delta_t),3)*pow(d2(delta_t),1), delta_t ) <<"   "<<  get_lookback(delta_t*4 , S0*pow(u2(delta_t),2)*pow(d2(delta_t),2) , delta_t )<<"   "<< get_lookback(delta_t*4 , S0*pow(u2(delta_t),1)*pow(d2(delta_t),3 ) , delta_t ) <<"   "<< get_lookback(delta_t*4, S0*pow(d2(delta_t),4) , delta_t ) <<endl;

	return 0;
}
	
