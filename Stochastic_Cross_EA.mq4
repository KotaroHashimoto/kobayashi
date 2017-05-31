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
input double Stop_Loss = 20;
input double Take_Profit = 20;
input int Signal_Range = 3;

double sl;
double tp;
string thisSymbol;

const string eInd = "Stochastic_Cross_Alert_Except";
const string nInd = "Stochastic_Cross_Alert_Normal";


int getOrdersTotal() {

  int count = 0;
  for(int i = 0; 0 < OrdersTotal(); i++) {  
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
    if(0 < iCustom(NULL, PERIOD_CURRENT, nInd, 0, i) || 0 < iCustom(NULL, PERIOD_CURRENT, eInd, 0, i)) {
      return OP_BUY;
    }
    else if(0 < iCustom(NULL, PERIOD_CURRENT, nInd, 1, i) || 0 < iCustom(NULL, PERIOD_CURRENT, eInd, 1, i)) {
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
    for(int i = 0; i < getOrdersTotal(); i++) {
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
