import Config

config :sistema_financeiro,
       :account_repository,
       SistemaFinanceiro.Repository.Account.InMemoryRepository
