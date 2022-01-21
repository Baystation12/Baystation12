GLOBAL_LIST_EMPTY(capture_nodes)
#define FALLBACK_MOBSPAWN_AMOUNT 6
#define EXTRAPLAYER_CAP_AMT_INCREASE 0.25
#define EXTRAPLAYER_CAP_AMT_MAX 2

/obj/machinery/computer/capture_node
	name = "Sovereignty Console"
	icon_keyboard = "tech_key"
	icon_screen = "comm_monitor"
	desc = "Used to determine who controls this area."
	var/control_faction
	var/comms_from = "Sovereignty Update"//The origin of comms messages sent by this console.
	var/list/capturing_factions = list("UNSC","Insurrection","Covenant")
	var/list/faction_frequencies = list()
	var/list/faction_languages = list()
	var/capture_time = 180
	var/last_cap_tick_time
	var/faction_capturing
	var/capture_ticks_remain = -1
	var/datum/progressbar/cap_bar
	var/next_cap_tick_at = 0
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
	if(capture_ticks_remain > 0)
		to_chat(user,"<span class = 'warning'>It is currently being captured by [faction_capturing]. [capture_ticks_remain] ticks remain until capture.</span>")

	var/chat_text = "<span class='info'>Current score: "
	for(var/datum/faction/F in GLOB.all_factions)
		for(var/datum/objective/colony_capture/O in F.all_objectives)
			chat_text += "<span class='em'>[F.name]</span> ([O.capture_score] | [round(100 * (O.controlled_nodes.len / GLOB.capture_nodes.len))]% control) "
			break
	chat_text += "</span>"
	to_chat(user, chat_text)

/obj/machinery/computer/capture_node/proc/check_faction_cap_active(var/get_amount = 0)
	if(!faction_capturing)
		return 0
	var/area/a = get_area(loc)
	var/amt = 0
	for(var/mob/living/l in GLOB.player_list)
		if(l.stat == CONSCIOUS && l.faction == faction_capturing && get_area(l.loc) == a)
			if(get_amount)
				amt++
			else
				return 1
	if(amt > 0)
		return amt

	return 0

/obj/machinery/computer/capture_node/attack_hand(var/mob/living/user)
	var/userfaction = user.faction
	if(userfaction == control_faction)
		to_chat(user,"<span class = 'notice'>Your faction is already in control of [src].</span>")
		return
	if(faction_capturing)
		if(userfaction == faction_capturing)
			to_chat(user,"<span class='warning'>Your faction is already capturing [src].</span>")
			return
		else
			to_chat(user,"<span class-'warning'>A faction is already capturing [src]. Eliminate their members and try again.</span>")
			return
	else
		if(userfaction in capturing_factions)
			src.visible_message("\icon[user] <span class='warning'>[user] begins taking control of [src]! Stay in the area to keep gaining control! Have more faction members in the area to speed up the capture!</span>")
			contest_markers(userfaction)
			faction_capturing = userfaction
			capture_ticks_remain = capture_time
			next_cap_tick_at = world.time + 1 SECOND
			last_cap_tick_time = world.time
		else
			to_chat(user,"\icon[src] <span class='warning'>Your faction has no interest in controlling [src].</span>")
			return

/obj/machinery/computer/capture_node/process()
	if(!faction_capturing)
		return
	if(world.time < next_cap_tick_at)
		return
	if(capture_ticks_remain == 0)
		capture_ticks_remain = -1
		if(control_faction)
			control_markers(null,faction_capturing)
		control_markers(faction_capturing,faction_capturing)
		faction_capturing = null
		overlays -= cap_bar
		qdel(cap_bar)
		cap_bar = null
		return
	var/amt_capping = check_faction_cap_active(1)
	if(amt_capping == 0)
		if(capture_ticks_remain >= capture_time)
			faction_capturing = null
			reset_markers()
			overlays -= cap_bar
			qdel(cap_bar)
			cap_bar = null
		else
			capture_ticks_remain = min(capture_time,capture_ticks_remain+3)
	else
		var/deltaticks = (world.time - last_cap_tick_time)/10
		var/ticks_remove = (1 + ((amt_capping-1)*EXTRAPLAYER_CAP_AMT_INCREASE)) * deltaticks
		capture_ticks_remain = max(0,capture_ticks_remain-min(ticks_remove,EXTRAPLAYER_CAP_AMT_MAX))
	if(!cap_bar)
		cap_bar = new (null,capture_time, src)
		cap_bar.process_without_user = 1
	last_cap_tick_time = world.time
	next_cap_tick_at = world.time + 1 SECOND
	overlays -= cap_bar.bar
	cap_bar.update(capture_time-capture_ticks_remain)
	overlays += cap_bar.bar

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
		var/area/our_area = loc.loc
		var/list/view_turfs = list()
		for(var/turf/t in our_area.contents)
			if(t.density != 1)
				view_turfs += t
		for(var/i = 0 to FALLBACK_MOBSPAWN_AMOUNT)
			var/to_spawn = pickweight(defenders_spawn)
			new to_spawn (pick(view_turfs))
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
