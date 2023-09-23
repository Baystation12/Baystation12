$COLOR_RESET = [char]27 + '[0m'
$COLOR_GREEN = [char]27 + '[32m'
$COLOR_BLUE  = [char]27 + '[36m'

$script_dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mod_name = ""
$mod_name_upper = ""
$mod_name_lower = ""

while (-not $mod_name) {
  Write-Host "${COLOR_GREEN}| ${COLOR_RESET}Название мода пишется заглавными буквами, а также с"
  Write-Host "${COLOR_GREEN}| ${COLOR_RESET}использованием подчёркиваний вместо пробелов или тире."
  Write-Host "${COLOR_GREEN}| ${COLOR_RESET}Пример: COOKIE_FACTORY"
  $mod_name = Read-Host "${COLOR_BLUE}> ${COLOR_RESET}Введи название мода"
  Write-Host
  $mod_name = $mod_name -replace '\s|-', '_'

  $mod_name_upper = $mod_name.ToUpper()
  $mod_name_lower = $mod_name.ToLower()

  Write-Host "${COLOR_GREEN}| ${COLOR_RESET}Выбранное название: ${mod_name_upper} / ${mod_name_lower}"
  $confirmation = Read-Host "${COLOR_BLUE}> ${COLOR_RESET}Всё верно? (Y/n)"
  Write-Host
  if ($confirmation -and $confirmation.ToLower() -ne "y") {
    $mod_name = ""
  }
}

if (-Not (Test-Path "$script_dir\_example" -PathType Container)) {
    Write-Host "Папка mods\_example не найдена. Убедись что она существует и попробуй ещё раз."
    Exit
}

$modpack_dir = Join-Path -Path $script_dir -ChildPath $mod_name_lower
if (Test-Path "$modpack_dir" -PathType Container) {
    Write-Host "Папка mods\$mod_name_lower уже существует."
    Exit
}

New-Item -ItemType Directory -Path "$modpack_dir" | Out-Null
Copy-Item -Path "$script_dir\_example\*" -Destination "$modpack_dir"

# Rename files
Get-ChildItem "$modpack_dir" | ForEach-Object {
    $newName = $_.Name -replace "_example", "_$mod_name_lower"
    Rename-Item -Path $_.FullName -NewName $newName
}

# Process and update content of all the files
Get-ChildItem "$modpack_dir\*.*" | ForEach-Object {
    $content = Get-Content $_.FullName | ForEach-Object {
        $_ -creplace "EXAMPLE", $mod_name_upper -creplace "example", $mod_name_lower
    }
    $content | Set-Content $_.FullName
}

Write-Host "Готово! Файлы для мода $mod_name_upper созданы."
Write-Host "Находятся они в папке mods/$mod_name_lower."
