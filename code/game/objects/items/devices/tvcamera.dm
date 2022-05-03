/obj/item/device/camera/tvcamera
	name = "press camera drone"
	desc = "A Ward-Takahashi EyeBuddy livestreaming press camera drone. Weapon of choice for war correspondents and reality show cameramen. It does not appear to have any internal memory storage."
	icon_state = "camcorder"
	item_state = "camcorder"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT
	var/channel = "General News Feed"
	var/obj/machinery/camera/network/thunder/camera
	var/obj/item/device/radio/radio

/obj/item/device/camera/tvcamera/New()
	..()
	GLOB.listening_objects += src

/obj/item/device/camera/tvcamera/Destroy()
	GLOB.listening_objects -= src
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	. = ..()

/obj/item/device/camera/tvcamera/Initialize()
	camera = new(src)
	camera.c_tag = channel
	camera.status = FALSE
	radio = new(src)
	radio.listening = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.power_usage = 0
	. = ..()

/obj/item/device/camera/tvcamera/examine(mob/user)
	. = ..()
	to_chat(user, "Video feed is currently: [camera.status ? "Online" : "Offline"]")
	to_chat(user, "Audio feed is currently: [radio.broadcasting ? "Online" : "Offline"]")
	to_chat(user, "Photography setting is currently: [on ? "On" : "Off"]")

/obj/item/device/camera/tvcamera/attack_self(mob/user)
	add_fingerprint(user)
	user.set_machine(src)
	var/dat = list()
	dat += "Photography mode is currently: <a href='?src=\ref[src];photo=1'>[on ? "On" : "Off"]</a><br>"
	dat += "Photography focus is currently: <a href='?src=\ref[src];focus=1'>[size]</a><br>"
	dat += "Channel name is: <a href='?src=\ref[src];channel=1'>[channel ? channel : "unidentified broadcast"]</a><br>"
	dat += "Video streaming is: <a href='?src=\ref[src];video=1'>[camera.status ? "Online" : "Offline"]</a><br>"
	dat += "Microphone is: <a href='?src=\ref[src];sound=1'>[radio.broadcasting ? "Online" : "Offline"]</a><br>"
	dat += "Sound is being broadcasted on frequency: [format_frequency(radio.frequency)] ([get_frequency_default_name(radio.frequency)])<br>"
	var/datum/browser/popup = new(user, "Press Camera Drone", "EyeBuddy", 300, 390, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/device/camera/tvcamera/Topic(bred, href_list, state = GLOB.physical_state)
	if(..())
		return 1
	if (href_list["photo"])
		on = !on
	if (href_list["focus"])
		change_size()
	if(href_list["channel"])
		var/nc = sanitize(input(usr, "Channel name", "Select new channel name", channel) as text|null)
		if(nc)
			channel = nc
			camera.c_tag = channel
			to_chat(usr, "<span class='notice'>New channel name: '[channel]' has been set.</span>")
	if(href_list["video"])
		camera.set_status(!camera.status)
		if(camera.status)
			to_chat(usr,"<span class='notice'>Video streaming: Activated. Broadcasting on channel: '[channel]'</span>")
		else
			to_chat(usr,"<span class='notice'>Video streaming: Deactivated.</span>")
		update_icon()
	if(href_list["sound"])
		radio.ToggleBroadcast()
		if(radio.broadcasting)
			to_chat(usr,"<span class='notice'>Audio streaming: Activated. Broadcasting on frequency: [format_frequency(radio.frequency)].</span>")
		else
			to_chat(usr,"<span class='notice'>Audio streaming: Deactivated.</span>")
	if(!href_list["close"])
		attack_self(usr)

/obj/item/device/camera/tvcamera/on_update_icon()
	..()
	if(camera.status)
		icon_state = "camcorder_on"
		item_state = "camcorder_on"
	else
		icon_state = "camcorder"
		item_state = "camcorder"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_r_hand(0)
		H.update_inv_l_hand()

/* Assembly by a roboticist */
/obj/item/robot_parts/head/attackby(var/obj/item/device/assembly/S, mob/user as mob)
	if ((!istype(S, /obj/item/device/assembly/infra)))
		..()
		return
	var/obj/item/TVAssembly/A = new(user)
	qdel(S)
	user.put_in_hands(A)
	to_chat(user, "<span class='notice'>You add the infrared sensor to the robot head.</span>")
	qdel(src)

/* Using camcorder icon as I can't sprite.
Using robohead because of restricting to roboticist */
/obj/item/TVAssembly
	name = "TV Camera assembly"
	desc = "A robotic head with an infrared sensor inside."
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "head"
	item_state = "head"
	var/buildstep = 0
	w_class = ITEM_SIZE_LARGE

/obj/item/TVAssembly/attackby(var/obj/item/W, var/mob/user)
	switch(buildstep)
		if(0)
			if(istype(W, /obj/item/robot_parts/robot_component/camera))
				to_chat(user, "<span class='notice'>You add the camera module to [src]</span>")
				qdel(W)
				desc = "This TV camera assembly has a camera module."
				buildstep++
		if(1)
			if(istype(W, /obj/item/device/taperecorder))
				qdel(W)
				buildstep++
				to_chat(user, "<span class='notice'>You add the tape recorder to [src]</span>")
				desc = "This TV camera assembly has a camera and audio module."
				return
		if(2)
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if(!C.use(3))
					to_chat(user, "<span class='notice'>You need three cable coils to wire the devices.</span>")
					..()
					return
				buildstep++
				to_chat(user, "<span class='notice'>You wire the assembly</span>")
				desc = "This TV camera assembly has wires sticking out."
				return
		if(3)
			if(isWirecutter(W))
				to_chat(user, "<span class='notice'> You trim the wires.</span>")
				buildstep++
				desc = "This TV camera assembly needs casing."
				return
		if(4)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/S = W
				if(S.use(1))
					buildstep++
					to_chat(user, "<span class='notice'>You encase the assembly.</span>")
					var/turf/T = get_turf(src)
					new /obj/item/device/camera/tvcamera(T)
					qdel(src)
					return
	..()