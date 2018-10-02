//TORCH NanoTrasen Uniforms - DO NOT ADD NEW UNIFORMS TO UNIFORM.DMI - TORCH NANOTRASEN UNIFORMS GO IN NANOTRASEN.DMI

/obj/item/clothing/under/rank/guard
	name = "corporate security uniform"
	desc = "A durable uniform worn by Torch, Ltd. security."
	icon_state = "guard"
	item_state = "w_suit"
	worn_state = "guard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)

/obj/item/clothing/under/rank/guard/nanotrasen
	desc = "A durable uniform worn by NanoTrasen security."
	icon_state = "guard_nt"
	worn_state = "guard_nt"

/obj/item/clothing/under/rank/scientist
	name = "polo and pants"
	desc = "A fashionable polo and pair of trousers made from patented biohazard-resistant synthetic fabrics."
	icon_state = "smock"
	item_state = "w_suit"
	worn_state = "smock"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)
	starting_accessories = list(/obj/item/clothing/accessory/tunic)

/obj/item/clothing/under/rank/scientist/nanotrasen
	name = "\improper NanoTrasen polo and pants"
	desc = "A fashionable polo and pair of trousers belonging to the NanoTrasen corporation, a megacorporation that is primarily concerned with the research of new and dangerous technologies."
	starting_accessories = list(/obj/item/clothing/accessory/tunic/nanotrasen)

/obj/item/clothing/under/rank/scientist/executive
	name = "executive polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a Torch, Ltd. higher-up."
	icon_state = "smockexec"
	worn_state = "smockexec"
	starting_accessories = list(/obj/item/clothing/accessory/tunic/exec)

/obj/item/clothing/under/rank/scientist/executive/nanotrasen
	name = "\improper NanoTrasen polo and pants"
	desc = "A fashionable polo and pair of trousers made from expensive biohazard-resistant fabrics. The colors denote the wearer as a NanoTrasen higher-up."
	icon_state = "smockexec_nt"
	worn_state = "smockexec_nt"
	starting_accessories = list(/obj/item/clothing/accessory/tunic/exec/nanotrasen)

/obj/item/clothing/under/rank/ntwork
	name = "beige coveralls"
	desc = "A pair of beige coveralls made of a strong, canvas-like fabric."
	icon_state = "work"
	item_state = "lb_suit"
	worn_state = "work"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)

/obj/item/clothing/under/rank/ntwork/nanotrasen
	icon_state = "work_nt"
	worn_state = "work_nt"

/obj/item/clothing/under/rank/ntpilot
	name = "flight suit"
	desc = "A sleek flight suit. It proudly sports three different patches with corporate logos on them, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "pilot"
	item_state = "g_suit"
	worn_state = "pilot"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)

/obj/item/clothing/under/rank/ntpilot/nanotrasen
	name = "\improper NanoTrasen flight suit"
	desc = "A sleek red NanoTrasen flight suit. It proudly sports three different patches with corporate logos on them, as well as several unnecessary looking flaps and pockets for effect."
	icon_state = "pilot_nt"
	item_state = "r_suit"
	worn_state = "pilot_nt"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)

/obj/item/clothing/under/suit_jacket/corp
	name = "executive suit"
	desc = "A set of suit pants and shirt that companies tend to give to their executives."
	icon_state = "suit_tl"
	item_state = "bl_suit"
	worn_state = "suit_tl"
	item_icons = list(slot_w_uniform_str = 'icons/mob/onmob/nanotrasen.dmi')
	starting_accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket, /obj/item/clothing/accessory/corptie)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/nanotrasen.dmi',
		)

/obj/item/clothing/under/suit_jacket/corp/nanotrasen
	desc = "A set of NanoTrasen-issued suit pants and shirt that particularly enthusiastic company executives tend to wear."
	icon_state = "suit_nt"
	worn_state = "suit_nt"
	starting_accessories = list(/obj/item/clothing/accessory/toggleable/corpjacket/nanotrasen, /obj/item/clothing/accessory/corptie/nanotrasen)