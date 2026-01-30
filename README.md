# 🚀 Crypto Data Pipeline

Pipeline completo de Engenharia de Dados para coleta, transformação e visualização de dados de criptomoedas em tempo real.

## 📊 Arquitetura
```
API CoinGecko → Python Script → PostgreSQL (Raw) → dbt (Transformação) → PostgreSQL (Analytics) → Metabase (Dashboard)
                                        ↓
                                Apache Airflow (Orquestração)
```

## 🛠️ Tecnologias Utilizadas

- **Docker & Docker Compose** - Containerização
- **Apache Airflow** - Orquestração de pipelines
- **PostgreSQL** - Data Warehouse
- **dbt (data build tool)** - Transformação de dados
- **Metabase** - Visualização e dashboards
- **Python** - Scripts de extração
- **CoinGecko API** - Fonte de dados

## 🏗️ Estrutura do Projeto
```
crypto-pipeline/
├── dags/                          # DAGs do Airflow
│   ├── crypto_pipeline_dag.py     # Pipeline de extração
│   └── crypto_pipeline_complete.py # Pipeline completo (extração + transformação)
├── scripts/                       # Scripts Python
│   ├── extract_crypto_data.py     # Extração de dados da API
│   └── init_db.sql               # Inicialização do banco
├── dbt/                          # Projeto dbt
│   ├── models/
│   │   ├── staging/              # Camada Silver (dados limpos)
│   │   │   ├── stg_crypto_prices.sql
│   │   │   └── schema.yml
│   │   └── marts/                # Camada Gold (métricas de negócio)
│   │       └── crypto_metrics.sql
│   ├── dbt_project.yml
│   └── profiles.yml
└── docker-compose.yml            # Configuração dos containers
```

## 🎯 Camadas de Dados (Medallion Architecture)

### 🥉 Bronze Layer (Raw)
- Dados brutos da API CoinGecko
- Schema: `raw.crypto_prices`
- Atualização: A cada 15 minutos

### 🥈 Silver Layer (Staging)
- Dados limpos e padronizados
- Schema: `staging.stg_crypto_prices`
- Validações de qualidade aplicadas

### 🥇 Gold Layer (Analytics)
- Métricas prontas para negócio
- Schema: `analytics.crypto_metrics`
- Inclui:
  - Classificação de volatilidade (Alta/Média/Baixa)
  - Categorização de market cap (Large/Mid/Small Cap)
  - Identificação de tendências (Subindo/Caindo/Estável)

## 🚀 Como Executar

### Pré-requisitos
- Docker Desktop instalado
- 8GB de RAM disponível
- Portas livres: 5433, 8081, 3001

### Passo a Passo

1. **Clone o repositório:**
```bash
git clone https://github.com/SEU_USUARIO/crypto-data-pipeline.git
cd crypto-data-pipeline
```

2. **Suba os containers:**
```bash
docker-compose up -d
```

3. **Aguarde 2-3 minutos para inicialização**

4. **Acesse as interfaces:**
- **Airflow:** http://localhost:8081 (user: `admin` / pass: `admin`)
- **Metabase:** http://localhost:3001

5. **Ative a DAG no Airflow:**
- Procure por `crypto_pipeline_complete`
- Ative o toggle
- Clique em ▶️ para executar manualmente

## 📊 Dashboards Disponíveis

### Dashboard Crypto (Metabase)
- **Top 10 Criptomoedas** - Ranking por market cap
- **Variação 24h** - Gráfico de barras
- **Tendências** - Análise de volatilidade e categorização

## 🔄 Pipeline Automatizado

O Airflow executa automaticamente:
1. **Extração** - Busca dados da API CoinGecko
2. **Transformação** - Roda modelos dbt
3. **Frequência** - A cada 15 minutos
4. **Retry** - 1 tentativa com delay de 5 minutos

## 📈 Métricas do Pipeline

- **Tempo médio de execução:** ~1 minuto
- **Volume de dados:** 20 criptomoedas por execução
- **Uptime:** 24/7
- **Latência:** < 2 minutos (API → Dashboard)

## 🎓 Aprendizados

Este projeto demonstra:
- ✅ Extração de dados de APIs REST
- ✅ Modelagem dimensional (Star Schema)
- ✅ Transformações SQL com dbt
- ✅ Orquestração com Airflow
- ✅ Containerização com Docker
- ✅ Versionamento de código
- ✅ Documentação técnica

## 📝 Próximas Melhorias

- [ ] Adicionar testes de qualidade de dados (dbt tests)
- [ ] Implementar alertas (Slack/Email)
- [ ] Criar snapshot para análise histórica
- [ ] Adicionar mais fontes de dados
- [ ] Implementar CI/CD

## 👨‍💻 Autor

**Luciendel Alves**
- GitHub: [@luciendelalves](https://github.com/luciendelalves)
- LinkedIn: [Luciendel Alves](https://www.linkedin.com/in/luciendelalves/)

## 📄 Licença

Este projeto está sob a licença MIT.