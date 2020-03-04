
/obj/item/device/radio/announcer
	invisibility = 101
	listening = 0
	channels=list("Engineering" = 1, "Security" = 1, "Medical" = 1, "Command" = 1, "Common" = 1, "Science" = 1, "Supply" = 1, "Service" = 1,\
	"SHIPCOM" = 1,"TEAMCOM" = 1,"SQUADCOM" = 1,"FLEETCOM" = 1,"EBAND" = 1,"BattleNet" = 1,"GCPD" = 1, "INNIECOM" = 1, "TACCOM" = 1, "System" = 1,"RamNet" = 1,"BoulderNet" = 1)

/obj/item/device/radio/announcer/Destroy()
	crash_with("attempt to delete a [src.type] detected, and prevented.")
	return 1

/obj/item/device/radio/announcer/Initialize()
	. = ..()
	forceMove(locate(1,1,GLOB.using_map.contact_levels.len ? GLOB.using_map.contact_levels[1] : 1))

/obj/item/device/radio/announcer/subspace
	//subspace_transmission = 1

/obj/item/device/radio/announcer/autosay(var/message, var/from, var/channel, var/language_name) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return
	var/mob/living/silicon/ai/A = new /mob/living/silicon/ai(src, null, null, 1)
	A.fully_replace_character_name(from)
	Broadcast_Message(connection,A,0,"states",src,message,from,"Ship",from,from,4,0,list(0),connection.frequency)
	qdel(A)
