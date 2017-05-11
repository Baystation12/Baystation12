/spell/aoe_turf/conjure/build_shrine
	name = "Build Shrine"
	desc = "Start the groundwork for a new shrine by building an altar."
	cast_delay = 100

	charge_max = 1000
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	hud_state = "const_pylon"
	cast_sound = 'sound/effects/meteorimpact.ogg'
	list(/obj/structure/deity/altar)

/spell/aoe_turf/conure/build_shrine/set_connected_god(var/mob/living/deity/god)
	..()
	if(!newVars)
		newVars = list()
	newVars["linked_god"] = god