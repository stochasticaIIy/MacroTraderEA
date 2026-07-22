//+------------------------------------------------------------------+
//| Macro Trader EA                                                  |
//| Version 0.1.0-alpha                                              |
//+------------------------------------------------------------------+
#property strict
#property version "0.10"
#property description "Macro Trader EA"

#include <Config/Config.mqh>
#include <Core/Constants.mqh>
#include <Config/Inputs.mqh>
#include <Core/Version.mqh>
#include <Core/Logger.mqh>
#include <Trade/RiskManager.mqh>
#include <Utils/ATR.mqh>

CLogger  Logger;
CVersion EA_Version;
CConfig Config;
CRiskManager RiskManager;
CATR ATR;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   Config.Load();
   double atr = ATR.Current(ATRPeriod);

Logger.Info("ATR: " + DoubleToString(atr, Digits));

Logger.Info("SL Distance: " +
            DoubleToString(
               ATR.StopLossDistance(
                  ATRPeriod,
                  StopLossATR),
               Digits));

Logger.Info("TP Distance: " +
            DoubleToString(
               ATR.TakeProfitDistance(
                  ATRPeriod,
                  TakeProfitATR),
               Digits));
               
   Logger.Separator();
   Logger.Info(EA_Version.FullVersion());
   Logger.Info("Risk Per Trade: " + DoubleToString(Config.RiskPercent(), 2) + "%");
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