# Crypto Data Pipeline

Pipeline de engenharia de dados para coleta, transformação e visualização
de preços de criptomoedas em tempo real, com atualização automática a cada
15 minutos.

---

## Contexto

O objetivo foi construir um pipeline completo do zero, da extração de dados
de uma API pública até um dashboard interativo, aplicando boas práticas de
engenharia de dados como arquitetura em camadas, orquestração e
containerização.

---

## Arquitetura
```
CoinGecko API
      ↓
  Python (extração)
      ↓
  PostgreSQL — Raw Layer
  dado bruto, sem transformação
      ↓
  dbt — Staging Layer
  limpeza e padronização
      ↓
  dbt — Analytics Layer
  métricas de negócio
      ↓
  Metabase Dashboard

  Orquestrado pelo Apache Airflow (a cada 15 minutos)
```

---

## Stack

- Python -> extração de dados da API
- Apache Airflow -> orquestração do pipeline
- PostgreSQL -> armazenamento em camadas
- dbt -> transformação e modelagem
- Metabase -> visualização
- Docker -> containerização do ambiente

---

## Camadas de Dados

**Raw** - dado bruto exatamente como veio da API CoinGecko.
Schema: `raw.crypto_prices`

**Staging** - dados limpos e padronizados pelo dbt.
Schema: `staging.stg_crypto_prices`

**Analytics** - métricas prontas para consumo: classificação de volatilidade
(Alta/Média/Baixa), categorização de market cap (Large/Mid/Small Cap) e
identificação de tendência (Subindo/Caindo/Estável).
Schema: `analytics.crypto_metrics`

---

## Estrutura
```
crypto-pipeline/
├── dags/
│   ├── crypto_pipeline_dag.py
│   └── crypto_pipeline_complete.py
├── scripts/
│   ├── extract_crypto_data.py
│   └── init_db.sql
├── dbt/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_crypto_prices.sql
│   │   │   └── schema.yml
│   │   └── marts/
│   │       └── crypto_metrics.sql
│   ├── dbt_project.yml
│   └── profiles.yml
└── docker-compose.yml
```

---

## Como executar

**Pré-requisitos:** Docker Desktop e 8GB de RAM. Portas livres: 5433, 8081, 3001.
```bash
# 1. Clone o repositório
git clone https://github.com/luciendelalves/crypto-data-pipeline.git
cd crypto-data-pipeline

# 2. Suba os containers
docker compose up -d

# 3. Aguarde 2-3 minutos para inicialização

# 4. Acesse as interfaces
# Airflow:  http://localhost:8081  (admin / admin)
# Metabase: http://localhost:3001
```

No Airflow, ative a DAG `crypto_pipeline_complete` e execute manualmente
clicando em play.

---

## Próximos passos

- Testes de qualidade de dados com dbt tests
- Alertas por Slack ou email em caso de falha
- Snapshot histórico para análise de séries temporais
- CI/CD

---

## Autor

**Luciendel Alves**
Analista de Risco & PLD - iGaming
[LinkedIn](https://www.linkedin.com/in/luciendel-alves-008321107/) ·
[GitHub](https://github.com/luciendelalves)