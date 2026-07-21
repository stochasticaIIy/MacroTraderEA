//--------------------------------------------------------------
// Macro Trader EA
//--------------------------------------------------------------
// File: Constants.mqh
// Module: Core
// Version: v0.1.0-alpha
//--------------------------------------------------------------

#ifndef CONSTANTS_MQH
#define CONSTANTS_MQH


//==============================================================
// VERSION
//==============================================================

#define EA_NAME                 "Macro Trader EA"

#define EA_VERSION_MAJOR        0
#define EA_VERSION_MINOR        1
#define EA_VERSION_PATCH        0

//==============================================================
// FTMO DEFAULTS
//==============================================================

#define DEFAULT_DAILY_DD        5.0
#define DEFAULT_MAX_DD          10.0

#define DEFAULT_RISK_PER_TRADE  1.0

#define DEFAULT_MAX_TRADES_DAY  3

#define DEFAULT_MAX_OPEN_TRADES 3

//==============================================================
// STRATEGY DEFAULTS
//==============================================================

#define DEFAULT_ATR_PERIOD      14

#define DEFAULT_SL_ATR          2.0

#define DEFAULT_TP_ATR          4.0

#define DEFAULT_ZIGZAG_DEPTH    12

#define DEFAULT_ZIGZAG_DEV      5

#define DEFAULT_ZIGZAG_BACKSTEP 3

//==============================================================
// RESEARCH
//==============================================================

#define SNAPSHOT_VERSION        1

#define CSV_SEPARATOR           ","

//==============================================================
// DEBUG
//==============================================================

#define HUD_CORNER              0

#define HUD_X                   10

#define HUD_Y                   20

#define HUD_LINE_HEIGHT         18

#endif