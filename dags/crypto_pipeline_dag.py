from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'engenheiro_de_dados',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'crypto_pipeline_complete',
    default_args=default_args,
    description='Pipeline completo: Extração + Transformação dbt',
    schedule_interval='*/15 * * * *',  # Roda a cada 15 minutos
    catchup=False,
    tags=['crypto', 'etl', 'dbt'],
)

# Task 1: Extrair dados da API
extract_data = BashOperator(
    task_id='extract_crypto_data',
    bash_command='python /opt/airflow/scripts/extract_crypto_data.py',
    dag=dag,
)

# Task 2: Rodar transformações dbt
transform_data = BashOperator(
    task_id='transform_with_dbt',
    bash_command='cd /opt/airflow/dbt && dbt run',
    dag=dag,
)

# Definir ordem: primeiro extrai, depois transforma
extract_data >> transform_data