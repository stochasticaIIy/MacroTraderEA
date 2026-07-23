//+------------------------------------------------------------------+
//| Macro Trader EA                                                  |
//| Version 0.1.0-alpha                                              |
//+------------------------------------------------------------------+
#property strict
#property version "0.10"
#property description "Macro Trader EA"

#include <Utils/ATR.mqh>
#include <Config/Config.mqh>
#include <Core/Constants.mqh>
#include <Config/Inputs.mqh>
#include <Core/Logger.mqh>
#include <Trade/RiskManager.mqh>
#include <Market/SwingEngine.mqh>
#include <Market/SwingFilter.mqh>
#include <Market/TrendEngine.mqh>
#include <Core/Version.mqh>
#include <Utils/ZigZag.mqh>

CATR ATR;
CLogger  Logger;
CVersion EA_Version;
CConfig Config;
CRiskManager RiskManager;
CSwingFilter SwingFilter(ATR);
CZigZag ZigZag(
    ZigZagDepth,
    ZigZagDeviation,
    ZigZagBackstep);
    CSwingEngine SwingEngine(ZigZag);
CTrendEngine TrendEngine(SwingEngine);

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   Config.Load();

   double atr = ATR.Current(ATRPeriod);

   double slDistance = ATR.StopLossDistance(
                           ATRPeriod,
                           StopLossATR);

   double lot = RiskManager.CalculateLotSize(
                  Config.RiskPercent(),
                  slDistance);

   Logger.Info("ATR: " + DoubleToString(atr, Digits));

   Logger.Info("SL Distance: " +
               DoubleToString(slDistance, Digits));

   Logger.Info("Lot Size: " +
               DoubleToString(lot,2));
               
   Logger.Separator();
   Logger.Info(EA_Version.FullVersion());
   Logger.Info("Risk Per Trade: " + DoubleToString(Config.RiskPercent(), 2) + "%");
   Logger.Info("Initialization started...");
   Logger.Info("Initialization completed successfully.");
   Logger.Separator();

      Logger.Separator();
   Logger.Info("Testing Swing Engine");

   SwingPoint swing;

   if(SwingEngine.PreviousSwing(1, swing))
   {
      Logger.Info("Time: " + TimeToString(swing.Time));

      Logger.Info("Price: " +
         DoubleToString(swing.Price, Digits));

      if(swing.Type == SWING_HIGH)
         Logger.Info("Type: HIGH");
      else
         Logger.Info("Type: LOW");
   }
   else
   {
      Logger.Warning("No swing found.");
   }
   
   Logger.Separator();
   Logger.Info("Recent ZigZag Swings");

   for(int i=1; i<=50; i++)
   {
      if(ZigZag.IsSwing(i))
      {
         Logger.Info(
            "Bar "
            + IntegerToString(i)
            + " Price="
            + DoubleToString(
               ZigZag.SwingPrice(i),
               Digits));
      }
   }

   Logger.Separator();
   Logger.Info("Trend Engine");

   TrendInfo trend;

   if(TrendEngine.Analyze(trend))
   {
      switch(trend.Trend)
      {
         case TREND_UP:
            Logger.Info("Trend: UP");
            break;

         case TREND_DOWN:
            Logger.Info("Trend: DOWN");
            break;

         case TREND_RANGE:
            Logger.Info("Trend: RANGE");
            break;

         default:
            Logger.Info("Trend: UNKNOWN");
            break;
      }
   }
   else
   {
      Logger.Warning("Unable to determine trend.");
   }

   SwingPoint s1;
   SwingPoint s2;

   if(SwingEngine.PreviousSwing(1, s1) &&
      SwingEngine.PreviousSwing(10, s2))
   {
      bool significant =
         SwingFilter.IsSignificant(
            s1.Price,
            s2.Price);

      Logger.Info("Swing Filter: " +
         string(significant ? "PASS" : "FAIL"));
   }
   else
   {
      Logger.Warning("Unable to test Swing Filter.");
   }

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