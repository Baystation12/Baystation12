/var/repository/client_eye/client_eye_repository = new()

/mob/proc/reset_view()
	// This is going away

/mob/Login()
	..()

	// We want to update the client view ASAP when a client is shunted into a new mob
	//  or they have a tendency to be stuck in eternal darkness until the next tick.
	client_eye_repository.process_mob(src)

/repository/client_eye
	var/list/clients_eyes_by_mob

	// Order matters as client eye instances are processed from left to right.
	var/list/clients_eye_types_by_type = list(
		/mob = list(/datum/client_eye/eye_obj, /datum/client_eye/virtual, /datum/client_eye/default)
	)

/repository/client_eye/New()
	..()
	clients_eyes_by_mob = list()

/repository/client_eye/proc/add_client_eye(var/mob/mob, var/datum/client_eye/client_eye)
	if(!istype(mob))
		CRASH("Invalid mob supplied: [log_info_line(mob)]")
	if(!istype(client_eye))
		CRASH("Invalid client eye supplied: [log_info_line(client_eye)]")

	var/list/client_eyes = clients_eyes_by_mob[mob] || setup_client_eyes(mob)
	client_eyes.Insert(1, client_eyes)
	process_mob(mob)

/repository/client_eye/proc/remove_client_eye(var/mob/mob, var/datum/client_eye/client_eye)
	if(!istype(mob))
		CRASH("Invalid mob supplied: [log_info_line(mob)]")
	if(!istype(client_eye))
		CRASH("Invalid client eye supplied: [log_info_line(client_eye)]")

	var/list/client_eyes = clients_eyes_by_mob[mob]
	if(!client_eyes)
		return

	client_eyes -= client_eyes
	process_mob(mob)

/repository/client_eye/proc/process_mob(var/mob/mob)
	if(!istype(mob))
		CRASH("Invalid mob supplied: [log_info_line(mob)]")
	if(!mob.client)
		return
	var/list/client_eyes = clients_eyes_by_mob[mob] || setup_client_eyes(mob)

	for(var/ce in client_eyes)
		var/datum/client_eye/client_eye = ce
		switch(client_eye.process())
			if(CLIENT_EYE_REMOVE)
				client_eyes -= client_eye
				qdel(client_eye)
			if(CLIENT_EYE_APPLICABLE)
				break

/repository/client_eye/proc/setup_client_eyes(var/mob/mob)
	var/list/client_eyes = clients_eyes_by_mob[mob]
	if(client_eyes)
		return client_eyes

	client_eyes = list()
	for(var/cet in get_client_eye_types(mob))
		client_eyes += new cet(src, mob)
	clients_eyes_by_mob[mob] = client_eyes

	destroyed_event.register(mob, src, /repository/client_eye/proc/clear_client_eyes)
	return client_eyes

/repository/client_eye/proc/get_client_eye_types(var/mob)
	for(var/ctype in clients_eye_types_by_type)
		if(istype(mob, ctype))
			return clients_eye_types_by_type[ctype]
	return list(/datum/client_eye/default)

/repository/client_eye/proc/clear_client_eyes(var/mob/mob)
	destroyed_event.unregister(mob, src, /repository/client_eye/proc/clear_client_eyes)

	var/client_eyes = clients_eyes_by_mob[mob]
	qdel_null_list(client_eyes)
	clients_eyes_by_mob -= mob

/*
	The main client_eye implementations.
*/

/datum/client_eye
	var/mob/owner
	var/repository/client_eye/client_eye_repository

/datum/client_eye/New(var/client_eye_repository, var/mob/owner)
	if(!istype(owner))
		CRASH("Invalid owner supplied: [log_info_line(owner)]")
	src.owner = owner
	src.client_eye_repository = client_eye_repository
	..()

/datum/client_eye/Destroy()
	owner = null
	client_eye_repository = null
	. = ..()

// Sometimes an update which cannot wait until the next tick may be needed or things might look wonky.
/datum/client_eye/proc/request_refresh()
	return client_eye_repository.process_mob(owner)

// A helpful base proc.
/datum/client_eye/proc/process()
	return CLIENT_EYE_REMOVE

/datum/client_eye/eye_obj/process()
	if(!owner.eyeobj)
		return CLIENT_EYE_SKIP

	adjust_client_eye(owner.eyeobj)
	return CLIENT_EYE_APPLICABLE

/datum/client_eye/virtual/process()
	if(!owner.virtual_mob)
		return CLIENT_EYE_SKIP

	adjust_client_eye(owner.virtual_mob)
	return CLIENT_EYE_APPLICABLE

/datum/client_eye/default/New(var/client_eye, var/owner)
	..()
	moved_event.register(owner, src, /datum/client_eye/default/proc/owner_movement)

/datum/client_eye/default/Destroy()
	moved_event.unregister(owner, src, /datum/client_eye/default/proc/owner_movement)
	. = ..()

/datum/client_eye/default/proc/owner_movement(var/mob/owner, var/old_loc, var/new_loc)
	// Let us attempt to cause as little overhead as possible.
	// We only want to cause a refresh when moving between a turf and a non-turf.
	if(owner.client && (isturf(old_loc) ^ isturf(new_loc)))
		request_refresh()

/datum/client_eye/default/process()
	var/new_eye
	var/new_perspective
	if(isturf(owner.loc))
		new_eye = owner
		new_perspective = MOB_PERSPECTIVE
	else
		// For correctness we should really recursively walk up the loc-chain until we hit the last loc before turf.
		// For performance concerns and because it probably (hopefully) won't matter much we just stick with loc.
		// If nothing else, this is pretty match matches the original client.eye adjustments made across the codebase.
		new_eye = owner.loc
		new_perspective = EYE_PERSPECTIVE

	adjust_client_eye(new_eye, new_perspective)
	return CLIENT_EYE_APPLICABLE

/datum/client_eye/proc/adjust_client_eye(var/new_eye, var/new_perspective = EYE_PERSPECTIVE, var/new_view = world.view)
	// Assigning these vars a value apparently cause a client view update, whether there was an actual change or not
	if(owner.client.eye != new_eye)
		owner.client.eye = new_eye
	if(owner.client.view != new_view)
		owner.client.view = new_view
	if(owner.client.perspective != new_perspective)
		owner.client.perspective = new_perspective
