/atom/movable/overlay/typing_indicator
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"
	
/atom/movable/overlay/typing_indicator/proc/follow_master()
	//master is the mob that creates the indicator and calls the follow proc
	name = master
	invisibility = master.invisibility
	moved_event.register(master, src, /atom/movable/proc/move_to_turf)
	destroyed_event.register(master, src, /atom/movable/overlay/typing_indicator/proc/destroy_self)
	
/atom/movable/overlay/typing_indicator/proc/destroy_self(var/mob/M)
	M = master
	moved_event.unregister(M, src)
	destroyed_event.unregister(M, src)
	if(M)
		M.typing_indicator = null
		M = null
	qdel(src)

mob/var/atom/movable/overlay/typing_indicator/typing_indicator = null
	
/mob/proc/create_typing_indicator()
	if(client && !stat && is_preference_enabled(/datum/client_preference/show_typing_indicator))
		if(!typing_indicator)
			typing_indicator = new(loc)
			typing_indicator.master = usr
		typing_indicator.follow_master()
	else 
		if(typing_indicator)
			typing_indicator.destroy_self()
		
/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1
	
	create_typing_indicator()
	var/message = input("","say (text)") as text
	if(typing_indicator)
		typing_indicator.destroy_self()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","me (text)") as text
	if(typing_indicator)
		typing_indicator.destroy_self()
	if(message)
		me_verb(message)

/mob/Logout()
	..()
	if(typing_indicator)
		typing_indicator.destroy_self()
	
/mob/death()
	..()
	if(typing_indicator)
		typing_indicator.destroy_self()