#!/bin/bash
# ================================================
#  Skrypt: projekt1_setup.sh
#  Opis:
#    Skrypt tworzy katalog "projekt1", a w nim plik
#    "readme.txt". Następnie przenosi ten plik do
#    podkatalogu "dokumenty".
#
#  Dodatkowo:
#    - sprawdza, czy katalog i pliki już istnieją,
#      aby uniknąć błędów.
#    - pozwala szybko odtworzyć strukturę projektu.
#
#  Autor: shovker
# ================================================


mkdir -p projekt1/docs projekt1/src # twórz ścieżki
touch projekt1/docs/readme.txt
touch projekt1/src/main.sh
cp projekt1/docs/readme.txt ~/
mv projekt1/src/main.sh projekt1/docs/
ls -R projekt1   # pokaż strukturę katalogu rekursywnie
cat projekt1/docs/readme.txt
