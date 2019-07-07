/obj/item/weapon/tool/wirecutters
	name = "wirecutters"
	desc = "Cuts wires and other objects with it."
	icon_state = "cutters"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_WIRECUTTING
	throw_speed = 2
	throw_range = 9
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1)
	attack_verb = list("pinched", "nipped")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_WIRE_CUTTING = 30, QUALITY_RETRACTING = 15, QUALITY_BONE_SETTING = 15)

//Better and more flexible than most improvised tools, but more bulky and annoying to make
/obj/item/weapon/tool/wirecutters/improvised
	name = "wiremanglers"
	desc = "An improvised monstrosity made of bent rods which can sometimes be used to snip things."
	icon_state = "impro_cutter"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_NORMAL
	tool_qualities = list(QUALITY_WIRE_CUTTING = 20, QUALITY_RETRACTING = 10, QUALITY_BONE_SETTING = 10)
	degradation = 1.5

/obj/item/weapon/tool/wirecutters/armature
	name = "armature cutter"
	desc = "Bigger brother of wirecutter. Can't do much in terms of emergency surgery, but dose its main job better."
	icon_state = "arm-cutter"
	force = WEAPON_FORCE_NORMAL
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 1)
	tool_qualities = list(QUALITY_WIRE_CUTTING = 40, QUALITY_CUTTING = 30)
	degradation = 0.07
	max_upgrades = 4

/obj/item/weapon/tool/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message(
			"\The [usr] cuts \the [C]'s restraints with \the [src]!",
			"You cut \the [C]'s restraints with \the [src]!",
			"You hear cable being cut."
		)
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()
