#ifndef PULLBACKENGINE_MQH
#define PULLBACKENGINE_MQH

#include "../Core/Types.mqh"

class CPullbackEngine
{
public:

   //----------------------------------------------------------
   // Calculate retracement percentage for an UP impulse
   //----------------------------------------------------------
   double UpRetracement(double impulseHigh,
                        double impulseLow,
                        double price)
   {
      if(impulseHigh <= impulseLow)
         return(0.0);

      double range = impulseHigh - impulseLow;

      if(range <= 0.0)
         return(0.0);

      double retracement =
         ((impulseHigh - price) / range) * 100.0;

      if(retracement < 0.0)
         retracement = 0.0;

      return(retracement);
   }

   //----------------------------------------------------------
   // Calculate retracement percentage for a DOWN impulse
   //----------------------------------------------------------
   double DownRetracement(double impulseHigh,
                          double impulseLow,
                          double price)
   {
      if(impulseHigh <= impulseLow)
         return(0.0);

      double range = impulseHigh - impulseLow;

      if(range <= 0.0)
         return(0.0);

      double retracement =
         ((price - impulseLow) / range) * 100.0;

      if(retracement < 0.0)
         retracement = 0.0;

      return(retracement);
   }

   //----------------------------------------------------------
   // Check minimum 38.2% retracement
   //----------------------------------------------------------
   bool HasReached382(double retracement)
   {
      return(retracement >= 38.2);
   }

   //----------------------------------------------------------
   // Detect first pullback after the impulse
   //
   // UP:
   // Search from impulse high toward the present.
   // A Low touching 38.2% confirms the pullback.
   //
   // DOWN:
   // Search from impulse low toward the present.
   // A High touching 38.2% confirms the pullback.
   //----------------------------------------------------------
   bool FirstPullbackReached(
      ENUM_TREND trend,
      double impulseHigh,
      double impulseLow,
      datetime impulseEndTime)
   {
      if(impulseHigh <= impulseLow)
         return(false);

      int impulseShift =
         iBarShift(NULL, 0, impulseEndTime, true);

      if(impulseShift < 0)
         return(false);

      // We need bars AFTER the impulse.
      if(impulseShift <= 1)
         return(false);

      double range = impulseHigh - impulseLow;

      double fib382 = 0.0;

      if(trend == TREND_UP)
      {
         fib382 =
            impulseHigh - (range * 0.382);

         for(int shift = impulseShift - 1;
             shift >= 1;
             shift--)
         {
            if(Low[shift] <= fib382)
               return(true);
         }
      }

      if(trend == TREND_DOWN)
      {
         fib382 =
            impulseLow + (range * 0.382);

         for(int shift = impulseShift - 1;
             shift >= 1;
             shift--)
         {
            if(High[shift] >= fib382)
               return(true);
         }
      }

      return(false);
   }

};

#endif