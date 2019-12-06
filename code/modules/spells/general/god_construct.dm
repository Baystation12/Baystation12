#define CONSTRUCT_SPELL_COST 1
#define CONSTRUCT_SPELL_TYPE 2

/spell/construction
	name = "Construction"
	desc = "This ability will let you summon a structure of your choosing."

	cast_delay = 10
	charge_max = 100
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	hud_state = "const_wall"
	cast_sound = 'sound/effects/meteorimpact.ogg'

/spell/construction/choose_targets()
	var/list/possible_targets = list()
	if(connected_god && connected_god.form)
		for(var/type in connected_god.form.buildables)
			var/cost = 10
			if(ispath(type, /obj/structure/deity))
				var/obj/structure/deity/D = type
				cost = initial(D.build_cost)
			possible_targets["[connected_god.get_type_name(type)] - [cost]"] = list(cost, type)
		var/choice = input("Construct to build.", "Construction") as null|anything in possible_targets
		if(!choice)
			return
		if(locate(/obj/structure/deity) in get_turf(holder))
			return

		return possible_targets[choice]
	else
		return

/spell/construction/cast_check(var/skipcharge, var/mob/user, var/list/targets)
	if(!..())
		return 0
	var/turf/T = get_turf(user)
	if(skipcharge && !valid_deity_structure_spot(targets[CONSTRUCT_SPELL_TYPE], T, connected_god, user))
		return 0
	else
		for(var/obj/O in T)
			if(O.density)
				to_chat(user, "<span class='warning'>Something here is blocking your construction!</span>")
				return 0
	return 1

/spell/construction/cast(var/target, mob/user)
	charge_max = target[CONSTRUCT_SPELL_COST]
	target = target[CONSTRUCT_SPELL_TYPE]
	var/turf/T = get_turf(user)
	new target(T, connected_god)
#undef CONSTRUCT_SPELL_COST
#undef CONSTRUCT_SPELL_TYPE