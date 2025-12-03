// Diffuses shields in a large radius for a long time
/obj/item/missile_equipment/payload/diffuser
	name = "dynamic antiphase emitter"
	missile_name_override = "diffuser missile"
	desc = "A one time use device designed to emit a strong, lasting strobe of antiphase EM waves. It can diffuse large shield sections for a long period of time, possibly causing massive damage to them as well."
	icon_state = "diffuse"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_GOLD = 1000, MATERIAL_DIAMOND = 250)

	var/diffuse_range = 10
	var/diffuse_duration = 60

/obj/item/missile_equipment/payload/diffuser/on_trigger(armed)
	if (armed)
		for (var/turf/turf_in_range in trange(diffuse_range, loc))
			for (var/obj/shield/shield in turf_in_range)
				shield.diffuse(diffuse_duration)
	..()
