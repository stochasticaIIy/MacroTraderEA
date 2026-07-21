#ifndef CONFIG_MQH
#define CONFIG_MQH

#include "Inputs.mqh"

class CConfig
{
private:

   bool m_debugMode;
   bool m_enableHUD;
   bool m_enableResearch;

   double m_riskPercent;
   double m_dailyDD;
   double m_maxDD;

   int m_maxTradesPerDay;
   int m_maxOpenTrades;

public:

   bool Load()
   {
      m_debugMode        = DebugMode;
      m_enableHUD        = EnableHUD;
      m_enableResearch   = EnableResearch;

      m_riskPercent      = RiskPercent;
      m_dailyDD          = DailyDrawdownLimit;
      m_maxDD            = MaximumDrawdownLimit;

      m_maxTradesPerDay  = MaxTradesPerDay;
      m_maxOpenTrades    = MaxOpenTrades;

      return(true);
   }

   double RiskPercent()      const { return m_riskPercent; }
   double DailyDD()          const { return m_dailyDD; }
   double MaxDD()            const { return m_maxDD; }

   int MaxTradesDay()        const { return m_maxTradesPerDay; }
   int MaxOpenTrades()       const { return m_maxOpenTrades; }

   bool DebugMode()          const { return m_debugMode; }
   bool EnableHUD()          const { return m_enableHUD; }
   bool EnableResearch()     const { return m_enableResearch; }
};

#endif