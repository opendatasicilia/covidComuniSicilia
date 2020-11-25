#!/bin/bash

### requisiti ###
# csvkit https://csvkit.readthedocs.io/en/latest/
# Miller https://github.com/johnkerl/miller
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing

URL="https://www.comune.palermo.it/js/server/uploads/statistica/_25112020105310.xlsx"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica i dati
if [ $code -eq 200 ]; then
  curl -kL "$URL" >"$folder"/rawdata/positiviProvinciaPalermo.xlsx
  in2csv -I --sheet tavola_pop_res01 "$folder"/rawdata/positiviProvinciaPalermo.xlsx >"$folder"/rawdata/positiviProvinciaPalermo.csv
  mlr --csv -N filter -S '$1=~"^(8|Pr)"' "$folder"/rawdata/positiviProvinciaPalermo.csv >"$folder"/processing/positiviProvinciaPalermo.csv
  sed -i -r 's/(\.|…)+//g' "$folder"/processing/positiviProvinciaPalermo.csv
  mv "$folder"/processing/positiviProvinciaPalermo.csv "$folder"/../../082053/output/positiviProvinciaPalermo.csv
  mlr --csv remove-empty-columns then reshape -r "-" -o item,value then sort -f "Pro Com",item then rename item,data,value,positivi "$folder"/../../082053/output/positiviProvinciaPalermo.csv >"$folder"/../../082053/output/positiviProvinciaPalermoLong.csv
  mlr --csv cut -x -r -f "(Res|Dis|Pro)" then reshape -s COMUNE,positivi then sort -f data then clean-whitespace "$folder"/../../082053/output/positiviProvinciaPalermoLong.csv >"$folder"/../../082053/output/positiviProvinciaPalermoComuni.csv
fi

