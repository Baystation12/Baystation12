/client/var/inquisitive_ghost = 1
/mob/observer/ghost/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, "<span class='notice'>You will now examine everything you click on.</span>")
	else
		to_chat(src, "<span class='notice'>You will no longer examine things you click on.</span>")

/mob/observer/ghost/DblClickOn(var/atom/A, var/params)
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, exosuit, etc)
			return

	// Things you might plausibly want to follow
	if(istype(A,/atom/movable))
		start_following(A)
	// Otherwise jump
	else
		stop_following()
		forceMove(get_turf(A))

/mob/observer/ghost/ClickOn(var/atom/A, var/params)
	if(!canClick()) return
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	// Not all of them require checking, see below
	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		// I'd rather call ..() but who knows what will break if we do that
		var/datum/extension/on_click/alt = get_extension(A, /datum/extension/on_click/alt)
		if(alt && alt.on_click(src))
			return
		var/target_turf = get_turf(A)
		if(target_turf)
			AltClickOn(target_turf)
		return
	if(modifiers["shift"])
		examinate(A)
		return
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/ghost/user as mob)
	if(!istype(user))
		return
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)
	return


/obj/effect/portal/attack_ghost(mob/user as mob)
	if(target)
		user.forceMove(get_turf(target))
