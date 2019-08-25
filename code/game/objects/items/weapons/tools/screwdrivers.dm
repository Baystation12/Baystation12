/obj/item/weapon/tool/screwdriver
	name = "screwdriver"
	desc = "You can use this to open panels and such things."
	icon_state = "screwdriver"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	worksound = WORKSOUND_SCREW_DRIVING
	slot_flags = SLOT_BELT | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	throw_speed = 3
	throw_range = 5
	matter = list(MATERIAL_STEEL = 800, MATERIAL_PLASTIC = 400)
	attack_verb = list("stabbed")
	tool_qualities = list(QUALITY_SCREW_DRIVING = 30, QUALITY_BONE_SETTING = 10)

/obj/item/weapon/tool/screwdriver/improvised
	name = "screwpusher"
	desc = "A little metal rod wrapped in tape, barely qualifies as a tool."
	icon_state = "impro_screwdriver"
	tool_qualities = list(QUALITY_SCREW_DRIVING = 15)
	degradation = 2

/obj/item/weapon/tool/screwdriver/electric
	name = "electric screwdriver"
	desc = "Screwdriver powered by S class cell."
	icon_state = "e-screwdriver"
	worksound = WORKSOUND_DRIVER_TOOL
	tool_qualities = list(QUALITY_SCREW_DRIVING = 40, QUALITY_DRILLING = 10, QUALITY_BONE_SETTING = 10)
	degradation = 0.07
	use_power_cost = 0.18
	suitable_cell = /obj/item/weapon/cell

/obj/item/weapon/tool/screwdriver/combi_driver
	name = "combi driver"
	desc = "Drive screws, drive bolts, drill bones, you can do everything with it."
	icon_state = "combi_driver"
	w_class = ITEM_SIZE_NORMAL
	worksound = WORKSOUND_DRIVER_TOOL
	matter = list(MATERIAL_STEEL = 900, MATERIAL_PLASTIC = 600)
	tool_qualities = list(QUALITY_SCREW_DRIVING = 50, QUALITY_BOLT_TURNING = 50, QUALITY_DRILLING = 20)
	degradation = 0.07
	use_power_cost = 0.24
	suitable_cell = /obj/item/weapon/cell
	max_upgrades = 4

/obj/item/weapon/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != BP_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)
