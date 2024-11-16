#!/bin/bash

#read variables from params.yml
version=$(yq eval '.version' params.yml)
size=$(yq eval ".size.\"$version\"" params.yml)

#check if size exists for the given version
if [ -z "$size" ]; then
 echo "Invalid version specified in params.yml"
  exit 1
  fi

#fetch data from api
  api_url="https://jsonplaceholder.typicode.com/photos"
  curl -s "$api_url" | jq ".[:$size]" > datahub/new_data.json

#compare new data to with existing data
if cmp -s datahub/new_data.json datahub/data.json; then
	echo "No changes in the data"
	rm datahub/new_data.json
else
	mv datahub/new_data.json datahub/data.json
	echo "Data updated successfully"
fi

