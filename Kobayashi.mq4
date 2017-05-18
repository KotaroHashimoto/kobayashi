//+------------------------------------------------------------------+
//|                                                    Kobayashi.mq4 |
//|                           Copyright 2017, Palawan Software, Ltd. |
//|                             https://coconala.com/services/204383 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Palawan Software, Ltd."
#property link      "https://coconala.com/services/204383"
#property description "Author: Kotaro Hashimoto <hasimoto.kotaro@gmail.com>"
#property version   "1.00"
#property strict

input int Magic_Number = 1;

input double Take_Profit = 30;
input double Stop_Loss = 30;

input double Entry_Lot = 0.1;

input double Upper_Threshold = 80;
input double Bottom_Threshold = 20;



input string IIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #1 Settings >>>>>>>>>>>>>>>";
input int  TimeFrame1=0;
input int K_period1 = 6;
input int D_period1 = 1;
input int S_period1 = 10;
input int STOCH_1_Price_field = 0;
input int STOCH_1_MAIN_Ma_Mode = 0;
input int STOCH_1_SIGNAL_Ma_Mode = 0;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #2 Settings >>>>>>>>>>>>>>>>>";
input int  TimeFrame2=0;
input int K_period2 = 23;
input int D_period2 = 1;
input int S_period2 = 10;
input int STOCH_2_Price_field = 0;
input int STOCH_2_MAIN_Ma_Mode = 0;
input int STOCH_2_SIGNAL_Ma_Mode = 0;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #3 Settings >>>>>>>>>>>>>>>>>>>";
input int  TimeFrame3=0;
input int K_period3 = 43;
input int D_period3 = 1;
input int S_period3 = 10;
input int STOCH_3_Price_field = 0;
input int STOCH_3_MAIN_Ma_Mode = 0;
input int STOCH_3_SIGNAL_Ma_Mode = 0;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Stochastic #4 Settings >>>>>>>>>>>>>>>>>>>>>";
input int  TimeFrame4=0;
input int K_period4 = 89;
input int D_period4 = 43;
input int S_period4 = 10;
input int STOCH_4_Price_field = 0;
input int STOCH_4_MAIN_Ma_Mode = 0;
input int STOCH_4_SIGNAL_Ma_Mode = 0;


string thisSymbol;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
  thisSymbol = Symbol();
    
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      
  }
  
double sltp(double price, double dpips) {

  if(dpips == 0) {
    return 0;
  }
  else {
    return NormalizeDouble(price + (dpips * 10.0 * Point), Digits);
  }
}

int getSignal() {

  double lines[8];
   
  lines[0] = iStochastic(NULL,TimeFrame1,K_period1,D_period1,S_period1,STOCH_1_MAIN_Ma_Mode,STOCH_1_Price_field,MODE_MAIN, 0);
  lines[1] = iStochastic(NULL,TimeFrame1,K_period1,D_period1,S_period1,STOCH_1_SIGNAL_Ma_Mode,STOCH_1_Price_field,MODE_SIGNAL, 0);
     
  lines[2] = iStochastic(NULL,TimeFrame2,K_period2,D_period2,S_period2,STOCH_2_MAIN_Ma_Mode,STOCH_2_Price_field,MODE_MAIN, 0);
  lines[3] = iStochastic(NULL,TimeFrame2,K_period2,D_period2,S_period2,STOCH_2_SIGNAL_Ma_Mode,STOCH_2_Price_field,MODE_SIGNAL, 0);
  
  lines[4] = iStochastic(NULL,TimeFrame3,K_period3,D_period3,S_period3,STOCH_3_MAIN_Ma_Mode,STOCH_3_Price_field,MODE_MAIN, 0);
  lines[5] = iStochastic(NULL,TimeFrame3,K_period3,D_period3,S_period3,STOCH_3_SIGNAL_Ma_Mode,STOCH_3_Price_field,MODE_SIGNAL, 0);
  
  lines[6] = iStochastic(NULL,TimeFrame4,K_period4,D_period4,S_period4,STOCH_4_MAIN_Ma_Mode,STOCH_4_Price_field,MODE_MAIN, 0);
  lines[7] = iStochastic(NULL,TimeFrame4,K_period4,D_period4,S_period4,STOCH_4_SIGNAL_Ma_Mode,STOCH_4_Price_field,MODE_SIGNAL, 0);


  for(int i = 0; i < 8; i++) {
    if(lines[i] < Upper_Threshold) {
      break;
    }
    if(i == 7) {
      return OP_SELL;
    }
  }
  
  for(int i = 0; i < 8; i++) {
    if(Bottom_Threshold < lines[i]) {
      break;
    }
    if(i == 7) {
      return OP_BUY;
    }
  }
  
  return -1;
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

  int signal = getSignal();
  
  if(0 < OrdersTotal()) {  
    if(OrderSelect(0, SELECT_BY_POS)) {
      if(!StringCompare(OrderSymbol(), thisSymbol) && OrderMagicNumber() == Magic_Number) {
        if(signal == OP_SELL && OrderType() == OP_BUY) {
          bool closed = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), 0);
        }
        else if(signal == OP_BUY && OrderType() == OP_SELL) {
          bool closed = OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), 0);
        }
      }
    }  
  }
  else {

    if(signal == OP_SELL) {
      int ticket = OrderSend(Symbol(), OP_SELL, Entry_Lot, NormalizeDouble(Bid, Digits), 0, sltp(Bid, Stop_Loss), sltp(Bid, -1 * Take_Profit), NULL, Magic_Number, 0, clrBlue);
    }
    else if(signal == OP_BUY) {
      int ticket = OrderSend(Symbol(), OP_BUY, Entry_Lot, NormalizeDouble(Ask, Digits), 0, sltp(Ask, -1 * Stop_Loss), sltp(Ask, Take_Profit), NULL, Magic_Number, 0, clrRed);
    }
  }
}


    
