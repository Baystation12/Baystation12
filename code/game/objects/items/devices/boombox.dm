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
	var/datum/sound_token/sound_token
	var/list/datum/track/tracks
	var/sound_id

/obj/item/device/boombox/attack_self(mob/user)
	interact(user)

/obj/item/device/boombox/New()
	..()
	sound_id = "[type]_[sequential_id(type)]"

/obj/item/device/boombox/Initialize()
	. = ..()
	tracks = setup_music_tracks(tracks)

/obj/item/device/boombox/Destroy()
	stop()
	. = ..()

/obj/item/device/boombox/interact(mob/user)
	var/dat = "<A href='?src=\ref[src];tracknum=1;'>NEXT</a>"
	dat += "<A href='?src=\ref[src];tracknum=-1;'>PREV</a>"
	dat += "<A href='?src=\ref[src];start=1;'>PLAY</a>"
	dat += "<A href='?src=\ref[src];stop=1;'>STOP</a>"
	var/datum/browser/popup = new(user, "boombox", "BOOMTASTIC 3000", 120, 30)
	popup.set_content(dat)
	popup.open()

/obj/item/device/boombox/attack_ai(mob/user)
	return //silicons have no groove

/obj/item/device/boombox/CouldUseTopic(var/mob/user)
	..()
	if(istype(user, /mob/living/carbon))
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

/obj/item/device/boombox/update_icon()
	icon_state = playing ? "on" : "off"

/obj/item/device/boombox/proc/stop()
	playing = 0
	update_icon()
	QDEL_NULL(sound_token)

/obj/item/device/boombox/proc/start()
	QDEL_NULL(sound_token)
	var/datum/track/T = tracks[track_num]
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, T.GetTrack(), volume = volume, range = 7, falloff = 4, prefer_mute = TRUE)
	playing = 1
	update_icon()

/obj/random_multi/single_item/boombox
	name = "boombox spawnpoint"
	id = "boomtastic"
	item_path = /obj/item/device/boombox/