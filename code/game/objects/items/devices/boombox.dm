/obj/item/device/boombox
	name = "boombox"
	desc = "A device used to emit rhythmical sounds, colloquialy refered to as a 'boombox'."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "off"
	item_state = "boombox"
	force = 5
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/playing = 0
	var/track_num = 1
	var/volume = 40
	var/frequency = 1
	var/datum/sound_token/sound_token
	var/list/datum/track/tracks
	var/sound_id

/obj/item/device/boombox/attack_self(var/mob/user)
	interact(user)

/obj/item/device/boombox/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"
	tracks = setup_music_tracks(tracks)

/obj/item/device/boombox/Destroy()
	stop()
	. = ..()

/obj/item/device/boombox/interact(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/dat = "<A href='?src=\ref[src];tracknum=1;'>NEXT</a>"
	dat += "<A href='?src=\ref[src];tracknum=-1;'>PREV</a>"
	dat += "<A href='?src=\ref[src];start=1;'>PLAY</a>"
	dat += "<A href='?src=\ref[src];stop=1;'>STOP</a>"
	var/datum/browser/popup = new(user, "boombox", "BOOMTASTIC 3000", 220, 130)
	popup.set_content(dat)
	popup.open()

/obj/item/device/boombox/DefaultTopicState()
	return GLOB.physical_state

/obj/item/device/boombox/CouldUseTopic(var/mob/user)
	..()
	playsound(src, "switch", 40)

/obj/item/device/boombox/OnTopic(var/user, var/list/href_list)
	if(href_list["tracknum"])
		var/diff = text2num(href_list["tracknum"])
		track_num += diff
		if(track_num > tracks.len)
			track_num = 1
		else if (track_num < 1)
			track_num = tracks.len
		if(playing)
			start()
		return TOPIC_REFRESH
	if(href_list["stop"])
		stop()
		return TOPIC_HANDLED
	if(href_list["start"])
		start()
		return TOPIC_HANDLED

/obj/item/device/boombox/attackby(var/obj/item/W, var/mob/user)
	if(isScrewdriver(W))
		AdjustFrequency(W, user)
		return TRUE
	else
		. = ..()

/obj/item/device/boombox/proc/AdjustFrequency(var/obj/item/W, var/mob/user)
	var/const/MIN_FREQUENCY = 0.5
	var/const/MAX_FREQUENCY = 1.5

	if(!MayAdjust(user))
		return FALSE

	var/list/options = list()
	var/tighten = "Tighten (play slower)"
	var/loosen  = "Loosen (play faster)"

	if(frequency > MIN_FREQUENCY)
		options += tighten
	if(frequency < MAX_FREQUENCY)
		options += loosen

	var/operation = input(user, "How do you wish to adjust the player head?", "Adjust player", options[1]) as null|anything in options
	if(!operation)
		return FALSE
	if(!MayAdjust(user))
		return FALSE
	if(W != user.get_active_hand())
		return FALSE

	if(!CanPhysicallyInteract(user))
		return FALSE

	if(operation == loosen)
		frequency += 0.1
	else if(operation == tighten)
		frequency -= 0.1
	frequency = Clamp(frequency, MIN_FREQUENCY, MAX_FREQUENCY)

	user.visible_message(SPAN_NOTICE("\The [user] adjusts \the [src]'s player head."), SPAN_NOTICE("You adjust \the [src]'s player head."))
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

	if(frequency > 1.0)
		to_chat(user, SPAN_NOTICE("\The [src] should be playing faster than usual."))
	else if(frequency < 1.0)
		to_chat(user, SPAN_NOTICE("\The [src] should be playing slower than usual."))
	else
		to_chat(user, SPAN_NOTICE("\The [src] should be playing as fast as usual."))

	return TRUE

/obj/item/device/boombox/proc/MayAdjust(var/mob/user)
	if(playing)
		to_chat(user, "<span class='warning'>You can only adjust \the [src] when it's not playing.</span>")
		return FALSE
	return TRUE

/obj/item/device/boombox/update_icon()
	icon_state = playing ? "on" : "off"

/obj/item/device/boombox/proc/stop()
	playing = 0
	update_icon()
	QDEL_NULL(sound_token)

/obj/item/device/boombox/proc/start()
	QDEL_NULL(sound_token)
	var/datum/track/T = tracks[track_num]
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, T.GetTrack(), volume = volume, frequency = frequency, range = 7, falloff = 4, prefer_mute = TRUE)
	playing = 1
	update_icon()

/obj/random_multi/single_item/boombox
	name = "boombox spawnpoint"
	id = "boomtastic"
	item_path = /obj/item/device/boombox/
