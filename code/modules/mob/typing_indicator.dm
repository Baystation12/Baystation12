mob/var/atom/movable/overlay/typing_indicator

/mob/proc/typing_indicator_follow_me(var/atom/movable/overlay/follower)
	if(follower)
		return
	
	follower = typing_indicator
	moved_event.register(src, follower, /atom/movable/proc/move_to_turf)
	dir_set_event.register(src, follower, /atom/proc/recursive_dir_set)
	destroyed_event.register(src, follower, /mob/proc/destroy_typing_indicator)

	move_to_turf(follower, loc, usr.loc)
	
/mob/proc/create_typing_indicator()
	if(client && !stat && is_preference_enabled(/datum/client_preference/show_typing_indicator))
		if(!typing_indicator)
			typing_indicator = new /atom/movable/overlay(loc)
			typing_indicator.icon = 'icons/mob/talk.dmi'
			typing_indicator.icon_state = "typing"
			typing_indicator.name = name
			typing_indicator.invisibility = invisibility
			typing_indicator.master = usr
		typing_indicator_follow_me()
	else
		destroy_typing_indicator()
			
/mob/proc/destroy_typing_indicator()
	if(typing_indicator)
		typing_indicator.Destroy()
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
