#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

class CRiskManager
{
public:

   //----------------------------------------------------------
   // Calculates lot size based on risk percentage
   //----------------------------------------------------------
   double CalculateLotSize(double riskPercent,
                           double stopLossPips)
   {
      if(stopLossPips <= 0.0)
         return(0.0);

      double balance = AccountBalance();

      double riskAmount = balance * riskPercent / 100.0;

      double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);

      double lot = riskAmount / (stopLossPips * tickValue);

      double minLot = MarketInfo(Symbol(), MODE_MINLOT);
      double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
      double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

      lot = MathFloor(lot / lotStep) * lotStep;

      if(lot < minLot)
         lot = minLot;

      if(lot > maxLot)
         lot = maxLot;

      return(NormalizeDouble(lot, 2));
   }

};

#endif