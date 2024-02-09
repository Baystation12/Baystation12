/datum/universal_state/bluespace_jump
	name = "Bluespace Jump"
	var/list/bluespaced = list()
	var/list/bluegoasts = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels


/datum/universal_state/bluespace_jump/New(list/zlevels)
	affected_levels = zlevels

/datum/universal_state/bluespace_jump/OnEnter()
	var/obj/machinery/bluespacedrive/drive = locate() in SSmachines.get_machinery_of_type(/obj/machinery/bluespacedrive)

	if (!drive || !(drive.z in affected_levels))
		return

	if (HAS_FLAGS(drive.state, drive.STATE_BROKEN))
		var/datum/event_meta/bsd = new(EVENT_LEVEL_MAJOR, "Bluespace Jump Fracture", add_to_queue = 0)
		new/datum/event/bsd_instability(bsd) // Destroyed BSD means the ship still jumps, but not without consequences

	var/space_zlevel = GLOB.using_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in SSmobs.mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel)
				if(T)
					M.forceMove(T)
			else
				apply_bluespaced(M)
	for(var/mob/goast in GLOB.ghost_mobs)
		goast.mouse_opacity = 0	//can't let you click that Dave
		goast.set_invisibility(SEE_INVISIBLE_LIVING)
		goast.alpha = 255
	old_accessible_z_levels = GLOB.using_map.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		GLOB.using_map.accessible_z_levels -= "[z]" //not accessible during the jump
	GLOB.using_map.ship_jump()


/datum/universal_state/bluespace_jump/OnExit()
	for(var/mob/M in bluespaced)
		if(!QDELETED(M))
			clear_bluespaced(M)

	bluespaced.Cut()
	GLOB.using_map.accessible_z_levels = old_accessible_z_levels
	old_accessible_z_levels = null


/datum/universal_state/bluespace_jump/OnPlayerLatejoin(mob/living/M)
	if(M.z in affected_levels)
		apply_bluespaced(M)


/datum/universal_state/bluespace_jump/OnTouchMapEdge(atom/A)
	if((A.z in affected_levels) && (A in bluespaced))
		if(ismob(A))
			to_chat(A,SPAN_WARNING("You drift away into the shifting expanse, never to be seen again."))
		qdel(A) //lost in bluespace
		return FALSE
	return TRUE


/datum/universal_state/bluespace_jump/proc/apply_bluespaced(mob/living/M)
	bluespaced += M
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly."))
		M.overlay_fullscreen("bluespace", /obj/screen/fullscreen/bluespace_overlay)
	M.set_confused(20)
	bluegoasts += new/obj/bluegoast/(get_turf(M),M)


/datum/universal_state/bluespace_jump/proc/clear_bluespaced(mob/living/M)
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel rooted in material world again."))
		M.clear_fullscreen("bluespace")
	for(var/mob/goast in GLOB.ghost_mobs)
		goast.mouse_opacity = initial(goast.mouse_opacity)
		goast.set_invisibility(initial(goast.invisibility))
		goast.alpha = initial(goast.alpha)
	for(var/G in bluegoasts)
		qdel(G)
	bluegoasts.Cut()


/obj/bluegoast
	name = "bluespace echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/carbon/human/daddy
	anchored = TRUE
	var/reality = 0
	simulated = FALSE


/obj/bluegoast/New(nloc, ndaddy)
	..(nloc)
	if(!ndaddy)
		qdel(src)
		return
	daddy = ndaddy
	set_dir(daddy.dir)
	appearance = daddy.appearance
	GLOB.moved_event.register(daddy, src, /obj/bluegoast/proc/mirror)
	GLOB.dir_set_event.register(daddy, src, /obj/bluegoast/proc/mirror_dir)
	GLOB.destroyed_event.register(daddy, src, /datum/proc/qdel_self)


/obj/bluegoast/Destroy()
	GLOB.destroyed_event.unregister(daddy, src)
	GLOB.dir_set_event.unregister(daddy, src)
	GLOB.moved_event.unregister(daddy, src)
	daddy = null
	. = ..()


/obj/bluegoast/proc/mirror(atom/movable/am, old_loc, new_loc)
	var/ndir = get_dir(new_loc,old_loc)
	appearance = daddy.appearance
	var/nloc = get_step(src, ndir)
	if(nloc)
		forceMove(nloc)
	if(nloc == new_loc)
		reality++
		if(reality > 5)
			to_chat(daddy, SPAN_NOTICE("Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended..."))
			blueswitch()
		else if(reality > 3)
			to_chat(daddy, SPAN_DANGER("Something is definitely wrong. Why do you think YOU are the original?"))
		else
			to_chat(daddy, SPAN_WARNING("You feel a bit less real. Which one of you two was original again?.."))


/obj/bluegoast/proc/mirror_dir(atom/movable/am, old_dir, new_dir)
	set_dir(GLOB.reverse_dir[new_dir])


/obj/bluegoast/examine()
	return daddy?.examine(arglist(args))


/obj/bluegoast/proc/blueswitch()
	daddy.blueswitch(src)
	qdel(src)


/**
 * Handles applying blueswitch effects to the mob and creating the clone.
 *
 * **Parameters**:
 * - `ghost` - The bluespace ghost triggering the switch.
 *
 * Returns instance of mob. The created bluespace clone, or null if no clone was created.
 */
/mob/proc/blueswitch(obj/bluegoast/ghost)
	var/mob/clone = new type(get_turf(ghost))
	clone.appearance = appearance
	clone.real_name = real_name
	clone.flavor_text = flavor_text
	dust()
	return clone


/mob/living/exosuit/blueswitch(obj/bluegoast/ghost)
	if (!length(pilots))
		return
	for (var/mob/pilot in pilots)
		remove_pilot(pilot)
		var/mob/clone = pilot.blueswitch(ghost)
		add_pilot(clone)


/mob/living/carbon/human/blueswitch(obj/bluegoast/ghost)
	var/mob/living/carbon/human/clone = new(get_turf(ghost), species.name)
	clone.dna = dna.Clone()
	clone.sync_organ_dna()
	clone.UpdateAppearance()
	for (var/obj/item/entry in get_equipped_items(TRUE))
		remove_from_mob(entry) //steals instead of copies so we don't end up with duplicates
		clone.equip_to_appropriate_slot(entry)
	clone.real_name = real_name
	clone.flavor_text = flavor_text
	dust()
	return clone


/obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	alpha = 80
	color = "#000050"
	blend_mode = BLEND_ADD
