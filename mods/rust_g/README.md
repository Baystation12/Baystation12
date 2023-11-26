
#### Список PRов:

- https://github.com/SierraBay/SierraBay12/pull/1467
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## RustG

ID мода: RUST_G
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Мод добавляет поддержку растижки - написанной на языке RUST библиотеки, которая
позволяет заменить более быстрыми те функции BYOND'а, которые он делает медленно.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- `code/_helpers/logging.dm`: `/proc/game_log()`
- `code/controllers/master.dm`: `/datum/controller/master/New()`
- `code/controllers/subsystems/garbage.dm`: `/datum/controller/subsystem/garbage/Shutdown()`
- `code/datums/helper_datums/getrev.dm`: `/datum/getrev/New()`
- `code/game/world.dm`:
  - `/world/New()`
  - `/world/Topic()`
  - `/world/Reboot()`
- `code/modules/persistence/persistence_datum.dm`: `/datum/persistent/proc/Shutdown()`
<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- `mods/_master_files/code/game/world.dm`: `/world/save_mode()`
- `mods/_master_files/code/modules/client/preferences_persist.dm`: `/datum/preferences/save_pref_record()`
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- `code/__defines/~mods/rust_g.dm`:
  - `RUST_G`
  - `RUSTG_OVERRIDE_BUILTINS`
  - `RUSTG_CALL`
  - `rustg_setup_acreplace`
  - `rustg_setup_acreplace_with_options`
  - `rustg_acreplace`
  - `rustg_acreplace_with_replacements`
  - `rustg_cnoise_generate`
  - `rustg_dmi_strip_metadata`
  - `rustg_dmi_create_png`
  - `rustg_dmi_resize_png`
  - `rustg_dmi_icon_states`
  - `rustg_file_read`
  - `rustg_file_exists`
  - `rustg_file_write`
  - `rustg_file_append`
  - `rustg_file_get_line_count`
  - `rustg_file_seek_line`
  - `rustg_git_revparse`
  - `rustg_git_commit_date`
  - `RUSTG_HTTP_METHOD_GET`
  - `RUSTG_HTTP_METHOD_PUT`
  - `RUSTG_HTTP_METHOD_DELETE`
  - `RUSTG_HTTP_METHOD_PATCH`
  - `RUSTG_HTTP_METHOD_HEAD`
  - `RUSTG_HTTP_METHOD_POST`
  - `rustg_http_request_blocking`
  - `rustg_http_request_async`
  - `rustg_http_check_request`
  - `RUSTG_JOB_NO_RESULTS_YET`
  - `RUSTG_JOB_NO_SUCH_JOB`
  - `RUSTG_JOB_ERROR`
  - `rustg_json_is_valid`
  - `rustg_log_write`
  - `rustg_log_write_formatted`
  - `rustg_log_write_no_format`
  - `rustg_noise_get_at_coordinates`
  - `rustg_sql_connect_pool`
  - `rustg_sql_query_async`
  - `rustg_sql_query_blocking`
  - `rustg_sql_connected`
  - `rustg_sql_disconnect_pool`
  - `rustg_sql_check_query`
  - `rustg_time_microseconds`
  - `rustg_time_milliseconds`
  - `rustg_time_reset`
  - `rustg_raw_read_toml_file`
  - `rustg_raw_toml_encode`
  - `rustg_url_encode`
  - `rustg_url_decode`
<!--
  Если требовалось добавить какие-либо дефайны, укажи файлы,
  в которые ты их добавил, а также перечисли имена.
  И то же самое, если ты используешь дефайны, определённые другим модом.

  Не используешь - напиши "Отсутствуют"
-->

### Используемые файлы, не содержащиеся в модпаке

- `scripts/install-rust_g.sh`
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
