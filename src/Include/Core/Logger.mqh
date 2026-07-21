//--------------------------------------------------------------
// Macro Trader EA
//--------------------------------------------------------------
// File: Logger.mqh
//--------------------------------------------------------------

#ifndef LOGGER_MQH
#define LOGGER_MQH

#include "Types.mqh"

class CLogger
{
public:

   void Info(string message)
   {
      Print("[INFO] ", message);
   }

   void Warning(string message)
   {
      Print("[WARNING] ", message);
   }

   void Error(string message)
   {
      Print("[ERROR] ", message);
   }

   void Debug(string message)
   {
#ifdef DEBUG
      Print("[DEBUG] ", message);
#endif
   }

   void Separator()
   {
      Print("------------------------------------------------");
   }
};

#endif