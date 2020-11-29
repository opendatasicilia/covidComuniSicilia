#!/bin/bash

### requisiti ###
# csvkit https://csvkit.readthedocs.io/en/latest/
# Miller https://github.com/johnkerl/miller
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing

URL="https://www.comune.palermo.it/statistica.php?sel=9&per=2020"
#URL="https://www.comune.palermo.it/js/server/uploads/statistica/_25112020105310.xlsx"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica i dati
if [ $code -eq 200 ]; then
  # estrai primo href "Dati comuni citta'", che dovrebbe essere sempre il più recente
  hrefFile=$(curl -kL "$URL" | scrape -be '//a[contains(text(),"Dati comuni citta")]' | xq -r '.html.body.a[0]."@href"')
  # scarica xlsx
  curl -kL "https://www.comune.palermo.it/$hrefFile" >"$folder"/rawdata/positiviProvinciaPalermo.xlsx
  # trasforma xlsx in csv
  in2csv -I --sheet tavola_pop_res01 "$folder"/rawdata/positiviProvinciaPalermo.xlsx >"$folder"/rawdata/positiviProvinciaPalermo.csv
  # rimuovi righe righe inutili, intestazione, piede, ---
  mlr --csv -N filter -S '$1=~"^(8|Pr)"' "$folder"/rawdata/positiviProvinciaPalermo.csv >"$folder"/processing/positiviProvinciaPalermo.csv
  # rimuovi i caratteri . e …
  sed -i -r 's/(\.|…)+//g' "$folder"/processing/positiviProvinciaPalermo.csv
  # sposta file in cartella di output
  mv "$folder"/processing/positiviProvinciaPalermo.csv "$folder"/../../082053/output/positiviProvinciaPalermo.csv
  # rimuovi colonne vuote e crea versione del file in versione long
  mlr --csv remove-empty-columns then reshape -r "-" -o item,value then sort -f "Pro Com",item then rename item,data,value,positivi "$folder"/../../082053/output/positiviProvinciaPalermo.csv >"$folder"/../../082053/output/positiviProvinciaPalermoLong.csv
  # crea versione del file con nomi comune in colonna
  mlr --csv cut -x -r -f "(Res|Dis|Pro)" then reshape -s COMUNE,positivi then sort -f data then clean-whitespace "$folder"/../../082053/output/positiviProvinciaPalermoLong.csv >"$folder"/../../082053/output/positiviProvinciaPalermoComuni.csv
fi

