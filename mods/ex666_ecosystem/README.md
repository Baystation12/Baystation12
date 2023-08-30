
#### Список PRов:

- https://github.com/SierraBay/SierraBay12/pull/901
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## Экосистема EX666

ID мода: EX666_ECOSYSTEM
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Подключает Сьерру к экосистеме EX666.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- `code/contorllers/configuration.dm`:
  - `/datum/configuration/proc/load_config()`
  - `/datum/configuration/proc/load_sql()`
- `code/game/world.dm`: `/world/Topic()`
- `code/modules/admin/DB ban/functions.dm`:
  - `/proc/_DB_ban_record()`
  - `/datum/admins/proc/DB_ban_unban()`
  - `/datum/admins/proc/DB_ban_unban_by_id()`
  - `/datum/admins/proc/DB_ban_panel()`
- `code/modules/admin/IsBanned.dm`: `/world/IsBanned()`
- `code/modules/admin/admin.dm`: `/datum/admins/proc/show_player_panel()`
- `code/modules/admin/admin_ranks.dm`:
  - `/proc/load_admin_ranks()`
  - `/proc/load_admins()`
- `code/modules/admin/banjob.dm`: `/proc/jobban_loadbanfile()`
- `code/modules/admin/connectioncheck/bancheck_functions.dm`:
  - `/proc/_fetch_bans()`
  - `/proc/_find_bans_in_connections()`
- `code/modules/admin/topic.dm`: `/datum/admins/Topic()`
- `code/modules/new_player/login.dm`: `/mob/new_player/Login()`
- `code/modules/client/client_procs.dm`: `/client/New()`
<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- `mods/_master_files/code/modules/mob/new_player/new_player.dm`: `/mob/new_player/Topic()`
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- Отсутствуют
<!--
  Если требовалось добавить какие-либо дефайны, укажи файлы,
  в которые ты их добавил, а также перечисли имена.
  И то же самое, если ты используешь дефайны, определённые другим модом.

  Не используешь - напиши "Отсутствуют"
-->

### Используемые файлы, не содержащиеся в модпаке

- Отсутствуют
<!--
  Будь то немодульный файл или модульный файл, который не содержится в папке,
  принадлежащей этому конкретному моду, он должен быть упомянут здесь.
  Хорошими примерами являются иконки или звуки, которые используются одновременно
  несколькими модулями, или что-либо подобное.
-->

### Авторы:

SuhEugene
<!--
  Здесь находится твой никнейм
  Если работал совместно - никнеймы тех, кто помогал.
  В случае порта чего-либо должна быть ссылка на источник.
-->
