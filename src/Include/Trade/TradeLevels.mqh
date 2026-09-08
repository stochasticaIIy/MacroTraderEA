#ifndef TRADELEVELS_MQH
#define TRADELEVELS_MQH

#include "../Core/Types.mqh"

class CTradeLevels
{
public:

   bool Calculate(
   TradeSetup &setup,
   double atr,
   double stopLossATR,
   double takeProfitATR)
   {
      if(!setup.IsValid)
      {
         Print("[TradeLevels] FAIL: setup.IsValid = false");
         return(false);
      }

      if(setup.Direction == DIRECTION_NONE)
      {
         Print("[TradeLevels] FAIL: Direction = NONE");
         return(false);
      }

      if(setup.Entry <= 0.0)
      {
         Print("[TradeLevels] FAIL: Entry <= 0");
         return(false);
      }

      if(atr <= 0.0)
      {
         Print("[TradeLevels] FAIL: ATR <= 0");
         return(false);
      }

      if(stopLossATR <= 0.0)
      {
         Print("[TradeLevels] FAIL: StopLossATR <= 0");
         return(false);
      }

      if(takeProfitATR <= 0.0)
      {
         Print("[TradeLevels] FAIL: TakeProfitATR <= 0");
         return(false);
      }

      double slDistance = atr * stopLossATR;
      double tpDistance = atr * takeProfitATR;

      Print(
         "[TradeLevels] Inputs: Entry=",
         DoubleToString(setup.Entry, Digits),
         " ATR=",
         DoubleToString(atr, Digits),
         " SL_ATR=",
         DoubleToString(stopLossATR, 2),
         " TP_ATR=",
         DoubleToString(takeProfitATR, 2));

      Print(
         "[TradeLevels] Distances: SL=",
         DoubleToString(slDistance, Digits),
         " TP=",
         DoubleToString(tpDistance, Digits));

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
         Print("[TradeLevels] FAIL: Invalid direction");
         return(false);
      }

      Print(
         "[TradeLevels] Calculated: SL=",
         DoubleToString(setup.StopLoss, Digits),
         " TP=",
         DoubleToString(setup.TakeProfit, Digits));

      if(setup.StopLoss <= 0.0)
      {
         Print("[TradeLevels] FAIL: StopLoss <= 0");
         return(false);
      }

      if(setup.TakeProfit <= 0.0)
      {
         Print("[TradeLevels] FAIL: TakeProfit <= 0");
         return(false);
      }

      Print("[TradeLevels] SUCCESS");

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