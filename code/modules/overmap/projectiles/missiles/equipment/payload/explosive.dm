/obj/item/missile_equipment/payload/explosive
	name = "explosive charge"
	missile_name_override = "\improper HE missile"
	desc = "An explosive charge. Detonates when the missile is triggered."
	icon_state = "explosive"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_ESOTERIC = 4)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_GOLD = 1000, MATERIAL_PHORON = 2000)

/obj/item/missile_equipment/payload/explosive/on_trigger(armed, atom/triggerer)
	if (armed)
		if (istype(triggerer, /obj/shield))
			explosion(loc, 3, shaped = get_dir(src, triggerer), turf_breaker = FALSE)
		else
			explosion(loc, 7, shaped = get_dir(src, triggerer), turf_breaker = TRUE)
	..()
