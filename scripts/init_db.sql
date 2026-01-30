-- Criar database para o Metabase
CREATE DATABASE metabase;

-- Criar database para nossos dados de crypto
CREATE DATABASE crypto_data;

-- Conectar ao crypto_data e criar schema
\c crypto_data;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Tabela para dados brutos
CREATE TABLE IF NOT EXISTS raw.crypto_prices (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(10),
    name VARCHAR(100),
    current_price DECIMAL(20, 8),
    market_cap BIGINT,
    total_volume BIGINT,
    price_change_24h DECIMAL(20, 8),
    price_change_percentage_24h DECIMAL(10, 2),
    last_updated TIMESTAMP,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);