#ifndef TRADEGUARD_MQH
#define TRADEGUARD_MQH

class CTradeGuard
{
public:

   //----------------------------------------------------------
   // Check whether today is an allowed trading day
   //----------------------------------------------------------
   bool IsTradingDay()
   {
      int day = DayOfWeek();

      if(day == 0)
         return(false);   // Sunday

      if(day == 1)
         return(TradeMonday);

      if(day == 2)
         return(TradeTuesday);

      if(day == 3)
         return(TradeWednesday);

      if(day == 4)
         return(TradeThursday);

      if(day == 5)
         return(TradeFriday);

      return(false);
   }

   //----------------------------------------------------------
   // Count currently open/pending orders for this symbol
   //----------------------------------------------------------
   int CountOpenTrades()
   {
      int count = 0;

      int total = OrdersTotal();

      for(int i = 0; i < total; i++)
      {
         if(!OrderSelect(
               i,
               SELECT_BY_POS,
               MODE_TRADES))
         {
            continue;
         }

         if(OrderSymbol() != Symbol())
            continue;

         count++;
      }

      return(count);
   }

   //----------------------------------------------------------
   // Count orders opened today for this symbol
   //----------------------------------------------------------
   int CountTradesToday()
   {
      int count = 0;

      datetime now = TimeCurrent();

      string dateString =
         TimeToString(
            now,
            TIME_DATE);

      datetime dayStart =
         StringToTime(dateString);

      int total = OrdersHistoryTotal();

      for(int i = 0; i < total; i++)
      {
         if(!OrderSelect(
               i,
               SELECT_BY_POS,
               MODE_HISTORY))
         {
            continue;
         }

         if(OrderSymbol() != Symbol())
            continue;

         if(OrderOpenTime() >= dayStart)
            count++;
      }

      return(count);
   }

   //----------------------------------------------------------
   // Check maximum open-trade limit
   //----------------------------------------------------------
   bool CanOpenTrade()
   {
      int openTrades =
         CountOpenTrades();

      if(openTrades >= MaxOpenTrades)
         return(false);

      int tradesToday =
         CountTradesToday();

      if(tradesToday >= MaxTradesPerDay)
         return(false);

      return(true);
   }

};

#endif