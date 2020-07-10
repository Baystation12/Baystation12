
/obj/item/clothing/under/unggoy_internal
	name = "Unggoy Internal Jumpsuit"
	desc = "A form fitting functional undersuit for Unggoy soldiers. Has a little protective padding."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "utility_jumpsuit"
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	species_restricted = list("Unggoy")
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	matter = list("cloth" = 1)

/obj/item/clothing/under/unggoy_thrall
	name = "Unggoy thrall robe"
	desc = "A simple utilitarian garment for a simple, utilitarian people."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "thrall_robe"
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	matter = list("cloth" = 1)
	species_restricted = list("Unggoy")

/obj/item/clothing/shoes/grunt_boots
	name = "Natural Armor"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = GRUNT_GEAR_ICON
	icon_state = "naturallegarmor"
	item_state = "blank"
	species_restricted = list("Unggoy")
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 30, bomb = 15, bio = 30, rad = 30)
	body_parts_covered = FEET|LEGS
	canremove = 0
	armor_thickness = null
	armor_thickness_max = null

/obj/item/clothing/shoes/grunt_boots/dropped(mob/user as mob)
	. = ..()
	if(isnull(src.gc_destroyed))
		qdel(src)

/obj/item/clothing/gloves/thick/grunt_gloves
	name = "Natural Armor"
	desc = "The natural armor on your arms provides a small amount of protection against the elements."
	icon = GRUNT_GEAR_ICON
	icon_state = "naturalhandarmor"
	item_state = "blank"
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 30, rad = 30)
	species_restricted = list("Unggoy")
	body_parts_covered = HANDS|ARMS
	canremove = 0
	armor_thickness = null
	armor_thickness_max = null

/obj/item/clothing/gloves/thick/grunt_gloves/dropped(mob/user as mob)
	. = ..()
	if(isnull(src.gc_destroyed))
		qdel(src)
