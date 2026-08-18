#ifndef PATTERNENGINE_MQH
#define PATTERNENGINE_MQH

#include "../Core/Types.mqh"
#include "SwingEngine.mqh"
#include "../Utils/ATR.mqh"

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

      //----------------------------------------------------------
   // Detect Head & Shoulders
   //----------------------------------------------------------
   bool IsHeadAndShoulders(double shoulderTolerance)
   {
      if(shoulderTolerance <= 0.0)
         return(false);

      SwingPoint swings[5];

      for(int i = 0; i < 5; i++)
         swings[i].IsValid = false;

      if(!SwingEngine.GetLastSwings(swings, 5))
         return(false);

      // Most recent first:
      //
      // [0] HIGH = Right Shoulder
      // [1] LOW  = Right Neckline
      // [2] HIGH = Head
      // [3] LOW  = Left Neckline
      // [4] HIGH = Left Shoulder
      //
      // Chronological structure:
      //
      // Left Shoulder
      //       ↓
      //     Neckline
      //       ↑
      //      Head
      //       ↓
      //     Neckline
      //       ↑
      // Right Shoulder

      if(swings[0].Type != SWING_HIGH)
         return(false);

      if(swings[1].Type != SWING_LOW)
         return(false);

      if(swings[2].Type != SWING_HIGH)
         return(false);

      if(swings[3].Type != SWING_LOW)
         return(false);

      if(swings[4].Type != SWING_HIGH)
         return(false);

      // Head must be higher than both shoulders.
      if(swings[2].Price <= swings[4].Price)
         return(false);

      if(swings[2].Price <= swings[0].Price)
         return(false);

      // Shoulders must be reasonably close in height.
      double shoulderDifference =
         MathAbs(
            swings[4].Price -
            swings[0].Price);

      if(shoulderDifference > shoulderTolerance)
         return(false);

      return(true);
   }

   //----------------------------------------------------------
   // Detect Inverse Head & Shoulders
   //----------------------------------------------------------
   bool IsInverseHeadAndShoulders(double shoulderTolerance)
   {
      if(shoulderTolerance <= 0.0)
         return(false);

      SwingPoint swings[5];

      for(int i = 0; i < 5; i++)
         swings[i].IsValid = false;

      if(!SwingEngine.GetLastSwings(swings, 5))
         return(false);

      // Most recent first:
      //
      // [0] LOW  = Right Shoulder
      // [1] HIGH = Right Neckline
      // [2] LOW  = Head
      // [3] HIGH = Left Neckline
      // [4] LOW  = Left Shoulder
      //
      // Chronological structure:
      //
      // Left Shoulder
      //       ↑
      //     Neckline
      //       ↓
      //      Head
      //       ↑
      //     Neckline
      //       ↓
      // Right Shoulder

      if(swings[0].Type != SWING_LOW)
         return(false);

      if(swings[1].Type != SWING_HIGH)
         return(false);

      if(swings[2].Type != SWING_LOW)
         return(false);

      if(swings[3].Type != SWING_HIGH)
         return(false);

      if(swings[4].Type != SWING_LOW)
         return(false);

      // Head must be lower than both shoulders.
      if(swings[2].Price >= swings[4].Price)
         return(false);

      if(swings[2].Price >= swings[0].Price)
         return(false);

      // Shoulders must be reasonably close in height.
      double shoulderDifference =
         MathAbs(
            swings[4].Price -
            swings[0].Price);

      if(shoulderDifference > shoulderTolerance)
         return(false);

      return(true);
   }

      //----------------------------------------------------------
   // Detect Bullish Fair Value Gap
   //
   // Using three closed candles:
   //
   // Candle 3       Candle 2       Candle 1
   //   HIGH  <        ...          LOW
   //
   // Bullish FVG exists when:
   //
   // Low[1] > High[3]
   //----------------------------------------------------------
   bool IsBullishFVG(int shift)
   {
      if(shift < 1)
         return(false);

      if(shift + 2 >= Bars)
         return(false);

      double newestLow = Low[shift];
      double oldestHigh = High[shift + 2];

      if(newestLow > oldestHigh)
         return(true);

      return(false);
   }

   //----------------------------------------------------------
   // Detect Bearish Fair Value Gap
   //
   // Bearish FVG exists when:
   //
   // High[1] < Low[3]
   //----------------------------------------------------------
   bool IsBearishFVG(int shift)
   {
      if(shift < 1)
         return(false);

      if(shift + 2 >= Bars)
         return(false);

      double newestHigh = High[shift];
      double oldestLow = Low[shift + 2];

      if(newestHigh < oldestLow)
         return(true);

      return(false);
   }

   //----------------------------------------------------------
   // Get Bullish FVG boundaries
   //
   // Lower boundary = High of oldest candle
   // Upper boundary = Low of newest candle
   //----------------------------------------------------------
   bool GetBullishFVG(int shift,
                      double &lower,
                      double &upper)
   {
      if(!IsBullishFVG(shift))
         return(false);

      lower = High[shift + 2];
      upper = Low[shift];

      return(true);
   }

   //----------------------------------------------------------
   // Get Bearish FVG boundaries
   //
   // Lower boundary = High of newest candle
   // Upper boundary = Low of oldest candle
   //----------------------------------------------------------
   bool GetBearishFVG(int shift,
                      double &lower,
                      double &upper)
   {
      if(!IsBearishFVG(shift))
         return(false);

      lower = High[shift];
      upper = Low[shift + 2];

      return(true);
   }

      //----------------------------------------------------------
   // Analyze available chart patterns
   //----------------------------------------------------------
   bool Analyze(PatternData &pattern)
   {
      pattern.IsValid = false;
      pattern.Pattern = PATTERN_NONE;
      pattern.Score = 0.0;
      pattern.DetectionTime = 0;

      double tolerance =
         ATR.Current(ATRPeriod) * 0.5;

      if(tolerance <= 0.0)
         return(false);

      //-------------------------------------------------------
      // W Pattern
      //-------------------------------------------------------
      if(IsWPattern(tolerance))
      {
         pattern.IsValid = true;
         pattern.Pattern = PATTERN_W;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // M Pattern
      //-------------------------------------------------------
      if(IsMPattern(tolerance))
      {
         pattern.IsValid = true;
         pattern.Pattern = PATTERN_M;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // Head & Shoulders
      //-------------------------------------------------------
      if(IsHeadAndShoulders(tolerance))
      {
         pattern.IsValid = true;
         pattern.Pattern = PATTERN_HEAD_SHOULDERS;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // Inverse Head & Shoulders
      //-------------------------------------------------------
      if(IsInverseHeadAndShoulders(tolerance))
      {
         pattern.IsValid = true;
         pattern.Pattern =
            PATTERN_INVERSE_HEAD_SHOULDERS;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // Bullish FVG
      //-------------------------------------------------------
      if(IsBullishFVG(1))
      {
         pattern.IsValid = true;
         pattern.Pattern = PATTERN_FVG;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // Bearish FVG
      //-------------------------------------------------------
      if(IsBearishFVG(1))
      {
         pattern.IsValid = true;
         pattern.Pattern = PATTERN_FVG;
         pattern.Score = 1.0;
         pattern.DetectionTime = Time[1];

         return(true);
      }

      //-------------------------------------------------------
      // No pattern
      //-------------------------------------------------------
      return(true);
   }

};

#endif