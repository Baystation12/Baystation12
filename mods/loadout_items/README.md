
#### Список PRов:

- https://github.com/SierraBay/SierraBay12/pull/1562
- https://github.com/SierraBay/SierraBay12/pull/1643
- https://github.com/SierraBay/SierraBay12/pull/1650
- https://github.com/SierraBay/SierraBay12/pull/1761
- https://github.com/SierraBay/SierraBay12/pull/1856
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## Предметы лодаута

ID мода: LOADOUT_ITEMS
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Модулярно добавленные в билд предметы для лодаута.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- `code/controllers/subsystems/jobs.dm`:
  - `/datum/controller/subsystem/jobs/proc/equip_custom_loadout`
<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- `mods/_master_files/code/modules/clothing/spacesuits/spacesuits.dm`:
  - `/obj/item/clothing/suit/space/var/valid_accessory_slots`
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- `code/__defines/~mods/~master_defines.dm`:
  - `ACCESSORY_SLOT_OVER`
<!--
  Если требовалось добавить какие-либо дефайны, укажи файлы,
  в которые ты их добавил, а также перечисли имена.
  И то же самое, если ты используешь дефайны, определённые другим модом.

  Не используешь - напиши "Отсутствуют"
-->

### Используемые файлы, не содержащиеся в модпаке

- `maps\sierra\loadout\loadout_gloves.dm`
- `maps\torch\icons\obj\obj_accessories_solgov.dmi`
- `maps\torch\icons\mob\unathi\onmob_accessories_solgov_unathi.dmi`
- `maps\torch\icons\mob\onmob_accessories_solgov.dmi`
- `maps\torch\icons\obj\obj_under_solgov.dmi`
- `maps\torch\icons\mob\onmob_under_solgov.dmi`
- `maps\torch\icons\mob\unathi\onmob_under_solgov_unathi.dmi`

<!--
  Будь то немодульный файл или модульный файл, который не содержится в папке,
  принадлежащей этому конкретному моду, он должен быть упомянут здесь.
  Хорошими примерами являются иконки или звуки, которые используются одновременно
  несколькими модулями, или что-либо подобное.
-->

### Авторы:

UEDHighCommand
<!--
  Здесь находится твой никнейм
  Если работал совместно - никнеймы тех, кто помогал.
  В случае порта чего-либо должна быть ссылка на источник.
-->
