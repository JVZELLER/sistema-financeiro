import Config

config :sistema_financeiro,
  account_database: Repository.Account.InMemoryDatabase,
  currency_database: Repository.Currency.InMemoryDatabase,
  exchange_database: Repository.ExchangeRate.InMemoryDatabase
