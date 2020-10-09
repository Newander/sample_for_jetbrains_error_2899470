import logging

from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from pendulum import Pendulum


def debug_dag(execution_date: Pendulum, prev_execution_date: Pendulum, **context):
    # type here any code
    logging.info('The sample output')


default_args = {
    'owner': 'help-desk-eddy',
    'depends_on_past': True,
    'start_date': datetime(2020, 9, 9),
    'email': [],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=10),
    'wait_for_downstream': True
}

with DAG(
        'sample-dag-v0',
        default_args=default_args,
        schedule_interval=timedelta(hours=12),
        catchup=True
) as dag:
    PythonOperator(
        task_id='vkpay',
        python_callable=debug_dag,
        provide_context=True,
    )
