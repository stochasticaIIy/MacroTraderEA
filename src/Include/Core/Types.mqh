//--------------------------------------------------------------
// Macro Trader EA
//--------------------------------------------------------------
// File: Types.mqh
// Module: Core
// Version: v0.1.0-alpha
//--------------------------------------------------------------

#pragma once

//==============================================================
// ENUMERATIONS
//==============================================================

//--------------------------------------------------------------
// Logging
//--------------------------------------------------------------
enum ENUM_LOG_LEVEL
{
   LOG_INFO = 0,
   LOG_WARNING,
   LOG_ERROR,
   LOG_DEBUG
};

//--------------------------------------------------------------
// Market Trend
//--------------------------------------------------------------
enum ENUM_TREND
{
   TREND_UNKNOWN = 0,
   TREND_UP,
   TREND_DOWN,
   TREND_RANGE
};

//--------------------------------------------------------------
// Market State
//--------------------------------------------------------------
enum ENUM_MARKET_STATE
{
   MARKET_UNKNOWN = 0,
   MARKET_TRENDING,
   MARKET_RANGING
};

//--------------------------------------------------------------
// Swing Type
//--------------------------------------------------------------
enum ENUM_SWING_TYPE
{
   SWING_NONE = 0,
   SWING_HIGH,
   SWING_LOW
};

//--------------------------------------------------------------
// Support / Resistance
//--------------------------------------------------------------
enum ENUM_ZONE_TYPE
{
   ZONE_SUPPORT = 0,
   ZONE_RESISTANCE
};

//--------------------------------------------------------------
// Trade Direction
//--------------------------------------------------------------
enum ENUM_TRADE_DIRECTION
{
   DIRECTION_NONE = 0,
   DIRECTION_BUY,
   DIRECTION_SELL
};

//--------------------------------------------------------------
// Trade Status
//--------------------------------------------------------------
enum ENUM_TRADE_STATUS
{
   TRADE_PENDING = 0,
   TRADE_OPEN,
   TRADE_CLOSED,
   TRADE_CANCELLED
};

//--------------------------------------------------------------
// Macro Bias
//--------------------------------------------------------------
enum ENUM_MACRO_BIAS
{
   MACRO_UNKNOWN = 0,
   MACRO_STRONG_BEARISH,
   MACRO_BEARISH,
   MACRO_NEUTRAL,
   MACRO_BULLISH,
   MACRO_STRONG_BULLISH
};

//--------------------------------------------------------------
// EA State
//--------------------------------------------------------------
enum ENUM_SYSTEM_STATE
{
   STATE_IDLE = 0,
   STATE_ANALYZING,
   STATE_WAITING_PULLBACK,
   STATE_WAITING_PATTERN,
   STATE_READY,
   STATE_EXECUTING,
   STATE_MANAGING,
   STATE_LOGGING
};

//--------------------------------------------------------------
// Pattern Types
//--------------------------------------------------------------
enum ENUM_PATTERN
{
   PATTERN_NONE = 0,
   PATTERN_W,
   PATTERN_M,
   PATTERN_HEAD_SHOULDERS,
   PATTERN_INVERSE_HEAD_SHOULDERS,
   PATTERN_BREAK_RETEST,
   PATTERN_CHANNEL,
   PATTERN_FVG
};

//==============================================================
// STRUCTURES
//==============================================================

//--------------------------------------------------------------
// Swing Point
//--------------------------------------------------------------
struct SwingPoint
{
   bool             IsValid;

   datetime         Time;

   double           Price;

   double           ATRDistance;

   int              Strength;

   ENUM_SWING_TYPE  Type;
};

//--------------------------------------------------------------
// Trend Information
//--------------------------------------------------------------
struct TrendInfo
{
   bool          IsValid;

   ENUM_TREND    Trend;

   int           HH;

   int           HL;

   int           LH;

   int           LL;

   double        Strength;
};

//--------------------------------------------------------------
// Fibonacci
//--------------------------------------------------------------
struct FibData
{
   bool      IsValid;

   double    High;

   double    Low;

   double    Fib382;

   double    Fib500;

   double    Fib618;

   bool      FirstPullback;
};

//--------------------------------------------------------------
// Pattern
//--------------------------------------------------------------
struct PatternData
{
   bool             IsValid;

   ENUM_PATTERN     Pattern;

   double           Score;

   datetime         DetectionTime;
};

//--------------------------------------------------------------
// Support Resistance
//--------------------------------------------------------------
struct SRZone
{
   bool              IsValid;

   ENUM_ZONE_TYPE    Type;

   double            Upper;

   double            Lower;

   int               Touches;

   double            Strength;
};

//--------------------------------------------------------------
// Macro Bias
//--------------------------------------------------------------
struct MacroBiasData
{
   bool               IsValid;

   ENUM_MACRO_BIAS    USD;

   ENUM_MACRO_BIAS    EUR;

   ENUM_MACRO_BIAS    GBP;

   ENUM_MACRO_BIAS    AUD;

   ENUM_MACRO_BIAS    NZD;

   ENUM_MACRO_BIAS    CAD;
};

//--------------------------------------------------------------
// Trade Setup
//--------------------------------------------------------------
struct TradeSetup
{
   bool                    IsValid;

   string                  Symbol;

   ENUM_TRADE_DIRECTION    Direction;

   TrendInfo               Trend;

   FibData                 Fib;

   PatternData             Pattern;

   SRZone                  Zone;

   MacroBiasData           Macro;

   double                  Entry;

   double                  StopLoss;

   double                  TakeProfit;

   double                  RiskPercent;

   double                  Confidence;

   double                  StrategyHealth;
};