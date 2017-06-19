/obj/item/weapon/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "5.56"
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	origin_tech = list(TECH_COMBAT = 1)
	var/remaining = 9

/obj/item/weapon/magnetic_ammo/examine(mob/user)
	. = ..()
	to_chat(user, "There [(remaining == 1)? "is" : "are"] [remaining] flechette\s left!")