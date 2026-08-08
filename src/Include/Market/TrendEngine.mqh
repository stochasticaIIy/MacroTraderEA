#ifndef TRENDENGINE_MQH
#define TRENDENGINE_MQH

#include "../Core/Types.mqh"
#include "SwingEngine.mqh"

class CTrendEngine
{
private:

   CSwingEngine *m_swingEngine;

public:

   //----------------------------------------------------------
   // Constructor
   //----------------------------------------------------------
   CTrendEngine(CSwingEngine &swingEngine)
   {
      m_swingEngine = &swingEngine;
   }

   //----------------------------------------------------------
   // Determine trend from last confirmed swings
   //----------------------------------------------------------
   bool Analyze(TrendInfo &trend)
   {
      trend.IsValid = false;
      trend.Trend   = TREND_UNKNOWN;
      trend.HH = 0;
      trend.HL = 0;
      trend.LH = 0;
      trend.LL = 0;
      trend.Strength = 0.0;

      SwingPoint swings[4];

      if(!m_swingEngine.GetLastSwings(swings, 4))
         return(false);

      // Most recent first:
      //
      // swings[0]
      // swings[1]
      // swings[2]
      // swings[3]

      bool highLowHighLow =
         swings[0].Type == SWING_HIGH &&
         swings[1].Type == SWING_LOW &&
         swings[2].Type == SWING_HIGH &&
         swings[3].Type == SWING_LOW;

      bool lowHighLowHigh =
         swings[0].Type == SWING_LOW &&
         swings[1].Type == SWING_HIGH &&
         swings[2].Type == SWING_LOW &&
         swings[3].Type == SWING_HIGH;

      if(highLowHighLow || lowHighLowHigh)
      {
         double newestHigh;
         double previousHigh;

         double newestLow;
         double previousLow;

         if(highLowHighLow)
         {
            newestHigh   = swings[0].Price;
            previousHigh = swings[2].Price;

            newestLow    = swings[1].Price;
            previousLow  = swings[3].Price;
         }
         else
         {
            newestHigh   = swings[1].Price;
            previousHigh = swings[3].Price;

            newestLow    = swings[0].Price;
            previousLow  = swings[2].Price;
         }

         bool higherHigh = newestHigh > previousHigh;
         bool higherLow  = newestLow  > previousLow;

         if(higherHigh && higherLow)
         {
            trend.IsValid = true;
            trend.Trend = TREND_UP;
            trend.HH = 1;
            trend.HL = 1;
            trend.Strength = 1.0;
            return(true);
         }

         bool lowerHigh = newestHigh < previousHigh;
         bool lowerLow  = newestLow  < previousLow;

         if(lowerHigh && lowerLow)
         {
            trend.IsValid = true;
            trend.Trend = TREND_DOWN;
            trend.LH = 1;
            trend.LL = 1;
            trend.Strength = 1.0;
            return(true);
         }
      }

      trend.IsValid = true;
      trend.Trend = TREND_RANGE;

      return(true);
   }

   //----------------------------------------------------------
   // Is the market ranging?
   //----------------------------------------------------------
   bool IsRange()
   {
      TrendInfo trend;

      if(!Analyze(trend))
         return(false);

      return(trend.Trend == TREND_RANGE);
   }

//----------------------------------------------------------
// Get the active impulse for Fibonacci
//----------------------------------------------------------
   bool GetActiveImpulse(SwingPoint &start,
                        SwingPoint &end)
   {
      TrendInfo trend;

      if(!Analyze(trend))
         return(false);

      SwingPoint swings[4];

      for(int i = 0; i < 4; i++)
         swings[i].IsValid = false;

      int found = 0;
      int shift = 1;

      while(found < 4 && shift < Bars)
      {
         SwingPoint s;

         if(m_swingEngine.GetSwing(shift, s))
         {
            swings[found] = s;
            found++;
         }

         shift++;
      }

      if(found < 2)
         return(false);

      if(trend.Trend == TREND_UP)
      {
         // Latest LOW -> Latest HIGH
         if(swings[0].Type != SWING_LOW ||
            swings[1].Type != SWING_HIGH)
            return(false);

         start = swings[0];
         end   = swings[1];

         return(true);
      }

      if(trend.Trend == TREND_DOWN)
      {
         // Latest HIGH -> Latest LOW
         if(swings[0].Type != SWING_LOW ||
            swings[1].Type != SWING_HIGH)
            return(false);

         start = swings[1];
         end   = swings[0];

         return(true);
      }

      return(false);
   }

};

#endif