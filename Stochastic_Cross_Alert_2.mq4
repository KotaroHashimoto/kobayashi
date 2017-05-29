//compile//
//+------------------------------------------------------------------+
//|                                       Stochastic_Cross_Alert.mq4 |
//|                         Copyright © 2006, Robert Hill            |
//|                                                                  |
//| Written Robert Hill for use with AIME for the stochastic cross   |
//| to draw arrows and popup alert or send email                     |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2006, Robert Hill"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

extern bool SoundON=true;
extern bool EmailON=false;
//---- input parameters
extern int KPeriod=5;
extern int DPeriod=3;
extern int Slowing=3;
extern int MA_Method = 0; // SMA 0, EMA 1, SMMA 2, LWMA 3
extern int PriceField = 0; // Low/High 0, Close/Close 1

input int Disable_Range_Bottom = 40;
input int Disable_Range_Upper = 60;

input int Buy_Line = 15;
input int Sell_Line = 85;

//---- input parameters
input string IIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> White Stochastic Settings >>>>>>>>>>>>>>>";
input int White_K_period = 81;
input int White_D_period = 6;
input int White_S_period = 5;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Pink1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Pink1_K_period = 81;
input int Pink1_D_period = 12;
input int Pink1_S_period = 6;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Pink2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Pink2_K_period = 81;
input int Pink2_D_period = 24;
input int Pink2_S_period = 7;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Pink3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Pink3_K_period = 81;
input int Pink3_D_period = 36;
input int Pink3_S_period = 8;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Green1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Green1_K_period = 81;
input int Green1_D_period = 48;
input int Green1_S_period = 9;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Green2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Green2_K_period = 81;
input int Green2_D_period = 72;
input int Green2_S_period = 10;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Green3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Green3_K_period = 81;
input int Green3_D_period = 108;
input int Green3_S_period = 11;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Blue Stochastic Settings >>>>>>>>>>>>>>>";
input int Blue_K_period = 81;
input int Blue_D_period = 243;
input int Blue_S_period = 12;


double CrossUp[];
double CrossDown[];
int flagval1 = 0;
int flagval2 = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 

//----
   return(0);
  }


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit, i, counter;
   double tmp=0;
   double fastMAnow, slowMAnow, fastMAprevious, slowMAprevious;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   
   for(i = 1; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       
      fastMAnow = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i);
      fastMAprevious = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_MAIN, i+1);

      slowMAnow = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_SIGNAL, i);
      slowMAprevious = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, PriceField, MODE_SIGNAL, i+1);
      
      CrossUp[i] = 0;
      CrossDown[i] = 0;
      
      double white = iStochastic(NULL, 0, White_K_period, White_D_period, White_S_period, 3, 1, MODE_SIGNAL, i);
      double white_1 = iStochastic(NULL, 0, White_K_period, White_D_period, White_S_period, 3, 1, MODE_SIGNAL, i + 1);

      double pink0 = iStochastic(NULL, 0, Pink1_K_period, Pink1_D_period, Pink1_S_period, 3, 1, MODE_SIGNAL, i);     
      double pink1 = iStochastic(NULL, 0, Pink2_K_period, Pink2_D_period, Pink2_S_period, 3, 1, MODE_SIGNAL, i);
      double pink2 = iStochastic(NULL, 0, Pink3_K_period, Pink3_D_period, Pink3_S_period, 3, 1, MODE_SIGNAL, i);
      double pink2_1 = iStochastic(NULL, 0, Pink3_K_period, Pink3_D_period, Pink3_S_period, 3, 1, MODE_SIGNAL, i + 1);
  
      double green0 = iStochastic(NULL, 0, Green1_K_period, Green1_D_period, Green1_S_period, 3, 1, MODE_SIGNAL, i);
      double green1 = iStochastic(NULL, 0, Green2_K_period, Green2_D_period, Green2_S_period, 3, 1, MODE_SIGNAL, i);  
      double green2 = iStochastic(NULL, 0, Green3_K_period, Green3_D_period, Green3_S_period, 3, 1, MODE_SIGNAL, i);
      double green2_1 = iStochastic(NULL, 0, Green3_K_period, Green3_D_period, Green3_S_period, 3, 1, MODE_SIGNAL, i + 1);

      double blue = iStochastic(NULL, 0, Blue_K_period, Blue_D_period, Blue_S_period, 3, 1, MODE_SIGNAL, i);
      
      if ((fastMAnow > slowMAnow) && (fastMAprevious < slowMAprevious))
      {
         if (i == 1 && flagval1==0)
         {
           flagval1=1;
           flagval2=0;
           if (SoundON) Alert("BUY signal at Ask=",Ask,"\n Bid=",Bid,"\n Time=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
           if (EmailON) SendMail("BUY signal alert","BUY signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
         }
         CrossUp[i] = Low[i] - Range*0.75;
      }
      else if ((fastMAnow < slowMAnow) && (fastMAprevious > slowMAprevious))
      {
         if (i == 1 && flagval2==0)
         {
          flagval2=1;
          flagval1=0;
         if (SoundON) Alert("SELL signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("SELL signal alert","SELL signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
         }
         CrossDown[i] = High[i] + Range*0.75;
      }
      
      if(Disable_Range_Bottom < pink0 && Disable_Range_Bottom < pink1 && Disable_Range_Bottom < pink2 && Disable_Range_Bottom < green0 && Disable_Range_Bottom < green1 && Disable_Range_Bottom < green2) {
        if(pink0 < Disable_Range_Upper && pink1 < Disable_Range_Upper && pink2 < Disable_Range_Upper && green0 < Disable_Range_Upper && green1 < Disable_Range_Upper && green2 < Disable_Range_Upper) {
          CrossUp[i] = 0;
          CrossDown[i] = 0;
        }
      }
   }

   return(0);
}

