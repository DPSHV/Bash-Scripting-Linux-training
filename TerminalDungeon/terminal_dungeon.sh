#!/bin/bash

# SET BROKE CONDITION
set -euo pipefail
trap 'tput sgr0; tput cnorm; clear' EXIT

# GLOBAL MAP
declare -A MAP
declare -A ENEMY_HP  # klucz: "x,y" -> wartość HP

# BASIC GAME PARAMS
MAP_LENGTH=8
MAP_WIDTH=8

PLAYER_HP=10
PLAYER_X=0
PLAYER_Y=0

ENEMY_COUNT=3
REMAINING_ENEMIES=$ENEMY_COUNT
ITEM_COUNT=3
GOLD=10
KILL_FLAG=0


# map funtions and flow 
init_game() {
    # map clear
    for key in "${!MAP[@]}"; do unset 'MAP[$key]'; done
    for key in "${!ENEMY_HP[@]}"; do unset 'ENEMY_HP[$key]'; done

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
                ENEMY_HP["$ex,$ey"]=$((RANDOM % 3 + 3))  # potwory 3–5 HP
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
    echo "HP: $PLAYER_HP | GOLD: $GOLD | ENEMIES LEFT: $REMAINING_ENEMIES"
    echo "Use W/A/S/D to move, H to heal (15 gold = +3 HP), Q to Quit"
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

   # pomaga na migające refreshe
    tput sgr0
    sleep 0.1
}

handle_input() {
    tput civis
    read -n1 -s key
    tput cnorm

    case "$key" in 
        w|W) move_player up ;;
        s|S) move_player down ;;
        a|A) move_player left ;;
        d|D) move_player right ;;
        h|H) heal_player ;;
        q|Q) game_over ;;
    esac
}

move_player() {
    local dx=0 dy=0
    case $1 in
        up)    ((dx=-1));;
        down)  ((dx=1));;
        left)  ((dy=-1));;
        right) ((dy=1));;
    esac

    local new_x=$((PLAYER_X + dx))
    local new_y=$((PLAYER_Y + dy))

    # ściany
    if (( new_x < 0 || new_x >= MAP_LENGTH || new_y < 0 || new_y >= MAP_WIDTH )); then
        return
    fi

    # Co jest na polu ? 
    local target="${MAP["$new_x,$new_y"]}"
    KILL_FLAG=0

    case "$target" in
        M)
            combat_phase "$new_x" "$new_y"
            if (( KILL_FLAG == 0 )); then
                return
            fi
            MAP["$new_x,$new_y"]="."
            unset 'ENEMY_HP["$new_x,$new_y"]'
            ;;
        I)
            loot_item
            ;;
        .) : ;;
    esac

    # aktualizacja pozycji
    MAP["$PLAYER_X,$PLAYER_Y"]="."
    PLAYER_X=$new_x
    PLAYER_Y=$new_y
    MAP["$PLAYER_X,$PLAYER_Y"]="P"
}


combat_phase() {
    KILL_FLAG=0
    local ex=$1
    local ey=$2
    local key="$ex,$ey"
    local enemy_hp=${ENEMY_HP["$key"]}
    echo "You engage a monster with $enemy_hp HP!"

    while (( enemy_hp > 0 && PLAYER_HP > 0 )); do
        local player_damage=$((RANDOM % 3 + 1))
        local enemy_damage=$((RANDOM % 3 + 1))

        enemy_hp=$((enemy_hp - player_damage))
        PLAYER_HP=$((PLAYER_HP - enemy_damage))

        echo "You hit for $player_damage, got hit for $enemy_damage."
        echo "Enemy HP: $(( enemy_hp > 0 ? enemy_hp : 0 )), Your HP: $PLAYER_HP"
        sleep 1

        if (( PLAYER_HP <= 0 )); then
            game_over
            return
        fi
    done

    if (( enemy_hp <= 0 )); then
        ((REMAINING_ENEMIES--))
        GOLD=$((GOLD + 5))
        KILL_FLAG=1
        echo "Enemy defeated. +5 gold."
        ENEMY_HP["$key"]=0
        sleep 1
        check_victory
    fi
}


loot_item() {
    local loot_type=$((RANDOM % 2))

    case $loot_type in 
        0)
            PLAYER_HP=$((PLAYER_HP + 3))
            (( PLAYER_HP > 10 )) && PLAYER_HP=10
            echo "You found a potion, HP +3!!! You have $PLAYER_HP HP!"
            ;;
        1)
            GOLD=$((GOLD + 5))
            echo "YOU FOUND A BUNCH OF GOLD COINS! GOLD + 5!"
            ;;
    esac
    sleep 1.5
}


heal_player() {
    # leczenie za gold
    if (( GOLD < 15 )); then
        echo "Not enough gold. You need 15."
        sleep 1.2
        return
    fi

    if (( PLAYER_HP >= 10 )); then
        echo "You're already at full HP."
        sleep 1.2
        return
    fi

    GOLD=$((GOLD - 15))
    PLAYER_HP=$((PLAYER_HP + 3))
    (( PLAYER_HP > 10 )) && PLAYER_HP=10
    echo "You paid 15 gold and restored +3 HP. Current HP: $PLAYER_HP"
    sleep 1.5
}


game_over() {
    tput clear
    tput cnorm

    echo ""
    echo "GAME OVER"
    echo "Your final stats:"
    echo "HP: $PLAYER_HP"
    echo "Gold: $GOLD"
    echo ""

    read -p "Play again? (y/n): " choice
    case "$choice" in
        y|Y)
            exec "$0"
            ;;
        *)
            echo "Thanks for playing, hero!"
            sleep 1
            exit 0
            ;;
    esac
}

check_victory() {
    if (( REMAINING_ENEMIES <= 0 )); then
        tput clear
        echo "ALL ENEMIES DEFEATED. YOU CLEARED THE DUNGEON."
        echo "Final stats: HP $PLAYER_HP, GOLD $GOLD"
        echo ""
        read -p "Play again? (y/n): " choice
        case "$choice" in
            y|Y)
                exec "$0"
                ;;
            *)
                echo "Thanks for playing!"
                sleep 1
                exit 0
                ;;
        esac
    fi
}


main() {
    init_game
    while true; do
        draw_map
        handle_input
    done
}

main
