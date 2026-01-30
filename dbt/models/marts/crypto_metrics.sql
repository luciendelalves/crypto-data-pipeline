-- Métricas agregadas de criptomoedas
WITH latest_data AS (
    SELECT *
    FROM {{ ref('stg_crypto_prices') }}
    WHERE extracted_at = (SELECT MAX(extracted_at) FROM {{ ref('stg_crypto_prices') }})
      AND is_valid_price = TRUE
)

SELECT 
    name,
    symbol,
    current_price,
    market_cap,
    total_volume,
    price_change_percentage_24h,
    
    -- Classificação de volatilidade
    CASE 
        WHEN ABS(price_change_percentage_24h) > 10 THEN 'Alta Volatilidade'
        WHEN ABS(price_change_percentage_24h) > 5 THEN 'Média Volatilidade'
        ELSE 'Baixa Volatilidade'
    END AS volatility_category,
    
    -- Classificação de market cap
    CASE 
        WHEN market_cap > 100000000000 THEN 'Large Cap'
        WHEN market_cap > 10000000000 THEN 'Mid Cap'
        ELSE 'Small Cap'
    END AS market_cap_category,
    
    -- Tendência
    CASE 
        WHEN price_change_percentage_24h > 0 THEN 'Subindo'
        WHEN price_change_percentage_24h < 0 THEN 'Caindo'
        ELSE 'Estável'
    END AS trend,
    
    extracted_at AS last_update
    
FROM latest_data
ORDER BY market_cap DESC