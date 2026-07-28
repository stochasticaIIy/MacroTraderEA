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

   //----------------------------------------------------------
   // Get latest confirmed Swing High
   //----------------------------------------------------------
   bool GetLastSwingHigh(SwingPoint &swing)
   {
      for(int i = 1; i < Bars; i++)
      {
         SwingPoint current;

         if(!GetSwing(i, current))
            continue;

         if(current.Type == SWING_HIGH)
         {
            swing = current;
            return(true);
         }
      }

      return(false);
   }

   //----------------------------------------------------------
   // Get latest confirmed Swing Low
   //----------------------------------------------------------
   bool GetLastSwingLow(SwingPoint &swing)
   {
      for(int i = 1; i < Bars; i++)
      {
         SwingPoint current;

         if(!GetSwing(i, current))
            continue;

         if(current.Type == SWING_LOW)
         {
            swing = current;
            return(true);
         }
      }

      return(false);
   }

   //----------------------------------------------------------
   // Get the last N confirmed swings
   //----------------------------------------------------------
   bool GetLastSwings(SwingPoint &swings[], int count)
   {
      int found = 0;

      for(int i = 1; i < Bars && found < count; i++)
      {
         SwingPoint current;

         if(!GetSwing(i, current))
            continue;

         swings[found] = current;
         found++;
      }

      return(found == count);
   }

   //----------------------------------------------------------
   // Get the swing immediately preceding another swing
   //----------------------------------------------------------
   bool GetPreviousSwing(const SwingPoint &current,
                        SwingPoint &previous)
   {
      bool foundCurrent = false;

      for(int i = 1; i < Bars; i++)
      {
         SwingPoint s;

         if(!GetSwing(i, s))
            continue;

         if(!foundCurrent)
         {
            if(s.Time == current.Time)
               foundCurrent = true;

            continue;
         }

         previous = s;
         return(true);
      }

      return(false);
   }

};

#endif