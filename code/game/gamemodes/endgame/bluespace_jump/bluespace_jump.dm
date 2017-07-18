/datum/universal_state/bluespace_jump
	name = "Bluespace Jump"
	var/list/bluespaced = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels

/datum/universal_state/bluespace_jump/New(var/list/zlevels)
	affected_levels = zlevels

/datum/universal_state/bluespace_jump/OnEnter()
	var/space_zlevel = using_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel)
				if(T)
					M.forceMove(T)
			else
				apply_bluespaced(M)
				bluespaced += M

	old_accessible_z_levels = using_map.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		using_map.accessible_z_levels -= "[z]" //not accessible during the jump

/datum/universal_state/bluespace_jump/OnExit()
	for(var/M in bluespaced)
		clear_bluespaced(M)

	bluespaced.Cut()
	using_map.accessible_z_levels = old_accessible_z_levels
	old_accessible_z_levels = null

/datum/universal_state/bluespace_jump/OnPlayerLatejoin(var/mob/living/M)
	if(M.z in affected_levels)
		apply_bluespaced(M)

/datum/universal_state/bluespace_jump/OnTouchMapEdge(var/atom/A)
	if((A.z in affected_levels) && (A in bluespaced))
		if(ismob(A))
			to_chat(A,"<span class='warning'>You drift away into the shifting expanse, never to be seen again.</span>")
		qdel(A) //lost in bluespace
		return FALSE
	return TRUE

/datum/universal_state/bluespace_jump/proc/check_density(var/mob/living/M)
	var/turf/T = get_turf(M)
	if(T && T.density)
		return T
	var/obj/machinery/door/airlock/A = locate() in T
	if(A && A.density && M.blocks_airlock())
		return A
	return null

/datum/universal_state/bluespace_jump/proc/apply_bluespaced(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly.</span>")
		M.overlay_fullscreen("bluespace", /obj/screen/fullscreen/bluespace_overlay)
	M.incorporeal_move = 1
	M.confused = INFINITY //needed since normally confused ticks down own it's own

/datum/universal_state/bluespace_jump/proc/clear_bluespaced(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		M.clear_fullscreen("bluespace")

	M.incorporeal_move = 0
	M.confused = 0

	var/atom/dense = check_density(M)
	if(dense)
		to_chat(M,"<span class='danger'>\The [dense] suddenly appears inside you!</span>")
		M.gib()

/obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#FF9900"
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER