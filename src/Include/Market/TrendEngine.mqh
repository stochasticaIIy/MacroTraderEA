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

      SwingPoint swings[4];
      for(int i=0;i<4;i++)
      {
         swings[i].IsValid = false;
      }

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

      if(found < 4)
         return(false);

      // Most recent first:
      //
      // swings[0]
      // swings[1]
      // swings[2]
      // swings[3]

      if(swings[0].Type == SWING_HIGH &&
         swings[1].Type == SWING_LOW &&
         swings[2].Type == SWING_HIGH &&
         swings[3].Type == SWING_LOW)
      {
         bool higherHigh =
            swings[0].Price > swings[2].Price;

         bool higherLow =
            swings[1].Price > swings[3].Price;

         if(higherHigh && higherLow)
         {
            trend.IsValid = true;
            trend.Trend = TREND_UP;
            return(true);
         }

         bool lowerHigh =
            swings[0].Price < swings[2].Price;

         bool lowerLow =
            swings[1].Price < swings[3].Price;

         if(lowerHigh && lowerLow)
         {
            trend.IsValid = true;
            trend.Trend = TREND_DOWN;
            return(true);
         }
      }

      trend.IsValid = true;
      trend.Trend = TREND_RANGE;

      return(true);
   }

};

#endif