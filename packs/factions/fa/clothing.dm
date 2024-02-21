/obj/item/clothing/under/fa
	abstract_type = /obj/item/clothing/under/fa
	icon = 'packs/factions/fa/clothing.dmi'
	item_icons = list(
		slot_w_uniform_str = 'packs/factions/fa/clothing.dmi'
	)
	sprite_sheets = list()
	body_parts_covered = FULL_TORSO | ARMS | FULL_LEGS
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)


/obj/item/clothing/under/fa/vacsuit
	name = "copernican VAC-suit"
	desc = {"\
		A somewhat uncomfortable, utilitarian uniform meant to be worn under \
		spacesuits by orbital shipyard workers. This one has Frontier Alliance \
		crests on both shoulders.\
	"}
	icon_state = "vacsuit"
	item_state_slots = list(
		slot_w_uniform_str = "vacsuit"
	)
	sprite_sheets = list(
		SPECIES_UNATHI = 'packs/factions/fa/clothing_unathi.dmi'
	)
