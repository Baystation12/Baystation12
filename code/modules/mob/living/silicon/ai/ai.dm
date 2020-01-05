#define AI_CHECK_WIRELESS 1
#define AI_CHECK_RADIO 2
#define AI_CPULOSS_STUNMAX_DIVISOR 3
#define RANGECHECK_DELETE_DELAY 5 SECONDS //Delay between spawning the image and deleting it.

var/list/ai_list = list()
var/list/ai_verbs_default = list(
	/mob/living/silicon/ai/proc/prep_EWAR_command,
	/mob/living/silicon/ai/proc/prep_ewar_command_macroable,
	/mob/living/silicon/ai/proc/check_EWAR_command,
	/mob/living/silicon/ai/proc/reset_network_connection,
	/mob/living/silicon/ai/proc/toggle_resist_carding,
	/mob/living/silicon/ai/proc/routing_node_check,
	//mob/living/silicon/ai/proc/ai_announcement,
	//mob/living/silicon/ai/proc/ai_call_shuttle,
	//mob/living/silicon/ai/proc/ai_emergency_message,
	/mob/living/silicon/ai/proc/ai_camera_track,
	/mob/living/silicon/ai/proc/ai_camera_list,
	/mob/living/silicon/ai/proc/ai_goto_location,
	/mob/living/silicon/ai/proc/ai_remove_location,
	/mob/living/silicon/ai/proc/ai_hologram_change,
	/mob/living/silicon/ai/proc/manifest_hologram_verb,
	//mob/living/silicon/ai/proc/ai_network_change,
	/mob/living/silicon/ai/proc/ai_roster,
	//mob/living/silicon/ai/proc/ai_statuschange,
	/mob/living/silicon/ai/proc/ai_store_location,
	/mob/living/silicon/ai/proc/ai_checklaws,
	/mob/living/silicon/ai/proc/control_integrated_radio,
	/mob/living/silicon/ai/proc/core,
	/mob/living/silicon/ai/proc/pick_icon,
	/mob/living/silicon/ai/proc/sensor_mode,
	/mob/living/silicon/ai/proc/show_laws_verb,
	/mob/living/silicon/ai/proc/toggle_camera_light,
	/mob/living/silicon/ai/proc/multitool_mode,
	/mob/living/silicon/ai/proc/toggle_hologram_movement
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
	var/network = "Exodus"
	var/obj/machinery/camera/camera = null
	var/list/connected_robots = list()
	var/viewalerts = 0
	var/icon/holo_icon//Default is assigned when AI is created.
	var/obj/effect/ai_holo/our_holo
	var/obj/item/device/pda/ai/aiPDA = null
	var/obj/item/device/multitool/aiMulti = null
	var/obj/item/device/radio/headset/heads/ai_integrated/aiRadio = null
	var/camera_light_on = 0	//Defines if the AI toggled the light on the camera it's looking through.
	var/datum/trackable/track = null
	var/last_announcement = ""
	var/control_disabled = 0
	var/datum/announcement/priority/announcement
	var/hologram_follow = 1
	var/resist_carding = 1

	var/datum/ai_icon/selected_sprite			// The selected icon set
	var/carded

	var/multitool_mode = 0

	var/default_ai_icon = /datum/ai_icon/blue
	var/static/list/custom_ai_icons_by_ckey_and_name

	var/cpu_points_max = 100
	var/cpu_points = 100 //Spent on Terminal access, node access and ability usage.

	var/native_network = "Exodus"//We recieve alerts from this network, even if we're not in it.
	var/obj/structure/ai_terminal/our_terminal = null
	var/list/nodes_accessed = list()

	var/obj/machinery/overmap_weapon_console/console_operating = null

	//CyberWarfare Stuff//
	var/datum/cyberwarfare_command/prepped_command
	var/list/active_cyberwarfare_effects = list() //Commands are placed in here if their code requires processing on life ticks.
	var/list/cyberwarfare_commands = newlist(\
	/datum/cyberwarfare_command/network_scan,
	/datum/cyberwarfare_command/network_scan/l2,
	/datum/cyberwarfare_command/network_scan/l3,
	/datum/cyberwarfare_command/investigate_node,
	/datum/cyberwarfare_command/hack_routing_node,
	/datum/cyberwarfare_command/node_lockdown,
	/datum/cyberwarfare_command/nuke_node,
	/datum/cyberwarfare_command/shock_terminal,
	/datum/cyberwarfare_command/shock_terminal/siphon,
	/datum/cyberwarfare_command/flash_network,
	/datum/cyberwarfare_command/trap/logic_bomb,
	/datum/cyberwarfare_command/trap/terminal_tripwire,
	/datum/cyberwarfare_command/ai_hide,
	/datum/cyberwarfare_command/disconnect_protect,
	/datum/cyberwarfare_command/switch_terminal,
	/datum/cyberwarfare_command/switch_terminal/stealth)

/mob/living/silicon/ai/proc/add_ai_verbs()
	src.verbs |= ai_verbs_default
	src.verbs -= /mob/living/verb/ghost

/mob/living/silicon/ai/proc/remove_ai_verbs()
	src.verbs -= ai_verbs_default
	src.verbs += /mob/living/verb/ghost

/mob/living/silicon/ai/proc/switch_to_net_by_name(var/name)
	var/new_net = all_networks[name]
	if(!isnull(new_net))
		our_visualnet = new_net
		if(!isnull(eyeobj))
			eyeobj.visualnet = our_visualnet
			eyeobj.possess(src)

/mob/living/silicon/ai/proc/toggle_resist_carding()
	set name = "Toggle Resist Carding"
	set category = "Silicon Commands"

	resist_carding = !resist_carding
	to_chat(usr,"<span class = 'notice'>You will [resist_carding ? "now" : "no longer"] resist any carding.</span>")
	if(our_terminal)
		our_terminal.set_terminal_inactive(resist_carding)

/mob/living/silicon/ai/proc/get_command_list(var/apply_categories = 1)
	var/list/name_to_command = list()
	for(var/datum/cyberwarfare_command/cmd in cyberwarfare_commands)
		if(apply_categories)
			name_to_command["\[[cmd.category]\] [cmd.name]"] = cmd
		else
			name_to_command["[cmd.name]"] = cmd
	return name_to_command

/mob/living/silicon/ai/proc/prep_ewar_command_macroable(var/command as text)
	set name = "prepare-ewar-command-macro"
	set category = "EWAR"
	set hidden = 1

	prep_ewar_command_proc(command)

/mob/living/silicon/ai/proc/prep_EWAR_command()
	set name = "Prepare EWAR command"
	set category = "EWAR"

	prep_ewar_command_proc(null)

/mob/living/silicon/ai/proc/prep_ewar_command_proc(var/command_pick)

	var/do_list_pick = isnull(command_pick) || command_pick == ""

	var/list/name_to_command = get_command_list((do_list_pick ? 1 : 0))
	if(do_list_pick)
		command_pick = input(src,"Pick a cyberwarfare command to prepare.\n(If you want to macro this, use prepare-ewar-command-macro \"command_name\", ignoring the category.)","EWAR command selection","Cancel") in name_to_command + list("Cancel")
		if(command_pick == "Cancel")
			to_chat(src,"<span class = 'notice'>EWAR command selection cancelled.</span>")
			return
	var/datum/cyberwarfare_command/picked = name_to_command[command_pick]
	if(isnull(picked))
		return
	var/datum/cyberwarfare_command/new_cmd = new picked.type
	to_chat(src,"<span class = 'notice'>Command \[[new_cmd.name]\] primed for sending.</span>")
	new_cmd.prime_command(src)

/mob/living/silicon/ai/proc/check_EWAR_command()
	set name = "Check EWAR Command"
	set category = "EWAR"

	var/list/name_to_command = get_command_list()

	var/command_pick = input(src,"Pick a cyberwarfare command to check.","EWAR command selection","Cancel") in name_to_command + list("Cancel")
	if(command_pick == "Cancel")
		to_chat(src,"<span class = 'notice'>EWAR command selection cancelled.</span>")
		return
	var/datum/cyberwarfare_command/picked = name_to_command[command_pick]
	picked.show_desc(src)

/mob/living/silicon/ai/proc/reset_network_connection()
	set name = "Reset Network Connection"
	set category = "EWAR"

	if(!our_terminal)
		to_chat(src,"<span class = 'notice'>No terminal to reset to.</span>")
		return
	if(carded)
		to_chat(src,"<span class = 'notice'>You can't do that whilst carded!</span>")
		return
	destroy_eyeobj()
	switch_to_net_by_name(our_terminal.inherent_network)
	create_eyeobj(loc.loc)

/mob/living/silicon/ai/proc/routing_node_check()
	set name = "Check Routing Node Ranges"
	set category = "EWAR"

	if(isnull(eyeobj))
		to_chat(src,"<span class = 'notice'>You need an eye object to do this!</span>")
		return

	var/list/viewed_nodes = view(7,eyeobj) & nodes_accessed

	var/ctr = 0
	for(var/n in viewed_nodes)
		ctr++
		var/obj/structure/ai_routing_node/node = n
		var/area/node_area = node.loc.loc
		for(var/turf/t in node_area)
			var/image/image_send = image('code/modules/halo/icons/machinery/ai_area_displays.dmi',t,"area[ctr]")
			show_image(src,image_send)
			spawn(RANGECHECK_DELETE_DELAY)
				qdel(image_send)


/mob/living/silicon/ai/proc/do_network_alert(var/message,var/severity = "danger")
	message = "\[NETWORK ALERT\] \[[network]\] [message]"
	for(var/ai_untyped in get_ais_in_network(network,native_network))
		var/tmp_msg = message
		if(ai_untyped == src)
			tmp_msg = "Previous EWAR action triggered network alert!"
		to_chat(ai_untyped,"<span class = '[severity]'>[tmp_msg]</span>")

/mob/living/silicon/ai/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	announcement = new()
	announcement.title = "A.I. Announcement"
	announcement.announcement_type = "A.I. Announcement"
	announcement.newscast = 1

	var/list/possibleNames = GLOB.ai_names

	var/pickedName = null
	while(!pickedName)
		pickedName = pick(GLOB.ai_names)
		for (var/mob/living/silicon/ai/A in GLOB.silicon_mob_list)
			if (A.real_name == pickedName && possibleNames.len > 1) //fixing the theoretically possible infinite loop
				possibleNames -= pickedName
				pickedName = null

	aiPDA = new/obj/item/device/pda/ai(src)
	fully_replace_character_name(pickedName)
	anchored = 1
	canmove = 0
	set_density(1)
	loc = loc

	holo_icon = getHologramIcon(icon('icons/mob/hologram.dmi',"Default"))

	if(istype(L, /datum/ai_laws))
		laws = L

	aiMulti = new(src)
	aiRadio = new(src)
	common_radio = aiRadio
	aiRadio.myAi = src
	additional_law_channels["Holopad"] = ":h"

	aiCamera = new/obj/item/device/camera/siliconcam/ai_camera(src)
	our_visualnet = all_networks[network]
	if(isnull(our_visualnet))
		all_networks[network] = new /datum/visualnet/camera

	if (istype(loc, /turf))
		add_ai_verbs(src)

	//Languages
	add_language("Robot Talk", 1)
	add_language(LANGUAGE_GALCOM, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_UNATHI, 1)
	add_language(LANGUAGE_SIIK_MAAS, 1)
	add_language(LANGUAGE_SKRELLIAN, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language("Balahese",1)
	add_language("Ruuhti",1)
	add_language("Doisacci",1)
	add_language(LANGUAGE_SANGHEILI,1)
	add_language(LANGUAGE_SIGN, 0)
	add_language(LANGUAGE_INDEPENDENT, 1)

	if(!safety)//Only used by AIize() to successfully spawn an AI.
		if (!B)//If there is no player/brain inside.
			empty_playable_ai_cores += new/obj/structure/AIcore/deactivated(loc)//New empty terminal.
			qdel(src)//Delete AI.
			return
		else
			if (B.brainmob.mind)
				B.brainmob.mind.transfer_to(src)

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[LIFE_HUD] 		  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[ID_HUD]          = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

	ai_list += src
	..()

/mob/living/silicon/ai/Stat()
	if(statpanel("Status"))
		stat(null, text("CPU : [cpu_points]"))
		if(prepped_command)
			stat(null, text("Prepped EWAR Command: [prepped_command.name]"))
		else
			stat(null, text("Prepped EWAR Command: None"))
	. = ..()

/mob/living/silicon/ai/proc/on_mob_init()
	to_chat(src, "<B>You are playing as an AI. AIs cannot move normally, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other areas, click on yourself to get a camera menu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	to_chat(src, "Use say [get_language_prefix()]b to speak to your cyborgs through binary. Use say :h to speak from an active hologram.")
	to_chat(src, "For department channels, use the following say commands:")

	job = "AI"
	setup_icon()
	eyeobj.possess(src)
	var/obj/structure/ai_terminal/terminal = locate(/obj/structure/ai_terminal) in loc.contents
	if(!isnull(terminal))
		if(!isnull(terminal.held_ai))
			to_chat(src,"<span class = 'notice'>An artificial intelligence is already in your spawn terminal!</span>")
		else
			terminal.move_to_node(src)
			switch_to_net_by_name(network)
			terminal.apply_radio_channels(src)

	var/radio_text = ""
	for(var/i = 1 to common_radio.channels.len)
		var/channel = common_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != common_radio.channels.len)
			radio_text += ", "

	to_chat(src, radio_text)

/mob/living/silicon/ai/Destroy()
	ai_list -= src

	. = ..()

	QDEL_NULL(announcement)
	QDEL_NULL(eyeobj)
	QDEL_NULL(aiPDA)
	QDEL_NULL(aiMulti)
	QDEL_NULL(aiRadio)
	QDEL_NULL(aiCamera)

/mob/living/silicon/ai/proc/setup_icon()
	if(LAZYACCESS(custom_ai_icons_by_ckey_and_name, "[ckey][real_name]"))
		return
	var/list/custom_icons = list()
	LAZYSET(custom_ai_icons_by_ckey_and_name, "[ckey][real_name]", custom_icons)

	var/file = file2text("config/custom_sprites.txt")
	var/lines = splittext(file, "\n")

	var/custom_index = 1
	var/custom_icon_states = icon_states(CUSTOM_ITEM_SYNTH)

	for(var/line in lines)
	// split & clean up
		var/list/Entry = splittext(line, ":")
		for(var/i = 1 to Entry.len)
			Entry[i] = trim(Entry[i])

		if(Entry.len < 2)
			continue
		if(Entry.len == 2) // This is to handle legacy entries
			Entry[++Entry.len] = Entry[1]

		if(Entry[1] == src.ckey && Entry[2] == src.real_name)
			var/alive_icon_state = "[Entry[3]]-ai"
			var/dead_icon_state = "[Entry[3]]-ai-crash"

			if(!(alive_icon_state in custom_icon_states))
				to_chat(src, "<span class='warning'>Custom display entry found but the icon state '[alive_icon_state]' is missing!</span>")
				continue

			if(!(dead_icon_state in custom_icon_states))
				dead_icon_state = ""

			selected_sprite = new/datum/ai_icon("Custom Icon [custom_index++]", alive_icon_state, dead_icon_state, COLOR_WHITE, CUSTOM_ITEM_SYNTH)
			custom_icons += selected_sprite
	update_icon()

/mob/living/silicon/ai/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/living/silicon/ai/fully_replace_character_name(pickedName as text)
	..()
	announcement.announcer = pickedName
	if(eyeobj)
		eyeobj.name = "[pickedName] (AI Eye)"

	// Set ai pda name
	if(aiPDA)
		aiPDA.set_owner_rank_job(pickedName, "AI")

	GLOB.data_core.ResetPDAManifest()
	setup_icon()

/mob/living/silicon/ai/proc/pick_icon()
	set category = "Silicon Commands"
	set name = "Set AI Core Display"
	if(stat)
		return

	var/new_sprite = input("Select an icon!", "AI", selected_sprite) as null|anything in available_icons()
	if(new_sprite)
		selected_sprite = new_sprite

	update_icon()

/mob/living/silicon/ai/proc/available_icons()
	. = list()
	var/all_ai_icons = decls_repository.get_decls_of_subtype(/datum/ai_icon)
	for(var/ai_icon_type in all_ai_icons)
		var/datum/ai_icon/ai_icon = all_ai_icons[ai_icon_type]
		if(ai_icon.may_used_by_ai(src))
			dd_insertObjectList(., ai_icon)

	// Placing custom icons first to have them be at the top
	. = LAZYACCESS(custom_ai_icons_by_ckey_and_name, "[ckey][real_name]") | .

/mob/living/silicon/ai/proc/check_access_level(var/atom/a)
	var/area/atom_area = a.loc.loc
	if(!istype(atom_area))
		return -1
	if(!istype(atom_area.ai_routing_node)) //If we don't have a routing node, access isn't restricted at all.
		return 999
	if(!(atom_area.ai_routing_node in nodes_accessed))
		return -1
	return atom_area.ai_routing_node.get_access_for_ai(src)

/mob/living/silicon/ai/proc/spend_cpu(var/amt,var/check_only = 0)
	var/new_cpu = min((cpu_points - amt),cpu_points_max)
	if(new_cpu < 0)
		if(!check_only)
			var/new_stunned = stunned + -(new_cpu*2) //Mismanagement of CPU is punishing.
			Stun(min(new_stunned,(initial(cpu_points_max)/AI_CPULOSS_STUNMAX_DIVISOR)))
			cpu_points = 0
			if(our_terminal)
				our_terminal.set_terminal_inactive(0)
		return 0

	if(!check_only)
		cpu_points = new_cpu
	return 1

// this verb lets the ai see the stations manifest
/mob/living/silicon/ai/proc/ai_roster()
	set category = "Silicon Commands"
	set name = "Show Crew Manifest"
	show_station_manifest()
/*
/mob/living/silicon/ai/var/message_cooldown = 0
/mob/living/silicon/ai/proc/ai_announcement()
	set category = "Silicon Commands"
	set name = "Make Announcement"

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(message_cooldown)
		to_chat(src, "Please allow one minute to pass between announcements.")
		return
	var/input = input(usr, "Please write a message to announce to the [station_name()] crew.", "A.I. Announcement")
	if(!input)
		return

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	announcement.Announce(input)
	message_cooldown = 1
	spawn(600)//One minute cooldown
		message_cooldown = 0

/mob/living/silicon/ai/proc/ai_call_shuttle()
	set category = "Silicon Commands"
	set name = "Call Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to evacuate?", "Confirm Evacuation", "Yes", "No")

	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		call_shuttle_proc(src)

	post_status("shuttle")

/mob/living/silicon/ai/proc/ai_recall_shuttle()
	set category = "Silicon Commands"
	set name = "Cancel Evacuation"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	var/confirm = alert("Are you sure you want to cancel the evacuation?", "Confirm Cancel", "Yes", "No")
	if(check_unable(AI_CHECK_WIRELESS))
		return

	if(confirm == "Yes")
		cancel_call_proc(src)

/mob/living/silicon/ai/var/emergency_message_cooldown = 0
/mob/living/silicon/ai/proc/ai_emergency_message()
	set category = "Silicon Commands"
	set name = "Send Emergency Message"

	if(check_unable(AI_CHECK_WIRELESS))
		return
	if(!is_relay_online())
		to_chat(usr, "<span class='warning'>No Emergency Bluespace Relay detected. Unable to transmit message.</span>")
		return
	if(emergency_message_cooldown)
		to_chat(usr, "<span class='warning'>Arrays recycling. Please stand by.</span>")
		return
	var/input = sanitize(input(usr, "Please choose a message to transmit to [GLOB.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", ""))
	if(!input)
		return
	Centcomm_announce(input, usr)
	to_chat(usr, "<span class='notice'>Message transmitted.</span>")
	log_say("[key_name(usr)] has made an IA [GLOB.using_map.boss_short] announcement: [input]")
	emergency_message_cooldown = 1
	spawn(300)
		emergency_message_cooldown = 0
*/

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
		var/datum/visualnet/camera/our_cameranet = our_visualnet
		switchCamera(locate(href_list["switchcamera"])) in our_cameranet.cameras
	if (href_list["showalerts"])
		open_subsystem(/datum/nano_module/alarm_monitor/all)
	//Carn: holopad requests
	if (href_list["jumptoholopad"])
		var/obj/machinery/hologram/holopad/H = locate(href_list["jumptoholopad"])
		if(stat == CONSCIOUS)
			if(H)
				H.attack_ai(src) //may as well recycle
			else
				to_chat(src, "<span class='notice'>Unable to locate the holopad.</span>")

	if (href_list["track"])
		var/mob/target = locate(href_list["track"]) in GLOB.mob_list
		var/mob/living/carbon/human/H = target

		if(!istype(H) || (html_decode(href_list["trackname"]) == H.get_visible_name()) || (html_decode(href_list["trackname"]) == H.get_id_name()))
			ai_actual_track(target)
		else
			to_chat(src, "<span class='warning'>System error. Cannot locate [html_decode(href_list["trackname"])].</span>")
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
	set category = "Silicon Commands"
	set name = "Cancel Camera View"

	//src.cameraFollow = null
	src.view_core()
	if(console_operating)
		unset_machine()
		if(eyeobj)
			reset_view(eyeobj)
		else
			reset_view(null)

/mob/living/silicon/ai/proc/get_network_from_name(var/name)
	return all_networks[name]
/*
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
	set category = "Silicon Commands"
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
	to_chat(src, "<span class='notice'>Switched to [network] camera network.</span>")
//End of code by Mord_Sith
*/
/mob/living/silicon/ai/proc/ai_statuschange()
	set category = "Silicon Commands"
	set name = "AI Status"

	if(check_unable(AI_CHECK_WIRELESS))
		return

	set_ai_status_displays(src)
	return

/mob/living/silicon/ai/proc/manifest_hologram_verb()
	set name = "Manifest Hologram"
	set desc = "Manifest your hologram at your AI eye's current location."
	set category = "Silicon Commands"

	manifest_hologram()

/mob/living/silicon/ai/proc/manifest_hologram()
	if(isnull(eyeobj))
		to_chat(src,"<span class = 'notice'>You need to have an AI eye to manifest your hologram.</span>")
		return

	if(our_holo)
		our_holo.visible_message("<span class = 'notice'>[our_holo.name] demanifests!</span>")
		qdel(our_holo)
		our_holo = null
	else
		our_holo = new(eyeobj.loc,src,holo_icon)
		our_holo.visible_message("<span class = 'notice'>[our_holo.name] flickers to life before your eyes!</span>")

//I am the icon meister. Bow fefore me.	//>fefore
/mob/living/silicon/ai/proc/ai_hologram_change()
	set name = "Change Hologram"
	set desc = "Change the default hologram available to AI to something else."
	set category = "Silicon Commands"

	if(check_unable())
		return

	var/input
	if(alert("Would you like to select a hologram based on a crew member or switch to unique avatar?",,"Crew Member","Unique")=="Crew Member")

		var/personnel_list[] = list()

		for(var/datum/data/record/t in GLOB.data_core.locked)//Look in data core locked.
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
		var/list/hologramsAICanUse = list()
		var/holograms_by_type = decls_repository.get_decls_of_subtype(/decl/ai_holo)
		for (var/holo_type in holograms_by_type)
			var/decl/ai_holo/holo = holograms_by_type[holo_type]
			if (holo.may_be_used_by_ai(ckey,faction))
				hologramsAICanUse.Add(holo)
		var/decl/ai_holo/choice = input("Please select a hologram:") as null|anything in hologramsAICanUse
		if(choice)
			qdel(holo_icon)
			holo_icon = getHologramIcon(icon(choice.icon, choice.icon_state), noDecolor=choice.icon_colorize)
	return

//Toggles the luminosity and applies it by re-entereing the camera.
/mob/living/silicon/ai/proc/toggle_camera_light()
	set name = "Toggle Camera Light"
	set desc = "Toggles the light on the camera the AI is looking through."
	set category = "Silicon Commands"

	if(check_unable())
		return

	camera_light_on = !camera_light_on
	to_chat(src, "Camera lights [camera_light_on ? "activated" : "deactivated"].")
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
	if(istype(W, /obj/item/weapon/aicard))

		var/obj/item/weapon/aicard/card = W
		card.grab_ai(src, user)

	else if(istype(W, /obj/item/weapon/wrench))
		if(anchored)
			user.visible_message("<span class='notice'>\The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!do_after(user,40, src))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = 0
			return
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating...</span>")
			if(!do_after(user,40,src))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = 1
			return
	else
		return ..()

/mob/living/silicon/ai/proc/control_integrated_radio()
	set name = "Radio Settings"
	set desc = "Allows you to change settings of your radio."
	set category = "Silicon Commands"

	if(check_unable(AI_CHECK_RADIO))
		return

	to_chat(src, "Accessing Subspace Transceiver control...")
	if (src.aiRadio)
		src.aiRadio.interact(src)

/mob/living/silicon/ai/proc/sensor_mode()
	set name = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment visual feed with internal sensor overlays"
	toggle_sensor_mode()

/mob/living/silicon/ai/proc/toggle_hologram_movement()
	set name = "Toggle Hologram Movement"
	set category = "Silicon Commands"
	set desc = "Toggles hologram movement based on moving with your virtual eye."

	hologram_follow = !hologram_follow
	to_chat(usr, "<span class='info'>Your hologram will now [hologram_follow ? "follow" : "no longer follow"] you.</span>")

/mob/living/silicon/ai/proc/check_unable(var/flags = 0, var/feedback = 1)
	if(stat == DEAD)
		if(feedback) to_chat(src, "<span class='warning'>You are dead!</span>")
		return 1

	if((flags & AI_CHECK_WIRELESS) && src.control_disabled)
		if(feedback) to_chat(src, "<span class='warning'>Wireless control is disabled!</span>")
		return 1
	if((flags & AI_CHECK_RADIO) && src.aiRadio.disabledAi)
		if(feedback) to_chat(src, "<span class='warning'>System Error - Transceiver Disabled!</span>")
		return 1
	return 0

/mob/living/silicon/ai/proc/is_in_chassis()
	return istype(loc, /turf)

/mob/living/silicon/ai/proc/multitool_mode()
	set name = "Toggle Multitool Mode"
	set category = "Silicon Commands"

	multitool_mode = !multitool_mode
	to_chat(src, "<span class='notice'>Multitool mode: [multitool_mode ? "E" : "Dise"]ngaged</span>")

/mob/living/silicon/ai/update_icon()
	if(!selected_sprite || !(selected_sprite in available_icons()))
		selected_sprite = decls_repository.get_decl(default_ai_icon)

	icon = selected_sprite.icon
	if(stat == DEAD)
		icon_state = selected_sprite.dead_icon
		set_light(3, 1, selected_sprite.dead_light)
	else
		icon_state = selected_sprite.alive_icon
		set_light(1, 1, selected_sprite.alive_light)

/mob/living/silicon/ai/proc/process_trap_trigger(var/atom/trap_on,var/disarm = 0) //Used to make an AI process all of the traps they have triggered on a given object.
	for(var/a in get_ais_in_network(network,native_network))
		var/mob/living/silicon/ai/ai = a
		for(var/datum/cyberwarfare_command/trap/t in ai.active_cyberwarfare_effects)
			if(t.trap_target == trap_on)
				t.tripped(src,disarm)

// Pass lying down or getting up to our pet human, if we're in a rig.
/mob/living/silicon/ai/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = 0
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(rig)
		rig.force_rest(src)

#undef RANGECHECK_DELETE_DELAY
#undef AI_CPULOSS_STUNMAX_DIVISOR
#undef AI_CHECK_WIRELESS
#undef AI_CHECK_RADIO
