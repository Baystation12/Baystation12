import os

COLOR_RESET = '\033[0m'
COLOR_GREEN = '\033[32m'
COLOR_BLUE = '\033[36m'

script_dir = os.path.dirname(os.path.realpath(__file__))
mod_name = ""
mod_name_upper = ""
mod_name_lower = ""


while not mod_name:
    print(f"{COLOR_GREEN}| {COLOR_RESET}Название мода пишется заглавными буквами, а также с")
    print(f"{COLOR_GREEN}| {COLOR_RESET}использованием подчёркиваний вместо пробелов или тире.")
    print(f"{COLOR_GREEN}| {COLOR_RESET}Пример: COOKIE_FACTORY")
    mod_name = input(f"{COLOR_BLUE}> {COLOR_RESET}Введи название мода: ")
    print()
    mod_name = mod_name.replace(' ', '_')
    mod_name = mod_name.replace('-', '_')

    mod_name_upper = mod_name.upper()
    mod_name_lower = mod_name.lower()

    print(f"{COLOR_GREEN}| {COLOR_RESET}Выбранное название: {mod_name_upper} / {mod_name_lower}")
    confirmation = input(f"{COLOR_BLUE}> {COLOR_RESET}Всё верно? (Y/n) ").lower()
    print()
    if confirmation and confirmation != "y":
        mod_name = ""

if not os.path.exists(f"{script_dir}/_example"):
    print("Папка mods/_example не найдена. Убедись что она существует и попробуй ещё раз.")
    print()
    input("Нажмите Enter для закрытия...")
    exit()

if os.path.exists(f"{script_dir}/{mod_name_lower}"):
    print(f"Папка mods/{mod_name_lower} уже существует.")
    print()
    input("Нажмите Enter для закрытия...")
    exit()

os.mkdir(f"{script_dir}/{mod_name_lower}")

for filename in os.listdir(f"{script_dir}/_example"):
    source = f"{script_dir}/_example/{filename}"
    destination = f"{script_dir}/{mod_name_lower}/{filename}"
    if os.path.isdir(source):
        continue
    with open(source, 'r', encoding="utf8") as src_file, open(destination, 'w', encoding="utf8") as dest_file:
        dest_file.write(src_file.read().replace("EXAMPLE", mod_name_upper).replace("example", mod_name_lower))


# Rename files
for filename in os.listdir(f"{script_dir}/{mod_name_lower}"):
    new_name = filename.replace("_example", f"_{mod_name_lower}")
    os.rename(f"{script_dir}/{mod_name_lower}/{filename}", f"{script_dir}/{mod_name_lower}/{new_name}")


print(f"Готово! Файлы для мода {mod_name_upper} созданы.")
print(f"Находятся они в папке mods/{mod_name_lower}.")
print()
input("Нажмите Enter для закрытия...")
