#ifndef PULLBACKENGINE_MQH
#define PULLBACKENGINE_MQH

#include "../Core/Types.mqh"

class CPullbackEngine
{
public:

   //----------------------------------------------------------
   // Check whether an UP trend has reached the 38.2% pullback
   //----------------------------------------------------------
   bool IsUpPullbackValid(double impulseHigh,
                          double impulseLow,
                          double currentPrice)
   {
      if(impulseHigh <= impulseLow)
         return(false);

      double range = impulseHigh - impulseLow;

      double fib382 = impulseHigh - (range * 0.382);

      if(currentPrice <= fib382)
         return(true);

      return(false);
   }

   //----------------------------------------------------------
   // Check whether a DOWN trend has reached the 38.2% pullback
   //----------------------------------------------------------
   bool IsDownPullbackValid(double impulseHigh,
                            double impulseLow,
                            double currentPrice)
   {
      if(impulseHigh <= impulseLow)
         return(false);

      double range = impulseHigh - impulseLow;

      double fib382 = impulseLow + (range * 0.382);

      if(currentPrice >= fib382)
         return(true);

      return(false);
   }

};

#endif