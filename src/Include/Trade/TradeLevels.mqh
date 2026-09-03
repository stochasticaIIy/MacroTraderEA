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

      double slDistance = atr * stopLossATR;
      double tpDistance = atr * takeProfitATR;

      if(setup.Direction == DIRECTION_BUY)
      {
         setup.StopLoss =
            setup.Entry - slDistance;

         setup.TakeProfit =
            setup.Entry + tpDistance;
      }
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

   //----------------------------------------------------------
   // Return absolute take-profit distance
   //----------------------------------------------------------
   double TakeProfitDistance(TradeSetup &setup)
   {
      if(setup.Entry <= 0.0)
         return(0.0);

      if(setup.TakeProfit <= 0.0)
         return(0.0);

      return(MathAbs(
         setup.Entry - setup.TakeProfit));
   }

   //----------------------------------------------------------
   // Calculate actual risk/reward ratio
   //----------------------------------------------------------
   double RiskRewardRatio(TradeSetup &setup)
   {
      double slDistance =
         StopLossDistance(setup);

      double tpDistance =
         TakeProfitDistance(setup);

      if(slDistance <= 0.0)
         return(0.0);

      if(tpDistance <= 0.0)
         return(0.0);

      return(tpDistance / slDistance);
   }

   //----------------------------------------------------------
   // Check minimum required risk/reward
   //----------------------------------------------------------
   bool MeetsMinimumRiskReward(
      TradeSetup &setup,
      double minimumRR)
   {
      if(minimumRR <= 0.0)
         return(false);

      double rr =
         RiskRewardRatio(setup);

      return(rr >= minimumRR);
   }
};

#endif