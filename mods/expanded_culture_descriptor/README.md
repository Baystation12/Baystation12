
#### Список PRов:

- https://github.com/SierraBay/SierraBay12/pull/1442
<!--
  Ссылки на PRы, связанные с модом:
  - Создание
  - Большие изменения
-->

<!-- Название мода. Не важно на русском или на английском. -->
## Expanded Culture Descriptor

ID мода: EXPANDED_CULTURE_DESCRIPTOR
<!--
  Название модпака прописными буквами, СОЕДИНЁННЫМИ_ПОДЧЁРКИВАНИЕМ,
  которое ты будешь использовать для обозначения файлов.
-->

### Описание мода

Мод включает в себя полный перевод редактора происхождения персонажа, 
а также добавляет новые варианты происхождений на основании лора и 
контента билда Infinity.
- Редактор бэкграунда персонажей полностью переведен, включая все культуры, происхождения, религии и фракции, существующие на SierraBay и в соседствующих модах;
- Для людей, унати и скреллов добавлены культуры, происхождения и фракции, что были доступны для них на Infinity, но не имелись в наличии на SierraBay;
- Добавлены языки, соответствующие новым культурам - мираниский, авалонский, лорриманский;
- Добавлена новая обложка для миранийского паспорта, улучшено описание авалонского паспорта, добавлены отдельные паспорта для фракций унати.
<!--
  Что он делает, что добавляет: что, куда, зачем и почему - всё здесь.
  А также любая полезная информация.
-->

### Изменения *кор кода*

- `code/__defines/culture.dm`:
  - `#define TAG_CULTURE`
  - `#define TAG_HOMEWORLD`
  - `#define TAG_FACTION`
  - `#define TAG_RELIGION`
- `code/modules/client/preference_setup/background/01_culture.dm`: `/datum/category_item/player_setup_item/background/culture/content()`
- `code/modules/client/preference_setup/background/02_language.dm`:
  - `/datum/category_item/player_setup_item/background/languages/content()`
  - `/datum/category_item/player_setup_item/background/languages/OnTopic()`
  - `/datum/category_item/player_setup_item/background/languages/proc/get_language_text()`
- `code/modules/client/preference_setup/background/03_records.dm`:
  - `/datum/category_item/player_setup_item/background/records/content()`
  - `/datum/category_item/player_setup_item/background/records/OnTopic()`
- `code/modules/culture_descriptor/culture/cultures_serpentid.dm`: `/singleton/cultural_info/culture/nabber/New()`
- `code/modules/culture_descriptor/location/_location.dm`: `/singleton/cultural_info/location/get_text_details()`
- `code/modules/species/species.dm`: `/datum/species/New()`
<!--
  Если вы редактировали какие-либо процедуры или переменные в кор коде,
  они должны быть указаны здесь.
  Нужно указать и файл, и процедуры/переменные.

  Изменений нет - напиши "Отсутствуют"
-->

### Оверрайды

- `mods/_master_files/code/modules/culture_descriptor/_culture.dm`:
  - `/singleton/cultural_info/get_text_details()`
  - `/singleton/cultural_info/get_description()`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_adherent.dm`: `/singleton/cultural_info/culture/adherent`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_diona.dm`: `/singleton/cultural_info/culture/diona`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_human.dm`:
  - `/singleton/cultural_info/culture/generic`
  - `/singleton/cultural_info/culture/human`
  - `/singleton/cultural_info/culture/human/martian_surfacer`
  - `/singleton/cultural_info/culture/human/martian_tunneller`
  - `/singleton/cultural_info/culture/human/luna_poor`
  - `/singleton/cultural_info/culture/human/luna_rich`
  - `/singleton/cultural_info/culture/human/venusian_upper`
  - `/singleton/cultural_info/culture/human/venusian_surfacer`
  - `/singleton/cultural_info/culture/human/belter`
  - `/singleton/cultural_info/culture/human/plutonian`
  - `/singleton/cultural_info/culture/human/earthling`
  - `/singleton/cultural_info/culture/human/ceti_north`
  - `/singleton/cultural_info/culture/human/ceti_south`
  - `/singleton/cultural_info/culture/human/ceti_interstate`
  - `/singleton/cultural_info/culture/human/spacer_core`
  - `/singleton/cultural_info/culture/human/spacer_frontier`
  - `/singleton/cultural_info/culture/human/confederate`
  - `/singleton/cultural_info/culture/human/gaia`
  - `/singleton/cultural_info/culture/human/other`
  - `/singleton/cultural_info/culture/human/vatgrown`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_ipc.dm`:
  - `/singleton/cultural_info/culture/ipc`
  - `/singleton/cultural_info/culture/ipc/gen2`
  - `/singleton/cultural_info/culture/ipc/gen3`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_serpentid.dm`:
  - `/singleton/cultural_info/culture/nabber`
  - `/singleton/cultural_info/culture/nabber/c`
  - `/singleton/cultural_info/culture/nabber/c/plus`
  - `/singleton/cultural_info/culture/nabber/b`
  - `/singleton/cultural_info/culture/nabber/b/minus`
  - `/singleton/cultural_info/culture/nabber/b/plus`
  - `/singleton/cultural_info/culture/nabber/a`
  - `/singleton/cultural_info/culture/nabber/a/minus`
  - `/singleton/cultural_info/culture/nabber/a/plus`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_skrell.dm`:
  - `/singleton/cultural_info/culture/skrell`
  - `/singleton/cultural_info/culture/skrell/caste_malish`
  - `/singleton/cultural_info/culture/skrell/caste_kanin`
  - `/singleton/cultural_info/culture/skrell/caste_talum`
  - `/singleton/cultural_info/culture/skrell/caste_raskinta`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_unathi.dm`:
  - `/singleton/cultural_info/culture/unathi`
  - `/singleton/cultural_info/culture/unathi_polar`
  - `/singleton/cultural_info/culture/unathi_desert`
  - `/singleton/cultural_info/culture/unathi_savannah`
  - `/singleton/cultural_info/culture/unathi_salt_swamp`
  - `/singleton/cultural_info/culture/unathi_space`
  - `/singleton/cultural_info/culture/unathi_yeosa`
  - `/singleton/cultural_info/culture/unathi_yeosa_abyss`
- `mods/_master_files/code/modules/culture_descriptor/culture/cultures_vox.dm`:
  - `/singleton/cultural_info/culture/vox`
  - `/singleton/cultural_info/culture/vox/salvager`
  - `/singleton/cultural_info/culture/vox/raider`
- `mods/_master_files/code/modules/culture_descriptor/faction/factions_adherent.dm`:
  - `/singleton/cultural_info/faction/adherent`
  - `/singleton/cultural_info/faction/adherent/loyalists`
  - `/singleton/cultural_info/faction/adherent/separatists`
- `mods/_master_files/code/modules/culture_descriptor/faction/factions_human.dm`:
  - `/singleton/cultural_info/faction/scg`
  - `/singleton/cultural_info/faction/scg/fleet`
  - `/singleton/cultural_info/faction/torchco`
  - `/singleton/cultural_info/faction/gcc`
  - `/singleton/cultural_info/faction/remote`
  - `/singleton/cultural_info/faction/remote/nanotrasen`
  - `/singleton/cultural_info/faction/remote/xynergy`
  - `/singleton/cultural_info/faction/remote/hephaestus`
  - `/singleton/cultural_info/faction/free`
  - `/singleton/cultural_info/faction/pcrc`
  - `/singleton/cultural_info/faction/saare`
  - `/singleton/cultural_info/faction/dais`
  - `/singleton/cultural_info/faction/other`
- `mods/_master_files/code/modules/culture_descriptor/faction/factions_skrell.dm`:
  - `/singleton/cultural_info/faction/skrell`
  - `/singleton/cultural_info/faction/skrell/qalaoa`
  - `/singleton/cultural_info/faction/skrell/yiitalana`
  - `/singleton/cultural_info/faction/skrell/krrigli`
  - `/singleton/cultural_info/faction/skrell/qonprri`
  - `/singleton/cultural_info/faction/skrell/otherskrellfac`
  - `/singleton/cultural_info/faction/skrell/othersdtf`
- `mods/_master_files/code/modules/culture_descriptor/faction/factions_unathi.dm`:
  - `/singleton/cultural_info/faction/unathi`
  - `/singleton/cultural_info/faction/unathi/ssen_uuma`
  - `/singleton/cultural_info/faction/unathi/baask`
  - `/singleton/cultural_info/faction/unathi/gresis`
  - `/singleton/cultural_info/faction/unathi/rahzakeh`
  - `/singleton/cultural_info/faction/unathi/kharza`
  - `/singleton/cultural_info/faction/unathi/independent`
- `mods/_master_files/code/modules/culture_descriptor/faction/factions_vox.dm`:
  - `/singleton/cultural_info/faction/vox`
  - `/singleton/cultural_info/faction/vox/raider`
  - `/singleton/cultural_info/faction/vox/apex`
- `mods/_master_files/code/modules/culture_descriptor/location/_location.dm`:
  - `/singleton/cultural_info/location`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_adherent.dm`:
  - `/singleton/cultural_info/location/adherent`
  - `/singleton/cultural_info/location/adherent/monument`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_diona.dm`:
  - `/singleton/cultural_info/location/epsilon`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_human.dm`:
  - `/singleton/cultural_info/location/human`
  - `/singleton/cultural_info/location/human/earth`
  - `/singleton/cultural_info/location/human/luna`
  - `/singleton/cultural_info/location/human/venus`
  - `/singleton/cultural_info/location/human/ceres`
  - `/singleton/cultural_info/location/human/pluto`
  - `/singleton/cultural_info/location/human/cetiepsilon`
  - `/singleton/cultural_info/location/human/eos`
  - `/singleton/cultural_info/location/human/terra`
  - `/singleton/cultural_info/location/human/saffar`
  - `/singleton/cultural_info/location/human/tadmor`
  - `/singleton/cultural_info/location/human/pirx`
  - `/singleton/cultural_info/location/human/brahe`
  - `/singleton/cultural_info/location/human/iolaus`
  - `/singleton/cultural_info/location/human/gaia`
  - `/singleton/cultural_info/location/human/magnitka`
  - `/singleton/cultural_info/location/human/castilla`
  - `/singleton/cultural_info/location/human/fosters`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_other.dm`:
  - `/singleton/cultural_info/location/stateless`
  - `/singleton/cultural_info/location/other`
  - `/singleton/cultural_info/location/deep_space`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_serpentids.dm`:
  - `/singleton/cultural_info/location/tauwilo`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_skrell.dm`:
  - `/singleton/cultural_info/location/qerrbalak`
  - `/singleton/cultural_info/location/talamira`
  - `/singleton/cultural_info/location/roasora`
  - `/singleton/cultural_info/location/mitorqi`
  - `/singleton/cultural_info/location/skrellspace`
  - `/singleton/cultural_info/location/otherskrell`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_unathi.dm`:
  - `/singleton/cultural_info/location/moghes`
  - `/singleton/cultural_info/location/ouere`
  - `/singleton/cultural_info/location/offworld`
- `mods/_master_files/code/modules/culture_descriptor/location/locations_vox.dm`:
  - `/singleton/cultural_info/location/vox`
  - `/singleton/cultural_info/location/vox/shroud`
  - `/singleton/cultural_info/location/vox/ship`
- `mods/_master_files/code/modules/culture_descriptor/religion/religions_human.dm`:
  - `/singleton/cultural_info/religion/other`
  - `/singleton/cultural_info/religion/unstated`
  - `/singleton/cultural_info/religion/jewish` 
  - `/singleton/cultural_info/religion/hindu` 
  - `/singleton/cultural_info/religion/buddhist` 
  - `/singleton/cultural_info/religion/jain` 
  - `/singleton/cultural_info/religion/sikh` 
  - `/singleton/cultural_info/religion/muslim` 
  - `/singleton/cultural_info/religion/christian` 
  - `/singleton/cultural_info/religion/bahai` 
  - `/singleton/cultural_info/religion/agnostic` 
  - `/singleton/cultural_info/religion/deist` 
  - `/singleton/cultural_info/religion/atheist` 
  - `/singleton/cultural_info/religion/thelemite` 
  - `/singleton/cultural_info/religion/spiritualism` 
  - `/singleton/cultural_info/religion/shinto` 
  - `/singleton/cultural_info/religion/taoist`
- `mods/_master_files/code/modules/culture_descriptor/religion/religions_skrell.dm`:
  - `/singleton/cultural_info/religion/warble`
- `mods/_master_files/code/modules/culture_descriptor/religion/religions_unathi.dm`:
  - `/singleton/cultural_info/religion/unathi`
  - `/singleton/cultural_info/religion/unathi_precursors`
  - `/singleton/cultural_info/religion/unathi_strat`
  - `/singleton/cultural_info/religion/unathi_lights`
  - `/singleton/cultural_info/religion/unathi_markesh`
  - `/singleton/cultural_info/religion/unathi_ancestor`
  - `/singleton/cultural_info/religion/unathi_aga_eakhe`
- `mods/_master_files/code/modules/culture_descriptor/religion/religions_vox.dm`: `/singleton/cultural_info/religion/vox`
<!--
  Если ты добавлял новый модульный оверрайд, его нужно указать здесь.
  Здесь указываются оверрайды в твоём моде и папке `_master_files`

  Изменений нет - напиши "Отсутствуют"
-->

### Дефайны

- `code/__defines/~mods/expanded_culture_descriptor.dm`:
  - `HOME_SYSTEM_UNATHI_TERSTEN`
  - `FACTION_UNATHI_TERSTEN`
  - `CULTURE_UNATHI_TERSTEN`
  - `FACTION_ZENG_HU`
  - `FACTION_WARD_TAKAHASHI`
  - `FACTION_GRAYSON`
  - `FACTION_AERTHER`
  - `FACTION_MAJOR_BILL`
  - `FACTION_FOCAL_POINT`
  - `FACTION_XION`
  - `FACTION_VEY_MED`
  - `FACTION_BISHOP`
  - `FACTION_MORPHEUS`
  - `FACTION_ZPCI`
  - `FACTION_SEPTENERGO`
  - `CULTURE_HUMAN_LORRIMAN`
  - `CULTURE_HUMAN_AVANOBLE`
  - `CULTURE_HUMAN_AVACOMMON`
  - `CULTURE_HUMAN_LORDUP`
  - `CULTURE_HUMAN_LORDLOW`
  - `CULTURE_HUMAN_MIRANIAN`
  - `CULTURE_HUMAN_NYXIAN`
  - `HOME_SYSTEM_TERSTEN`
  - `HOME_SYSTEM_AVALON`
  - `HOME_SYSTEM_MIRANIA`
  - `HOME_SYSTEM_NYX_BRINKBURN`
  - `HOME_SYSTEM_NYX_KALDARK`
  - `HOME_SYSTEM_NYX_ROANOK`
  - `HOME_SYSTEM_NYX_YUKLIT`
  - `HOME_SYSTEM_NYX_CASSER`
  - `FACTION_SKRELL_MED`
  - `FACTION_SKRELL_AIR`
  - `FACTION_SKRELL_FOOD`
  - `FACTION_POSITRONICS`
  - `HOME_SYSTEM_ROOT`
  - `LANGUAGE_HUMAN_LORRIMAN`
  - `LANGUAGE_HUMAN_AVALON`
  - `LANGUAGE_HUMAN_MIRANIAN`
- `code/__defines/culture.dm`:
  - `TAG_CULTURE`
  - `TAG_HOMEWORLD`
  - `TAG_FACTION`
  - `TAG_RELIGION`
<!--
  Если требовалось добавить какие-либо дефайны, укажи файлы,
  в которые ты их добавил, а также перечисли имена.
  И то же самое, если ты используешь дефайны, определённые другим модом.

  Не используешь - напиши "Отсутствуют"
-->

### Используемые файлы, не содержащиеся в модпаке

Отсутствуют
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
