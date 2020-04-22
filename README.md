# SistemaFinanceiro
![Elixir](https://github.com/elixir-lang/elixir-lang.github.com/raw/master/images/logo/logo.png)

![build](https://github.com/JVZELLER/sistema-financeiro/workflows/build/badge.svg?branch=master)

## Para gerenciar transações financeiras entre contas bancárias
O sistema permite as seguintes operações:
- 'Split' de dinheiro entre contas bancárias;
- Conversões de Câmbio de contas bancárias.

Para executar o sistema abra um terminal no diretório da pasta do projeto e execute:
```bash
$ iex -S mix
iex(1)> SistemaFinanceiro.start()
```

Para executar os testes, execute:
```bash
$ mix test
```

Para gerar documentação:
```bash
$ mix docs
```
E depois acesse `doc/index.html`.

## Tecnologias
- Elixir ~> 1.10
- Mix
- Credo ~> 1.2
- Ex_doc ~> 0.21
- GitHub Actions

## Módulos Específicos
De todos os módulos do projeto, dois merecem atenção especial:
- `Money`
- `Currency`

Estes dois módulos representam "Dinheiro" e "Moeda respectivamente, e foram desenvolvidos a fim de abstrair essas duas entidades do mundo real e contornar os problemas ao manipular valores monetarios computacionalmente.

## Arquitetura
O sistema baseia-se em uma arquiterua MVC com algumas modificações e camadas extras.
Nossa `view` é representada pelo módulo `SistemaFinanceiro`, cuja responsabilidade é exibir os dados aos usuários. Para a execução de uma operação, a `view` captura os dados necessários e realiza uma chamada para a `controller` (módulo `SistemaFinanceiro.Controller`).
A `controller` simplesmente repassa as requisições que nela chegam para a camada de `serviço` (módulo `SistemaFinanceiro.AccountService`) que se encarrega de validar os dados e executar a ação requisitada.
A nossa `service` consulta os dados da aplicação através da camada de `repositórios` (módulos  `Repository.AccountRepository`, `Repository.CurrencyRepository` e `Repository.ExchangeRateRepository`).
Os dados estão armazenados em memória (módulos `InMemoryDatabase`) e definidos nas configurações de acordo com o ambiente que o sistema está sendo executado (PRD, TEST ou DEV). Cada repositório, antes de realizar suas operações verifica qual tipo de `database` deve usar de acordo com o ambiente, deixando assim uma forma flexível para novas implementações de consultas em diferentes bancos de dados.

## Fontes
- [Elixir School](https://elixirschool.com/pt/)
- [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide/blob/master/README.md)
- [Elixir in Action: Juric, Saša](https://www.amazon.com/Elixir-Action-Sa%C5%A1a-Juri-cacute/dp/1617295027)
- [Plataformatec Blog](http://blog.plataformatec.com.br/)
