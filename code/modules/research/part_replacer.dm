/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon = 'icons/obj/tools/part_replacer.dmi'
	icon_state = "RPED"
	item_state = "RPED"
	w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 50
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	collection_mode = TRUE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3)

/obj/item/research
	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ESOTERIC = 19)
