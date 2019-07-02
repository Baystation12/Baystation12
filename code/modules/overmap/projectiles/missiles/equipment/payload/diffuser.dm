// Diffuses shields in a large radius for a long time
/obj/item/missile_equipment/payload/diffuser
	name = "dynamic antiphase emitter"
	desc = "A one time use device designed to emit a strong, lasting strobe of antiphase EM waves. It can diffuse large shield sections for a long period of time, possibly causing massive damage to them as well."
	icon_state = "diffuse"

	var/diffuse_range = 10
	var/diffuse_duration = 60

/obj/item/missile_equipment/payload/diffuser/on_trigger()
	for(var/turf/T in trange(diffuse_range, get_turf(src)))
		for(var/obj/effect/shield/S in T)
			S.diffuse(diffuse_duration)

	..()
