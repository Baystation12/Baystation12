/mob/living/chorus
	var/atom/movable/following

/mob/living/chorus/proc/follow_follower(var/mob/living/L)
	if(!L || L.stat == DEAD || !get_implant(L))
		return
	if(following)
		stop_follow()
	eyeobj.setLoc(get_turf(L))
	to_chat(src, "<span class='notice'>You begin to follow \the [L].</span>")
	following = L
	GLOB.moved_event.register(L, src, /mob/living/chorus/proc/keep_following)
	GLOB.destroyed_event.register(L, src, /mob/living/chorus/proc/stop_follow)
	GLOB.death_event.register(L, src, /mob/living/chorus/proc/stop_follow)

/mob/living/chorus/proc/stop_follow()
	GLOB.moved_event.unregister(following, src)
	GLOB.destroyed_event.unregister(following, src)
	GLOB.death_event.unregister(following,src)
	to_chat(src, "<span class='red'>You stop following \the [following].</span>")
	following = null

/mob/living/chorus/proc/keep_following(var/atom/movable/moving_instance, var/atom/old_loc, var/atom/new_loc)
	eyeobj.setLoc(new_loc)