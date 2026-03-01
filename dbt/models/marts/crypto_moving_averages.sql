{{ config(materialized='table') }}

WITH daily_prices AS (
    SELECT 
        c.id,
        c.symbol,
        c.name,
        c.current_price,
        c.market_cap,
        c.price_change_percentage_24h,
        DATE(c.last_updated) as date,
        c.last_updated
    FROM {{ ref('stg_crypto_prices') }} c
),

moving_averages AS (
    SELECT 
        id,
        symbol,
        name,
        current_price,
        market_cap,
        price_change_percentage_24h,
        date,
        last_updated,
        
        -- Média Móvel 7 dias
        AVG(current_price) OVER (
            PARTITION BY symbol 
            ORDER BY date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as ma_7d,
        
        -- Média Móvel 14 dias
        AVG(current_price) OVER (
            PARTITION BY symbol 
            ORDER BY date 
            ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
        ) as ma_14d,
        
        -- Média Móvel 30 dias
        AVG(current_price) OVER (
            PARTITION BY symbol 
            ORDER BY date 
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) as ma_30d,
        
        -- Contagem de registros para validar dados suficientes
        COUNT(*) OVER (
            PARTITION BY symbol 
            ORDER BY date 
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) as days_count
        
    FROM daily_prices
)

SELECT 
    id,
    symbol,
    name,
    current_price,
    market_cap,
    price_change_percentage_24h,
    date,
    last_updated,
    
    -- Médias móveis
    ROUND(ma_7d::numeric, 2) as ma_7d,
    ROUND(ma_14d::numeric, 2) as ma_14d,
    ROUND(ma_30d::numeric, 2) as ma_30d,
    
    -- Sinais de tendência (preço vs média)
    CASE 
        WHEN current_price > ma_7d THEN 'BULLISH_7D'
        WHEN current_price < ma_7d THEN 'BEARISH_7D'
        ELSE 'NEUTRAL'
    END as trend_7d,
    
    CASE 
        WHEN current_price > ma_30d THEN 'BULLISH_30D'
        WHEN current_price < ma_30d THEN 'BEARISH_30D'
        ELSE 'NEUTRAL'
    END as trend_30d,
    
    -- Força da tendência (% de distância da média)
    ROUND(((current_price - ma_7d) / ma_7d * 100)::numeric, 2) as deviation_from_ma_7d_pct,
    ROUND(((current_price - ma_30d) / ma_30d * 100)::numeric, 2) as deviation_from_ma_30d_pct,
    
    days_count

FROM moving_averages
WHERE days_count >= 7  -- Filtrar apenas registros com dados suficientes
ORDER BY symbol, date DESC

