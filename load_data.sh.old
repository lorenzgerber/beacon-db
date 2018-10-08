#!/bin/bash
set -e

echo "extracting data"
tar xvf global.tar.gz

for FILE in W*.SNPs
do
    echo "Processing $FILE file..."
    FILE_LENGTH=$(wc -l $FILE |  cut -f1 -d' ')
    echo $FILE_LENGTH
    FILE_NAME="${FILE%.*}"
    echo $FILE_NAME

    PGPASSWORD=r783qjkldDsiu \
        psql -U microaccounts_dev elixir_beacon_dev <<-EOSQL
            INSERT INTO beacon_dataset
            (id, description, access_type, reference_genome, size)
            VALUES
            ('$FILE_NAME', 'dataset_description', 'PUBLIC', 'grch38', $FILE_LENGTH);
EOSQL

    echo "created beacon schema..."

    echo "Loading sample data..."
    cat /tmp/$FILE | \
        PGPASSWORD=r783qjkldDsiu \
            psql -U microaccounts_dev elixir_beacon_dev -c \
                "COPY beacon_data_table(dataset_id,chromosome,position,alternate) FROM STDIN USING DELIMITERS ';' CSV"

    echo "loaded sample data."

    rm /tmp/$FILE

done

