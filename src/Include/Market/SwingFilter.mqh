#ifndef SWINGFILTER_MQH
#define SWINGFILTER_MQH

#include "../Utils/ATR.mqh"
#include "../Core/Types.mqh"

class CSwingFilter
{
private:
   
   CATR m_atr;

public:

   CSwingFilter(CATR &atr)
{
   m_atr = atr;
}

   //----------------------------------------------------------
   // Returns true if the swing is significant enough
   //----------------------------------------------------------
   bool IsSignificant(double currentSwing,
                      double previousSwing,
                      double multiplier = 1.0)
   {
      double atr = m_atr.Current();

      double distance = MathAbs(currentSwing - previousSwing);

      return(distance >= atr * multiplier);
   }
};

#endif