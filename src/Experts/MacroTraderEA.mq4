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
#include <Market/EntryEngine.mqh>
#include <Utils/Fibonacci.mqh>
#include <Market/FibonacciEngine.mqh>
#include <Market/FirstPullback.mqh>
#include <Config/Inputs.mqh>
#include <Core/Logger.mqh>
#include <Market/PatternEngine.mqh>
#include <Utils/PullbackEngine.mqh>
#include <Trade/RiskManager.mqh>
#include <Core/SetupEngine.mqh>
#include <Market/SupportResistance.mqh>
#include <Market/SwingEngine.mqh>
#include <Market/SwingFilter.mqh>
#include <Trade/TradeLevels.mqh>
#include <Market/TrendEngine.mqh>
#include <Core/Version.mqh>
#include <Utils/ZigZag.mqh>

CATR ATR;
CEntryEngine EntryEngine;
CFibonacci Fibonacci;
CFirstPullback FirstPullback;
CLogger  Logger;
CPatternEngine PatternEngine;
CPullbackEngine PullbackEngine;
CSetupEngine SetupEngine;
CSupportResistance SupportResistance;
CVersion EA_Version;
CConfig Config;
CRiskManager RiskManager;
CSwingFilter SwingFilter(ATR);
CTradeLevels TradeLevels;
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

   SwingPoint fibHigh;
   SwingPoint fibLow;

   FibData fibData;

   //----------------------------------------------------------
   // Fibonacci Test - Active Impulse
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Active Impulse Fibonacci Test");

   TrendInfo activeTrend;

   if(!TrendEngine.Analyze(activeTrend))
   {
      Logger.Warning("Unable to determine market trend.");
   }
   else
   if(activeTrend.Trend == TREND_RANGE)
   {
      Logger.Info("Active Impulse Fibonacci Test skipped: Market is RANGE.");
   }
   else
   if(activeTrend.Trend == TREND_UNKNOWN)
   {
      Logger.Info("Active Impulse Fibonacci Test skipped: Trend is UNKNOWN.");
   }
   else
   {
      SwingPoint impulseStart;
      SwingPoint impulseEnd;
      FibData activeFib;

      if(TrendEngine.GetActiveImpulse(impulseStart, impulseEnd))
      {
         Logger.Info("Impulse Start: "
            + DoubleToString(impulseStart.Price, Digits));

         Logger.Info("Impulse End: "
            + DoubleToString(impulseEnd.Price, Digits));

         bool fibCalculated = false;

         if(impulseStart.Type == SWING_LOW &&
            impulseEnd.Type == SWING_HIGH)
         {
            // Uptrend:
            // LOW -> HIGH

            fibCalculated = Fibonacci.Calculate(
               impulseEnd.Price,
               impulseStart.Price,
               activeFib);
         }
         else
         if(impulseStart.Type == SWING_HIGH &&
            impulseEnd.Type == SWING_LOW)
         {
            // Downtrend:
            // HIGH -> LOW

            fibCalculated = Fibonacci.Calculate(
               impulseStart.Price,
               impulseEnd.Price,
               activeFib);
         }

         if(fibCalculated)
         {
            Logger.Info("Fibonacci High: "
               + DoubleToString(activeFib.High, Digits));

            Logger.Info("Fibonacci Low: "
               + DoubleToString(activeFib.Low, Digits));

            Logger.Info("38.2: "
               + DoubleToString(activeFib.Fib382, Digits));

            Logger.Info("50.0: "
               + DoubleToString(activeFib.Fib500, Digits));

            Logger.Info("61.8: "
               + DoubleToString(activeFib.Fib618, Digits));
         }
         else
         {
            Logger.Warning(
               "Unable to calculate Fibonacci.");
         }
      }
      else
      {
         Logger.Warning(
            "Unable to determine active impulse.");
      }
   }

   //----------------------------------------------------------
   // First Pullback Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("First Pullback Test");

   TrendInfo pullbackTrend;

   if(!TrendEngine.Analyze(pullbackTrend))
   {
      Logger.Warning(
         "Unable to determine trend for pullback.");
   }
   else
   if(pullbackTrend.Trend == TREND_RANGE ||
      pullbackTrend.Trend == TREND_UNKNOWN)
   {
      Logger.Info(
         "Pullback Test skipped: Market is not trending.");
   }
   else
   {
      SwingPoint pullbackStart;
      SwingPoint pullbackEnd;
      FibData pullbackFib;

      if(!TrendEngine.GetActiveImpulse(
            pullbackStart,
            pullbackEnd))
      {
         Logger.Warning(
            "Unable to determine active impulse for pullback.");
      }
      else
      {
         bool fibReady = false;

         if(pullbackStart.Type == SWING_LOW &&
            pullbackEnd.Type == SWING_HIGH)
         {
            fibReady = Fibonacci.Calculate(
               pullbackEnd.Price,
               pullbackStart.Price,
               pullbackFib);
         }
         else
         if(pullbackStart.Type == SWING_HIGH &&
            pullbackEnd.Type == SWING_LOW)
         {
            fibReady = Fibonacci.Calculate(
               pullbackStart.Price,
               pullbackEnd.Price,
               pullbackFib);
         }

         if(!fibReady)
         {
            Logger.Warning(
               "Unable to calculate pullback Fibonacci.");
         }
         else
         {
            bool firstPullback =
               PullbackEngine.FirstPullbackReached(
                  pullbackTrend.Trend,
                  pullbackFib.High,
                  pullbackFib.Low,
                  pullbackEnd.Time);

            Logger.Info(
               "Impulse End: "
               + TimeToString(
                  pullbackEnd.Time));

            Logger.Info(
               "38.2 Level: "
               + DoubleToString(
                  pullbackFib.Fib382,
                  Digits));

            if(firstPullback)
            {
               Logger.Info(
                  "First Pullback: REACHED");
            }
            else
            {
               Logger.Info(
                  "First Pullback: NOT REACHED");
            }
         }
      }
   }

   //----------------------------------------------------------
// Support / Resistance Test
//----------------------------------------------------------
Logger.Separator();
Logger.Info("Support / Resistance Test");

double currentPrice = Close[1];

// Use half an ATR as the initial zone tolerance.
double srTolerance =
   ATR.Current(ATRPeriod) * 0.5;

Logger.Info(
   "Current Price: "
   + DoubleToString(
      currentPrice,
      Digits));

Logger.Info(
   "S/R Tolerance: "
   + DoubleToString(
      srTolerance,
      Digits));

//----------------------------------------------------------
// Support
//----------------------------------------------------------
SRZone supportZone;

if(SupportResistance.FindSupport(
      currentPrice,
      srTolerance,
      supportZone))
{
   Logger.Info("Support Found");

   Logger.Info(
      "Support Lower: "
      + DoubleToString(
         supportZone.Lower,
         Digits));

   Logger.Info(
      "Support Upper: "
      + DoubleToString(
         supportZone.Upper,
         Digits));
}
else
{
   Logger.Info("No Support Found");
}

   //----------------------------------------------------------
   // Resistance
   //----------------------------------------------------------
   SRZone resistanceZone;

   if(SupportResistance.FindResistance(
         currentPrice,
         srTolerance,
         resistanceZone))
   {
      Logger.Info("Resistance Found");

      Logger.Info(
         "Resistance Lower: "
         + DoubleToString(
            resistanceZone.Lower,
            Digits));

      Logger.Info(
         "Resistance Upper: "
         + DoubleToString(
            resistanceZone.Upper,
            Digits));
   }
   else
   {
      Logger.Info("No Resistance Found");
   }

   //----------------------------------------------------------
   // S/R Significance Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("S/R Significance Test");

   if(supportZone.IsValid)
   {
      double supportPrice =
         (supportZone.Lower +
         supportZone.Upper) / 2.0;

      int supportTouches =
         SupportResistance.CountTouches(
            supportPrice,
            srTolerance);

      double supportStrength =
         SupportResistance.CalculateStrength(
            supportTouches);

      bool supportSignificant =
         SupportResistance.IsSignificant(
            supportTouches);

      Logger.Info(
         "Support Touches: "
         + IntegerToString(
            supportTouches));

      Logger.Info(
         "Support Strength: "
         + DoubleToString(
            supportStrength,
            2));

      Logger.Info(
         "Support Significant: "
         + string(
            supportSignificant
            ? "YES"
            : "NO"));
   }
   else
   {
      Logger.Info("No valid support zone.");
   }

   if(resistanceZone.IsValid)
   {
      double resistancePrice =
         (resistanceZone.Lower +
         resistanceZone.Upper) / 2.0;

      int resistanceTouches =
         SupportResistance.CountTouches(
            resistancePrice,
            srTolerance);

      double resistanceStrength =
         SupportResistance.CalculateStrength(
            resistanceTouches);

      bool resistanceSignificant =
         SupportResistance.IsSignificant(
            resistanceTouches);

      Logger.Info(
         "Resistance Touches: "
         + IntegerToString(
            resistanceTouches));

      Logger.Info(
         "Resistance Strength: "
         + DoubleToString(
            resistanceStrength,
            2));

      Logger.Info(
         "Resistance Significant: "
         + string(
            resistanceSignificant
            ? "YES"
            : "NO"));
   }
   else
   {
      Logger.Info("No valid resistance zone.");
   }

   //----------------------------------------------------------
   // Break & Retest Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Break & Retest Test");

   TrendInfo patternTrend;

   if(!TrendEngine.Analyze(patternTrend))
   {
      Logger.Warning(
         "Unable to determine trend for pattern test.");
   }
   else
   if(patternTrend.Trend == TREND_UP ||
      patternTrend.Trend == TREND_DOWN)
   {
      double patternLevel = 0.0;

      if(patternTrend.Trend == TREND_UP &&
         resistanceZone.IsValid)
      {
         patternLevel =
            (resistanceZone.Lower +
            resistanceZone.Upper) / 2.0;
      }
      else
      if(patternTrend.Trend == TREND_DOWN &&
         supportZone.IsValid)
      {
         patternLevel =
            (supportZone.Lower +
            supportZone.Upper) / 2.0;
      }

      if(patternLevel > 0.0)
      {
         bool breakRetest =
            PatternEngine.IsBreakRetest(
               patternLevel,
               patternTrend.Trend,
               100);

         Logger.Info(
            "Pattern Level: "
            + DoubleToString(
               patternLevel,
               Digits));

         if(breakRetest)
         {
            Logger.Info(
               "Break & Retest: DETECTED");
         }
         else
         {
            Logger.Info(
               "Break & Retest: NOT DETECTED");
         }
      }
      else
      {
         Logger.Info(
            "No suitable S/R level for pattern test.");
      }
   }
   else
   {
      Logger.Info(
         "Pattern test skipped: Market is not trending.");
   }

   //----------------------------------------------------------
   // W / M Pattern Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("W / M Pattern Test");

   double patternTolerance =
      ATR.Current(ATRPeriod) * 0.5;

   bool wPattern =
      PatternEngine.IsWPattern(
         patternTolerance);

   bool mPattern =
      PatternEngine.IsMPattern(
         patternTolerance);

   Logger.Info(
      "Pattern Tolerance: "
      + DoubleToString(
         patternTolerance,
         Digits));

   if(wPattern)
   {
      Logger.Info("W Pattern: DETECTED");
   }
   else
   {
      Logger.Info("W Pattern: NOT DETECTED");
   }

   if(mPattern)
   {
      Logger.Info("M Pattern: DETECTED");
   }
   else
   {
      Logger.Info("M Pattern: NOT DETECTED");
   }

   //----------------------------------------------------------
   // Head & Shoulders Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Head & Shoulders Test");

   double hsTolerance =
      ATR.Current(ATRPeriod) * 0.5;

   bool headShoulders =
      PatternEngine.IsHeadAndShoulders(
         hsTolerance);

   bool inverseHeadShoulders =
      PatternEngine.IsInverseHeadAndShoulders(
         hsTolerance);

   Logger.Info(
      "Shoulder Tolerance: "
      + DoubleToString(
         hsTolerance,
         Digits));

   if(headShoulders)
   {
      Logger.Info(
         "Head & Shoulders: DETECTED");
   }
   else
   {
      Logger.Info(
         "Head & Shoulders: NOT DETECTED");
   }

   if(inverseHeadShoulders)
   {
      Logger.Info(
         "Inverse Head & Shoulders: DETECTED");
   }
   else
   {
      Logger.Info(
         "Inverse Head & Shoulders: NOT DETECTED");
   }

   //----------------------------------------------------------
   // Fair Value Gap Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Fair Value Gap Test");

   bool bullishFVG =
      PatternEngine.IsBullishFVG(1);

   bool bearishFVG =
      PatternEngine.IsBearishFVG(1);

   if(bullishFVG)
   {
      double bullishLower;
      double bullishUpper;

      if(PatternEngine.GetBullishFVG(
            1,
            bullishLower,
            bullishUpper))
      {
         Logger.Info(
            "Bullish FVG: DETECTED");

         Logger.Info(
            "Bullish FVG Lower: "
            + DoubleToString(
               bullishLower,
               Digits));

         Logger.Info(
            "Bullish FVG Upper: "
            + DoubleToString(
               bullishUpper,
               Digits));
      }
   }
   else
   {
      Logger.Info(
         "Bullish FVG: NOT DETECTED");
   }

   if(bearishFVG)
   {
      double bearishLower;
      double bearishUpper;

      if(PatternEngine.GetBearishFVG(
            1,
            bearishLower,
            bearishUpper))
      {
         Logger.Info(
            "Bearish FVG: DETECTED");

         Logger.Info(
            "Bearish FVG Lower: "
            + DoubleToString(
               bearishLower,
               Digits));

         Logger.Info(
            "Bearish FVG Upper: "
            + DoubleToString(
               bearishUpper,
               Digits));
      }
   }
   else
   {
      Logger.Info(
         "Bearish FVG: NOT DETECTED");
   }

   //----------------------------------------------------------
   // Unified Pattern Analysis Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Unified Pattern Analysis Test");

   PatternData detectedPattern;

   if(PatternEngine.Analyze(detectedPattern))
   {
      if(detectedPattern.IsValid)
      {
         Logger.Info(
            "Pattern Detected");

         Logger.Info(
            "Pattern Score: "
            + DoubleToString(
               detectedPattern.Score,
               2));

         Logger.Info(
            "Detection Time: "
            + TimeToString(
               detectedPattern.DetectionTime));

         switch(detectedPattern.Pattern)
         {
            case PATTERN_W:
               Logger.Info("Pattern Type: W");
               break;

            case PATTERN_M:
               Logger.Info("Pattern Type: M");
               break;

            case PATTERN_HEAD_SHOULDERS:
               Logger.Info(
                  "Pattern Type: HEAD & SHOULDERS");
               break;

            case PATTERN_INVERSE_HEAD_SHOULDERS:
               Logger.Info(
                  "Pattern Type: INVERSE HEAD & SHOULDERS");
               break;

            case PATTERN_FVG:
               Logger.Info("Pattern Type: FVG");
               break;

            default:
               Logger.Info("Pattern Type: UNKNOWN");
               break;
         }
      }
      else
      {
         Logger.Info("No pattern detected.");
      }
   }
   else
   {
      Logger.Warning(
         "Pattern analysis failed.");
   }

   //----------------------------------------------------------
   // Preliminary Trade Setup Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Preliminary Trade Setup Test");

   TrendInfo setupTrend;
   FibData setupFib;
   PatternData setupPattern;
   SRZone setupZone;
   TradeSetup setup;

   //----------------------------------------------------------
   // Initialize setup
   //----------------------------------------------------------
   setup.IsValid = false;
   setup.Direction = DIRECTION_NONE;
   setupFib.IsValid = false;
   setupPattern.IsValid = false;
   setupZone.IsValid = false;

   setup.Pullback.IsValid = false;

   //----------------------------------------------------------
   // Get trend
   //----------------------------------------------------------
   bool setupTrendValid =
      TrendEngine.Analyze(setupTrend);

   //----------------------------------------------------------
   // Get active impulse / Fibonacci
   //----------------------------------------------------------
   SwingPoint setupImpulseStart;
   SwingPoint setupImpulseEnd;

   if(TrendEngine.GetActiveImpulse(
         setupImpulseStart,
         setupImpulseEnd))
   {
      if(setupImpulseStart.Type == SWING_LOW &&
         setupImpulseEnd.Type == SWING_HIGH)
      {
         Fibonacci.Calculate(
            setupImpulseEnd.Price,
            setupImpulseStart.Price,
            setupFib);
      }
      else
      if(setupImpulseStart.Type == SWING_HIGH &&
         setupImpulseEnd.Type == SWING_LOW)
      {
         Fibonacci.Calculate(
            setupImpulseStart.Price,
            setupImpulseEnd.Price,
            setupFib);
      }
   }

   //----------------------------------------------------------
   // First Pullback
   //----------------------------------------------------------
   PullbackInfo setupPullback;

   setupPullback.IsValid = false;

   if(setupFib.IsValid)
   {
      if(setupImpulseStart.Type == SWING_LOW &&
         setupImpulseEnd.Type == SWING_HIGH)
      {
         FirstPullback.CheckUptrend(
            setupFib.Fib382,
            1,
            setupPullback);
      }
      else
      if(setupImpulseStart.Type == SWING_HIGH &&
         setupImpulseEnd.Type == SWING_LOW)
      {
         FirstPullback.CheckDowntrend(
            setupFib.Fib382,
            1,
            setupPullback);
      }
   }

   //----------------------------------------------------------
   // IMPORTANT:
   // Copy the detected pullback into the TradeSetup
   //----------------------------------------------------------
   setup.Pullback = setupPullback;

   //----------------------------------------------------------
   // Get pattern
   //----------------------------------------------------------
   PatternEngine.Analyze(setupPattern);

   //----------------------------------------------------------
   // Get S/R
   //----------------------------------------------------------
   if(supportZone.IsValid)
   {
      setupZone = supportZone;
   }
   else
   if(resistanceZone.IsValid)
   {
      setupZone = resistanceZone;
   }

   //----------------------------------------------------------
   // Build preliminary setup
   //----------------------------------------------------------
   if(setupTrendValid)
   {
      if(SetupEngine.Analyze(
            setupTrend,
            setupFib,
            setupPattern,
            setupZone,
            setup))
      {
         if(setup.IsValid)
         {
            Logger.Info("Setup: VALID");

            if(setup.Direction == DIRECTION_BUY)
               Logger.Info("Direction: BUY");
            else
            if(setup.Direction == DIRECTION_SELL)
               Logger.Info("Direction: SELL");

            Logger.Info(
               "Confidence: "
               + DoubleToString(
                  setup.Confidence,
                  2));

            Logger.Info(
               "Strategy Health: "
               + DoubleToString(
                  setup.StrategyHealth,
                  2));
         }
         else
         {
            Logger.Info("Setup: NOT VALID");

            switch(setup.Rejection)
            {
               case SETUP_INVALID_TREND:
                  Logger.Info("Rejection: INVALID TREND");
                  break;

               case SETUP_RANGE:
                  Logger.Info("Rejection: MARKET RANGE");
                  break;

               case SETUP_NO_FIBONACCI:
                  Logger.Info("Rejection: NO FIBONACCI");
                  break;

               case SETUP_NO_PULLBACK:
                  Logger.Info("Rejection: NO FIRST PULLBACK");
                  break;

               case SETUP_NO_PATTERN:
                  Logger.Info("Rejection: NO PATTERN");
                  break;

               case SETUP_NO_SR_ZONE:
                  Logger.Info("Rejection: NO S/R ZONE");
                  break;

               case SETUP_SR_NOT_SIGNIFICANT:
                  Logger.Info("Rejection: S/R NOT SIGNIFICANT");
                  break;

               default:
                  Logger.Info("Rejection: NONE");
                  break;
            }
         }
      }
      else
      {
         Logger.Warning(
            "Setup analysis failed.");
      }
   }
   else
   {
      Logger.Warning(
         "Unable to determine trend for setup.");
   }

   //----------------------------------------------------------
   // Position Sizing Test
   //----------------------------------------------------------
   Logger.Separator();
   Logger.Info("Position Sizing Test");

   if(!setup.IsValid)
   {
      Logger.Info(
         "Position Sizing skipped: Setup is not valid.");
   }
   else
   if(setup.Entry <= 0.0)
   {
      Logger.Warning(
         "Position Sizing skipped: Entry is invalid.");
   }
   else
   if(setup.StopLoss <= 0.0)
   {
      Logger.Warning(
         "Position Sizing skipped: Stop Loss is invalid.");
   }
   else
   {
      double actualSLDistance =
         TradeLevels.StopLossDistance(setup);

      if(actualSLDistance > 0.0)
      {
         double calculatedLot =
            RiskManager.CalculateLotSize(
               Config.RiskPercent(),
               actualSLDistance);

         Logger.Info(
            "Risk Percent: "
            + DoubleToString(
               Config.RiskPercent(),
               2)
            + "%");

         Logger.Info(
            "Entry: "
            + DoubleToString(
               setup.Entry,
               Digits));

         Logger.Info(
            "Stop Loss: "
            + DoubleToString(
               setup.StopLoss,
               Digits));

         Logger.Info(
            "SL Distance: "
            + DoubleToString(
               actualSLDistance,
               Digits));

         Logger.Info(
            "Calculated Lot Size: "
            + DoubleToString(
               calculatedLot,
               2));
      }
      else
      {
         Logger.Warning(
            "Unable to determine SL distance.");
      }
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