#ifndef PATTERNENGINE_MQH
#define PATTERNENGINE_MQH

#include "../Core/Types.mqh"
#include "SwingEngine.mqh"

class CPatternEngine
{
public:

   //----------------------------------------------------------
   // Detect a basic break and retest of a price level
   //----------------------------------------------------------
   bool IsBreakRetest(double level,
                      ENUM_TREND trend,
                      int lookback)
   {
      if(level <= 0.0)
         return(false);

      if(lookback < 3)
         lookback = 3;

      if(lookback >= Bars)
         lookback = Bars - 1;

      if(trend == TREND_UP)
      {
         bool broken = false;

         for(int shift = lookback;
             shift >= 1;
             shift--)
         {
            if(Close[shift] > level)
            {
               broken = true;
               continue;
            }

            if(broken &&
               Low[shift] <= level &&
               Close[shift] > level)
            {
               return(true);
            }
         }
      }

      if(trend == TREND_DOWN)
      {
         bool broken = false;

         for(int shift = lookback;
             shift >= 1;
             shift--)
         {
            if(Close[shift] < level)
            {
               broken = true;
               continue;
            }

            if(broken &&
               High[shift] >= level &&
               Close[shift] < level)
            {
               return(true);
            }
         }
      }

      return(false);
   }

      //----------------------------------------------------------
   // Detect W / double-bottom structure
   //----------------------------------------------------------
   bool IsWPattern(double tolerance)
   {
      if(tolerance <= 0.0)
         return(false);

      SwingPoint swings[4];

      for(int i = 0; i < 4; i++)
         swings[i].IsValid = false;

      if(!SwingEngine.GetLastSwings(swings, 4))
         return(false);

      // Most recent first:
      //
      // [0] HIGH
      // [1] LOW
      // [2] HIGH
      // [3] LOW
      //
      // This gives:
      //
      // LOW -> HIGH -> LOW -> HIGH

      if(swings[0].Type != SWING_HIGH)
         return(false);

      if(swings[1].Type != SWING_LOW)
         return(false);

      if(swings[2].Type != SWING_HIGH)
         return(false);

      if(swings[3].Type != SWING_LOW)
         return(false);

      double lowDifference =
         MathAbs(
            swings[1].Price -
            swings[3].Price);

      if(lowDifference > tolerance)
         return(false);

      // Second low should not be materially
      // below the first low.
      if(swings[1].Price < swings[3].Price - tolerance)
         return(false);

      return(true);
   }

   //----------------------------------------------------------
   // Detect M / double-top structure
   //----------------------------------------------------------
   bool IsMPattern(double tolerance)
   {
      if(tolerance <= 0.0)
         return(false);

      SwingPoint swings[4];

      for(int i = 0; i < 4; i++)
         swings[i].IsValid = false;

      if(!SwingEngine.GetLastSwings(swings, 4))
         return(false);

      // Most recent first:
      //
      // [0] LOW
      // [1] HIGH
      // [2] LOW
      // [3] HIGH
      //
      // This gives:
      //
      // HIGH -> LOW -> HIGH -> LOW

      if(swings[0].Type != SWING_LOW)
         return(false);

      if(swings[1].Type != SWING_HIGH)
         return(false);

      if(swings[2].Type != SWING_LOW)
         return(false);

      if(swings[3].Type != SWING_HIGH)
         return(false);

      double highDifference =
         MathAbs(
            swings[1].Price -
            swings[3].Price);

      if(highDifference > tolerance)
         return(false);

      // Second high should not be materially
      // above the first high.
      if(swings[1].Price > swings[3].Price + tolerance)
         return(false);

      return(true);
   }

};

#endif