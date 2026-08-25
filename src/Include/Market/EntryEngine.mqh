#ifndef ENTRYENGINE_MQH
#define ENTRYENGINE_MQH

#include "../Core/Types.mqh"

class CEntryEngine
{
public:

   //----------------------------------------------------------
   // Validate whether a trade setup has a valid entry
   //----------------------------------------------------------
   bool Validate(TradeSetup &setup)
   {
      //-------------------------------------------------------
      // Reset entry
      //-------------------------------------------------------
      setup.Entry = 0.0;

      //-------------------------------------------------------
      // Basic setup validation
      //-------------------------------------------------------
      if(!setup.IsValid)
         return(false);

      if(setup.Direction == DIRECTION_NONE)
         return(false);

      if(!setup.Trend.IsValid)
         return(false);

      if(!setup.Fib.IsValid)
         return(false);

      if(!setup.Pullback.IsValid)
         return(false);

      if(!setup.Pattern.IsValid)
         return(false);

      if(!setup.Zone.IsValid)
         return(false);

      //-------------------------------------------------------
      // Use the last closed candle
      //-------------------------------------------------------
      double currentPrice = Close[1];

      if(currentPrice <= 0.0)
         return(false);

      //-------------------------------------------------------
      // BUY
      //-------------------------------------------------------
      if(setup.Direction == DIRECTION_BUY)
      {
         //----------------------------------------------------
         // Price must be at or below the 38.2% retracement
         // after the first pullback.
         //----------------------------------------------------
         if(currentPrice > setup.Fib.Fib382)
            return(false);

         setup.Entry = currentPrice;

         return(true);
      }

      //-------------------------------------------------------
      // SELL
      //-------------------------------------------------------
      if(setup.Direction == DIRECTION_SELL)
      {
         //----------------------------------------------------
         // Price must be at or above the 38.2% retracement
         // after the first pullback.
         //----------------------------------------------------
         if(currentPrice < setup.Fib.Fib382)
            return(false);

         setup.Entry = currentPrice;

         return(true);
      }

      return(false);
   }
};

#endif