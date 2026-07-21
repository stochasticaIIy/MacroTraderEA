//+------------------------------------------------------------------+
//| Macro Trader EA                                                  |
//| Version 0.1.0-alpha                                              |
//+------------------------------------------------------------------+
#property strict
#property version "0.10"
#property description "Macro Trader EA"

#include <Core/Constants.mqh>
#include <Core/Version.mqh>
#include <Core/Logger.mqh>

CLogger  Logger;
CVersion EA_Version;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   Logger.Separator();
   Logger.Info(EA_Version.FullVersion());
   Logger.Info("Initialization started...");
   Logger.Info("Initialization completed successfully.");
   Logger.Separator();

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Logger.Separator();
   Logger.Info("EA stopped.");
   Logger.Separator();
}

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick()
{
   // Trading logic will be added here.
}