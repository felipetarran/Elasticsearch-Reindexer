#!/bin/bash

curl -o indexes.json http://${SRC_SERVER_IP}:9200/_aliases?pretty=true

INDEXES=$(jq -r 'keys[]' indexes.json)

echo ${INDEXES[*]}  


for index in ${INDEXES[@]}; do
	curl -X POST "${TARGET_SERVER_IP}:9200/_reindex?wait_for_completion=true&pretty=true" -H 'Content-Type: application/json' -d'
	{
		"source": {
			"remote": {
				"host": "http://'${SRC_SERVER_IP}':9200"
			},
			"index": "'$index'"
		},
		"dest": {
			"index": "'$index'"
		}
	}'
done
