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

input bool SoundON = False;
input bool EmailON = False;


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

