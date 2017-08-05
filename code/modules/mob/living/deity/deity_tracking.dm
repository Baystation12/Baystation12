/mob/living/deity/verb/jump_to_follower()
	set category = "Godhood"

	if(!minions)
		return

	var/list/could_follow = list()
	for(var/m in minions)
		var/datum/mind/M = m
		if(M.current && M.current.stat != DEAD)
			could_follow += M.current

	if(!could_follow.len)
		return

	var/choice = input(src, "Jump to follower", "Teleport") as null|anything in could_follow
	if(choice)
		follow_follower(choice)

/mob/living/deity/proc/follow_follower(var/mob/living/L)
	if(following)
		stop_follow()
	eyeobj.setLoc(get_turf(L))
	to_chat(src, "<span class='notice'>You begin to follow \the [L].</span>")
	following = L
	GLOB.moved_event.register(L, src, /mob/living/deity/proc/keep_following)
	GLOB.destroyed_event.register(L, src, /mob/living/deity/proc/stop_follow)

/mob/living/deity/proc/stop_follow()
	GLOB.moved_event.unregister(following, src)
	GLOB.destroyed_event.unregister(following, src)
	to_chat(src, "<span class='notice'>You stop following \the [following].</span>")
	following = null

/mob/living/deity/proc/keep_following(var/atom/movable/moving_instance, var/atom/old_loc, var/atom/new_loc)
	if(following.stat == DEAD)
		stop_follow()
		return
	eyeobj.setLoc(new_loc)
