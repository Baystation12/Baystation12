/datum/technomancer/spell/pulsar
	name = "Pulsar"
	desc = "Emits electronic pulses to destroy, disable, or otherwise harm devices and machines.  Be sure to not hit yourself with this."
	cost = 100
	obj_path = /obj/item/weapon/spell/spawner/pulsar
	ability_icon_state = "tech_pulsar"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/spawner/pulsar
	name = "pulsar"
	desc = "Be sure to not hit yourself!"
	icon_state = "targeting_matrix"
	cast_methods = CAST_RANGED | CAST_THROW
	aspect = ASPECT_EMP
	spawner_type = /obj/effect/temporary_effect/pulsar

/obj/item/weapon/spell/spawner/pulsar/New()
	..()
	set_light(3, 2, l_color = "#2ECCFA")

/obj/item/weapon/spell/spawner/pulsar/on_ranged_cast(atom/hit_atom, mob/user)
	if(pay_energy(4000))
		adjust_instability(8)
		..()

/obj/item/weapon/spell/spawner/pulsar/on_throw_cast(atom/hit_atom, mob/user)
	empulse(hit_atom, 1, 1, log=1)

/obj/effect/temporary_effect/pulsar
	name = "pulsar"
	desc = "Not a real pulsar, but still emits loads of EMP."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	time_to_die = null
	invisibility = 0
	new_light_range = 4
	new_light_power = 5
	new_light_color = "#2ECCFA"
	var/pulses_remaining = 3

/obj/effect/temporary_effect/pulsar/New()
	..()
	pulse_loop()

/obj/effect/temporary_effect/pulsar/proc/pulse_loop()
	while(pulses_remaining)
		sleep(2 SECONDS)
		empulse(src, heavy_range = 1, light_range = 2, log = 1)
		pulses_remaining--
	qdel(src)

