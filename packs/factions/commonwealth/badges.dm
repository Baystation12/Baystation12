/obj/item/clothing/accessory/commonwealth_badge
	abstract_type = /obj/item/clothing/accessory/commonwealth_badge
	icon = 'packs/factions/commonwealth/badges.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/factions/commonwealth/badges.dmi',
		slot_wear_suit_str = 'packs/factions/commonwealth/badges.dmi'
	)
	icon_state = null
	on_rolled_down = ACCESSORY_ROLLED_NONE
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_INSIGNIA
	sprite_sheets = list()


/obj/item/clothing/accessory/commonwealth_badge/get_fibers()
	return null


/obj/item/clothing/accessory/commonwealth_badge/navy
	name = "commonwealth navy patch"
	desc = {"\
		A shield shaped blue and green patch with a red star, signifying service in \
		the now-defunct Terran Commonwealth Navy.\
	"}
	icon_state = "navy"
	overlay_state = "navy_worn"


/obj/item/clothing/accessory/commonwealth_badge/army
	name = "commonwealth army patch"
	desc = {"\
		A shield shaped blue and green patch with a golden sun, signifying service in \
		the now-defunct Terran Commonwealth Army.\
	"}
	icon_state = "army"
	overlay_state = "army_worn"


/obj/item/clothing/accessory/commonwealth_badge/explorer
	name = "ancient Expeditionary Corps patch"
	desc = {"\
		A shield shaped blue and green patch with a purple chevron, signifying service \
		in the bygone Expeditionary Corps from before the foundation of the SCG.\
	"}
	icon_state = "explorer"
	overlay_state = "explorer_worn"


/obj/item/clothing/accessory/commonwealth_badge/shield
	name = "commonwealth shield"
	desc = {"\
		The pin worn by all agents of the Terran Commonwealth to symbolize their \
		service to the blue marble.\
	"}
	icon_state = "shield"
	overlay_state = "shield_worn"
	slot = ACCESSORY_SLOT_MEDAL


/obj/item/clothing/accessory/commonwealth_badge/earhart
	name = "mission patch, COL Earhart"
	desc = {"\
		A reproduction of the symbology for the Terran Commonwealth colony ship COL \
		Earhart, a sea-blue airplane over a red cross. This one has a three digit \
		number on it.\
	"}
	icon_state = "earhart"
	overlay_state = "earhart_worn"
