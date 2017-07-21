#define CONSTRUCT_SPELL_COST 1
#define CONSTRUCT_SPELL_REQ  2
#define CONSTRUCT_SPELL_TYPE 3

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
	if(connected_god)
		for(var/type in connected_god.form.buildables)
			var/cost = 10
			var/needs_turf = 0
			if(ispath(type, /obj/structure/deity))
				var/obj/structure/deity/D = type
				cost = initial(D.build_cost)
				needs_turf = initial(D.must_be_converted_turf)
			possible_targets["[connected_god.get_type_name(type)] - [cost]"] = list(cost, needs_turf, type)
		var/choice = input("Construct to build.", "Construction") as null|anything in possible_targets
		if(!choice)
			return
		var/list/buildable = possible_targets[choice]
		var/turf/T = get_turf(holder)
		if(istype(T, /turf/simulated/floor/deity))
			var/turf/simulated/floor/deity/D = T
			if(D.linked_god != connected_god)
				to_chat(holder, "<span class='warning'>This converted turf is not your master's! You can't build here.</span>")
				return
		else if(buildable[CONSTRUCT_SPELL_REQ])
			to_chat(holder, "<span class='warning'>This construct can only be built on converted turf!</span>")
			return
		if(locate(/obj/structure/deity) in get_turf(holder))
			return

		charge_max = buildable[CONSTRUCT_SPELL_COST]

		return list(buildable[CONSTRUCT_SPELL_TYPE])
	else
		return

/spell/construction/cast_check(var/skipcharge, var/mob/user, var/list/targets)
	if(!..())
		return 0
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.density)
			to_chat(user, "<span class='warning'>Something here is blocking your construction!</span>")
			return 0
	if(connected_god && !connected_god.near_structure(T))
		to_chat(user, "<span class='warning'>You need to be near an important structure for this to work!</span>")
		return 0
	return 1


/spell/construction/cast(var/target, mob/user)
	if(islist(target))
		target = target[1]
	var/turf/T = get_turf(user)
	if(!ispath(target, /turf))
		new target(T, connected_god)
	else
		var/turf/simulated/floor/deity/F = T.ChangeTurf(/turf/simulated/floor/deity)
		F.sync_god(connected_god)
#undef CONSTRUCT_SPELL_COST
#undef CONSTRUCT_SPELL_REQ
#undef CONSTRUCT_SPELL_TYPE