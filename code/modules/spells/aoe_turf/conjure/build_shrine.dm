/spell/aoe_turf/conjure/build_shrine
	name = "Build Shrine"
	desc = "Start the groundwork for a new shrine by building an altar."
	cast_delay = 100

	charge_max = 1000
	spell_flags = Z2NOCAST | IGNOREDENSE | IGNORESPACE
	invocation = "none"
	invocation_type = SpI_NONE

	hud_state = "const_pylon"
	cast_sound = 'sound/effects/meteorimpact.ogg'
	summon_type = list(/obj/structure/deity/altar)

/spell/aoe_turf/conjure/build_shrine/choose_targets()
	var/turf/target = ..()
	if(target)
		for(var/obj/O in target)
			if(O.density)
				return null

	return target

/spell/aoe_turf/conjure/build_shrine/set_connected_god(var/mob/living/deity/god)
	..()
	if(!newVars)
		newVars = list()
	newVars["linked_god"] = god