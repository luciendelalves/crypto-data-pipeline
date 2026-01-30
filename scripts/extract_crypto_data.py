import requests
import psycopg2
from datetime import datetime
import time

def get_crypto_data():
    """Busca dados de criptomoedas da API CoinGecko"""
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 20,
        'page': 1,
        'sparkline': False
    }
    
    try:
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Erro ao buscar dados: {e}")
        return None

def insert_data_to_postgres(data):
    """Insere dados no PostgreSQL"""
    conn = psycopg2.connect(
        host="postgres",
        database="crypto_data",
        user="airflow",
        password="airflow"
    )
    
    cursor = conn.cursor()
    
    for crypto in data:
        cursor.execute("""
            INSERT INTO raw.crypto_prices 
            (symbol, name, current_price, market_cap, total_volume, 
             price_change_24h, price_change_percentage_24h, last_updated)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            crypto['symbol'],
            crypto['name'],
            crypto['current_price'],
            crypto['market_cap'],
            crypto['total_volume'],
            crypto['price_change_24h'],
            crypto['price_change_percentage_24h'],
            datetime.fromisoformat(crypto['last_updated'].replace('Z', '+00:00'))
        ))
    
    conn.commit()
    cursor.close()
    conn.close()
    print(f"✅ {len(data)} registros inseridos com sucesso!")

if __name__ == "__main__":
    print("🚀 Iniciando extração de dados...")
    data = get_crypto_data()
    
    if data:
        print(f"📊 {len(data)} criptomoedas encontradas")
        insert_data_to_postgres(data)
    else:
        print("❌ Falha na extração")