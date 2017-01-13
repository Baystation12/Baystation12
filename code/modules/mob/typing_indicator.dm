/atom/movable/overlay/typing_indicator
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"
	
/atom/movable/overlay/typing_indicator/proc/destroy_self(var/mob/master)
	if(master)
		master.typing_indicator = null
		master = null
	qdel(src)

mob/var/atom/movable/overlay/typing_indicator = null

/mob/proc/typing_indicator_follow_me(var/atom/movable/overlay/typing_indicator/follower)
	if(follower)
		return
	
	follower = typing_indicator
	moved_event.register(src, follower, /atom/movable/proc/move_to_turf)
	destroyed_event.register(src, follower, /atom/movable/overlay/typing_indicator/proc/destroy_self)
	death_event.register(src, follower, /atom/movable/overlay/typing_indicator/proc/destroy_self)

	move_to_turf(follower, loc, usr.loc)
	
/mob/proc/create_typing_indicator()
	if(client && !stat && is_preference_enabled(/datum/client_preference/show_typing_indicator))
		if(!typing_indicator)
			typing_indicator = new /atom/movable/overlay/typing_indicator(loc)
			typing_indicator.name = name
			typing_indicator.invisibility = invisibility
			typing_indicator.master = usr
		typing_indicator_follow_me()
	else 
		if(typing_indicator)
			destroy_typing_indicator()
			
/mob/proc/destroy_typing_indicator()
	if(typing_indicator)
		qdel(typing_indicator)
		typing_indicator = null
		
/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","say (text)") as text
	destroy_typing_indicator()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","me (text)") as text
	destroy_typing_indicator()
	if(message)
		me_verb(message)
