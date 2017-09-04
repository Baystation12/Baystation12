/spell/aoe_turf/build_shrine
	name = "Build Shrine"
	desc = "Start the groundwork for a new shrine by building an altar."
	cast_delay = 100

	charge_max = 1000
	spell_flags = Z2NOCAST | IGNOREDENSE | IGNORESPACE
	invocation = "none"
	invocation_type = SpI_NONE

	hud_state = "const_pylon"
	cast_sound = 'sound/effects/meteorimpact.ogg'

/spell/aoe_turf/build_shrine/choose_targets()
	var/T = ..()
	if(islist(T))
		T = T[1]
	for(var/obj/O in T)
		if(O.density)
			return null
	return T

/spell/aoe_turf/build_shrine/cast(var/target, mob/user)
	new /obj/structure/deity/altar(target, connected_god)