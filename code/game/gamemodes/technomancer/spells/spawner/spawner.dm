/obj/item/weapon/spell/spawner
	name = "spawner template"
	desc = "If you see me, someone messed up."
	icon_state = "darkness"
	cast_methods = CAST_RANGED
	aspect = null
	var/obj/effect/spawner_type = null

/obj/effect/temporary_effect
	name = "self deleting effect"
	desc = "How are you examining what which cannot be seen?"
	invisibility = 101
	var/time_to_die = 10 SECONDS // Afer which, it will delete itself.
	var/new_light_range = 6
	var/new_light_power = 6
	var/new_light_color = "#FFFFFF"

/obj/effect/temporary_effect/New()
	..()
	set_light(new_light_range, new_light_power, l_color = new_light_color)
	if(time_to_die)
		spawn(time_to_die)
			qdel(src)

/obj/item/weapon/spell/spawner/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		new spawner_type(T)
		to_chat(user,"<span class='notice'>You shift \the [src] onto \the [T].</span>")
		qdel(src)