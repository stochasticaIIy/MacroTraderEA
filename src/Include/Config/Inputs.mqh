#ifndef INPUTS_MQH
#define INPUTS_MQH

//--------------------------------------------------------------
// General
//--------------------------------------------------------------

input bool DebugMode = true;

input bool EnableHUD = true;

input bool EnableResearch = true;

//--------------------------------------------------------------
// Risk
//--------------------------------------------------------------

input double RiskPercent = 1.0;

input double DailyDrawdownLimit = 5.0;

input double MaximumDrawdownLimit = 10.0;

input int MaxTradesPerDay = 3;

input int MaxOpenTrades = 3;

//--------------------------------------------------------------
// ATR
//--------------------------------------------------------------

input int ATRPeriod = 14;

input double StopLossATR = 2.0;

input double TakeProfitATR = 4.0;

//--------------------------------------------------------------
// ZigZag
//--------------------------------------------------------------

input int ZigZagDepth = 12;

input int ZigZagDeviation = 5;

input int ZigZagBackstep = 3;

//--------------------------------------------------------------
// Trading
//--------------------------------------------------------------

input bool TradeMonday = true;
input bool TradeTuesday = true;
input bool TradeWednesday = true;
input bool TradeThursday = true;
input bool TradeFriday = false;

//--------------------------------------------------------------
// Research
//--------------------------------------------------------------

input bool SaveSnapshots = true;

input bool SaveTradesCSV = true;

#endif