#ifndef FIBONACCI_MQH
#define FIBONACCI_MQH

#include "../Core/Types.mqh"

class CFibonacci
{
public:

   bool Calculate(double high,
                  double low,
                  FibData &fib)
   {
      fib.IsValid = false;

      if(high <= low)
         return(false);

      fib.High = high;
      fib.Low  = low;

      double range = high - low;

      fib.Fib382 = high - range * 0.382;
      fib.Fib500 = high - range * 0.500;
      fib.Fib618 = high - range * 0.618;

      fib.FirstPullback = false;

      fib.IsValid = true;

      return(true);
   }
};

#endif