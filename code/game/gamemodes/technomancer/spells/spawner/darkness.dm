/datum/technomancer/spell/darkness
	name = "Darkness"
	desc = "Disrupts photons moving in a local area, causing darkness to shroud yourself or a position of your choosing."
	cost = 25
	obj_path = /obj/item/weapon/spell/spawner/darkness
	ability_icon_state = "tech_darkness"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/spawner/darkness
	name = "darkness"
	desc = "Not even light can stand in your way now."
	icon_state = "darkness"
	cast_methods = CAST_RANGED
	aspect = ASPECT_DARK
	spawner_type = /obj/effect/temporary_effect/darkness

/obj/item/weapon/spell/spawner/darkness/on_ranged_cast(atom/hit_atom, mob/user)
	if(pay_energy(500))
		adjust_instability(4)
		..()

/obj/item/weapon/spell/spawner/darkness/New()
	..()
	set_light(6, -5, l_color = "#FFFFFF")

/obj/effect/temporary_effect/darkness
	name = "darkness"
	time_to_die = 2 MINUTES
	new_light_range = 6
	new_light_power = -5