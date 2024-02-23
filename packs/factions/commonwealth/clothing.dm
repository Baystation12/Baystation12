/obj/item/clothing/under/commonwealth
	abstract_type = /obj/item/clothing/under/commonwealth
	icon = 'packs/factions/commonwealth/clothing.dmi'
	item_icons = list(
		slot_w_uniform_str = 'packs/factions/commonwealth/clothing.dmi'
	)
	sprite_sheets = list()
	body_parts_covered = FULL_TORSO | ARMS | FULL_LEGS
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)


/obj/item/clothing/under/commonwealth/utility
	name = "commonwealth fatigues"
	desc = {"\
		The classic chocolate-brown fatigues of the explorers and soldiers of the \
		bygone Terran Commonwealth. They're in great condition despite probably \
		being over a century old.\
	"}
	icon_state = "utility"
	item_state_slots = list(
		slot_w_uniform_str = "utility"
	)
	rolled_down = FALSE
	rolled_sleeves = FALSE


/obj/item/clothing/under/commonwealth/utility/army
	accessories = list(
		/obj/item/clothing/accessory/commonwealth_badge/army
	)


/obj/item/clothing/under/commonwealth/utility/navy
	accessories = list(
		/obj/item/clothing/accessory/commonwealth_badge/navy
	)


/obj/item/clothing/under/commonwealth/utility/explorer
	accessories = list(
		/obj/item/clothing/accessory/commonwealth_badge/explorer
	)


/obj/item/clothing/under/commonwealth/earhart
	name = "earhart fatigues"
	desc = {"\
		Faded and greying fatigues that resemble old Commonwealth designs, \
		commonly worn by the Free Peoples of Earhart.\
	"}
	icon_state = "earhart"
	item_state_slots = list(
		slot_w_uniform_str = "earhart"
	)
	accessories = list(
		/obj/item/clothing/accessory/commonwealth_badge/earhart
	)
	rolled_down = FALSE
	rolled_sleeves = FALSE


/obj/item/clothing/suit/commonwealth
	abstract_type = /obj/item/clothing/suit/commonwealth
	icon = 'packs/factions/commonwealth/clothing.dmi'
	item_icons = list(
		slot_wear_suit_str = 'packs/factions/commonwealth/clothing.dmi'
	)
	sprite_sheets = list()
	body_parts_covered = FULL_TORSO | ARMS
	siemens_coefficient = 0.9
	valid_accessory_slots = list(
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_MEDAL
	)
	allowed = list()


/obj/item/clothing/suit/commonwealth/pilot
	name = "commonwealth pilot's jacket"
	desc = {"\
		A stylish brown jacket with blue and green Terran Commonwealth insignia. \
		Commonly worn by pilots of the prior century.\
	"}
	icon_state = "pilot"
	item_state_slots = list(
		slot_wear_suit_str = "pilot_worn"
	)
	accessories = list(
		/obj/item/clothing/accessory/storage/pockets
	)


/obj/item/clothing/head/commonwealth
	abstract_type = /obj/item/clothing/head/commonwealth
	icon = 'packs/factions/commonwealth/clothing.dmi'
	item_icons = list(
		slot_head_str = 'packs/factions/commonwealth/clothing.dmi'
	)
	sprite_sheets = list()


/obj/item/clothing/head/commonwealth/pilotka
	name = "commonwealth pilotka"
	desc = "The folded service cap of the bygone Terran Commonwealth."
	icon_state = "pilotka"
	item_state_slots = list(
		slot_head_str = "pilotka_worn"
	)
