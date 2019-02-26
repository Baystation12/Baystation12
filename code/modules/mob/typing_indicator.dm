/*Typing indicators, when a mob uses the F3/F4 keys to bring the say/emote input boxes up this little buddy is
made and follows them around until they are done (or something bad happens), helps tell nearby people that 'hey!
I IS TYPIN'!'
*/

/mob
	var/atom/movable/overlay/typing_indicator/typing_indicator = null

/atom/movable/overlay/typing_indicator
	follow_proc = /atom/movable/proc/move_to_turf_or_null
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"

/atom/movable/overlay/typing_indicator/Initialize()
	. = ..()
	if(!istype(master, /mob))
		crash_with("Master of typing_indicator has invalid type: [master.type].")

	GLOB.stat_set_event.register(master, src, /datum/proc/qdel_self) // Making the assumption master is conscious at creation
	GLOB.logged_out_event.register(master, src, /datum/proc/qdel_self)

/atom/movable/overlay/typing_indicator/Destroy()

	GLOB.stat_set_event.unregister(master, src)
	GLOB.logged_out_event.unregister(master, src)

	var/mob/M = master
	M.typing_indicator = null

	. = ..()

/atom/movable/overlay/typing_indicator/SetInitLoc()
	forceMove(get_turf(master))

/mob/proc/create_typing_indicator()
	if(client && !stat && get_preference_value(/datum/client_preference/show_typing_indicator) == GLOB.PREF_SHOW)
		if(typing_indicator)
			qdel(typing_indicator)

		typing_indicator = new(src)

/mob/proc/remove_typing_indicator() // A bit excessive, but goes with the creation of the indicator I suppose
	QDEL_NULL(typing_indicator)

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","say (text)") as text
	remove_typing_indicator()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","me (text)") as text
	remove_typing_indicator()
	if(message)
		me_verb(message)
