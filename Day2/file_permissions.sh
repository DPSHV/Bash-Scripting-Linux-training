#!/bin/bash
# ================================================
#  Skrypt: plik_uprawnienia.sh
#  Opis:
#    Skrypt pyta użytkownika o nazwę pliku,
#    sprawdza, czy plik istnieje i w razie potrzeby
#    pyta, czy nadpisać jego uprawnienia.
#    Następnie tworzy plik (jeśli nie istnieje)
#    i ustawia dla niego prawa: właściciel (user)
#    może czytać i pisać (u+rw).
#
#  Dodatkowo:
#    - wyświetla nazwę pliku i jego uprawnienia
#      w formacie symbolicznym (np. -rw-------).
#    - komunikaty błędów wysyła na stderr.

#  Autor: shovker
# 
# ================================================

echo "Enter filename:"
read -r name 

# Empty string
if [ -z "$name" ]; then
    echo "Error: filename is empty. Please provide a valid name." >&2
    exit 1
fi 

# File Exists
if [ -f "$name" ]; then 
    echo "File '$name' already exists. Overwrite permissions? [y/n]"
    read -r opt1
    if [ "$opt1" == "y" ]; then
        chmod u+rw "$name"
        echo "Permissions updated: user read/write enabled."
    else
        echo "No changes applied."
    fi
else
    # Create
    touch "$name"
    chmod u+rw "$name"
    echo "File '$name' created with user read/write permissions."
fi

# Print Perm
printf "File: %s\nPermissions: %s\n" "$name" "$(stat -c "%A" "$name")"

