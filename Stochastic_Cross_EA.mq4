//+------------------------------------------------------------------+
//|                                          Stochastic_Cross_EA.mq4 |
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
input int Max_Positions = 3;
input double Stop_Loss = 20;
input double Take_Profit = 20;

input bool Daily_Close = False;
input int Close_Hour = 4;
input int Open_Hour = 8;

//---- input parameters
input int Normal_KPeriod = 89;
input int Normal_DPeriod = 21;
input int Normal_Slowing = 10;
input int Normal_MA_Method = 3; // Normal SMA 0, EMA 1, SMMA 2, LWMA 3
input int Normal_PriceField = 1; // Normal Low/High 0, Close/Close 1

//サイン無効下限値
input int Normal_Disable_Range_Bottom = 100;

//サイン無効上限値
input int Normal_Disable_Range_Upper = 0;

//通常/例外時切替下閾値
input int Normal_Buy_Line = 10;

//通常/例外時切替上閾値
input int Normal_Sell_Line = 90;

//---- input parameters
input string IIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal White Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_White_K_period = 89;
input int Normal_White_D_period = 6;
input int Normal_White_S_period = 5;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Pink1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Pink1_K_period = 89;
input int Normal_Pink1_D_period = 13;
input int Normal_Pink1_S_period = 6;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Pink2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Pink2_K_period = 89;
input int Normal_Pink2_D_period = 21;
input int Normal_Pink2_S_period = 7;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Pink3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Pink3_K_period = 89;
input int Normal_Pink3_D_period = 34;
input int Normal_Pink3_S_period = 8;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Green1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Green1_K_period = 89;
input int Normal_Green1_D_period = 55;
input int Normal_Green1_S_period = 9;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Green2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Green2_K_period = 89;
input int Normal_Green2_D_period = 89;
input int Normal_Green2_S_period = 10;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Green3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Green3_K_period = 89;
input int Normal_Green3_D_period = 144;
input int Normal_Green3_S_period = 11;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII=">>> Normal Blue Stochastic Settings >>>>>>>>>>>>>>>";
input int Normal_Blue_K_period = 89;
input int Normal_Blue_D_period = 243;
input int Normal_Blue_S_period = 12;


//---- input parameters
input int Except_KPeriod = 89;
input int Except_DPeriod = 21;
input int Except_Slowing = 10;
input int Except_MA_Method = 3; // Except SMA 0, EMA 1, SMMA 2, LWMA 3
input int Except_PriceField = 1; // Except Low/High 0, Close/Close 1

//サイン無効下限値
input int Except_Disable_Range_Bottom = 100;

//サイン無効上限値
input int Except_Disable_Range_Upper = 0;

//通常/例外時切替下閾値
input int Except_Buy_Line = 10;

//通常/例外時切替上閾値
input int Except_Sell_Line = 90;

//---- input parameters
input string IIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except White Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_White_K_period = 89;
input int Except_White_D_period = 6;
input int Except_White_S_period = 5;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Pink1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Pink1_K_period = 89;
input int Except_Pink1_D_period = 13;
input int Except_Pink1_S_period = 6;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Pink2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Pink2_K_period = 89;
input int Except_Pink2_D_period = 21;
input int Except_Pink2_S_period = 7;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Pink3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Pink3_K_period = 89;
input int Except_Pink3_D_period = 34;
input int Except_Pink3_S_period = 8;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Green1 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Green1_K_period = 89;
input int Except_Green1_D_period = 55;
input int Except_Green1_S_period = 9;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Green2 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Green2_K_period = 89;
input int Except_Green2_D_period = 89;
input int Except_Green2_S_period = 10;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Green3 Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Green3_K_period = 89;
input int Except_Green3_D_period = 144;
input int Except_Green3_S_period = 11;

input string IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII_=">>> Except Blue Stochastic Settings >>>>>>>>>>>>>>>";
input int Except_Blue_K_period = 89;
input int Except_Blue_D_period = 243;
input int Except_Blue_S_period = 12;


double sl;
double tp;
string thisSymbol;
double maskPrice;

const string eInd = "Stochastic_Cross_Alert_Except";
const string nInd = "Stochastic_Cross_Alert_Normal";

const int Signal_Range = 1;

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

  for(int i = 0; i < Signal_Range; i++) {

    double ni = iCustom(NULL, PERIOD_CURRENT, nInd
                        , False, False
                        , Normal_KPeriod, Normal_DPeriod, Normal_Slowing, Normal_MA_Method, Normal_PriceField
                        , Normal_Disable_Range_Bottom, Normal_Disable_Range_Upper, Normal_Buy_Line, Normal_Sell_Line, ""
                        , Normal_White_K_period, Normal_White_D_period, Normal_White_S_period, ""
                        , Normal_Pink1_K_period, Normal_Pink1_D_period, Normal_Pink1_S_period, ""
                        , Normal_Pink2_K_period, Normal_Pink2_D_period, Normal_Pink2_S_period, ""
                        , Normal_Pink3_K_period, Normal_Pink3_D_period, Normal_Pink3_S_period, ""
                        , Normal_Green1_K_period, Normal_Green1_D_period, Normal_Green1_S_period, ""
                        , Normal_Green2_K_period, Normal_Green2_D_period, Normal_Green2_S_period, ""
                        , Normal_Green3_K_period, Normal_Green3_D_period, Normal_Green3_S_period, ""
                        , Normal_Blue_K_period, Normal_Blue_D_period, Normal_Blue_S_period    
                        , 0, i);

    double ei = iCustom(NULL, PERIOD_CURRENT, eInd
                        , False, False
                        , Except_KPeriod, Except_DPeriod, Except_Slowing, Except_MA_Method, Except_PriceField
                        , Except_Disable_Range_Bottom, Except_Disable_Range_Upper, Except_Buy_Line, Except_Sell_Line, ""
                        , Except_White_K_period, Except_White_D_period, Except_White_S_period, ""
                        , Except_Pink1_K_period, Except_Pink1_D_period, Except_Pink1_S_period, ""
                        , Except_Pink2_K_period, Except_Pink2_D_period, Except_Pink2_S_period, ""
                        , Except_Pink3_K_period, Except_Pink3_D_period, Except_Pink3_S_period, ""
                        , Except_Green1_K_period, Except_Green1_D_period, Except_Green1_S_period, ""
                        , Except_Green2_K_period, Except_Green2_D_period, Except_Green2_S_period, ""
                        , Except_Green3_K_period, Except_Green3_D_period, Except_Green3_S_period, ""
                        , Except_Blue_K_period, Except_Blue_D_period, Except_Blue_S_period    
                        , 0, i);
  
    if(0 < ni || 0 < ei) {
      return OP_BUY;
    }
    
    ni = iCustom(NULL, PERIOD_CURRENT, nInd
                        , False, False
                        , Normal_KPeriod, Normal_DPeriod, Normal_Slowing, Normal_MA_Method, Normal_PriceField
                        , Normal_Disable_Range_Bottom, Normal_Disable_Range_Upper, Normal_Buy_Line, Normal_Sell_Line, ""
                        , Normal_White_K_period, Normal_White_D_period, Normal_White_S_period, ""
                        , Normal_Pink1_K_period, Normal_Pink1_D_period, Normal_Pink1_S_period, ""
                        , Normal_Pink2_K_period, Normal_Pink2_D_period, Normal_Pink2_S_period, ""
                        , Normal_Pink3_K_period, Normal_Pink3_D_period, Normal_Pink3_S_period, ""
                        , Normal_Green1_K_period, Normal_Green1_D_period, Normal_Green1_S_period, ""
                        , Normal_Green2_K_period, Normal_Green2_D_period, Normal_Green2_S_period, ""
                        , Normal_Green3_K_period, Normal_Green3_D_period, Normal_Green3_S_period, ""
                        , Normal_Blue_K_period, Normal_Blue_D_period, Normal_Blue_S_period    
                        , 1, i);

    ei = iCustom(NULL, PERIOD_CURRENT, eInd
                        , False, False
                        , Except_KPeriod, Except_DPeriod, Except_Slowing, Except_MA_Method, Except_PriceField
                        , Except_Disable_Range_Bottom, Except_Disable_Range_Upper, Except_Buy_Line, Except_Sell_Line, ""
                        , Except_White_K_period, Except_White_D_period, Except_White_S_period, ""
                        , Except_Pink1_K_period, Except_Pink1_D_period, Except_Pink1_S_period, ""
                        , Except_Pink2_K_period, Except_Pink2_D_period, Except_Pink2_S_period, ""
                        , Except_Pink3_K_period, Except_Pink3_D_period, Except_Pink3_S_period, ""
                        , Except_Green1_K_period, Except_Green1_D_period, Except_Green1_S_period, ""
                        , Except_Green2_K_period, Except_Green2_D_period, Except_Green2_S_period, ""
                        , Except_Green3_K_period, Except_Green3_D_period, Except_Green3_S_period, ""
                        , Except_Blue_K_period, Except_Blue_D_period, Except_Blue_S_period    
                        , 1, i);
    
    if(0 < ni || 0 < ei) {
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

  maskPrice = -1.0;
  
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
  
  
void closeAll() {

  for(int i = 0; i < OrdersTotal(); i++) {
    if(OrderSelect(i, SELECT_BY_POS)) {
      if(!StringCompare(OrderSymbol(), thisSymbol) && OrderMagicNumber() == Magic_Number) {
        if(OrderType() == OP_BUY) {
          if(!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), 3)) {
            Print("Error on closing long order: ", GetLastError());
          }
          else {
            i = -1;
          }
        }
        else if(OrderType() == OP_SELL) {
          if(!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), 3)) {
            Print("Error on closing short order: ", GetLastError());
          }
          else {
            i = -1;
          }
        }
      }
    }
  }
}

  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  if(Daily_Close) {
    int h = TimeHour(TimeLocal());
    if(Close_Hour <= h && h < Open_Hour) {
      closeAll();
      return;
    }
  }

  int signal = getSignal();
  int pos = getOrdersTotal();

  if(0 < pos) {
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

  if(pos < Max_Positions && maskPrice != iOpen(Symbol(), PERIOD_CURRENT, 0)){
    if(signal == OP_BUY) {
      if(0 < OrderSend(Symbol(), OP_BUY, Entry_Lot, NormalizeDouble(Ask, Digits), 0, sltp(Ask, -1.0 * sl), sltp(Ask, tp), NULL, Magic_Number)) {
        maskPrice = iOpen(Symbol(), PERIOD_CURRENT, 0);
      }
    }
    else if(signal == OP_SELL) {
      if(0 < OrderSend(Symbol(), OP_SELL, Entry_Lot, NormalizeDouble(Bid, Digits), 0, sltp(Bid, sl), sltp(Bid, -1.0 * tp), NULL, Magic_Number)) {
        maskPrice = iOpen(Symbol(), PERIOD_CURRENT, 0);      
      }
    }
  }
}
//+------------------------------------------------------------------+
