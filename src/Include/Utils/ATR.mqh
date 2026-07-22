#ifndef ATR_MQH
#define ATR_MQH

class CATR
{
public:

   //----------------------------------------------------------
   // Returns current ATR
   //----------------------------------------------------------
   double Current(int period = 14,
                  int shift = 1)
   {
      return(iATR(Symbol(),
                  Period(),
                  period,
                  shift));
   }

   //----------------------------------------------------------
   // Stop Loss = ATR × Multiplier
   //----------------------------------------------------------
   double StopLossDistance(int period,
                           double multiplier)
   {
      return(Current(period) * multiplier);
   }

   //----------------------------------------------------------
   // Take Profit = ATR × Multiplier
   //----------------------------------------------------------
   double TakeProfitDistance(int period,
                             double multiplier)
   {
      return(Current(period) * multiplier);
   }

};

#endif