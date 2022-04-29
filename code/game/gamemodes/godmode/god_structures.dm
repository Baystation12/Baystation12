/proc/valid_deity_structure_spot(type, turf/target, mob/living/deity/deity, mob/living/user)
	var/obj/structure/deity/D = type
	var/flags = initial(D.deity_flags)

	if(flags & DEITY_STRUCTURE_NEAR_IMPORTANT && !deity.near_structure(target))
		if(user)
			to_chat(user, SPAN_WARNING("You need to be near \a [deity.get_type_name(/obj/structure/deity/altar)] to build this!"))
		return FALSE

	if(flags & DEITY_STRUCTURE_ALONE)
		for(var/structure in deity.structures)
			if(istype(structure,type) && get_dist(target,structure) <= 3)
				if(user)
					to_chat(user, SPAN_WARNING("You are too close to another [deity.get_type_name(type)]!"))
				return FALSE
	return TRUE

/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	var/mob/living/deity/linked_god
	damage_hitsound = 'sound/effects/Glasshit.ogg'
	health_resistances = list(
		DAMAGE_BRUTE     = 0.8,
		DAMAGE_BURN      = 0.2,
		DAMAGE_FIRE      = 0.2,
		DAMAGE_STUN      = 0,
		DAMAGE_EMP       = 0,
		DAMAGE_RADIATION = 0,
		DAMAGE_BIO       = 0,
		DAMAGE_PAIN      = 0,
		DAMAGE_TOXIN     = 0,
		DAMAGE_GENETIC   = 0,
		DAMAGE_OXY       = 0,
		DAMAGE_BRAIN     = 0
	)
	/// How much power we get/lose
	var/power_adjustment = 1
	/// How much it costs to build this item.
	var/build_cost = 0
	var/deity_flags = DEITY_STRUCTURE_NEAR_IMPORTANT
	density = TRUE
	anchored = TRUE
	icon_state = "tomealtar"

/obj/structure/deity/New(newloc, god)
	..(newloc)
	if(god)
		linked_god = god
		linked_god.form.sync_structure(src)
		linked_god.adjust_source(power_adjustment, src)

/obj/structure/deity/handle_death_change(new_death_state)
	. = ..()
	if (new_death_state)
		playsound(loc, 'sound/effects/break_stone.ogg', 50, 1)
		qdel(src)

/obj/structure/deity/post_health_change(health_mod, damage_type)
	update_icon()

/obj/structure/deity/proc/attack_deity(mob/living/deity/deity)
	return