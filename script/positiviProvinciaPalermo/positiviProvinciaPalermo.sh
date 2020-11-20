#!/bin/bash

### requisiti ###
# visidata https://github.com/saulpw/visidata
# Miller https://github.com/johnkerl/miller
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing

URL="https://www.comune.palermo.it/js/server/uploads/statistica/_20112020100242.xlsx"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica i dati
if [ $code -eq 200 ]; then
  curl -kL "$URL" >"$folder"/rawdata/positiviProvinciaPalermo.xlsx
  in2csv -I --sheet tavola_pop_res01 "$folder"/rawdata/positiviProvinciaPalermo.xlsx >"$folder"/rawdata/positiviProvinciaPalermo.csv
  mlr --csv -N filter -S '$1=~"^(8|Pr)"' rawdata/positiviProvinciaPalermo.csv >"$folder"/processing/positiviProvinciaPalermo.csv
fi

