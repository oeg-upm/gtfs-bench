#!/bin/bash

# ./generate_queries.sh "1 10 100 1000" "<TEMP_FOLDER>" "xml json csv"
SA_QUERIES=sparql-anything-query-templates
SA_QUERIES_XML=sparql-anything-query-templates_xml
SA_CONSTRUCT=sparql-anything-construct-templates
TMP_FOLDER="$2/"

echo "Generating query for testing resource creation"
sed -e "s/%size/1000/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true,blank-nodes=true/g" $SA_QUERIES/"q7.sparql" > "1000/q7-csv-strategy1-no_slice-blank-nodes.sparql"
sed -e "s/%size/1000/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true,blank-nodes=false/g" $SA_QUERIES/"q7.sparql" > "1000/q7-csv-strategy1-no_slice-no-blank-nodes.sparql"

echo "Generating query for testing headers impact"
sed -e "s/%size/1000/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/blank-nodes=true/g" $SA_QUERIES/"q7_no_headers.sparql" > "1000/q7-csv-strategy1-no_slice-no-headers.sparql"
sed -e "s/%size/1000/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true,blank-nodes=false/g" $SA_QUERIES/"q7.sparql" > "1000/q7-csv-strategy1-no_slice-headers.sparql"



if [ ! -d $TMP_FOLDER ]; then
  mkdir $TMP_FOLDER
  echo "Folder $TMP_FOLDER created!"
else
  echo "$TMP_FOLDER already exists!"
fi

for size in $1
do
  if [ ! -d $size ]; then
    mkdir $size
  else
    echo "$size already exists!"
  fi

  for query in {1..18}
  do

    QUERY_TEMPLATE_FILE=$SA_QUERIES/"q$query.sparql"
    QUERY_TEMPLATE_FILE_XML=$SA_QUERIES_XML/"q${query}_xml.sparql"
    echo "Processing $QUERY_TEMPLATE_FILE"

    if [[ $3 == *"csv"* ]]; then
      echo "Generating queries for CSV format"
      # CSV
      sed -e "s/%size/$size/g" -e "s/%strategy/0/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true/g" $QUERY_TEMPLATE_FILE > $size/"q$query-csv-strategy0-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true/g"  $QUERY_TEMPLATE_FILE > $size/"q$query-csv-strategy1-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/true/g" -e "s/%format/csv/g" -e "s/%param/csv.headers=true/g"  $QUERY_TEMPLATE_FILE > $size/"q$query-csv-strategy1-slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/csv/g" -e "s~%param~blank-nodes=true,ondisk=${TMP_FOLDER}/q$query-csv-strategy1-no_slice-ondisk~g"  $QUERY_TEMPLATE_FILE > $size/"q$query-csv-strategy1-no_slice-ondisk.sparql"
    fi

    if [[ $3 == *"json"* ]]; then
      echo "Generating queries for JSON format"
      # JSON
      sed -e "s/%size/$size/g" -e "s/%strategy/0/g" -e "s/%slice/false/g" -e "s/%format/json/g" -e "s/%param/blank-nodes=true/g" $QUERY_TEMPLATE_FILE > $size/"q$query-json-strategy0-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/json/g" -e "s/%param/blank-nodes=true/g"  $QUERY_TEMPLATE_FILE > $size/"q$query-json-strategy1-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/true/g" -e "s/%format/json/g" -e "s/%param/blank-nodes=true/g"  $QUERY_TEMPLATE_FILE > $size/"q$query-json-strategy1-slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/json/g" -e "s~%param~blank-nodes=true,ondisk=${TMP_FOLDER}/q$query-json-strategy1-no_slice-ondisk~g"  $QUERY_TEMPLATE_FILE > $size/"q$query-json-strategy1-no_slice-ondisk.sparql"
    fi

    if [[ $3 == *"xml"* ]]; then
      echo "Generating queries for XML format"
      # XML
      sed -e "s/%size/$size/g" -e "s/%strategy/0/g" -e "s/%slice/false/g" -e "s/%format/xml/g" -e "s/%param/blank-nodes=true/g" $QUERY_TEMPLATE_FILE_XML > $size/"q$query-xml-strategy0-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/xml/g" -e "s/%param/blank-nodes=true/g"  $QUERY_TEMPLATE_FILE_XML > $size/"q$query-xml-strategy1-no_slice.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/false/g" -e "s/%format/xml/g" -e "s~%param~blank-nodes=true,ondisk=${TMP_FOLDER}/q$query-xml-strategy1-no_slice-ondisk~g"  $QUERY_TEMPLATE_FILE_XML > $size/"q$query-xml-strategy1-no_slice-ondisk.sparql"
      sed -e "s/%size/$size/g" -e "s/%strategy/1/g" -e "s/%slice/true/g" -e "s/%format/xml/g" -e "s/%param/blank-nodes=true,xml.path=\/\/Record/g"  $QUERY_TEMPLATE_FILE_XML > $size/"q$query-xml-strategy1-slice.sparql"
    fi

  done
done
