#ifndef ZIGZAG_MQH
#define ZIGZAG_MQH

class CZigZag
{
private:

   int m_depth;
   int m_deviation;
   int m_backstep;

public:

   //----------------------------------------------------------
   // Constructor
   //----------------------------------------------------------
   CZigZag(int depth = 12,
           int deviation = 5,
           int backstep = 3)
   {
      m_depth = depth;
      m_deviation = deviation;
      m_backstep = backstep;
   }

   //----------------------------------------------------------
   // Returns ZigZag value
   //----------------------------------------------------------
   double Value(int shift)
   {
      return iCustom(
         Symbol(),
         Period(),
         "ZigZag",
         m_depth,
         m_deviation,
         m_backstep,
         0,
         shift
      );
   }

   //----------------------------------------------------------
   // Is there a swing on this candle?
   //----------------------------------------------------------
   bool IsSwing(int shift)
   {
      return(Value(shift) != 0.0);
   }

   //----------------------------------------------------------
   // Swing Price
   //----------------------------------------------------------
   double SwingPrice(int shift)
   {
      return(Value(shift));
   }

   //----------------------------------------------------------
   // Highest point?
   //----------------------------------------------------------
   bool IsSwingHigh(int shift)
   {
      if(!IsSwing(shift))
         return(false);

      return(High[shift] == Value(shift));
   }

   //----------------------------------------------------------
   // Lowest point?
   //----------------------------------------------------------
   bool IsSwingLow(int shift)
   {
      if(!IsSwing(shift))
         return(false);

      return(Low[shift] == Value(shift));
   }

};

#endif