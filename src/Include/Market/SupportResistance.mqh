#ifndef SUPPORTRESISTANCE_MQH
#define SUPPORTRESISTANCE_MQH

#include "../Core/Types.mqh"
#include "SwingEngine.mqh"

class CSupportResistance
{
public:

   //----------------------------------------------------------
   // Find the nearest support below current price
   //----------------------------------------------------------
   bool FindSupport(double currentPrice,
                    double tolerance,
                    SRZone &zone)
   {
      zone.IsValid = false;
      zone.Type = ZONE_SUPPORT;
      zone.Upper = 0.0;
      zone.Lower = 0.0;
      zone.Touches = 0;
      zone.Strength = 0.0;

      int barsToScan = Bars;

      if(barsToScan > 300)
         barsToScan = 300;

      double bestPrice = 0.0;
      int bestShift = -1;

      for(int shift = 1; shift < barsToScan; shift++)
      {
         SwingPoint swing;

         if(!SwingEngine.GetSwing(shift, swing))
            continue;

         if(swing.Type != SWING_LOW)
            continue;

         if(swing.Price >= currentPrice)
            continue;

         if(bestShift == -1 ||
            swing.Price > bestPrice)
         {
            bestPrice = swing.Price;
            bestShift = shift;
         }
      }

      if(bestShift == -1)
         return(false);

      zone.Lower = bestPrice - tolerance;
      zone.Upper = bestPrice + tolerance;
      zone.Touches = 1;
      zone.Strength = 1.0;
      zone.IsValid = true;

      return(true);
   }

   //----------------------------------------------------------
   // Find the nearest resistance above current price
   //----------------------------------------------------------
   bool FindResistance(double currentPrice,
                       double tolerance,
                       SRZone &zone)
   {
      zone.IsValid = false;
      zone.Type = ZONE_RESISTANCE;
      zone.Upper = 0.0;
      zone.Lower = 0.0;
      zone.Touches = 0;
      zone.Strength = 0.0;

      int barsToScan = Bars;

      if(barsToScan > 300)
         barsToScan = 300;

      double bestPrice = 0.0;
      int bestShift = -1;

      for(int shift = 1; shift < barsToScan; shift++)
      {
         SwingPoint swing;

         if(!SwingEngine.GetSwing(shift, swing))
            continue;

         if(swing.Type != SWING_HIGH)
            continue;

         if(swing.Price <= currentPrice)
            continue;

         if(bestShift == -1 ||
            swing.Price < bestPrice)
         {
            bestPrice = swing.Price;
            bestShift = shift;
         }
      }

      if(bestShift == -1)
         return(false);

      zone.Lower = bestPrice - tolerance;
      zone.Upper = bestPrice + tolerance;
      zone.Touches = 1;
      zone.Strength = 1.0;
      zone.IsValid = true;

      return(true);
   }

    //----------------------------------------------------------
    // Count confirmed swings inside a price zone
    //----------------------------------------------------------
    int CountTouches(double zonePrice,
                    double tolerance)
    {
        int touches = 0;

        int barsToScan = Bars;

        if(barsToScan > 300)
            barsToScan = 300;

        for(int shift = 1; shift < barsToScan; shift++)
        {
            SwingPoint swing;

            if(!SwingEngine.GetSwing(shift, swing))
                continue;

            if(MathAbs(swing.Price - zonePrice)
                <= tolerance)
            {
                touches++;
            }
        }

        return(touches);
    }

    //----------------------------------------------------------
    // Determine S/R zone significance
   //----------------------------------------------------------
   double CalculateStrength(int touches)
   {
      if(touches <= 0)
         return(0.0);

      if(touches == 1)
         return(0.33);

      if(touches == 2)
         return(0.66);

      return(1.0);
   }

   //----------------------------------------------------------
   // Check whether a zone is significant
   //----------------------------------------------------------
   bool IsSignificant(int touches)
   {
      return(touches >= 2);
   }

};

#endif