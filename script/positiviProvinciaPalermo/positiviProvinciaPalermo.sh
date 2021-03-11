#!/bin/bash

### requisiti ###
# csvkit https://csvkit.readthedocs.io/en/latest/
# Miller https://github.com/johnkerl/miller
# scrape-cli https://github.com/aborruso/scrape-cli
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing

# anno 2020

anno="2020"

URL="https://www.comune.palermo.it/statistica.php?sel=9&per=$anno"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

download2020="no"

# se il sito è raggiungibile scarica i dati
if [ $code -eq 200 ] && [ "$download2020" == 'sì' ]; then
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

# anno 2021

anno="2021"

URL="https://www.comune.palermo.it/statistica.php?sel=9&per=$anno"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica i dati
if [ $code -eq 200 ]; then

  # estrai primo href "Dati comuni citta'", che dovrebbe essere sempre il più recente
  tipo=$(curl -kL "$URL" | scrape -be '//a[contains(text(),"Dati citta")]' | xq -r '.html.body.a|type')

  # se l'URL è uno solo estrai oggetto
  if [[ $tipo == "object" ]]; then
    hrefFile=$(curl -kL "$URL" | scrape -be '//a[contains(text(),"Dati citta")]' | xq -r '.html.body.a."@href"')
  # altrimenti estrai primo item dell'array
  else
    hrefFile=$(curl -kL "$URL" | scrape -be '//a[contains(text(),"Dati citta")]' | xq -r '.html.body.a[0]."@href"')
  fi

  # scarica xlsx
  curl -kL "https://www.comune.palermo.it/$hrefFile" >"$folder"/rawdata/"$anno"_positiviProvinciaPalermo.xlsx
  # trasforma xlsx in csv
  in2csv -I --sheet tavola_pop_res01 "$folder"/rawdata/"$anno"_positiviProvinciaPalermo.xlsx >"$folder"/rawdata/"$anno"_positiviProvinciaPalermo.csv
  # rimuovi righe righe inutili, intestazione, piede, ---
  mlr --csv -N filter -S '$1=~"^(8|Pr)"' "$folder"/rawdata/"$anno"_positiviProvinciaPalermo.csv >"$folder"/processing/"$anno"_positiviProvinciaPalermo.csv
  # rimuovi i caratteri . e …
  sed -i -r 's/(\.|…)+//g' "$folder"/processing/"$anno"_positiviProvinciaPalermo.csv
  # sposta file in cartella di output
  mv "$folder"/processing/"$anno"_positiviProvinciaPalermo.csv "$folder"/../../082053/output/positiviProvinciaPalermo.csv
  # rimuovi colonne vuote e crea versione del file in versione long
  mlr --csv remove-empty-columns then reshape -r "-" -o item,value then sort -f "Pro Com",item then rename item,data,value,positivi "$folder"/../../082053/output/positiviProvinciaPalermo.csv >"$folder"/../../082053/output/positiviProvinciaPalermoLong.csv
  # crea versione del file con nomi comune in colonna
  mlr --csv cut -x -r -f "(Res|Dis|Pro)" then reshape -s COMUNE,positivi then sort -f data then clean-whitespace "$folder"/../../082053/output/positiviProvinciaPalermoLong.csv >"$folder"/../../082053/output/positiviProvinciaPalermoComuni.csv

  # calcolo soglia 250 contagi per 100.000 abitanti
  mlr -I --csv put '$250ContagiPer100kResidenti=int($positivi/${Residenti al 31/12/2019}*100000);if($250ContagiPer100kResidenti>=250){$allerta=1}else{$allerta=0}' "$folder"/../../082053/output/positiviProvinciaPalermoLong.csv
fi
