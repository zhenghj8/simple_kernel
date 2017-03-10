int NEW = 0;
int READY = 1;
int RUNNING = 2;
int BLOCKED = 3;
int EXITED = 4;

int free = 0;
int use = 1;
int ss_val = 0x6000;


typedef struct RegisterImage{
	int SS;
	int GS;
	int FS;
	int ES;
	int DS;
	int DI;
	int SI;
	int BP;
	int SP;
	int BX;
	int DX;
	int CX;
	int AX;
	int IP;
	int CS;
	int FLAGS;
}RegisterImage;

typedef struct PCB{
	RegisterImage regImg;
	int Process_Status;
	int used;
	int F_PCBID;
	int PCBID;
}PCB;


PCB pcb_list[8];
int CurrentPCBno = 0; 
int Program_Num = 0;


extern void printChar();
extern void putstr();
extern void pcb_restart();
extern void pcb_restart1();

PCB* Current_Process();
void Save_Process(int,int, int, int, int, int, int, int,
		  int,int,int,int, int,int, int,int );
void init(PCB*, int, int);
void Schedule();
void special();



void Save_Process(int gs,int fs,int es,int ds,int di,int si,int bp,
		int sp,int dx,int cx,int bx,int ax,int ss,int ip,int cs,int flags)
{
	pcb_list[CurrentPCBno].regImg.AX = ax;
	pcb_list[CurrentPCBno].regImg.BX = bx;
	pcb_list[CurrentPCBno].regImg.CX = cx;
	pcb_list[CurrentPCBno].regImg.DX = dx;

	pcb_list[CurrentPCBno].regImg.DS = ds;
	pcb_list[CurrentPCBno].regImg.ES = es;
	pcb_list[CurrentPCBno].regImg.FS = fs;
	pcb_list[CurrentPCBno].regImg.GS = gs;
	pcb_list[CurrentPCBno].regImg.SS = ss;

	pcb_list[CurrentPCBno].regImg.IP = ip;
	pcb_list[CurrentPCBno].regImg.CS = cs;
	pcb_list[CurrentPCBno].regImg.FLAGS = flags;
	
	pcb_list[CurrentPCBno].regImg.DI = di;
	pcb_list[CurrentPCBno].regImg.SI = si;
	pcb_list[CurrentPCBno].regImg.SP = sp;
	pcb_list[CurrentPCBno].regImg.BP = bp;
}

void Schedule(){
    if(pcb_list[CurrentPCBno].Process_Status != BLOCKED)
	{
        pcb_list[CurrentPCBno].Process_Status = READY;
    }
    CurrentPCBno ++;
    if(CurrentPCBno > Program_Num)
        CurrentPCBno = 1;
    while(pcb_list[CurrentPCBno].Process_Status == BLOCKED)
    {
        CurrentPCBno ++;
        if(CurrentPCBno > Program_Num)
           CurrentPCBno = 1;
    }
	if( pcb_list[CurrentPCBno].Process_Status != NEW )
		pcb_list[CurrentPCBno].Process_Status = RUNNING;
	return;
}
PCB* Current_Process(){

	return &pcb_list[CurrentPCBno];
}

void init(PCB* pcb,int segement, int offset)
{
	pcb->regImg.GS = 0xb800;
	pcb->regImg.SS = segement;
	pcb->regImg.ES = segement;
	pcb->regImg.DS = segement;
	pcb->regImg.CS = segement;
	pcb->regImg.FS = segement;
	pcb->regImg.IP = offset;
	pcb->regImg.SP = offset - 4;
	pcb->regImg.AX = 0;
	pcb->regImg.BX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.FLAGS = 512;
	pcb->Process_Status = NEW;
	pcb->used = use;
	pcb->PCBID = 0;
}

void special()
{
	if(pcb_list[CurrentPCBno].Process_Status==NEW)
		pcb_list[CurrentPCBno].Process_Status=RUNNING;
}



void memcopy( PCB* , PCB* );
extern void stackcopy( int,int );


void do_fork()
{		
	PCB* p1;
	PCB* p2;
	p1 = pcb_list+Program_Num+1;
	p2 = pcb_list+Program_Num+2;
	if( p1 > pcb_list + 8 )
		pcb_list[CurrentPCBno].regImg.AX = -1;
	else if( p2 > pcb_list + 8 )
		pcb_list[CurrentPCBno].regImg.AX = -1;
	else
	{
		Program_Num += 2;                      
		ss_val = 0x6000;   
	    memcopy( pcb_list + CurrentPCBno, p1 );
	    ss_val += 0x100;
	    memcopy( pcb_list + CurrentPCBno, p2 );
	    stackcopy( pcb_list[CurrentPCBno].regImg.SS, p1 ->regImg.SS );
	    stackcopy( pcb_list[CurrentPCBno].regImg.SS, p2 ->regImg.SS );
	    p1 -> PCBID = p1 - pcb_list;
	    p1 -> F_PCBID = CurrentPCBno;
	    p1 -> Process_Status = READY;
	    p1 -> used = use;
	    pcb_list[CurrentPCBno].regImg.AX = 2;
	    p1 -> regImg.AX = 0;
	    p2 -> PCBID = p2 - pcb_list;
	    p2 -> F_PCBID = CurrentPCBno;
	    p2 -> Process_Status = READY;
	    p2 -> used = use;
	    p2 -> regImg.AX = 1;
	    pcb_restart();
	}
}


void memcopy( PCB* F_PCB, PCB* C_PCB )
{
	C_PCB -> regImg.SP = F_PCB -> regImg.SP;
	C_PCB -> regImg.SS = ss_val; 
	C_PCB -> regImg.GS = F_PCB -> regImg.GS;
	C_PCB -> regImg.ES = F_PCB -> regImg.ES;
	C_PCB -> regImg.DS = F_PCB -> regImg.DS;
	C_PCB -> regImg.CS = F_PCB -> regImg.CS;
	C_PCB -> regImg.FS = F_PCB -> regImg.FS;
	C_PCB -> regImg.IP = F_PCB -> regImg.IP;
	C_PCB -> regImg.AX = F_PCB -> regImg.AX;
	C_PCB -> regImg.BX = F_PCB -> regImg.BX;
	C_PCB -> regImg.CX = F_PCB -> regImg.CX;
	C_PCB -> regImg.DX = F_PCB -> regImg.DX;
	C_PCB -> regImg.DI = F_PCB -> regImg.DI;
	C_PCB -> regImg.SI = F_PCB -> regImg.SI;
	C_PCB -> regImg.BP = F_PCB -> regImg.BP;
	C_PCB -> regImg.FLAGS = F_PCB -> regImg.FLAGS;
}


void do_wait() {
    pcb_list[CurrentPCBno].Process_Status = BLOCKED;
    Schedule();
    pcb_restart();
}

void do_exit() {
    pcb_list[CurrentPCBno].Process_Status = EXITED;
    pcb_list[CurrentPCBno].used = free; 
    pcb_list[pcb_list[CurrentPCBno].F_PCBID].Process_Status = READY;
    Program_Num--;
    Schedule();
    pcb_restart();
}


/****************实验8********************/
#define NRsem 100
#define PCBblock 10
void do_blocked(int);
void WaitUp(int);

typedef struct semaphone{
    int count;
    int pcb_blocked[PCBblock];
    int front;
    int back;
    int used;
}semaphone;
semaphone semlist[NRsem];

void seminit()
{
	int i;
	for(i = 0;i < NRsem;i++)
	{
		semlist[i].count=1;
		semlist[i].front=-1;
		semlist[i].back=0;
		semlist[i].used=free;
	}
}

int SemGet(int value) 
{
	
    int i = 0;
    while(semlist[i].used)
    {
    	i++;
    }
    if(i < NRsem) 
    {
      semlist[i].used=use;
      semlist[i].count=value; 
      return i;
    }
    else
    {
      return -1;
    }
}
void SemFree(int s) {
    semlist[s].used=free;
}

void do_p(int s) {
   semlist[s].count--;
   if(semlist[s].count<0)	
   	do_blocked(s);
}
void do_v(int s) {
   semlist[s].count++;
   if(semlist[s].count<=0)  
   	WaitUp(s);
}
void do_blocked(int s){
   /*putstr("BLOCKED");*/
   pcb_list[CurrentPCBno].Process_Status=BLOCKED;
   semlist[s].front=(semlist[s].front+1)%PCBblock;
   semlist[s].pcb_blocked[semlist[s].front]=CurrentPCBno;
   Schedule();
   pcb_restart();
}
void WaitUp(int s){
   pcb_list[CurrentPCBno].Process_Status=READY;
   pcb_list[semlist[s].pcb_blocked[semlist[s].back]].Process_Status=READY;
   semlist[s].back=(semlist[s].back+1)%PCBblock;
   Schedule();
   pcb_restart();
}


/*********************************************/



