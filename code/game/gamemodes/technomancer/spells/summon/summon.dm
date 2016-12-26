/mob/living/
	var/summoned = 0

/obj/item/weapon/spell/summon
	name = "summon template"
	desc = "Chitter chitter."
	cast_methods = CAST_RANGED | CAST_USE
	aspect = ASPECT_TELE
	var/mob/living/summoned_mob_type = null // The type to use when making new mobs when summoned.
	var/list/summon_options = list()
	var/energy_cost = 0
	var/instability_cost = 0

/obj/item/weapon/spell/summon/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/turf/T = get_turf(hit_atom)
	if(summoned_mob_type && core.summoned_mobs.len < core.max_summons && pay_energy(energy_cost))
		var/obj/effect/E = new(T)
		E.icon = 'icons/obj/objects.dmi'
		E.icon_state = "anom"
		sleep(5 SECONDS)
		qdel(E)
		if(owner) // We might've been dropped.
			var/mob/living/L = new summoned_mob_type(T)
			core.summoned_mobs |= L
			L.summoned = 1
			var/image/summon_underlay = image('icons/obj/objects.dmi',"anom")
			summon_underlay.alpha = 127
			L.underlays |= summon_underlay
			on_summon(L)
			to_chat(user,"<span class='notice'>You've successfully teleported \a [L] to you!</span>")
			visible_message("<span class='warning'>\A [L] appears from no-where!</span>")
			user.adjust_instability(instability_cost)

/obj/item/weapon/spell/summon/on_use_cast(mob/living/user)
	if(summon_options.len)
		var/choice = input(user, "Choose a creature to kidnap from somewhere!", "Summon") as null|anything in summon_options
		if(choice)
			summoned_mob_type = summon_options[choice]

// Called when a new mob is summoned, override for special behaviour.
/obj/item/weapon/spell/summon/proc/on_summon(var/mob/living/summoned)
	return