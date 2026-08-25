#ifndef TRADELEVELS_MQH
#define TRADELEVELS_MQH

#include "../Core/Types.mqh"

class CTradeLevels
{
public:

   //----------------------------------------------------------
   // Calculate Stop Loss and Take Profit
   //----------------------------------------------------------
   bool Calculate(
      TradeSetup &setup,
      double atr,
      double stopLossATR,
      double takeProfitATR)
   {
      if(!setup.IsValid)
         return(false);

      if(setup.Direction == DIRECTION_NONE)
         return(false);

      if(setup.Entry <= 0.0)
         return(false);

      if(atr <= 0.0)
         return(false);

      if(stopLossATR <= 0.0)
         return(false);

      if(takeProfitATR <= 0.0)
         return(false);

      //-------------------------------------------------------
      // Calculate distances
      //-------------------------------------------------------
      double slDistance = atr * stopLossATR;
      double tpDistance = atr * takeProfitATR;

      //-------------------------------------------------------
      // BUY
      //-------------------------------------------------------
      if(setup.Direction == DIRECTION_BUY)
      {
         setup.StopLoss =
            setup.Entry - slDistance;

         setup.TakeProfit =
            setup.Entry + tpDistance;
      }
      //-------------------------------------------------------
      // SELL
      //-------------------------------------------------------
      else
      if(setup.Direction == DIRECTION_SELL)
      {
         setup.StopLoss =
            setup.Entry + slDistance;

         setup.TakeProfit =
            setup.Entry - tpDistance;
      }
      else
      {
         return(false);
      }

      //-------------------------------------------------------
      // Sanity checks
      //-------------------------------------------------------
      if(setup.StopLoss <= 0.0)
         return(false);

      if(setup.TakeProfit <= 0.0)
         return(false);

      return(true);
   }

   //----------------------------------------------------------
   // Return absolute stop-loss distance
   //----------------------------------------------------------
   double StopLossDistance(TradeSetup &setup)
   {
      if(setup.Entry <= 0.0)
         return(0.0);

      if(setup.StopLoss <= 0.0)
         return(0.0);

      return(MathAbs(
         setup.Entry - setup.StopLoss));
   }
};

#endif