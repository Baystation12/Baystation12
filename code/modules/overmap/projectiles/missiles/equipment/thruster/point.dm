// Takes in coordinates and flies to said coordinates (although very slowly, so the range isn't great)
/obj/item/missile_equipment/thruster/point
	name = "pointman missile booster"
	desc = "A missile booster designed to travel to and rest at a given point. Steers away from structures."
	icon_state = "dumbfire"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_PHORON = 3000)

/obj/item/missile_equipment/thruster/point/preset/Initialize()
	. = ..()
	new /obj/item/tank/hydrogen(src)

/obj/item/missile_equipment/thruster/point/configure(mob/user)
	var/target_x = input(user, "Enter target X coordinate", "Input coordinates") as null|num
	var/target_y = input(user, "Enter target Y coordinate", "Input coordinates") as null|num
	if (!target_x || !target_y || target_x <= 0 || target_x >= GLOB.using_map.overmap_size || target_y <= 0 || target_y >= GLOB.using_map.overmap_size)
		to_chat(user, SPAN_NOTICE("The targeting computer display lets you know that's an invalid target."))
		return TRUE

	var/turf/tgt = locate(target_x, target_y, GLOB.using_map.overmap_z)
	if (!tgt)
		to_chat(user, SPAN_NOTICE("The targeting computer display indicates that the target wasn't valid."))
		return TRUE

	target = tgt
	to_chat(user, SPAN_NOTICE("Target successfully set to [target]."))
	return TRUE

/obj/item/missile_equipment/thruster/point/should_enter(obj/overmap/overmap_site)
	if (overmap_site.x == target.x && overmap_site.y == overmap_site.y)
		return TRUE
	return FALSE
