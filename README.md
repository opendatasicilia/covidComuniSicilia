# Report sui casi positivi di COVID 19 in provincia di Palermo

<!-- TOC -->

- [Report sui casi positivi di COVID 19 in provincia di Palermo](#report-sui-casi-positivi-di-covid-19-in-provincia-di-palermo)
  - [Introduzione](#introduzione)
  - [Perché questo repository](#perché-questo-repository)
  - [Struttura repository](#struttura-repository)
  - [Nome file CSV](#nome-file-csv)
  - [Struttura file CSV](#struttura-file-csv)

<!-- /TOC -->

## Introduzione

A partire dal 28/ottobre/2020 nel [Canale Telegram](https://t.me/ProtezioneCivilePalermo) della _**Protezione Civile di Palermo**_, rendono disponibile il seguente link `http://tiny.cc/CovidPalermo_27Ott` ovvero un **PDF** con i dati sui Comuni:

![](imgs/img_01.png)

## Perché questo repository

Come detto nell'introduzione, la _**Protezione Civile di Palermo**_ fornisce solo i **PDF**, in questo repository li raccoglieremo e estrarremo i dati per renderli usufruibili in forma di testo strutturato, i classici file CSV.

## Struttura repository

```
covidComuniSiclia/
│
├── 082053/
│   ├── output/
|       ├── 20201026-Covid_PA.csv
|   ├── rawdata/
|       ├── 20201026-Covid_PA_20201026.pdf
|       ├── 20201102-Covid_PA_201102.pdf
├── imgs/
```

## Nome file CSV

nome file | esempio | formato file
----------|---------|------------
YYYYMMDD-Covid_PA|20201026-Covid_PA.csv| CSV

## Struttura file CSV

nome campo    | descrizione | formato | esempio
--------------|-------------|---------|-------
_CodiceISTAT_   | Codice ISTAT numerico | numerico | 82001
_COMUNE_        | Denominazione Comune | Testo | Alia
_data_          | Data| YYYY-MM-DD | 2020-10-19
_positivi_      | Numero di Positivi | numerico | 3

--

**Fonte:** Elaborazioni Ufficio Statistica del Comune di Palermo su dati ASP Palermo

