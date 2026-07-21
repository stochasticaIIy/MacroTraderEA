//--------------------------------------------------------------
// Macro Trader EA
//--------------------------------------------------------------
// File: Version.mqh
//--------------------------------------------------------------

#ifndef VERSION_MQH
#define VERSION_MQH


#include "Constants.mqh"

class CVersion
{
public:

   string Name()
   {
      return EA_NAME;
   }

   string Version()
   {
      return IntegerToString(EA_VERSION_MAJOR)
            + "."
            + IntegerToString(EA_VERSION_MINOR)
            + "."
            + IntegerToString(EA_VERSION_PATCH);
   }

   string FullVersion()
   {
      return Name() + " v" + Version();
   }
};

#endif