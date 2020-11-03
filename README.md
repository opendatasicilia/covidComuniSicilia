# Report sui casi positivi di COVID 19 in provincia di Palermo

<!-- TOC -->

- [Report sui casi positivi di COVID 19 in provincia di Palermo](#report-sui-casi-positivi-di-covid-19-in-provincia-di-palermo)
  - [Introduzione](#introduzione)
  - [Perché questo repository](#perché-questo-repository)
  - [Struttura Repository](#struttura-repository)
  - [Struttura file CSV](#struttura-file-csv)

<!-- /TOC -->

## Introduzione

A partire dal 28/ottobre/2020 nel [Canale Telegram](https://t.me/ProtezioneCivilePalermo) della _**Protezione Civile di Palermo**_, rendono disponibile il seguente link `http://tiny.cc/CovidPalermo_27Ott` ovvero un PDF con i dati sui Comuni:

![](imgs/img_01.png)

## Perché questo repository

Come detto nell'introduzione, la _**Protezione Civile di Palermo**_ fornisce solo i PDF, in questo repository li raccoglieremo e estrarremo i dati per renderli usufruibili in forma di testo strutturato, i classici file CSV.

## Struttura Repository

```
covidComuniSicilia/
│
├── 082053/
│   ├── output/
|       ├── 20201026-Covid_PA.csv
|   ├── rawdata/
|       ├── 20201026-Covid_PA_20201026.pdf
|       ├── 20201102-Covid_PA_201102.pdf
├── imgs/
```

## Struttura file CSV

nome campo    | descrizione | formato | esempio
--------------|-------------|---------|-------
CodiceISTAT   | Codice ISTAT | numerico | 82001
COMUNE        | Denominazione Comune | testo | Alia
data          | Data| testo | 2020-10-19
positivi      | Numero di Positivi | numerico | 3

--

**Fonte:** Elaborazioni Ufficio Statistica del Comune di Palermo su dati ASP Palermo

