#ifndef FIRSTPULLBACK_MQH
#define FIRSTPULLBACK_MQH

#include "../Core/Types.mqh"

class CFirstPullback
{
public:

   //----------------------------------------------------------
   // Check first pullback for an UP trend
   //
   // Impulse:
   // LOW -> HIGH
   //
   // Pullback is valid when a CLOSED candle reaches
   // the 38.2% Fibonacci level.
   //----------------------------------------------------------
   bool CheckUptrend(double fib382,
                     int shift,
                     PullbackInfo &pullback)
   {
      pullback.IsValid = false;
      pullback.Direction = TREND_UNKNOWN;
      pullback.Shift = -1;
      pullback.Price = 0.0;
      pullback.FibLevel = 0.0;

      if(shift < 1)
         return(false);

      if(Bars <= shift)
         return(false);

      double candleLow   = Low[shift];
      double candleClose = Close[shift];

      // Candle must reach the 38.2% retracement.
      if(candleLow > fib382)
         return(false);

      pullback.IsValid = true;
      pullback.Direction = TREND_UP;
      pullback.Shift = shift;
      pullback.Price = candleClose;
      pullback.FibLevel = fib382;

      return(true);
   }

   //----------------------------------------------------------
   // Check first pullback for a DOWN trend
   //
   // Impulse:
   // HIGH -> LOW
   //
   // Pullback is valid when a CLOSED candle reaches
   // the 38.2% Fibonacci level.
   //----------------------------------------------------------
   bool CheckDowntrend(double fib382,
                       int shift,
                       PullbackInfo &pullback)
   {
      pullback.IsValid = false;
      pullback.Direction = TREND_UNKNOWN;
      pullback.Shift = -1;
      pullback.Price = 0.0;
      pullback.FibLevel = 0.0;

      if(shift < 1)
         return(false);

      if(Bars <= shift)
         return(false);

      double candleHigh  = High[shift];
      double candleClose = Close[shift];

      // Candle must reach the 38.2% retracement.
      if(candleHigh < fib382)
         return(false);

      pullback.IsValid = true;
      pullback.Direction = TREND_DOWN;
      pullback.Shift = shift;
      pullback.Price = candleClose;
      pullback.FibLevel = fib382;

      return(true);
   }
};

#endif