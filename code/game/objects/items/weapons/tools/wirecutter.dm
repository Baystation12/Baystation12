/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "A special pair of pliers with cutting edges. Various brackets and manipulators built into the handle allow it to repair severed wiring."
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 3.0
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 80)
	center_of_mass = "x=18;y=10"
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/weapon/wirecutters/Initialize()
	switch(pick("red","yellow","green","blue","black"))
		if ("red")
			icon_state = "cutters"
			item_state = "cutters"
		if ("yellow")
			icon_state = "cutters_yellow"
			item_state = "cutters_yellow"
		if ("green")
			icon_state = "cutters_green"
			item_state = "cutters_green"
		if ("blue")
			icon_state = "cutters_blue"
			item_state = "cutters_blue"
		if ("black")
			icon_state = "cutters_black"
			item_state = "cutters_black"
	. = ..()

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()