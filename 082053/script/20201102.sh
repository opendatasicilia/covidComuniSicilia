#!/bin/bash

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# rimuovi colonne inutili da output CSV di tabula
mlr --csv -N cat \
  then remove-empty-columns \
  then cut -x -r -f "[0-9]{2}" \
  then cut -x -f 8 "$folder"/../rawdata/tabula-20201102-Covid_PA_201102.csv >"$folder"/../output/20201102-Covid_PA.csv

# ristruttira CSV da wide a long
mlr -I --csv reshape -r "/" -o item,value \
  then rename item,data,value,positivi \
  then put -S '$data=sub($data,"([^/]+)/([^/]+)","2020-\2-\1");$data = strftime(strptime($data, "%Y-%m-%d"),"%Y-%m-%d")' \
  then sort -f data,COMUNE then clean-whitespace "$folder"/../output/20201102-Covid_PA.csv

# assegna codici ISTAT ai comuni
mlr --csv join --ul -j COMUNE -f "$folder"/../output/20201102-Covid_PA.csv then unsparsify then reorder -f CodiceISTAT "$folder"/../../risorse/codidciIstatComuni.csv >"$folder"/../output/tmp.csv

mv "$folder"/../output/tmp.csv "$folder"/../output/20201102-Covid_PA.csv
