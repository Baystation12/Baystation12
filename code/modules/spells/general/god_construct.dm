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

/spell/construction/cast_check(skipcharge, mob/user, list/targets)
	if(!..())
		return FALSE
	var/turf/T = get_turf(user)
	if(skipcharge && !valid_deity_structure_spot(targets[CONSTRUCT_SPELL_TYPE], T, connected_god, user))
		return FALSE
	else
		for(var/obj/O in T)
			if(O.density)
				to_chat(user, "<span class='warning'>Something here is blocking your construction!</span>")
				return FALSE
	return TRUE

/spell/construction/cast(target, mob/living/carbon/user)
	user.custom_pain(SPAN_WARNING("You wince in pain as you feel blood being ripped from your body in payment to create \the [target[2]]."), 5)
	user.visible_message(
		SPAN_WARNING("\The [user] winces in pain as they summon \the [target[2]]!"),
	)
	charge_max = target[CONSTRUCT_SPELL_COST]
	target = target[CONSTRUCT_SPELL_TYPE]
	var/turf/T = get_turf(user)
	new target(T, connected_god)

/spell/construction/check_valid_targets(var/list/targets)
	var/turf/T = get_turf(holder)

	for (var/atom/thing in T.contents)
		if (thing == holder)
			continue

		if (thing.density)
			return FALSE
	return TRUE

#undef CONSTRUCT_SPELL_COST
#undef CONSTRUCT_SPELL_TYPE
