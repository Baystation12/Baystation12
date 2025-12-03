// Diffuses shields in a large radius for a long time
/obj/item/missile_equipment/payload/emp
	name = "EMP device"
	missile_name_override = "emp missile"
	desc = "Emits a strong electromagnetic pulse when the detonation mechanism of the missile it's fitted in is triggered."
	icon_state = "ion"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_GOLD = 1000, MATERIAL_URANIUM = 500)

/obj/item/missile_equipment/payload/emp/on_trigger(armed)
	if (armed)
		empulse(get_turf(src), rand(4,5), rand(6,7))
	..()
