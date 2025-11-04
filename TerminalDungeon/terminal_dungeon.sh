#!/usr/bin/env bash
# ================================================================
# Script: terminal_dungeon.sh
# Description:
#   Text-based dungeon game played in the terminal.
#   Includes map initialization, random monster/item placement,
#   and colored visualization.
#
# Usage:
#   bash terminal_dungeon.sh
#
# Notes:
#   - Requires bash >= 4 (for associative arrays)
#   - Works in normal terminals and WSL
#
# Author: shovker
# ================================================================

# FAIL FAST
set -euo pipefail
trap 'tput sgr0; clear' EXIT

# GLOBAL MAP
declare -A MAP

# BASIC GAME PARAMS
MAP_LENGTH=8
MAP_WIDTH=8

PLAYER_HP=10
PLAYER_X=0
PLAYER_Y=0

ENEMY_COUNT=2
ITEM_COUNT=2

GOLD=10


# map funtions and flow 
init_game() {
    # map clear
    for key in "${!MAP[@]}"; do
        unset 'MAP[$key]'
    done

    # basic map
    for ((x=0; x<MAP_LENGTH; x++)); do
        for ((y=0; y<MAP_WIDTH; y++)); do
            MAP["$x,$y"]="."
        done
    done

    # enemy
    for ((i=0; i<ENEMY_COUNT; i++)); do
        while true; do
            ex=$((RANDOM % MAP_LENGTH))
            ey=$((RANDOM % MAP_WIDTH))
            if [[ "${MAP["$ex,$ey"]}" == "." ]]; then
                MAP["$ex,$ey"]="M"
                break
            fi
        done
    done

   # itemy
    for ((i=0; i<ITEM_COUNT; i++)); do
        while true; do
            ix=$((RANDOM % MAP_LENGTH))
            iy=$((RANDOM % MAP_WIDTH))
            if [[ "${MAP["$ix,$iy"]}" == "." ]]; then
                MAP["$ix,$iy"]="I"
                break
            fi
        done
    done

    # spawn player
    MAP["$PLAYER_X,$PLAYER_Y"]="P"

    echo "MAP initialized with ${#MAP[@]} tiles"
    sleep 1
}

draw_map() {
    # nuke screen + init HUD
    tput clear
    echo "HP: $PLAYER_HP | GOLD: $GOLD"
    echo "Use W/A/S/D to move, Q to Quit"
    echo ""

    for ((x=0; x<MAP_LENGTH; x++)); do
        for ((y=0; y<MAP_WIDTH; y++)); do
            tile=${MAP["$x,$y"]}

            case "$tile" in
                "P") tput setaf 2 ;; # ziel
                "M") tput setaf 1 ;; # czer
                "I") tput setaf 3 ;; # ż
                "E") tput setaf 4 ;; # nieb
                *)   tput sgr0     ;; # default
            esac

            printf "%s " "$tile"
            tput sgr0
        done
        echo ""
    done

   # pomaga na jebane migające refreshe
    tput sgr0
    sleep 0.1
}

handle_input() {
    tput civis
    read -n1 -s key

    case "$key" in 
        w|W) move_player up ;;
        s|S) move_player down;;
        a|A) move_player left;;
        d|D) move_player right;;
        q|Q) game_over ;;
    esac
}
move_player() {
    local dx=0
    local dy=0
    case $1 in
        up) ((dx=-1)) ;;
        down) ((dx=1));;
        left) ((dy=-1));;
        right) ((dy=1));;
    esac

    new_x=$((PLAYER_X + dx))
    new_y=$((PLAYER_Y + dy))

    if (( new_x < 0 || new_x >= MAP_LENGTH || new_y < 0 || new_y >= MAP_WIDTH )); then
        return  # nie ruszaj – ściana
    fi

    MAP["$PLAYER_X,$PLAYER_Y"]="."
    PLAYER_X=$new_x
    PLAYER_Y=$new_y
    MAP["$PLAYER_X,$PLAYER_Y"]="P"

    tput cnorm

}
check_tile() {
    ;
}
combat_phase() {
    :
}
loot_item() {
    :
}
game_over() {
    :
}


main() {
    init_game
    while true; do
        draw_map
        handle_input

    done
}

main