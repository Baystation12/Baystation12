/*
 * Holopad
 */

/obj/machinery/hologram/holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon_state = "holopad0"

	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER

	idle_power_usage = 5
	use_power = 1
	active_power_usage = 100

	var/holo_range = 5                             // Change to change how far the AI can move away from the holopad before deactivating.
	var/power_per_hologram = 500                   //  per usage per hologram

	var/list/mob/living/silicon/ai/masters = new() //List of AIs that use the holopad. Legacy cruft.

	var/list/holopad_actions                       // Currently ongoing hologram actions
	var/static/list/holopad_action_creators

/obj/machinery/hologram/holopad/initialize()
	..()
	holopad_actions = list()
	if(!holopad_action_creators)
		holopad_action_creators = list()
		var/decls = decls_repository.decls_of_subtype(/decl/holopad_action_creator)
		for(var/decl in decls)
			holopad_action_creators += decls[decl]

/obj/machinery/hologram/holopad/Destroy()
	qdel_null_list(holopad_actions)
	masters = null
	. = ..()

/obj/machinery/hologram/holopad/update_icon()
	if(holopad_actions.len)
		icon_state = "holopad1"
		set_light(2)
	else
		icon_state = initial(icon_state)
		set_light(0)

/obj/machinery/hologram/holopad/process()
	for(var/hologram_action in holopad_actions)
		var/datum/holopad_action/ha = hologram_action
		ha.process()
		use_power(power_per_hologram)

//Destruction procs.
/obj/machinery/hologram/holopad/ex_act(severity)
	switch(severity)
		if(EX_ACT_MAJOR)
			qdel(src)
		if(EX_ACT_MODERATE)
			if (prob(50))
				qdel(src)
		if(EX_ACT_MINOR)
			if (prob(5))
				qdel(src)

/obj/machinery/hologram/holopad/attack_ai(var/user)
	attack_hand(user)

/obj/machinery/hologram/holopad/attack_hand(var/user)
	// Attempt to interact with all active holopad actions
	for(var/hologram_action in holopad_actions)
		var/datum/holopad_action/ha = hologram_action
		if(ha.interact(user))
			return

	// If we found nothing to interact with, instead attempt to create a new holopad action
	var/list/actions = get_holopad_action_creators(user)
	if(!actions.len)
		to_chat(user, "<span class='danger'>No holopad actions available at this time.</span>")
		return

	var/decl/holopad_action_creator/action_creator = input("Select holopad action", "Holopad Action") as null|anything in actions
	if(!action_creator || !action_creator.can_conduct_action(src, user))
		return

	var/new_action = action_creator.conduct_action(src, user)
	if(!new_action)
		return

	destroyed_event.register(new_action, src, /obj/machinery/hologram/holopad/proc/action_destroyed)
	holopad_actions += new_action
	update_icon()

/obj/machinery/hologram/holopad/proc/get_holopad_action_creators(var/user)
	. = list()
	for(var/creator in holopad_action_creators)
		var/decl/holopad_action_creator/hc = creator
		if(hc.can_conduct_action(src, user))
			. += hc

/obj/machinery/hologram/holopad/proc/action_destroyed(var/destroyed_action)
	holopad_actions -= destroyed_action
	destroyed_event.register(destroyed_action, src, /obj/machinery/hologram/holopad/proc/action_destroyed)
	update_icon()

/*
* Holopad Action Creators
*/

/decl/holopad_action_creator
	var/name = "Hologram Action"
	var/datum/holopad_action/holopad_action_type

	var/static/list/actions_by_user // We are cruel and evil and only allow one hologram per user

/decl/holopad_action_creator/New()
	..()
	if(!actions_by_user)
		actions_by_user = list()

/decl/holopad_action_creator/proc/can_conduct_action(var/obj/machinery/hologram/holopad/holopad, var/mob/user)
	return holopad && user && holopad.operable() && !user.incapacitated() && !(user in actions_by_user)

/decl/holopad_action_creator/proc/conduct_action(var/obj/machinery/hologram/holopad/holopad, var/user)
	var/new_holo_action = new holopad_action_type(holopad, user)
	actions_by_user[user] = new_holo_action
	destroyed_event.register(new_holo_action, src, /decl/holopad_action_creator/proc/hologram_unmade)
	return new_holo_action

/decl/holopad_action_creator/proc/hologram_unmade(var/datum/holopad_action/action)
	actions_by_user -= action.user
	destroyed_event.unregister(action, src, /decl/holopad_action_creator/proc/hologram_unmade)

// AI hologram creation
/decl/holopad_action_creator/ai_hologram
	name = "Engage Holopad"
	holopad_action_type = /datum/holopad_action/ai

/decl/holopad_action_creator/ai_hologram/can_conduct_action(var/obj/machinery/hologram/holopad/holopad, var/mob/living/silicon/ai/AI)
	return istype(AI) && ..()

/decl/holopad_action_creator/ai_hologram/conduct_action(var/obj/machinery/hologram/holopad/holopad, var/mob/living/silicon/ai/AI)
	AI.eyeobj.setLoc(get_turf(holopad)) //Set client eye on the holopad if it's not already.
	. = ..()
	to_chat(AI, "<span>You engage \the [holopad].</span>")

// AI hologram request
/decl/holopad_action_creator/ai_request
	name = "Request AI Presence"
	var/list/holo_requests

/decl/holopad_action_creator/ai_request/New()
	..()
	holo_requests = list()

/decl/holopad_action_creator/ai_request/can_conduct_action(var/obj/machinery/hologram/holopad/holopad, var/mob/living/user)
	return istype(user) && !isAI(user) && ..()

/decl/holopad_action_creator/ai_request/conduct_action(var/obj/machinery/hologram/holopad/holopad, var/mob/living/user)
	if(holopad in holo_requests)
		to_chat(user, "<span class='warning'>There is already a pending AI request.</span>")
		return

	holo_requests += holopad
	spawn(20 SECONDS)
		holo_requests -= holopad

	to_chat(user, "<span class='notice'>You request an AI's presence.</span>")
	for(var/mob/living/silicon/ai/AI in living_mob_list_)
		if(!AI.client)	continue
		to_chat(AI, "<span class='info'>Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [get_area(holopad)]</a>.</span>")

/*
* Holopad Actions
*/

/datum/holopad_action
	var/mob/user
	var/obj/machinery/hologram/holopad/host
	var/obj/effect/overlay/holographic_overlay

/datum/holopad_action/New(var/host, var/user)
	..()

	src.user = user
	register_user(user)

	src.host = host

	holographic_overlay = create_hologram(host, user)

/datum/holopad_action/Destroy()
	if(holographic_overlay)
		host.visible_message("<span class='notice'>The holographic image belonging to \the [user] fades away.</span>")
		qdel_null(holographic_overlay)
	unregister_user(user)
	host = null
	. = ..()

/datum/holopad_action/proc/create_hologram(var/atom/host, var/user)
	var/obj/effect/overlay/hologram = new(get_turf(host))//Spawn a blank effect at the location.
	hologram.desc = "This is a holographic image belonging to \the [user]."
	hologram.mouse_opacity = 0         //So you can't click on it.
	hologram.plane = ABOVE_HUMAN_PLANE
	hologram.layer = ABOVE_HUMAN_LAYER //Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = 1              //So space wind cannot drag it.
	hologram.set_light(2)	           //hologram lighting
	hologram.color = host.color        //painted holopad gives coloured holograms

	host.visible_message("<span class='notice'>A holographic image belonging to \the [user] flicks to life right before your eyes!</span>")
	return hologram

/datum/holopad_action/proc/register_user(var/user)
	destroyed_event.register(user, src, /datum/proc/qdel_self)
	stat_set_event.register(user, src, /datum/proc/qdel_self)

/datum/holopad_action/proc/unregister_user(var/user)
	destroyed_event.unregister(user, src, /datum/proc/qdel_self)
	stat_set_event.unregister(user, src, /datum/proc/qdel_self)

/datum/holopad_action/proc/process()
	if(host.inoperable()) // We have this check here, in case someone ever wants to create holograms that somehow power themselves
		qdel(src)
		return FALSE
	else if(!(holographic_overlay in view(host)))
		qdel(src)
		return FALSE
	return TRUE

/datum/holopad_action/proc/interact(var/user)
	return FALSE

// AI
/datum/holopad_action/ai/Destroy()
	var/mob/living/silicon/ai/A = user
	if(A.holo == host)
		A.holo = null
	host.masters -= A
 . = ..()

/datum/holopad_action/ai/create_hologram(var/obj/machinery/hologram/holopad/host, var/user)
	. = ..()

	var/obj/effect/overlay/hologram = .
	var/mob/living/silicon/ai/A = user

	hologram.name = "[A.name] (Hologram)"//If someone decides to right click.
	hologram.overlays += A.holo_icon   // Add the AI's configured holo Icon

	A.holo = host
	host.masters[A] = src

/datum/holopad_action/ai/process()
	if(..())
		return user.client && user.eyeobj && !user.incapacitated()

/datum/holopad_action/ai/interact(var/interacter)
	if(user == interacter)
		. = TRUE
		qdel(src)

/*
* Legacy AI hologram helpers
*/

/obj/machinery/hologram/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(masters[user])
		var/datum/holopad_action/hologram = masters[user]
		var/obj/effect/overlay/H = hologram.holographic_overlay
		step_to(H, user.eyeobj) // So it turns.
		H.forceMove(get_turf(user.eyeobj))

		if(!(H in view(src)))
			qdel(hologram)
			return 0

		if(get_dist(user.eyeobj, src) > holo_range)
			qdel(hologram)
			return 0
	return 1

/obj/machinery/hologram/holopad/proc/set_dir_hologram(new_dir, mob/living/silicon/ai/user)
	if(masters[user])
		var/datum/holopad_action/hologram = masters[user]
		var/obj/effect/overlay/H = hologram.holographic_overlay
		H.set_dir(new_dir)
