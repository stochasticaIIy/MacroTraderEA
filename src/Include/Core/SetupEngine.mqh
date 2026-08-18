#ifndef SETUPENGINE_MQH
#define SETUPENGINE_MQH

#include "Types.mqh"

class CSetupEngine
{
public:

   //----------------------------------------------------------
   // Build a preliminary trade setup from existing analysis
   //----------------------------------------------------------

   bool Analyze(TrendInfo &trend,
                FibData &fib,
                PatternData &pattern,
                SRZone &zone,
                TradeSetup &setup)
   {
      //-------------------------------------------------------
      // Reset setup
      //-------------------------------------------------------
      setup.IsValid = false;
      setup.Symbol = Symbol();
      setup.Direction = DIRECTION_NONE;

      setup.Trend = trend;
      setup.Fib = fib;
      setup.Pattern = pattern;
      setup.Zone = zone;

      setup.Entry = 0.0;
      setup.StopLoss = 0.0;
      setup.TakeProfit = 0.0;
      setup.RiskPercent = 0.0;
      setup.Confidence = 0.0;
      setup.StrategyHealth = 0.0;

      //-------------------------------------------------------
      // Trend analysis itself must be valid
      //-------------------------------------------------------
      if(!trend.IsValid)
         return(false);

      //-------------------------------------------------------
      // Range = no trade setup
      //-------------------------------------------------------
      if(trend.Trend == TREND_RANGE)
      {
         setup.Direction = DIRECTION_NONE;
         return(true);
      }

      //-------------------------------------------------------
      // Determine direction
      //-------------------------------------------------------
      if(trend.Trend == TREND_UP)
      {
         setup.Direction = DIRECTION_BUY;
      }
      else
      if(trend.Trend == TREND_DOWN)
      {
         setup.Direction = DIRECTION_SELL;
      }
      else
      {
         setup.Direction = DIRECTION_NONE;
         return(true);
      }

      //-------------------------------------------------------
      // Fibonacci must be available
      //-------------------------------------------------------
      if(!fib.IsValid)
         return(true);

      //-------------------------------------------------------
      // Pattern must be available
      //-------------------------------------------------------
      if(!pattern.IsValid)
         return(true);

      //-------------------------------------------------------
      // S/R must be available
      //-------------------------------------------------------
      if(!zone.IsValid)
         return(true);

      //-------------------------------------------------------
      // S/R must be significant
      //-------------------------------------------------------
      if(zone.Strength < 0.66)
         return(true);

      //-------------------------------------------------------
      // Preliminary confidence
      //-------------------------------------------------------
      double score = 0.0;

      // Trend
      score += 0.25;

      // Fibonacci
      score += 0.25;

      // Pattern
      score += 0.25;

      // S/R
      if(zone.Strength >= 1.0)
         score += 0.25;
      else
         score += 0.20;

      setup.Confidence = score;
      setup.StrategyHealth = score;

      //-------------------------------------------------------
      // Preliminary setup is valid
      //-------------------------------------------------------
      setup.IsValid = true;

      return(true);
   }
};

#endif