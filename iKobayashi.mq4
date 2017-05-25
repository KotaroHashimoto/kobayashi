//+------------------------------------------------------------------+
//|                                                   iKobayashi.mq4 |
//|                           Copyright 2017, Palawan Software, Ltd. |
//|                             https://coconala.com/services/204383 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Palawan Software, Ltd."
#property link      "https://coconala.com/services/204383"
#property description "Author: Kotaro Hashimoto <hasimoto.kotaro@gmail.com>"
#property version   "1.00"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Aqua
#property indicator_color3 Red
#property indicator_color4 Magenta
#property indicator_width1  4
#property indicator_width2  4
#property indicator_width3  4
#property indicator_width4  4

input int Buy_Line = 15;
input int Sell_Line = 85;

input bool SoundON = False;
input bool EmailON = False;


//---- input parameters
input string IIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #1 Settings >>>>>>>>>>>>>>>";
input int K_period1 = 81;
input int D_period1 = 6;
input int S_period1 = 5;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #2 Settings >>>>>>>>>>>>>>>";
input int K_period2 = 81;
input int D_period2 = 12;
input int S_period2 = 6;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #3 Settings >>>>>>>>>>>>>>>";
input int K_period3 = 81;
input int D_period3 = 24;
input int S_period3 = 7;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #4 Settings >>>>>>>>>>>>>>>";
input int K_period4 = 81;
input int D_period4 = 36;
input int S_period4 = 8;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #5 Settings >>>>>>>>>>>>>>>";
input int K_period5 = 81;
input int D_period5 = 48;
input int S_period5 = 9;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #6 Settings >>>>>>>>>>>>>>>";
input int K_period6 = 81;
input int D_period6 = 72;
input int S_period6 = 10;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #7 Settings >>>>>>>>>>>>>>>";
input int K_period7 = 81;
input int D_period7 = 108;
input int S_period7 = 11;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #8 Settings >>>>>>>>>>>>>>>";
input int K_period8 = 81;
input int D_period8 = 243;
input int S_period8 = 12;


double CrossDown[];
double CrossDownL[];
double CrossUp[];
double CrossUpL[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 226);
   SetIndexBuffer(0, CrossDown);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDownL);

   SetIndexStyle(2, DRAW_ARROW, EMPTY);
   SetIndexArrow(2, 225);
   SetIndexBuffer(2, CrossUp);
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, 233);
   SetIndexBuffer(3, CrossUpL);

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

   int counted_bars = IndicatorCounted();
   
//---- check for possible errors
   if(counted_bars<0) return(-1);

//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   int limit = Bars - counted_bars;
   
   for(int i = 1; i <= limit; i++) {
   
     double AvgRange = 0.0;
     for(int counter = i ; counter <= i+9; counter++) {
       AvgRange += MathAbs(High[counter] - Low[counter]);
     }
     double Range = AvgRange / 10.0;
     
     double lines[8];
   
     double white = iStochastic(NULL,0,K_period1,D_period1,S_period1,3,1,MODE_SIGNAL, i);
     double white_1 = iStochastic(NULL,0,K_period1,D_period1,S_period1,3,1,MODE_SIGNAL, i + 1);

     double pink0 = iStochastic(NULL,0,K_period2,D_period2,S_period2,3,1,MODE_SIGNAL, i);     
     double pink1 = iStochastic(NULL,0,K_period3,D_period3,S_period3,3,1,MODE_SIGNAL, i);
     double pink2 = iStochastic(NULL,0,K_period4,D_period4,S_period4,3,1,MODE_SIGNAL, i);
     double pink2_1 = iStochastic(NULL,0,K_period4,D_period4,S_period4,3,1,MODE_SIGNAL, i + 1);
  
     double green0 = iStochastic(NULL,0,K_period5,D_period5,S_period5,3,1,MODE_SIGNAL, i);
     double green1 = iStochastic(NULL,0,K_period6,D_period6,S_period6,3,1,MODE_SIGNAL, i);  
     double green2 = iStochastic(NULL,0,K_period7,D_period7,S_period7,3,1,MODE_SIGNAL, i);
     double green2_1 = iStochastic(NULL,0,K_period7,D_period7,S_period7,3,1,MODE_SIGNAL, i + 1);

     double blue = iStochastic(NULL,0,K_period8,D_period8,S_period8,3,1,MODE_SIGNAL, i);

     CrossUp[i] = 0;
     CrossDown[i] = 0;
     CrossUpL[i] = 0;
     CrossDownL[i] = 0;
     
     if(Sell_Line < pink0 && Sell_Line < pink1 && Sell_Line < pink2) {
       if(green2_1 < pink2_1 && pink2 < green2) {

         CrossDown[i] = High[i] + Range*0.75;

         if (SoundON) Alert("Exceptional SELL signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("Exceptional SELL signal alert","SELL signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
       }
     }
     if(pink0 < Sell_Line && pink1 < Sell_Line && pink2 < Sell_Line) {
       if(pink2_1 < white_1 && white < pink2) {

         CrossDownL[i] = High[i] + Range*0.75;

         if (SoundON) Alert("SELL signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("SELL signal alert","SELL signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
       }
     }
     if(pink0 < Buy_Line && pink1 < Buy_Line && pink2 < Buy_Line) {
       if(pink2_1 < green2_1 && green2 < pink2) {

         CrossUp[i] = Low[i] - Range*0.75;

         if (SoundON) Alert("Exceptional BUY signal at Ask=",Ask,"\n Bid=",Bid,"\n Time=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("Exceptional BUY signal alert","BUY signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
       }
     }
     if(Buy_Line < pink0 && Buy_Line < pink1 && Buy_Line < pink2) {
       if(white_1 < pink2_1 && pink2 < white) {

         CrossUpL[i] = Low[i] - Range*0.75;

         if (SoundON) Alert("BUY signal at Ask=",Ask,"\n Bid=",Bid,"\n Time=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("BUY signal alert","BUY signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
       }
     }
   }

   return(0);
}

