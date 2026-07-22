#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

class CRiskManager
{
public:

   //----------------------------------------------------------
   // Calculate lot size from account risk and stop-loss distance
   // stopLossDistance is a PRICE distance (e.g. 0.00250 on EURUSD)
   //----------------------------------------------------------
   double CalculateLotSize(double riskPercent,
                           double stopLossDistance)
   {
      if(riskPercent <= 0.0)
         return(0.0);

      if(stopLossDistance <= 0.0)
         return(0.0);

      double balance = AccountBalance();

      double riskMoney = balance * riskPercent / 100.0;

      double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
      double tickSize  = MarketInfo(Symbol(), MODE_TICKSIZE);

      if(tickValue <= 0.0 || tickSize <= 0.0)
         return(0.0);

      // Number of ticks between entry and stop
      double ticks = stopLossDistance / tickSize;

      if(ticks <= 0.0)
         return(0.0);

      double lossPerLot = ticks * tickValue;

      if(lossPerLot <= 0.0)
         return(0.0);

      double lot = riskMoney / lossPerLot;

      double minLot  = MarketInfo(Symbol(), MODE_MINLOT);
      double maxLot  = MarketInfo(Symbol(), MODE_MAXLOT);
      double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

      // Round down to broker lot step
      lot = MathFloor(lot / lotStep) * lotStep;

      if(lot < minLot)
         lot = minLot;

      if(lot > maxLot)
         lot = maxLot;

      return NormalizeDouble(lot, 2);
   }
};

#endif