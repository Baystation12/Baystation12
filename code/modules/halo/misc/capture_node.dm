/obj/machinery/computer/capture_node
	name = "Sovereignty Console"
	icon_keyboard = "tech_key"
	icon_screen = "comm_monitor"
	desc = "Used to determine who controls this area."
	var/control_faction
	var/list/capturing_factions = list("UNSC","Insurrection","Covenant")
	var/list/faction_frequencies = list()
	var/list/faction_languages = list()
	var/capture_time = 8 SECONDS

/obj/machinery/computer/capture_node/New()
	. = ..()

	var/area/A = get_area(src)
	name = "[A] Sovereignty Console"

/obj/machinery/computer/capture_node/attack_hand(var/mob/living/user)
	set_owner(user)

/obj/machinery/computer/capture_node/proc/set_owner(var/mob/living/user)
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
				control_faction = user.faction
				control_markers(control_faction, user.faction)
			else
				reset_markers()
		else
			to_chat(user,"\icon[src] <span class='warning'>Your faction has no interest in controlling [src].</span>")

/obj/machinery/computer/capture_node/proc/contest_markers(var/trigger_faction)
	var/area/A = get_area(src)
	for(var/obj/structure/capture_marker/C in A)
		C.set_contesting(trigger_faction)

	//tell the objectives about the new contest
	for(var/datum/faction/F in GLOB.all_factions)
		for(var/datum/objective/colony_capture/O in F.all_objectives)
			O.node_contested(src, control_faction, trigger_faction)

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
