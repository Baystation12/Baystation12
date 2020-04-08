
/obj/item/device/radio/announcer
	invisibility = 101
	listening = 1
	long_range = 1

/obj/item/device/radio/announcer/Destroy()
	crash_with("attempt to delete a [src.type] detected, and prevented.")
	return 1

/obj/item/device/radio/announcer/Initialize()
	. = ..()
	forceMove(locate(1,1,GLOB.using_map.contact_levels.len ? GLOB.using_map.contact_levels[1] : 1))

	return INITIALIZE_HINT_LATELOAD

/obj/item/device/radio/announcer/LateInitialize()
	//connect to channels
	for(var/dongle_type in typesof(/obj/item/device/channel_dongle/) - /obj/item/device/channel_dongle/)
		var/obj/item/device/channel_dongle/new_dongle = new dongle_type(src)
		src.insert_dongle(null, new_dongle, 0)
