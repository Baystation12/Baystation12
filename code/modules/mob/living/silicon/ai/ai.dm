#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2

var/list/ai_list = list()
var/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/ai_announcement,
	/mob/living/silicon/ai/proc/ai_call_shuttle,
	// /mob/living/silicon/ai/proc/ai_recall_shuttle,
	/mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_roster,
	/mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_acceleration,
	/mob/living/silicon/ai/proc/toggle_camera_light
)

//Not sure why this is necessary...
/proc/AutoUpdateAI(obj/subject)
	var/is_in_use = 0
	if (subject!=null)
		for(var/A in ai_list)
			var/mob/living/silicon/ai/M = A
			if ((M.client && M.machine == subject))
				is_in_use = 1
				subject.attack_ai(M)
	return is_in_use


/mob/living/silicon/ai
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = 1 // -- TLE
	density = 1
	status_flags = CANSTUN|CANPARALYSE|CANPUSH
	shouldnt_see = list(/obj/effect/rune)
	var/list/network = list("Exodus")
	var/obj/machinery/camera/camera = null
	var/list/connected_robots = list()
	var/aiRestorePowerRoutine = 0
	var/viewalerts = 0
	var/icon/holo_icon//Default is assigned when AI is created.
	var/obj/item/device/pda/ai/aiPDA = null
	var/obj/item/device/multitool/aiMulti = null
	var/obj/item/device/radio/headset/heads/ai_integrated/aiRadio = null
	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/last_announcement = ""
	var/control_disabled = 0
	var/datum/announcement/priority/announcement
	var/obj/machinery/ai_powersupply/psupply = null // Backwards reference to AI's powersupply object.

	//NEWMALF VARIABLES
	var/malfunctioning = 0						// Master var that determines if AI is malfunctioning.
	var/datum/malf_hardware/hardware = null		// Installed piece of hardware.
	var/datum/malf_research/research = null		// Malfunction research datum.
	var/obj/machinery/power/apc/hack = null		// APC that is currently being hacked.
	var/list/hacked_apcs = null					// List of all hacked APCs
	var/APU_power = 0							// If set to 1 AI runs on APU power
	var/hacking = 0								// Set to 1 if AI is hacking APC, cyborg, other AI, or running system override.
	var/system_override = 0						// Set to 1 if system override is initiated, 2 if succeeded.
	var/hack_can_fail = 1						// If 0, all abilities have zero chance of failing.
	var/hack_fails = 0							// This increments with each failed hack, and determines the warning message text.
	var/errored = 0								// Set to 1 if runtime error occurs. Only way of this happening i can think of is admin fucking up with varedit.
	var/bombing_core = 0						// Set to 1 if core auto-destruct is activated
	var/bombing_station = 0						// Set to 1 if station nuke auto-destruct is activated
	var/override_CPUStorage = 0					// Bonus/Penalty CPU Storage. For use by admins/testers.
	var/override_CPURate = 0					// Bonus/Penalty CPU generation rate. For use by admins/testers.

	var/datum/ai_icon/selected_sprite			// The selected icon set
	var/custom_sprite 	= 0 					// Whether the selected icon is custom
	var/carded

/mob/living/silicon/ai/proc/add_ai_verbs()
	src.verbs |= ai_verbs_default
	src.verbs |= silicon_subsystems

/mob/living/silicon/ai/proc/remove_ai_verbs()
	src.verbs -= ai_verbs_default
	src.verbs -= silicon_subsystems

/mob/living/silicon/ai/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	announcement = new()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = 1

	var/list/possibleNames = ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(ai_names)
		for (var/mob/living/silicon/ai/A in mob_list)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	aiPDA = new/obj/item/device/pda/ai(src)
	SetName(pickedName)
	anchored = 1
	canmove = 0
	density = 1
	loc = loc

	holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))

	proc_holder_list = new()

	if(L)
		if (istype(L, /datum/ai_laws))
			laws = L
	else
		laws = new base_law_type

	aiMulti = new(src)
	aiRadio = new(src)
	common_radio = aiRadio
	aiRadio.myAi = src
	additional_law_channels += "Binary"
	additional_law_channels += "Holopad"

	aiCamera = new/obj/item/device/camera/siliconcam/ai_camera(src)

	if (istype(loc, /turf))
		add_ai_verbs(src)

	//Languages
	add_language("Robot Talk", 1)
	add_language("Galactic Common", 1)
	add_language("Sol Common", 0)
	add_language("Sinta'unathi", 0)
	add_language("Siik'tajr", 0)
	add_language("Skrellian", 0)
	add_language("Tradeband", 1)
	add_language("Gutter", 0)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			empty_playable_ai_cores += new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

			on_mob_init()

	spawn(5)
		new /obj/machinery/ai_powersupply(src)


	hud_list[HEALTH_HUD]      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[LIFE_HUD] 		  = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[ID_HUD]          = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]      = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = image('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = image('icons/mob/hud.dmi', src, "hudblank")

	ai_list += src
	..()
	return

/mob/living/silicon/ai/proc/on_mob_init()
	src << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
	src << "<B>To look at other parts of the station, click on yourself to get a camera menu.</B>"
	src << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
	src << "To use something, simply click on it."
	src << "Use say :b to speak to your cyborgs through binary. Use say :h to speak from an active holopad."
	src << "For department channels, use the following say commands:"

	var/radio_text = ""
	for(var/i = 1 to common_radio.channels.len)
		var/channel = common_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != common_radio.channels.len)
			radio_text += ", "

	src << radio_text

	if (malf && !(mind in malf.current_antagonists))
		show_laws()
		src << "<b>These laws may be changed by other players, or by you being the traitor.</b>"

	job = "AI"
	setup_icon()

/mob/living/silicon/ai/Destroy()
	ai_list -= src
	qdel(eyeobj)
	..()

/mob/living/silicon/ai/proc/setup_icon()
	var/file = file2text("config/custom_sprites.txt")
	var/lines = text2list(file, "\n")

	for(var/line in lines)
	// split & clean up
		var/list/Entry = text2list(line, ":")
		for(var/i = 1 to Entry.len)
			Entry[i] = trim(Entry[i])

		if(Entry.len < 2)
			continue;

		if(Entry[1] == src.ckey && Entry[2] == src.real_name)
			icon = CUSTOM_ITEM_SYNTH
			custom_sprite = 1
			selected_sprite = new/datum/ai_icon("Custom", "[src.ckey]-ai", "4", "[ckey]-ai-crash", "#FFFFFF", "#FFFFFF", "#FFFFFF")
		else
			selected_sprite = default_ai_icon
	updateicon()

/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/living/silicon/ai/SetName(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.name = "[pickedName] (AI Eye)"

	// Set ai pda name
	if(aiPDA)
		aiPDA.ownjob = "AI"
		aiPDA.owner = pickedName
		aiPDA.name = pickedName + " (" + aiPDA.ownjob + ")"

/*
	The AI Power supply is a dummy object used for powering the AI since only machinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_powersupply
	name="Power Supply"
	active_power_usage=50000 // Station AIs use significant amounts of power. This, when combined with charged SMES should mean AI lasts for 1hr without external power.
	use_power = 2
	power_channel = EQUIP
	var/mob/living/silicon/ai/powered_ai = null
	invisibility = 100

/obj/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai=null)
	powered_ai = ai
	powered_ai.psupply = src
	if(isnull(powered_ai))
		qdel(src)

	loc = powered_ai.loc
	use_power(1) // Just incase we need to wake up the power system.

	..()

/obj/machinery/ai_powersupply/process()
	if(!powered_ai || powered_ai.stat & DEAD)
		qdel()
		return
	if(powered_ai.psupply != src) // For some reason, the AI has different powersupply object. Delete this one, it's no longer needed.
		qdel(src)
	if(powered_ai.APU_power)
		use_power = 0
		return
	if(!powered_ai.anchored)
		loc = powered_ai.loc
		use_power = 0
		use_power(50000) // Less optimalised but only called if AI is unwrenched. This prevents usage of wrenching as method to keep AI operational without power. Intellicard is for that.
	if(powered_ai.anchored)
		use_power = 2

/mob/living/silicon/ai/proc/pick_icon()
	set category = "AI Commands"
	set name = "Set AI Core Display"
	if(stat || aiRestorePowerRoutine)
		return

	if (!custom_sprite)
		var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in ai_icons
		if(new_sprite) selected_sprite = new_sprite
	updateicon()

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "AI Commands"
	set name = "Show Crew Manifest"
	show_station_manifest()

/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "AI Commands"
	set name = "Make Station Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		src << "Please allow one minute to pass between announcements."
		return
	var/input = input(usr, "Please write a message to announce to the station crew.", "A.I. Announcement")
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = "AI Commands"
	set name = "Call Emergency Shuttle"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to call the shuttle?", "Confirm Shuttle Call", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	// hack to display shuttle timer
	if(emergency_shuttle.online())
		var/obj/machinery/computer/communications/C = locate() in machines
		if(C)
			C.post_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "AI Commands"
	set name = "Recall Emergency Shuttle"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to recall the shuttle?", "Confirm Shuttle Recall", "Yes", "No")
	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "AI Commands"
	set name = "Send Emergency Message"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		usr <<"<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit message.</span>"
		return
	if(emergency_message_cooldown)
		usr << "<span class='warning'>Arrays recycling. Please stand by.</span>"
		return
	var/input = input(usr, "Please choose a message to transmit to Centcomm via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "")
	if(!input)
		return
	Centcomm_announce(input, usr)
	usr << "<span class='notice'>Message transmitted.</span>"
	log_say("[key_name(usr)] has made an IA Centcomm announcement: [input]")
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0


/mob/living/silicon/ai/check_eye(var/mob/user as mob)
	if (!camera)
		return -1
	return 0

/mob/living/silicon/ai/restrained()
	return 0

/mob/living/silicon/ai/emp_act(severity)
	if (prob(30))
		view_core()
	..()

/mob/living/silicon/ai/Topic(href, href_list)
	if(usr != src)
		return
	if(..())
		return
	if (href_list["mach_close"])
		if (href_list["mach_close"] == "aialerts")
			viewalerts = 0
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)
	if (href_list["switchcamera"])
		switchCamera(locate(href_list["switchcamera"])) in cameranet.cameras
	if (href_list["showalerts"])
		subsystem_alarm_monitor()
	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				src << "<span class='notice'>Unable to locate the holopad.</span>"

	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in mob_list

		if(target && (!istype(target, /mob/living/carbon/human) || html_decode(href_list["trackname"]) == target:get_face_name()))
			ai_actual_track(target)
		else
			src << "\red System error. Cannot locate [html_decode(href_list["trackname"])]."
		return

	return

/mob/living/silicon/ai/reset_view(atom/A)
	if(camera)
		camera.set_light(0)
	if(istype(A,/obj/machinery/camera))
		camera = A
	..()
	if(istype(A,/obj/machinery/camera))
		if(camera_light_on)	A.set_light(AI_CAMERA_LUMINOSITY)
		else				A.set_light(0)


/mob/living/silicon/ai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C || stat == DEAD) //C.can_use())
		return 0

	if(!src.eyeobj)
		view_core()
		return
	// ok, we're alive, camera is good and in our network...
	eyeobj.setLoc(get_turf(C))
	//machine = src

	return 1

/mob/living/silicon/ai/cancel_camera()
	set category = "AI Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()

//Replaces /mob/living/silicon/ai/verb/change_network() in ai.dm & camera.dm
//Adds in /mob/living/silicon/ai/proc/ai_network_change() instead
//Addition by Mord_Sith to define AI's network change ability
/mob/living/silicon/ai/proc/get_camera_network_list()
	if(check_unable())
		return

	var/list/cameralist = new()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		var/list/tempnetwork = difflist(C.network,restricted_camera_networks,1)
		for(var/i in tempnetwork)
			cameralist[i] = i

	cameralist = sortAssoc(cameralist)
	return cameralist

/mob/living/silicon/ai/proc/ai_network_change(var/network in get_camera_network_list())
	set category = "AI Commands"
	set name = "Jump To Network"
	unset_machine()

	if(!network)
		return

	if(!eyeobj)
		view_core()
		return

	src.network = network

	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.can_use())
			continue
		if(network in C.network)
			eyeobj.setLoc(get_turf(C))
			break
	src << "\blue Switched to [network] camera network."
//End of code by Mord_Sith

/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "AI Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "AI Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in data_core.locked)//Look in data core locked.
			personnel_list["[t.fields["name"]]: [t.fields["rank"]]"] = t.fields["image"]//Pull names, rank, and image.

		if(personnel_list.len)
			input = input("Select a crew member:") as null|anything in personnel_list
			var/icon/character_icon = personnel_list[input]
			if(character_icon)
				qdel(holo_icon)//Clear old icon so we're not storing it in memory.
				holo_icon = getHologramIcon(icon(character_icon))
		else
			alert("No suitable records found. Aborting.")

	else
		var/icon_list[] = list(
		"default",
		"floating face",
		"carp"
		)
		input = input("Please select a hologram:") as null|anything in icon_list
		if(input)
			qdel(holo_icon)
			switch(input)
				if("default")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo1"))
				if("floating face")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo2"))
				if("carp")
					holo_icon = getHologramIcon(icon('icons/mob/AI.dmi',"holo4"))
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "AI Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	src << "Camera lights [camera_light_on ? "activated" : "deactivated"]."
	if(!camera_light_on)
		if(camera)
			camera.set_light(0)
			camera = null
	else
		lightNearbyCamera()



// Handled camera lighting, when toggled.
// It will get the nearest camera from the eyeobj, lighting it.

/mob/living/silicon/ai/proc/lightNearbyCamera()
	if(camera_light_on && camera_light_on < world.timeofday)
		if(src.camera)
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && src.camera != camera)
				src.camera.set_light(0)
				if(!camera.light_disabled)
					src.camera = camera
					src.camera.set_light(AI_CAMERA_LUMINOSITY)
				else
					src.camera = null
			else if(isnull(camera))
				src.camera.set_light(0)
				src.camera = null
		else
			var/obj/machinery/camera/camera = near_range_camera(src.eyeobj)
			if(camera && !camera.light_disabled)
				src.camera = camera
				src.camera.set_light(AI_CAMERA_LUMINOSITY)
		camera_light_on = world.timeofday + 1 * 20 // Update the light every 2 seconds.


/mob/living/silicon/ai/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/aicard))

		var/obj/item/device/aicard/card = W
		card.grab_ai(src, user)

	else if(istype(W, /obj/item/weapon/wrench))
		if(anchored)
			user.visible_message("\blue \The [user] starts to unbolt \the [src] from the plating...")
			if(!do_after(user,40))
				user.visible_message("\blue \The [user] decides not to unbolt \the [src].")
				return
			user.visible_message("\blue \The [user] finishes unfastening \the [src]!")
			anchored = 0
			return
		else
			user.visible_message("\blue \The [user] starts to bolt \the [src] to the plating...")
			if(!do_after(user,40))
				user.visible_message("\blue \The [user] decides not to bolt \the [src].")
				return
			user.visible_message("\blue \The [user] finishes fastening down \the [src]!")
			anchored = 1
			return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "AI Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	src << "Accessing Subspace Transceiver control..."
	if (src.aiRadio)
		src.aiRadio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "AI Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/check_unable(var/flags = 0, var/feedback = 1)
	if(stat == DEAD)
		if(feedback) src << "<span class='warning'>You are dead!</span>"
		return 1

	if(aiRestorePowerRoutine)
		if(feedback) src << "<span class='warning'>You lack power!</span>"
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) src << "<span class='warning'>Wireless control is disabled!</span>"
		return 1
	if((flags & AI_CHECK_RADIO) && src.aiRadio.disabledAi)
		if(feedback) src << "<span class='warning'>System Error - Transceiver Disabled!</span>"
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return istype(loc, /turf)


/mob/living/silicon/ai/ex_act(var/severity)
	if(severity == 1.0)
		qdel(src)
		return
	..()

/mob/living/silicon/ai/updateicon()
	if(!selected_sprite) selected_sprite = default_ai_icon

	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(3, 1, selected_sprite.dead_light)
	else if(aiRestorePowerRoutine)
		icon_state = selected_sprite.nopower_icon
		set_light(1, 1, selected_sprite.nopower_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 1, selected_sprite.alive_light)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = 0
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(istype(rig))
		rig.force_rest(src)

#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO
