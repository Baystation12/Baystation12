/obj/item/device/boombox
	name = "boombox"
	desc = "A device used to emit rhythmic sounds, colloquialy refered to as a 'boombox'. It's in a retro style (massive), and absolutely unwieldy."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "off"
	item_state = "boombox"
	force = 7
	w_class = ITEM_SIZE_HUGE //forbid putting something that emits loud sounds forever into a backpack
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/playing = 0
	var/track_num = 1
	var/volume = 20
	var/max_volume = 40
	var/frequency = 1
	var/datum/sound_token/sound_token
	var/list/datum/track/tracks
	var/sound_id
	var/break_chance = 3
	var/broken
	var/panel = TRUE

/obj/item/device/boombox/attack_self(var/mob/user)
	interact(user)

/obj/item/device/boombox/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"
	tracks = setup_music_tracks(tracks)

/obj/item/device/boombox/emp_act(severity)
	boombox_break()

/obj/item/device/boombox/examine(mob/user)
	. = ..()
	if(!panel)
		to_chat(user, SPAN_NOTICE("The front panel is unhinged."))
	if(broken)
		to_chat(user, SPAN_WARNING("It's broken."))

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
	dat += "<A href='?src=\ref[src];voldown=1;'>VOL -</a>"
	dat += "<A href='?src=\ref[src];volup=1;'>VOL +</a>"
	var/datum/browser/popup = new(user, "boombox", "BOOMTASTIC 3000", 290, 110)
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
	if(href_list["start"] && !broken)
		start()
		return TOPIC_HANDLED
	if(href_list["volup"])
		change_volume(volume + 10)
		return TOPIC_HANDLED
	if(href_list["voldown"])
		change_volume(volume - 10)
		return TOPIC_HANDLED

/obj/item/device/boombox/attackby(var/obj/item/W, var/mob/user)
	if(isScrewdriver(W))
		if(!panel)
			user.visible_message(SPAN_NOTICE("\The [user] re-attaches \the [src]'s front panel with \the [W]."), SPAN_NOTICE("You re-attach \the [src]'s front panel."))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			panel = TRUE
			return TRUE
		if(!broken)
			AdjustFrequency(W, user)
			return TRUE
		else if(panel)
			user.visible_message(SPAN_NOTICE("\The [user] unhinges \the [src]'s front panel with \the [W]."), SPAN_NOTICE("You unhinge \the [src]'s front panel."))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			panel = FALSE
	if(istype(W,/obj/item/stack/nanopaste))
		var/obj/item/stack/S = W
		if(broken && !panel)
			if(S.use(1))
				user.visible_message(SPAN_NOTICE("\The [user] pours some of \the [S] onto \the [src]."), SPAN_NOTICE("You pour some of \the [S] over \the [src]'s internals and watch as it retraces and resolders paths."))
				broken = FALSE
			else
				to_chat(user, SPAN_NOTICE("\The [S] is empty."))
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

/obj/item/device/boombox/on_update_icon()
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
	if(prob(break_chance))
		boombox_break()

/obj/item/device/boombox/proc/boombox_break()
	audible_message(SPAN_WARNING("\The [src]'s speakers pop with a sharp crack!"))
	playsound(src.loc, 'sound/effects/snap.ogg', 100, 1)
	broken = TRUE
	stop()

/obj/item/device/boombox/proc/change_volume(var/new_volume)
	volume = Clamp(new_volume, 0, max_volume)
	if(sound_token)
		sound_token.SetVolume(volume)

/obj/random_multi/single_item/boombox
	name = "boombox spawnpoint"
	id = "boomtastic"
	item_path = /obj/item/device/boombox/
