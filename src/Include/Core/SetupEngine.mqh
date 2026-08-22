#ifndef SETUPENGINE_MQH
#define SETUPENGINE_MQH

#include "Types.mqh"

class CSetupEngine
{
public:

   //----------------------------------------------------------
   // Build a preliminary trade setup
   //----------------------------------------------------------
   bool Analyze(TrendInfo &trend,
                FibData &fib,
                PullbackInfo &pullback,
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
      setup.Rejection = SETUP_NO_REJECTION;

      setup.Trend = trend;
      setup.Fib = fib;
      setup.Pullback = pullback;
      setup.Pattern = pattern;
      setup.Zone = zone;

      setup.Entry = 0.0;
      setup.StopLoss = 0.0;
      setup.TakeProfit = 0.0;
      setup.RiskPercent = 0.0;
      setup.Confidence = 0.0;
      setup.StrategyHealth = 0.0;

      //-------------------------------------------------------
      // Trend must be valid
      //-------------------------------------------------------
      if(!trend.IsValid)
      {
         setup.Rejection = SETUP_INVALID_TREND;
         return(false);
      }

      //-------------------------------------------------------
      // Range = no setup
      //-------------------------------------------------------
      if(trend.Trend == TREND_RANGE)
      {
         setup.Rejection = SETUP_RANGE;
         return(true);
      }

      //-------------------------------------------------------
      // Direction
      //-------------------------------------------------------
      if(trend.Trend == TREND_UP)
         setup.Direction = DIRECTION_BUY;
      else
      if(trend.Trend == TREND_DOWN)
         setup.Direction = DIRECTION_SELL;
      else
         return(true);

      //-------------------------------------------------------
      // Fibonacci required
      //-------------------------------------------------------
      if(!fib.IsValid)
      {
         setup.Rejection = SETUP_NO_FIBONACCI;
         return(true);
      }

      //-------------------------------------------------------
      // First pullback required
      //-------------------------------------------------------
      if(!pullback.IsValid)
      {
         setup.Rejection = SETUP_NO_PULLBACK;
         return(true);
      }

      //-------------------------------------------------------
      // Pattern required
      //-------------------------------------------------------
      if(!pattern.IsValid)
      {
         setup.Rejection = SETUP_NO_PATTERN;
         return(true);
      }

      //-------------------------------------------------------
      // S/R required
      //-------------------------------------------------------
      if(!zone.IsValid)
      {
         setup.Rejection = SETUP_NO_SR_ZONE;
         return(true);
      }

      //-------------------------------------------------------
      // Significant S/R required
      //-------------------------------------------------------
      if(zone.Strength < 0.66)
      {
         setup.Rejection = SETUP_SR_NOT_SIGNIFICANT;
         return(true);
      }

      //-------------------------------------------------------
      // Confidence
      //-------------------------------------------------------
      double score = 0.0;

      score += 0.20;   // Trend
      score += 0.20;   // Fibonacci
      score += 0.20;   // First Pullback
      score += 0.20;   // Pattern

      if(zone.Strength >= 1.0)
         score += 0.20;
      else
         score += 0.15;

      setup.Confidence = score;
      setup.StrategyHealth = score;

      //-------------------------------------------------------
      // Valid preliminary setup
      //-------------------------------------------------------
      setup.Rejection = SETUP_NO_REJECTION;
      setup.IsValid = true;

      return(true);
   }
};

#endif