#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cmath>
using namespace std;

float S0=9;
float K=10;
float T=3;
float r=0.06;
float sigma=0.3;
int M;

float max(float a,float b)
{
	if( a>b ) return a;
	else return b;
}

float u(float delta_t)
{
	return exp(sigma*sqrt(delta_t)+(r-0.5*sigma*sigma)*delta_t);
}
	
	
float d(float delta_t)
{
	return exp(-sigma*sqrt(delta_t)+(r-0.5*sigma*sigma)*delta_t);
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

// This is for the call option(recursive)
float get_C(float t,float S,float delta_t)    // returns the price of the option at time t if the price os stock is S )
{
	if(t>=T)
	{
		if(S>=K) return (S-K);
		else return 0;
	}
	else
	{
		float t1=get_C(t+delta_t , S*u(delta_t) , delta_t);
		float t2=get_C(t+delta_t , S*d(delta_t) , delta_t);
		return  ( p(delta_t)*t1 +q(delta_t)*t2)/discount_rate(delta_t) ;
	}
}
		
// This is for the put option(recursive)
float get_P(float t,float S,float delta_t)    // returns the price of the option at time t if the price os stock is S )
{
	if(t>=T)
	{
		if(S<=K) return (K-S);
		else return 0;
	}
	else
	{
		float t1=get_P(t+delta_t , S*u(delta_t) , delta_t);
		float t2=get_P(t+delta_t , S*d(delta_t) , delta_t);
		return  ( p(delta_t)*t1 +q(delta_t)*t2)/discount_rate(delta_t) ;
	}
}

// This is the fast version of the algorithm CALL
float get_C_fast(float t,float S,float delta_t)
{
	float U=u(delta_t);
	float D=d(delta_t);
	float P=p(delta_t);
	float Q=p(delta_t);
	float R=discount_rate(delta_t);
	float* SS=new float[M+2];
	float* value=new float[M+2];
	int i,j,k;
	for(i=0;i<=M;i++)
		SS[i]=S0*(pow(U,(float)(M-i)))*(pow(D,(float)i));
	for(i=0;i<=M;i++)
		value[i]=max(SS[i]-K,0);
	for(j=M; j>=0; j--)
	{
		for(k=0; k<j; k++)
			value[k]= (P*value[k+1]+Q*value[k])/R;
		if( abs(t-j*delta_t)<0.1 )
		{
			for(k=0;k<j;k++ )
				cout<<value[k]<<"\t";
			cout<<endl;
		}
	}
	return value[0];
}
		
// This is the fast version of the algorithm PUT
float get_P_fast(float t,float S,float delta_t)
{
	float U=u(delta_t);
	float D=d(delta_t);
	float P=p(delta_t);
	float Q=p(delta_t);
	float R=discount_rate(delta_t);
	float* SS=new float[M+2];
	float* value=new float[M+2];
	int i,j,k;
	for(i=0;i<=M;i++)
		SS[i]=S0*(pow(U,(float)(M-i)))*(pow(D,(float)i));
	for(i=0;i<=M;i++)
		value[i]=max(K-SS[i],0);
	for(j=M; j>=0; j--)
	{
		for(k=0; k<j; k++)
			value[k]= (P*value[k+1]+Q*value[k])/R;
		if( abs(t-j*delta_t)<0.01 )
		{
			for(k=0;k<j;k++)
				cout<<value[k]<<"\t";
			cout<<endl;
		}
	}
	return value[0];
}


int main()
{
	
	cout<<"Insert M :";
	cin>>M;
	float delta_t=T/M;
//	cout<<"ANS CALL :"<<get_C(0,S0,delta_t)<<endl;
//	cout<<"AND PUT  :"<<get_P(0,S0,delta_t)<<endl;
	cout<<"ANS CALL  :" << get_C_fast(0,S0,delta_t) <<endl;
	cout<<"ANS PUT  :" << get_P_fast(0,S0,delta_t) <<endl;
	return 0;
}
	
