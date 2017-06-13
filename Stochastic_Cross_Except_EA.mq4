//+------------------------------------------------------------------+
//|                                   Stochastic_Cross_Except_EA.mq4 |
//|                           Copyright 2017, Palawan Software, Ltd. |
//|                             https://coconala.com/services/204383 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Palawan Software, Ltd."
#property link      "https://coconala.com/services/204383"
#property description "Author: Kotaro Hashimoto <hasimoto.kotaro@gmail.com>"
#property version   "1.00"
#property strict

input int Magic_Number = 1;
input double Entry_Lot = 0.1;
input double Stop_Loss = 20;
input double Take_Profit = 20;
input int Signal_Range = 3;


//---- input parameters
extern int KPeriod = 81;
extern int DPeriod = 90;
extern int Slowing = 9;
extern int MA_Method = 3; // SMA 0, EMA 1, SMMA 2, LWMA 3
extern int PriceField = 1; // Low/High 0, Close/Close 1

//サイン無効下限値
input int Disable_Range_Bottom = 40;

//サイン無効上限値
input int Disable_Range_Upper = 60;

//通常/例外時切替下閾値
input int Buy_Line = 15;

//通常/例外時切替上閾値
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
input int Pink3_D_period = 30;
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



double sl;
double tp;
string thisSymbol;

const string indName = "Stochastic_Cross_Alert_Except";


int getOrdersTotal() {

  int count = 0;
  for(int i = 0; i < OrdersTotal(); i++) {  
    if(OrderSelect(i, SELECT_BY_POS)) {
      if(!StringCompare(OrderSymbol(), thisSymbol) && OrderMagicNumber() == Magic_Number) {
        count ++;
      }
    }
  }

  return count;
}


int getSignal() {

  for(int i = 1; i < Signal_Range + 1; i++) {
    if(0 < iCustom(NULL, PERIOD_CURRENT, indName, 0, i)) {
      return OP_BUY;
    }
    else if(0 < iCustom(NULL, PERIOD_CURRENT, indName
                        , False, False
                        , KPeriod, DPeriod, Slowing, MA_Method, PriceField
                        , Disable_Range_Bottom, Disable_Range_Upper, Buy_Line, Sell_Line, ""
                        , White_K_period, White_D_period, White_S_period, ""
                        , Pink1_K_period, Pink1_D_period, Pink1_S_period, ""
                        , Pink2_K_period, Pink2_D_period, Pink2_S_period, ""
                        , Pink3_K_period, Pink3_D_period, Pink3_S_period, ""
                        , Green1_K_period, Green1_D_period, Green1_S_period, ""
                        , Green2_K_period, Green2_D_period, Green2_S_period, ""
                        , Green3_K_period, Green3_D_period, Green3_S_period, ""
                        , Blue_K_period, Blue_D_period, Blue_S_period    
                        , 1, i)) {
      return OP_SELL;
    }
  }
  
  return -1;
}

double sltp(double price, double delta) {

  if(delta == 0.0) {
    return 0.0;
  }
  else {
    return NormalizeDouble(price + delta, Digits);
  }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

  sl = Stop_Loss * 10.0 * Point;
  tp = Take_Profit * 10.0 * Point;
  thisSymbol = Symbol();
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  int signal = getSignal();

  if(0 < getOrdersTotal()) {  
    for(int i = 0; i < OrdersTotal(); i++) {
      if(OrderSelect(i, SELECT_BY_POS)) {
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
  }
  else {
    if(signal == OP_BUY) {
      int ticket = OrderSend(Symbol(), OP_BUY, Entry_Lot, NormalizeDouble(Ask, Digits), 0, sltp(Ask, -1.0 * sl), sltp(Ask, tp), NULL, Magic_Number);
    }
    else if(signal == OP_SELL) {
      int ticket = OrderSend(Symbol(), OP_SELL, Entry_Lot, NormalizeDouble(Bid, Digits), 0, sltp(Bid, sl), sltp(Bid, -1.0 * tp), NULL, Magic_Number);
    }
  }
}
//+------------------------------------------------------------------+
