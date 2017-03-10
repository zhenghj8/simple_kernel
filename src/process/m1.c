int  fork();
char* tostr(int);
extern void putstr();
extern void int37();
extern void int_33();
extern void int_34();
extern void int_35();
extern void int_36();
void p(int);
void v(int);
int semget(int);
void semfree(int);
void delay(int);


int money=1000;/*银行帐户余额1000元*/
int k;
int n2,n3,c;
int n1;
char s1[80],s2[80];
void main() {
   int pid,sem_id;
   int t;
   sem_id=semget(1);
   pid=fork();
   if(pid==-1)
   {
   	  putstr("error in fork!");
   }
   
   else if(pid==2)
   {
      while(1)
      {
        /*putstr("Father:before operate p.");*/
        p(sem_id);
        money += 10;
        delay(3); 
        putstr("Father has save 10 $,the money is:");
        putstr(tostr(money));
        delay(3);
        /*delay(3);
        delay(3);*/
        v(sem_id);
      }
    } 
    else if(pid==0)
    {
       while(1)
       {
        /*putstr("Son1:before operate p.");*/
        p(sem_id);
        money -= 5;
        delay(3);
        putstr("Son1 has take 5 $,the money is:");
        putstr(tostr(money));
        delay(3);
        v(sem_id);
       }  
    }
    else
    {
       while(1)
       {
        /*putstr("Son2:before operate p.");*/
        p(sem_id);
        money -= 10;
        delay(3);
        putstr("Son2 has take 10 $,the money is:");
        putstr(tostr(money));
        delay(3);
        v(sem_id);
       }  
    }
    semfree(sem_id);
}





int fork()
{
	int37();
	return;
}


int semget(int a)
{
	int_33();
}

void semfree(int a)
{
	int_34();
	return;
}

void p(int a)
{
	int_35();
	return;
}

void v(int a)
{
	int_36();
	return;
}

char* tostr( int n )
{
  n2=0,n3=0,c = 0;
  n1 = n;
  for(k=0;k<80;k++)
  {
    s1[k]=0;
    s2[k]=0;
  }
    while(n1 > 9)
    {
       n2 = n1%10;
       n1 = n1/10;
       s2[c] = n2 + 48;
       c++;
    }
    s2[c] = n1 + 48;
    while(n3 <= c)
    {
    	s1[n3] = s2[c-n3];
    	n3++;
    }
    return s1;
}



void delay(int k)
{
	int i,j;
	if(k==1)
	{
		for(i = 0;i < 10000;i++)
		{
			for(j = 0;j < 10000;j++)
			{}
		}
	}
	else if(k==2)
	{
		for(i = 0;i < 20000;i++)
		{
			for(j = 0;j < 20000;j++)
			{}
		}
	}
	else if(k==3)
	{
		for(i = 0;i < 30000;i++)
		{
			for(j = 0;j < 30000;j++)
			{}
		}
	}
}



