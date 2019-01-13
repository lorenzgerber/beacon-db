#!/bin/bash
set -e

echo "extracting data"
tar xvf sg10k.tar.gz


echo "load dataset information into database"
PGPASSWORD=r783qjkldDsiu \
    psql -U microaccounts_dev elixir_beacon_dev <<-EOSQL
        INSERT INTO beacon_dataset (id, stable_id, description, access_type, reference_genome, variant_cnt, call_cnt, sample_cnt)
        VALUES (1, 'sg10k', 'variants', 'PUBLIC', 'grch37', 1, 1, 1);
EOSQL



for FILE in *.SNPs
do
    echo "Processing $FILE file..."
    cat /tmp/$FILE | \
        PGAPASSWORD=r783qjkldDsiu \
        psql -U microaccounts_dev elixir_beacon_dev -c \
        "COPY beacon_data_table (dataset_id,start,chromosome,reference,alternate,\"end\","type",sv_length,variant_cnt,call_cnt,sample_cnt, frequency) FROM STDIN USING DELIMITERS ';' CSV" elixir_beacon_dev
    echo "loaded sample data."
    rm /tmp/$FILE
done

PGPASSWORD=r783qkldDsiu \
    psql -U microaccounts_dev elixir_beacon_dev <<-EOSQL
        UPDATE beacon_dataset_table SET variant_cnt =
        (SELECT dataset_id, count(*) FROM beacon_data_table GROUP BY dataset_id)
EOSQL


PGPASSWORD=r783qkldDsiu \
    psql -U microaccounts_dev elixir_beacon_dev <<-EOSQL
        UPDATE beacon_dataset_table SET call_cnt =
        (SELECT dataset_id, sum(call_cnt) FROM beacon_data_table GROUP BY dataset_id)
EOSQL
