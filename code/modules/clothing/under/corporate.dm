//TORCH CORPORATE UNIFORMS - DO NOT ADD NEW UNIFORMS TO UNIFORM.DMI - TORCH CORPORATE UNIFORMS GO IN CORPORATE.DMI

//EXO
/obj/item/clothing/under/rank/guard
	name = "green security guard uniform"
	desc = "A durable uniform worn by Expeditionary Corps Organisation security."
	icon_state = "guard"
	item_state = "w_suit"
	worn_state = "guard"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

/obj/item/clothing/under/rank/scientist
	name = "\improper EXO polo and pants"
	desc = "A fashionable polo and pair of trousers made from patented biohazard-resistant synthetic fabrics."
	icon_state = "smock"
	item_state = "w_suit"
	worn_state = "smock"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)
	accessories = list(/obj/item/clothing/accessory/tunic)

/obj/item/clothing/under/rank/scientist/executive
	name = "\improper EXO polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a Expeditionary Corps Organisation higher-up."
	icon_state = "smockexec"
	worn_state = "smockexec"
	accessories = list(/obj/item/clothing/accessory/tunic/exec)

/obj/item/clothing/under/rank/ntwork
	name = "beige and green coveralls"
	desc = "A pair of beige coveralls made of a strong, canvas-like fabric."
	icon_state = "work"
	item_state = "lb_suit"
	worn_state = "work"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_MINOR
		)
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

/obj/item/clothing/under/rank/ntpilot
	name = "green flight suit"
	desc = "A sleek green Expeditionary Corps Organisation flight suit. It proudly sports three different patches with corporate logos on them, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "pilot"
	item_state = "g_suit"
	worn_state = "pilot"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

/obj/item/clothing/under/suit_jacket/corp
	name = "\improper EXO executive suit"
	desc = "A set of Expeditionary Corps Organisation-issued suit pants and shirt that particularly enthusiastic company executives tend to wear."
	icon_state = "suit"
	item_state = "bl_suit"
	worn_state = "suit"
	accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket, /obj/item/clothing/accessory/corptie)
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	gender_icons = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

//NanoTrasen
/obj/item/clothing/under/rank/guard/nanotrasen
	name = "red security guard uniform"
	desc = "A durable uniform worn by subcontracted NanoTrasen security."
	icon_state = "guard_nt"
	worn_state = "guard_nt"

/obj/item/clothing/under/rank/scientist/nanotrasen
	name = "\improper NanoTrasen polo and pants"
	desc = "A fashionable polo and pair of trousers belonging to NanoTrasen, a megacorporation primarily concerned with the research of new and dangerous technologies."
	icon_state = "smock_nt"
	worn_state = "smock_nt"
	accessories = list(/obj/item/clothing/accessory/tunic/nanotrasen)

/obj/item/clothing/under/rank/scientist/executive/nanotrasen
	name = "\improper NanoTrasen polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a NanoTrasen higher-up."
	icon_state = "smockexec_nt"
	worn_state = "smockexec_nt"
	accessories = list(/obj/item/clothing/accessory/tunic/exec/nanotrasen)

/obj/item/clothing/under/rank/ntwork/nanotrasen
	name = "beige and red coveralls"
	icon_state = "work_nt"
	worn_state = "work_nt"

/obj/item/clothing/under/rank/ntpilot/nanotrasen
	name = "red flight suit"
	desc = "A sleek red NanoTrasen flight suit. It proudly sports three different patches with corporate logos on them, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "pilot_nt"
	item_state = "r_suit"
	worn_state = "pilot_nt"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

/obj/item/clothing/under/suit_jacket/corp/nanotrasen
	name = "\improper NanoTrasen executive suit"
	desc = "A set of NanoTrasen-issued suit pants and shirt that particularly enthusiastic company executives tend to wear."
	icon_state = "suit_nt"
	worn_state = "suit_nt"
	accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket/nanotrasen, /obj/item/clothing/accessory/corptie/nanotrasen)

//Heph. Industries
/obj/item/clothing/under/rank/guard/heph
	name = "cyan security guard uniform"
	desc = "A durable uniform worn by subcontracted Hephaestus Industries security."
	icon_state = "guard_heph"
	worn_state = "guard_heph"

/obj/item/clothing/under/rank/scientist/heph
	name = "\improper Hephaestus polo and pants"
	desc = "A fashionable polo and pair of trousers belonging to Hephaestus Industries, a megacorporation primarily concerned with the research and production of weapon systems."
	icon_state = "smock_heph"
	worn_state = "smock_heph"
	accessories = list(/obj/item/clothing/accessory/tunic/heph)

/obj/item/clothing/under/rank/scientist/executive/heph
	name = "\improper Hephaestus polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a Hephaestus Industries higher-up."
	icon_state = "smockexec_heph"
	worn_state = "smockexec_heph"
	accessories = list(/obj/item/clothing/accessory/tunic/exec/heph)

/obj/item/clothing/under/rank/ntwork/heph
	name = "grey and cyan coveralls"
	icon_state = "work_heph"
	worn_state = "work_heph"

/obj/item/clothing/under/rank/ntpilot/heph
	name = "cyan flight suit"
	desc = "A sleek cyan Hephaestus Industries flight suit. It proudly sports three different patches with corporate logos on them, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "pilot_heph"
	worn_state = "pilot_heph"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_under_corporate.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_corporate_unathi.dmi',
		)

/obj/item/clothing/under/suit_jacket/corp/heph
	name = "\improper Hephaestus executive suit"
	desc = "A set of Hephaestus Industries-issued suit pants and shirt that particularly enthusiastic company executives tend to wear."
	icon_state = "suit_heph"
	worn_state = "suit_heph"
	accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket/heph, /obj/item/clothing/accessory/corptie/heph)

//Zeng-Hu
/obj/item/clothing/under/rank/scientist/zeng
	name = "\improper Zeng-Hu polo and pants"
	desc = "A fashionable polo and pair of trousers belonging to Zeng-Hu Pharmaceuticals, a megacorporation primarily concerned with the research and production of medical equipment and pharmaceuticals."
	icon_state = "smock_zeng"
	worn_state = "smock_zeng"
	accessories = list(/obj/item/clothing/accessory/tunic/zeng)

/obj/item/clothing/under/rank/scientist/executive/zeng
	name = "\improper Zeng-Hu polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a Zeng-Hu Pharmaceuticals higher-up."
	icon_state = "smockexec_zeng"
	worn_state = "smockexec_zeng"
	accessories = list(/obj/item/clothing/accessory/tunic/exec/zeng)

/obj/item/clothing/under/rank/ntwork/zeng
	name = "beige and gold coveralls"
	icon_state = "work_zeng"
	worn_state = "work_zeng"

/obj/item/clothing/under/suit_jacket/corp/zeng
	name = "\improper Zeng-Hu executive suit"
	desc = "A set of Zeng-Hu Pharmaceuticals-issued suit pants and shirt that particularly enthusiastic company executives tend to wear."
	icon_state = "suit_zeng"
	worn_state = "suit_zeng"
	accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket/zeng, /obj/item/clothing/accessory/corptie/zeng)
