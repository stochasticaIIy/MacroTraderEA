#ifndef SETUPENGINE_MQH
#define SETUPENGINE_MQH

#include "Types.mqh"

class CSetupEngine
{
public:

   //----------------------------------------------------------
   // Build a preliminary trade setup
   //----------------------------------------------------------
   bool Analyze(
      TrendInfo &trend,
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

      setup.Rejection = SETUP_NO_REJECTION;

      //-------------------------------------------------------
      // Trend must be valid
      //-------------------------------------------------------
      if(!trend.IsValid)
      {
         setup.Rejection = SETUP_INVALID_TREND;
         return(true);
      }

      //-------------------------------------------------------
      // Range = no trade
      //-------------------------------------------------------
      if(trend.Trend == TREND_RANGE)
      {
         setup.Direction = DIRECTION_NONE;
         setup.Rejection = SETUP_RANGE;
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
         setup.Rejection = SETUP_INVALID_TREND;
         return(true);
      }

      //-------------------------------------------------------
      // Fibonacci required
      //-------------------------------------------------------
      if(!fib.IsValid)
      {
         setup.Rejection = SETUP_NO_FIBONACCI;
         return(true);
      }

      //-------------------------------------------------------
      // Pullback required
      //-------------------------------------------------------
      if(!setup.Pullback.IsValid)
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
      // S/R zone required
      //-------------------------------------------------------
      if(!zone.IsValid)
      {
         setup.Rejection = SETUP_NO_SR_ZONE;
         return(true);
      }

      //-------------------------------------------------------
      // S/R must be significant
      //-------------------------------------------------------
      if(zone.Strength < 0.66)
      {
         setup.Rejection = SETUP_SR_NOT_SIGNIFICANT;
         return(true);
      }

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
      // Setup is valid
      //-------------------------------------------------------
      setup.IsValid = true;
      setup.Rejection = SETUP_NO_REJECTION;

      return(true);
   }
};

#endif