-- Camada staging: limpa e padroniza dados brutos
SELECT 
    id,
    UPPER(symbol) AS symbol,
    INITCAP(name) AS name,
    current_price,
    market_cap,
    total_volume,
    price_change_24h,
    price_change_percentage_24h,
    last_updated,
    extracted_at,
    -- Adiciona flag de qualidade
    CASE 
        WHEN current_price IS NULL OR current_price <= 0 THEN FALSE
        ELSE TRUE
    END AS is_valid_price
FROM {{ source('raw', 'crypto_prices') }}
WHERE current_price IS NOT NULL