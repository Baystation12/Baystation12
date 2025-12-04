// Anti-missile missile booster with more fuel and more thrust per unit of fuel
// Intended for use with the anti-missile equipment
/obj/item/missile_equipment/thruster/hunter
	name = "HUNTER warp booster"
	desc = "An advanced booster specifically designed to plot courses towards and catch up to rapidly moving objects such as other missiles."
	icon_state = "seeker"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_GOLD = 500, MATERIAL_PHORON = 3000)
	overmap_speed = 1 / (6 SECONDS)

/obj/item/missile_equipment/thruster/hunter/preset/Initialize()
	. = ..()
	new /obj/item/tank/hydrogen(src)

/obj/item/missile_equipment/thruster/hunter/is_target_valid(obj/overmap/overmap_target)
	return istype(overmap_target, /obj/overmap/projectile)
