GLOBAL_LIST_EMPTY(capture_nodes)
#define FALLBACK_MOBSPAWN_AMOUNT 4

/obj/machinery/computer/capture_node
	name = "Sovereignty Console"
	icon_keyboard = "tech_key"
	icon_screen = "comm_monitor"
	desc = "Used to determine who controls this area."
	var/control_faction
	var/comms_from = "Geminus Sovereignty Update"//The origin of comms messages sent by this console.
	var/list/capturing_factions = list("UNSC","Insurrection","Covenant")
	var/list/faction_frequencies = list()
	var/list/faction_languages = list()
	var/capture_time = 8 SECONDS
	var/mob/living/interacting
	var/list/capture_npc_spawnlocs = list()
	ai_access_level = 4

/obj/machinery/computer/capture_node/New()
	. = ..()

	var/area/A = get_area(src)
	name = "[A] Sovereignty Console"

	GLOB.capture_nodes.Add(src)

/obj/machinery/computer/capture_node/Initialize()
	. = ..()
	for(var/obj/effect/landmark/npc_capturespawn_marker/marker in loc.loc.contents)
		capture_npc_spawnlocs += marker.loc

/obj/machinery/computer/capture_node/Destroy()
	GLOB.capture_nodes.Remove(src)
	. = ..()

/obj/machinery/computer/capture_node/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	. = ..()

	var/chat_text = "<span class='info'>Current score: "
	for(var/datum/faction/F in GLOB.all_factions)
		for(var/datum/objective/colony_capture/O in F.all_objectives)
			chat_text += "<span class='em'>[F.name]</span> ([O.capture_score] | [round(100 * (O.controlled_nodes.len / GLOB.capture_nodes.len))]% control) "
			break
	chat_text += "</span>"
	to_chat(user, chat_text)

/obj/machinery/computer/capture_node/attack_hand(var/mob/living/user)
	if(interacting)
		if(interacting == user)
			to_chat(user,"<span class='warning'>You are already interacting with [src].</span>")
		else
			to_chat(user,"<span class='warning'>[interacting] is already interacting with [src].</span>")
	else
		interacting = user
		if(control_faction)
			src.visible_message("\icon[user] <span class='warning'>[user] begins resetting [src] to neutral!</span>")
			contest_markers(user.faction)
			if(do_after(user, capture_time, src, same_direction = 1))
				src.visible_message("\icon[user] <span class='info'>[user] has reset [src] to neutral.</span>")
				control_markers(null, user.faction)
			else
				reset_markers()
		else
			if(user.faction in capturing_factions)
				src.visible_message("\icon[user] <span class='warning'>[user] begins taking control of [src]!</span>")
				contest_markers(user.faction)
				if(do_after(user, capture_time, src, same_direction = 1))
					src.visible_message("\icon[user] <span class='info'>[user] has taken control of [src] for the [user.faction].</span>")
					control_markers(user.faction, user.faction)
				else
					reset_markers()
			else
				to_chat(user,"\icon[src] <span class='warning'>Your faction has no interest in controlling [src].</span>")
		interacting = null

/obj/machinery/computer/capture_node/proc/contest_markers(var/trigger_faction)
	var/area/A = get_area(src)
	for(var/obj/structure/capture_marker/C in A)
		C.set_contesting(trigger_faction)

	//tell the objectives about the new contest
	for(var/datum/faction/F in GLOB.all_factions)
		for(var/datum/objective/colony_capture/O in F.all_objectives)
			O.node_contested(src, control_faction, trigger_faction)

/obj/machinery/computer/capture_node/proc/spawn_defenders()
	var/datum/faction/F = GLOB.factions_by_name[control_faction]
	var/list/defenders_spawn = F.defender_mob_types
	if(defenders_spawn.len == 0)
		return
	if(capture_npc_spawnlocs.len == 0)
		for(var/i = 0,i < FALLBACK_MOBSPAWN_AMOUNT,i++)
			var/to_spawn = pickweight(defenders_spawn)
			new to_spawn (pick(view(7,src)))
		return
	for(var/turf/t in capture_npc_spawnlocs)
		var/to_spawn = pick(defenders_spawn)
		new to_spawn (t)

/obj/machinery/computer/capture_node/proc/control_markers(var/owner_faction, var/trigger_faction)

	var/area/A = get_area(src)
	for(var/obj/structure/capture_marker/C in A)
		C.set_owner(owner_faction)

	var/old_faction = control_faction
	control_faction = owner_faction

	//tell the objective about the new capture
	if(control_faction)
		for(var/datum/faction/F in GLOB.all_factions)
			for(var/datum/objective/colony_capture/O in F.all_objectives)
				O.node_captured(src, old_faction, control_faction)
	else
		for(var/datum/faction/F in GLOB.all_factions)
			for(var/datum/objective/colony_capture/O in F.all_objectives)
				O.node_reset(src, old_faction, trigger_faction)

	if(control_faction)
		minor_announcement.Announce("[control_faction] has captured the [src]!",comms_from)
	spawn_defenders()

/obj/machinery/computer/capture_node/proc/reset_markers()
	var/area/A = get_area(src)
	for(var/obj/structure/capture_marker/C in A)
		C.reset_control()

/obj/machinery/computer/capture_node/ex_act(var/severity)
	return

/obj/machinery/computer/capture_node/bullet_act()
	return

/obj/machinery/computer/capture_node/attackby()
	return









/obj/structure/capture_marker
	name = "Sovereignty Marker"
	desc = "For displaying the logo and propoganda of who controls this area."
	icon = 'code/modules/halo/misc/capture_node.dmi'
	icon_state = "sign"
	var/control_faction
	var/image/faction_logo
	var/fade_alpha1 = 100
	var/fade_alpha2 = 0

/obj/structure/capture_marker/proc/set_owner(var/new_faction)
	GLOB.processing_objects.Remove(src)
	if(new_faction)
		set_logo_alpha(255)
	else
		overlays -= faction_logo
		qdel(faction_logo)

	control_faction = new_faction
	if(control_faction)
		name = "[control_faction] [initial(name)]"
	else
		name = initial(name)

/obj/structure/capture_marker/proc/reset_control()
	GLOB.processing_objects.Remove(src)
	if(control_faction)
		set_logo_alpha(255)
	else
		overlays -= faction_logo
		qdel(faction_logo)

/obj/structure/capture_marker/proc/set_contesting(var/trigger_faction)
	if(!control_faction)
		faction_logo = image(src.icon,src,trigger_faction)
		set_logo_alpha(fade_alpha1)
	GLOB.processing_objects |= src

/obj/structure/capture_marker/process()
	if(control_faction)
		if(faction_logo.alpha == 255)
			set_logo_alpha(fade_alpha1)
		else
			set_logo_alpha(255)
	else
		if(faction_logo.alpha == fade_alpha1)
			set_logo_alpha(fade_alpha2)
		else
			set_logo_alpha(fade_alpha1)

/obj/structure/capture_marker/proc/set_logo_alpha(var/new_alpha)
	overlays -= faction_logo
	faction_logo.alpha = new_alpha
	overlays += faction_logo





/obj/effect/landmark/npc_capturespawn_marker
	name = "Capture-Spawn marker"
