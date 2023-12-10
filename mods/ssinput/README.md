
#### Список PRов:

- https://github.com/SierraBay/SierraBay12/pull/908
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## SSinput

ID мода: SSINPUT
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Кейбинды, диагональное передвижение и русская раскладка - то, что делает этот мод.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- `code/__defines/subsystem-priority.dm`: `#define SS_PRIORITY_INPUT`
- `code/__defines/subsystems.dm`: `#define SS_INIT_INPUT`
- `code/_onclick/click.dm`: `/mob/proc/MiddleClickOn()`
- `code/game/verbs/ooc.dm`: `/client/verb/ooc()`, `/client/verb/looc()`
- `code/modules/admin/callproc/callproc.dm`: `/client/Click()`
- `code/modules/client/client_procs.dm`: `/client/New()`, `/client/verb/toggle_fullscreen()`
- `code/modules/goonchat/browserOutput.dm`: `/datum/chatOutput/Topic()`
- `code/modules/mob/living/silicon/robot/login.dm`: `/mob/living/silicon/robot/Login()`
- `code/modules/mob/observer/ghost/ghost.dm`: `/mob/observer/ghost/appearance_flags`
- `code/modules/mob/login.dm`: `/mob/Login()`
- `code/modules/mob/mob_defines.dm`: `/mob/appearance_flags`
- `code/modules/mob/mob_helpers.dm`: `/mob/verb/a_intent_change()`

<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- `mods/ssinput/code/general/client.dm`: `/client/Topic()`
- `mods/ssinput/code/general/preferences.dm`: `/datum/preferences/setup()`
- `mods/ssinput/code/global_lists.dm`: `/hook/global_init/makeDatumRefLists()`
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- `code/__defines/subsystem-priority.dm`: `SS_PRIORITY_INPUT`
- `code/__defines/subsystems.dm`: `SS_INIT_INPUT`
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
