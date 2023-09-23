#!/bin/bash

COLOR_RESET='\033[0m'
COLOR_GREEN='\033[32m'
COLOR_BLUE='\033[36m'

mod_name=""
mod_name_upper=""
mod_name_lower=""

script_dir=$(dirname "$0")

while [ -z "$mod_name" ]; do
  echo -e "${COLOR_GREEN}| ${COLOR_RESET}Название мода пишется заглавными буквами, а также с"
  echo -e "${COLOR_GREEN}| ${COLOR_RESET}использованием подчёркиваний вместо пробелов или тире."
  echo -e "${COLOR_GREEN}| ${COLOR_RESET}Пример: COOKIE_FACTORY"
  echo -en "${COLOR_BLUE}> ${COLOR_RESET}Введи название мода: "
  read mod_name
  echo

  mod_name=$(echo "$mod_name" | sed -E 's/\s|-/_/g')

  mod_name_upper=$(echo "$mod_name" | tr '[:lower:]' '[:upper:]')
  mod_name_lower=$(echo "$mod_name" | tr '[:upper:]' '[:lower:]')

  echo -e "${COLOR_GREEN}| ${COLOR_RESET}Выбранное название: ${mod_name_upper} / ${mod_name_lower}"
  echo -en "${COLOR_BLUE}> ${COLOR_RESET}Всё верно? (Y/n) "
  read confirmation
  echo

  confirmation=${confirmation:-y}
  if [ "${confirmation,,}" != "y" ]; then
    mod_name=""
  fi
done

if [ ! -d "$script_dir/_example" ]; then
  echo "Папка mods/_example не найдена. Убедись что она существует и попробуй ещё раз."
  exit 1
fi

if [ -d "$script_dir/$mod_name_lower" ]; then
  echo "Папка mods/$mod_name_lower уже существует."
  exit 1
fi

mkdir -p "$script_dir/$mod_name_lower"
cp "$script_dir/_example/"* "$script_dir/$mod_name_lower/"

# Rename files
for file in "$script_dir/$mod_name_lower"/*example*; do
  new_name=$(echo "$file" | sed -E "s/_example/_$mod_name_lower/")
  mv "$file" "$new_name"
done

# Process and update content of all the files
for file in "$script_dir/$mod_name_lower"/*; do
  sed -i'' -e "s/EXAMPLE/$mod_name_upper/g" -e "s/example/$mod_name_lower/g" "$file"
done

echo "Готово! Файлы для мода $mod_name_upper созданы."
echo "Находятся они в папке mods/$mod_name_lower."
