/datum/extension/on_click/alt/ghost_admin_killer
	expected_type = /mob/living
	var/mob/living/living_holder
	var/death_proc

/datum/extension/on_click/alt/ghost_admin_killer/New(var/host, var/death_proc)
	..()
	living_holder = host
	src.death_proc = death_proc || /mob/proc/death

/datum/extension/on_click/alt/ghost_admin_killer/Destroy()
	living_holder = null
	. = ..()

/datum/extension/on_click/alt/ghost_admin_killer/on_click(var/mob/user)
	if(!valid_preconditions(user))
		return FALSE

	var/key_name = key_name(living_holder)
	if(alert(user, "Do you wish to kill [key_name]?", "Kill [living_holder]?", "No", "Yes") != "Yes")
		return FALSE
	if(!valid_preconditions(user))
		to_chat(user, SPAN_NOTICE("You were unable to kill [key_name]"))
		return FALSE

	call(living_holder, death_proc)()
	log_and_message_admins("killed [key_name]")

	return TRUE

/datum/extension/on_click/alt/ghost_admin_killer/proc/valid_preconditions(var/mob/observer/ghost/user)
	if(QDELETED(living_holder))               // Sanity check
		return FALSE
	if(!istype(user))                         // Only ghosts may attempt to alt-kill mobs
		return FALSE
	if(!check_rights(R_INVESTIGATE, 0, user)) // And only if they're investigators - Power creep
		return FALSE
	if(!living_holder.client)                 // And only if the target mob is currently possessed
		to_chat(user, SPAN_NOTICE("\The [living_holder] is not currently possessed."))
		return FALSE
	if(living_holder.stat == DEAD)            // No point in killing the already dead
		to_chat(user, SPAN_NOTICE("\The [living_holder] is already dead."))
		return FALSE
	return TRUE

/mob/living/Initialize()
	. = ..()
	if(possession_candidate)
		set_extension(src, /datum/extension/on_click/alt/ghost_admin_killer)
