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
#include <Utils/Fibonacci.mqh>
#include <Config/Inputs.mqh>
#include <Core/Logger.mqh>
#include <Trade/RiskManager.mqh>
#include <Market/SwingEngine.mqh>
#include <Market/SwingFilter.mqh>
#include <Market/TrendEngine.mqh>
#include <Core/Version.mqh>
#include <Utils/ZigZag.mqh>

CATR ATR;
CFibonacci Fibonacci;
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

   Logger.Info("HH: " + IntegerToString(trend.HH));
   Logger.Info("HL: " + IntegerToString(trend.HL));
   Logger.Info("LH: " + IntegerToString(trend.LH));
   Logger.Info("LL: " + IntegerToString(trend.LL));

   Logger.Info("Strength: "
      + DoubleToString(trend.Strength, 2));

   Logger.Separator();
   Logger.Info("Trend Structure Test");

   SwingPoint swings[4];

   if(SwingEngine.GetLastSwings(swings, 4))
   {
      for(int i=0; i<4; i++)
      {
         string type =
            swings[i].Type == SWING_HIGH
            ? "HIGH"
            : "LOW";

         Logger.Info(
            "Swing "
            + IntegerToString(i + 1)
            + " "
            + type
            + " "
            + DoubleToString(
               swings[i].Price,
               Digits));
      }
   }

   Logger.Separator();
   Logger.Info("Range Test");

   if(TrendEngine.IsRange())
      Logger.Info("Market State : RANGE");
   else
      Logger.Info("Market State : TREND");

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

   Logger.Separator();
   Logger.Info("Latest Swing High Test");

   SwingPoint lastHigh;

   if(SwingEngine.GetLastSwingHigh(lastHigh))
   {
      Logger.Info("Latest High Price: "
         + DoubleToString(lastHigh.Price, Digits));

      Logger.Info("Time: "
         + TimeToString(lastHigh.Time));
   }
   else
   {
   Logger.Warning("No swing high found.");
   }

   Logger.Separator();
   Logger.Info("Latest Swing Low Test");

   SwingPoint lastLow;

   if(SwingEngine.GetLastSwingLow(lastLow))
   {
      Logger.Info("Latest Low Price: "
         + DoubleToString(lastLow.Price, Digits));

      Logger.Info("Time: "
         + TimeToString(lastLow.Time));
   }
   else
   {
      Logger.Warning("No swing low found.");
   }

   Logger.Separator();
   Logger.Info("Last 4 Swings Test");

   if(SwingEngine.GetLastSwings(swings, 4))
   {
      for(int i = 0; i < 4; i++)
      {
         string type =
            (swings[i].Type == SWING_HIGH)
            ? "HIGH"
            : "LOW";

         Logger.Info(
            IntegerToString(i + 1)
            + ": "
            + type
            + " "
            + DoubleToString(swings[i].Price, Digits));
      }
   }
   else
   {
      Logger.Warning("Less than 4 swings found.");
   }

   Logger.Separator();
   Logger.Info("Previous Swing Test");

   SwingPoint latest;
   SwingPoint previous;

   if(SwingEngine.GetLastSwingHigh(latest))
   {
      if(SwingEngine.GetPreviousSwing(latest, previous))
      {
         Logger.Info("Latest : "
            + DoubleToString(latest.Price, Digits));

         Logger.Info("Previous : "
            + DoubleToString(previous.Price, Digits));
      }
      else
      {
         Logger.Warning("No previous swing found.");
      }
   }
   else
   {
      Logger.Warning("No latest swing found.");
   }

   Logger.Separator();
   Logger.Info("Fibonacci Test");

   SwingPoint fibHigh;
   SwingPoint fibLow;

   FibData fibData;

   if(SwingEngine.GetLastSwingHigh(fibHigh) &&
   SwingEngine.GetLastSwingLow(fibLow))
   {
      if(Fibonacci.Calculate(
         fibHigh.Price,
         fibLow.Price,
         fibData))
      {
         Logger.Info("High : " +
            DoubleToString(fibData.High, Digits));

         Logger.Info("Low : " +
            DoubleToString(fibData.Low, Digits));

         Logger.Info("38.2 : " +
            DoubleToString(fibData.Fib382, Digits));

         Logger.Info("50.0 : " +
            DoubleToString(fibData.Fib500, Digits));

         Logger.Info("61.8 : " +
            DoubleToString(fibData.Fib618, Digits));
      }
      else
      {
         Logger.Warning("Unable to calculate Fibonacci.");
      }
   }
   else
   {
      Logger.Warning("Not enough swings.");
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