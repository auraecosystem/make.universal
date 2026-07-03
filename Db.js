// db.js

const db = {
  users: [
    {
      id: 1,
      username: "kubulee",
      name: "Seriki Yakub",
      role: "owner"
    }
  ],

  organizations: [
    {
      id: 1,
      name: "QUBUHUB"
    }
  ],

  projects: [
    {
      id: 1,
      name: "Aura",
      description: "AI Development Platform"
    },
    {
      id: 2,
      name: "Fadaka",
      description: "Blockchain Platform"
    }
  ],

  ai_agents: [],
  ai_models: [],
  conversations: [],
  messages: [],

  wallets: [],
  tokens: [],
  smart_contracts: [],
  transactions: [],

  repositories: [],
  files: [],
  deployments: [],

  domains: [],
  dns_records: [],

  marketplace: [],
  subscriptions: [],
  payments: [],

  notifications: [],
  analytics: [],

  settings: {
    theme: "dark",
    language: "en"
  },

  profile: {
    name: "Seriki Yakub",
    company: "QUBUHUB"
  }
};

module.exports = db;
