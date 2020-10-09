FROM puckel/docker-airflow:1.10.7

ENV AIRFLOW_HOME=/usr/local/airflow
ENV LOAD_EX=n
ENV PYTHONPATH=${AIRFLOW_HOME}

ENV PYTHONUNBUFFERED=1
ENV PYTHONWARNINGS="ignore"

COPY ./dags ${AIRFLOW_HOME}/dags

USER root

RUN apt-get update && apt-get install -y \
    libpq-dev \
    unixodbc-dev \
    locales \
    libaio1 \
    libaio-dev \
    unzip

# Creates Oracle
RUN mkdir -p /opt/oracle/instantclient
COPY ./libs/lib* /opt/oracle/instantclient/

RUN sh -c "echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf"
RUN ldconfig

RUN pip install -r ${AIRFLOW_HOME}/dags/requirements.txt
RUN rm -rf /usr/local/bin/python3.7/site-packages/airflow/example_dags

USER airflow