declare -A MAP

MAP["0,0"]="P"
MAP["1,2"]="M"
MAP["3,3"]="I"

echo "${MAP["0,0"]}"
echo "${MAP["1,2"]}"

for key in "${!MAP[@]}"; do
  echo "Pole: $key → ${MAP[$key]}"
done

unset 'MAP["1,2"]'


[[ -v MAP["0,0"] ]] && echo "Pole zajęte!"
