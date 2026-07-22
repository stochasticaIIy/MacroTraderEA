#ifndef SWINGENGINE_MQH
#define SWINGENGINE_MQH

#include "../Core/Types.mqh"
#include "../Utils/ZigZag.mqh"

class CSwingEngine
{
private:

   CZigZag *m_zigzag;

public:

   //----------------------------------------------------------
   // Constructor
   //----------------------------------------------------------
   CSwingEngine(CZigZag &zigzag)
   {
      m_zigzag = &zigzag;
   }

   //----------------------------------------------------------
   // Get swing at a specific bar
   //----------------------------------------------------------
   bool GetSwing(int shift, SwingPoint &swing)
   {
      swing.IsValid = false;

      if(!m_zigzag.IsSwing(shift))
         return(false);

      swing.IsValid = true;
      swing.Time = Time[shift];
      swing.Price = m_zigzag.SwingPrice(shift);

      if(m_zigzag.IsSwingHigh(shift))
         swing.Type = SWING_HIGH;
      else
         swing.Type = SWING_LOW;

      swing.Strength = 1;
      swing.ATRDistance = 0.0;

      return(true);
   }

   //----------------------------------------------------------
   // Find previous swing
   //----------------------------------------------------------
   bool PreviousSwing(int startShift,
                      SwingPoint &swing)
   {
      for(int i = startShift; i < Bars; i++)
      {
         if(GetSwing(i, swing))
            return(true);
      }

      return(false);
   }

};

#endif