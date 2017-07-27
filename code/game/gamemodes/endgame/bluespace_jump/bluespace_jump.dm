/datum/universal_state/bluespace_jump
	name = "Bluespace Jump"
	var/list/bluespaced = list()
	var/list/bluegoasts = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels

/datum/universal_state/bluespace_jump/New(var/list/zlevels)
	affected_levels = zlevels

/datum/universal_state/bluespace_jump/OnEnter()
	var/space_zlevel = GLOB.using_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in GLOB.mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel)
				if(T)
					M.forceMove(T)
			else
				apply_bluespaced(M)
	for(var/mob/goast in GLOB.ghost_mob_list)
		goast.mouse_opacity = 0	//can't let you click that Dave
		goast.invisibility = SEE_INVISIBLE_LIVING
		goast.alpha = 255
	old_accessible_z_levels = GLOB.using_map.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		GLOB.using_map.accessible_z_levels -= "[z]" //not accessible during the jump

/datum/universal_state/bluespace_jump/OnExit()
	for(var/M in bluespaced)
		clear_bluespaced(M)

	bluespaced.Cut()
	GLOB.using_map.accessible_z_levels = old_accessible_z_levels
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

/datum/universal_state/bluespace_jump/proc/apply_bluespaced(var/mob/living/M)
	bluespaced += M
	if(M.client)
		to_chat(M,"<span class='notice'>You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly.</span>")
		M.overlay_fullscreen("bluespace", /obj/screen/fullscreen/bluespace_overlay)
	M.confused = 20
	bluegoasts += new/obj/effect/bluegoast/(get_turf(M),M)

/datum/universal_state/bluespace_jump/proc/clear_bluespaced(var/mob/living/M)
	if(M.client)
		to_chat(M,"<span class='notice'>You feel rooted in material world again.</span>")
		M.clear_fullscreen("bluespace")
	M.confused = 0
	for(var/mob/goast in GLOB.ghost_mob_list)
		goast.mouse_opacity = initial(goast.mouse_opacity)
		goast.invisibility = initial(goast.invisibility)
		goast.alpha = initial(goast.alpha)
	for(var/G in bluegoasts)
		qdel(G)
	bluegoasts.Cut()

/obj/effect/bluegoast
	name = "bluespace echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/carbon/human/daddy
	anchored = 1
	var/reality = 0
	simulated = 0

/obj/effect/bluegoast/New(nloc, ndaddy)
	..(nloc)
	if(!ndaddy)
		qdel(src)
		return
	daddy = ndaddy
	appearance = daddy.appearance
	GLOB.moved_event.register(daddy, src,/obj/effect/bluegoast/proc/mirror)
	GLOB.destroyed_event.register(daddy, src, /datum/proc/qdel_self)

/obj/effect/bluegoast/Destroy()
	GLOB.destroyed_event.unregister(daddy,src)
	GLOB.moved_event.unregister(daddy, src)
	daddy = null
	. = ..()

/obj/effect/bluegoast/proc/mirror(var/atom/movable/am, var/old_loc, var/new_loc)
	var/ndir = get_dir(new_loc,old_loc)
	appearance = daddy.appearance
	set_dir(ndir)
	var/nloc = get_step(src, ndir)
	if(nloc)
		forceMove(nloc)
	if(nloc == new_loc)
		reality++
		if(reality > 5)
			to_chat(daddy, "<span class='notice'>Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended...</span>")
			blueswitch()
		else if(reality > 3)
			to_chat(daddy, "<span class='danger'>Something is definitely wrong. Why do you think YOU are the original?</span>")
		else
			to_chat(daddy, "<span class='warning'>You feel a bit less real. Which one of you two was original again?..</span>")

/obj/effect/bluegoast/examine(user)
	return daddy.examine(user)

/obj/effect/bluegoast/proc/blueswitch()
	var/mob/living/carbon/human/H = new(get_turf(src), daddy.species.name)
	H.real_name = daddy.real_name
	H.dna = daddy.dna.Clone()
	H.sync_organ_dna()
	H.flavor_text = daddy.flavor_text
	H.UpdateAppearance()
	var/datum/job/job = job_master.GetJob(daddy.job)
	if(job)
		job.equip(H)
	daddy.dust()
	qdel(src)

/obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#FF9900"
	alpha = 100
	blend_mode = BLEND_SUBTRACT
	layer = FULLSCREEN_LAYER