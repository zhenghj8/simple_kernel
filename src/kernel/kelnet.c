/************进程控制相关成员*************/
extern void setClock();
extern void another_load(int segment,int offset);
void Random_Load();
void init_Pro(); 
void seminit();
void begin();
int Segment = 0x2000;
#include "proctr.h"
#define BUFLEN 1000
char Buffer[BUFLEN];
int StringLen;
char fnum;

/******************************************/


/************实验7新增函数************/
extern void set_int37();
extern void set_int38();
extern void set_int39();
void set_lab7();
/*************************************/


/************实验8新增函数************/
extern void set_int_33();
extern void set_int_34();
extern void set_int_35();
extern void set_int_36();
void set_lab8();
/*************************************/



/***************其他成员*****************/
extern void cls();
extern void setcur();
extern void time();
extern void keyboard();
extern void delay();
extern void int33();
extern void int34();
extern void int35();
extern void int36();
extern void intr();
extern void read1();
extern void read2();
extern void read3();
extern void exc1();
extern void exc2();
extern void exc3();
extern void getch();
extern void putch();
extern void putstr();
extern void getstr();
extern void scanf();
extern void print();
extern void printf();
extern void load_int21();
extern void Sh_int21();
/*********************************************/
void prochs();
void Delay0();



/**********************************************/
char b[70] = "Please press any three keys of 0,1,2,3 or esc to control your program:";
char bc[74]="Now I will show the function:getch,putch,scanf,print,getstr,putstr,printf.";
int disp_pos = 100;
char a[3]="000";
int i = 0;
int count = 4;
char ch[4] = "\|/-";
int  num = 0;
char k[10] = "OUCH!OUCH!";
char i33[15]="int 33 <{0-0}>!";
char i34[15]="int 34 <{0-0}>!";
char i35[15]="int 35 <{0-0}>!";
char i36[15]="int 36 <{0-0}>!";
char ch2[10000];
int length;
int value;
char gc;
char str[80];
int va;
int num1=0;
char num2[20],num3[20];
/*****************************************/

/************库函数调用******************/ 
void cfunction()
{ 
   num1=0;  
   putstr("Put in the char:");     
   getch(&gc);
   putstr("The char is:");
   putch(&gc);
   putstr("Put in the number(0~166):");
   scanf(&va);
   putstr("The number is:");
   print(&va);
   putstr("Put in the string:");
   getstr(str);
   putstr("The string is:");
   putstr(str);
   putstr("Put out the char ,int ,string:");
   printf(&gc,str,&va);
   delay();
}
/*************************************/



/*******主函数************************/ 
void cmain(){
    
    while(1)
    {   
        cls();
        setcur();
        begin();
        setClock();
        if(fnum == '1')
        {
            cls();
            setcur();
            init_Pro();
            seminit();
            set_lab7();
            set_lab8();
            prochs();
            cls();
            setcur();  
            
            Random_Load();  
            Delay0(); 
            cls();
            setcur();
            begin();     
        }
        else if(fnum == '2')
        {
            cls();
            setcur();
            load_int21();
            Sh_int21();
            delay();
        }
        else if(fnum == '3')
        {
            cls();
            setcur();
            int33();
            int34();
            int35();
            int36();
            intr();   
            delay();
            cls();
        }
        else if(fnum == '4')
        {
            cls();
            setcur();
            cfunction(); 
            delay(); 
        }
        else
        {
            putstr("Invalid input!");
            setcur();
            delay();
            cls();
        }
    }    
}
/*************************************/


/************内核初始界面************/
void begin()
{
    cls();
    putstr("               Welcome to my kelnet");     
    putstr("Function:");
    putstr("1:Process,you can choose 1~4 to run the user process.");
    putstr("2:Int 21h");
    putstr("3:Displaying Int 33h,Int 34h,Int 35h,Int 36h"); 
    putstr("4:Show the cfunction");
    putstr("Please choose the function of 1~3:");
    getch(&fnum);  
} 
/****************************************/


/*************进程选择界面*****************/
void prochs()
{
    int j; 
    cls();
    StringLen=0;
    putstr("Please choose the user process from 1~4:");
    getstr(Buffer);
    for(j = 0;j < 1000;j++)
    {
       if(Buffer[j] == '\0')
          break;
       else if(Buffer[j] != ' ' && (Buffer[j]<'1' || Buffer[j]>'4'))
       {
          putstr("Invalid input!");
          delay();
          StringLen=0;
          break;     
       }  
       else
          StringLen++;
    }     
} 
/****************************************/



/**********int21h相关函数*************/ 
upper(){
    int i=0;
   while(i < length) {
     if (ch2[i]>='a'&& ch2[i]<='z')  
      ch2[i]=ch2[i]+'A'-'a';
	  i++;
    }
}


lower(){
   int i=0;
   while(i < length) {
     if (ch2[i]>='A'&& ch2[i]<='Z')  
      ch2[i]=ch2[i]-'A'+'a';
	  i++;
    }
}

tovalue(){
   int i=0;
   value=0;
   while(i<length){
      value=value*10+ch2[i]-48;
      i++;                
   }                    
}


tochar(){
   int i=0;
   value = 1234;
   while(value>9){
      ch2[i]=value%10+48;
      value=value/10;
      i++;              
   }      
   ch2[i]=value+48;
   i++;
   length=i;         
}
/********************************************/



/*************进程控制相关函数***************/
void Random_Load()
{
	int i = 0;
	int j = 0;
	for( i=0; i<StringLen;i++ )
		if( Buffer[i]!=' ' && (Buffer[i]<'1' || Buffer[i]>'4') )
		{
			putstr("Error Input!");
			return;
		}
	for( i=0; i<StringLen;i++ )
	{
		if( Buffer[i] ==' ' )
			continue;
		else
		{
			j = (Buffer[i] - '0'-1)*2+1;
			if( Segment > 0x5000 )
			{
				putstr("There have been 4 Processes !");
				break;
			}
			another_load(Segment,j);
			Segment += 0x1000;
			Program_Num ++;
		}
	}
}

void init_Pro()
{
	init(&pcb_list[0],0x1000,0x100);
	init(&pcb_list[1],0x2000,0x100);
	init(&pcb_list[2],0x3000,0x100);
	init(&pcb_list[3],0x4000,0x100);
	init(&pcb_list[4],0x5000,0x100);
}
/*****************************************/ 


/************延时************************/
void Delay0()
{
	int i = 0;
	int j = 0;
	for( i=0;i<30000;i++ )
		for( j=0;j<30000;j++ )
		{
			j++;
			j--;
		}
}
/********************************************/


/********设置实验7中3个封装函数的中断********/
void set_lab7()
{
   set_int37();
   set_int38();
   set_int39();
}
/********************************************/


/********设置实验8中4个封装函数的中断********/
void set_lab8()
{
   set_int_33();
   set_int_34();
   set_int_35();
   set_int_36();
}
/********************************************/


