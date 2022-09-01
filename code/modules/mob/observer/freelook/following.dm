/mob/observer/eye/stop_following()
	if(following && owner)
		to_chat(owner, "<span class='warning'>Stopped following \the [following]</span>")
	..()

/mob/observer/eye/start_following(atom/a)
	..()
	if(owner)
		to_chat(owner, "<span class='notice'>Now following \the [a]</span>")

/mob/observer/eye/keep_following(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	setLoc(get_turf(new_loc))

/mob/observer/eye/EyeMove()
	stop_following()
	. = ..()
