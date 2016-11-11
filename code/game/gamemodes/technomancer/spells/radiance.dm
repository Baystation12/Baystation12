/datum/technomancer/spell/radiance
	name = "Radiance"
	desc = "Causes you to be very radiant, glowing brightly in visible light, thermal energy, and deadly ionizing radiation."
	cost = 100
	obj_path = /obj/item/weapon/spell/radiance
	ability_icon_state = "tech_radiance"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/radiance
	name = "radiance"
	desc = "You will glow with a radiance similar to that of Supermatter."
	icon_state = "radiance"
	aspect = ASPECT_LIGHT
	var/power = 100
	toggled = 1

/obj/item/weapon/spell/radiance/New()
	..()
	set_light(7, 4, l_color = "#D9D900")
	processing_objects |= src

/obj/item/weapon/spell/radiance/Destroy()
	processing_objects -= src
	return ..()

/obj/item/weapon/spell/radiance/process()
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	if(!istype(T, /turf/space))
		env = T.return_air()
		removed = env.remove(0.25 * env.total_moles)	//Remove gas from surrounding area

		var/thermal_power = 300 * power

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/L in range(T, round(sqrt(power / 2))))
		var/radius = max(get_dist(L, src), 1)
		var/rads = (power / 10) * ( 1 / (radius**2) )
		L.apply_effect(rads, IRRADIATE)
	adjust_instability(2)
