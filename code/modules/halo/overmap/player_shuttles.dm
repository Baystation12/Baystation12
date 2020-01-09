#define SHUTTLE_REQ_DELAY 5 SECONDS

/obj/machinery/shuttle_spawner
	name = "Shuttle Requisition Console"
	desc = "Used to obtain a small transport shuttle for long or short range transportation."
	icon = 'code/modules/halo/overmap/icons/consoles.dmi'
	icon_state = "shuttle_req_console"
	density = 1
	anchored = 1
	var/obj/effect/overmap/ship/npc_ship/ship_to_spawn
	var/ship_type_name = "shuttlecraft"
	var/shuttle_refresh_time = 5 MINUTES
	var/next_shuttle_at = 0
	var/allow_rename = 0

/obj/machinery/shuttle_spawner/examine(var/mob/examiner)
	. = ..()
	show_next_available_time(examiner)

/obj/machinery/shuttle_spawner/proc/show_next_available_time(var/mob/user)
	var/time_until_shuttle = (next_shuttle_at - world.time)/60
	if(time_until_shuttle <= 0)
		to_chat(user,"<span class = 'notice'>[ship_type_name] currently available.</span>")
		return
	to_chat(user,"<span class = 'notice'>Next [ship_type_name] available in [time_until_shuttle] seconds.</span>")

/obj/machinery/shuttle_spawner/proc/spawn_shuttlecraft()
	var/obj/effect/overmap/om_loc = map_sectors["[loc.z]"]
	if(isnull(om_loc))
		log_error("[src] tried to spawn a [ship_type_name] without having an overmap-object assigned to it's z-level. ([loc.z])")
		return
	if(!ship_to_spawn)
		log_error("[src] tried to spawn a [ship_type_name] at [om_loc.name]'s location, but it doesn't have a ship_to_spawn set!")
		return
	var/obj/effect/overmap/ship/npc_ship/ship = new ship_to_spawn (om_loc.loc)
	ship.loc = null
	ship.slipspace_to_location(om_loc.loc,0)
	ship.make_player_controlled()
	return ship

/obj/machinery/shuttle_spawner/proc/check_requisition_allowed()
	if(world.time < next_shuttle_at)
		visible_message("<span class = 'notice'>Undergoing refit, currently unavailable.</span>")
		return 0
	return 1

/obj/machinery/shuttle_spawner/ex_act(var/severity)
	return

/obj/machinery/shuttle_spawner/attack_hand(var/mob/living/user)
	if(!istype(user))
		return
	if(!check_requisition_allowed())
		return
	user.visible_message("<span class = 'notice'>[user] starts requisitioning a [ship_type_name] from [src]...</span>")
	if(!do_after(user,SHUTTLE_REQ_DELAY,user))
		return
	if(!check_requisition_allowed())
		return
	var/new_ship_name = null
	if(allow_rename)
		new_ship_name = sanitizeName(input(user,"Enter the Ship's Name","Ship Name","Ship"))
	if(!check_requisition_allowed())
		return
	user.visible_message("<span class = 'notice'>[user] requisitions a [ship_type_name] from [src].</span>")
	visible_message("<span class = 'notice'>[src] announces: \"[ship_type_name] Requisitioned. Connect umbilical for access.\"</span>")
	var/obj/spawned = spawn_shuttlecraft()
	if(spawned && new_ship_name)
		spawned.name = new_ship_name
	next_shuttle_at = world.time + shuttle_refresh_time

/obj/machinery/shuttle_spawner/debug
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/combat/unsc

/obj/effect/overmap/ship/npc_ship/shuttlecraft
	name = "Shuttle Craft"
	icons_pickfrom_list = list()
	vessel_mass = 1
	default_delay = 3 SECONDS //double the speed of a normal ship.

/obj/effect/overmap/ship/npc_ship/shuttlecraft/generate_ship_name()
	return initial(name)

#undef SHUTTLE_REQ_DELAY

//FACTION DEFINES//
/datum/npc_ship/cov_shuttle
	mapfile_links = list('maps/faction_bases/Covenant_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(3,26,48,3)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cov
	icon = 'code/modules/halo/icons/overmap/cov_shuttle.dmi'
	faction = "covenant"
	ship_datums = list(/datum/npc_ship/cov_shuttle)

/datum/npc_ship/unsc_shuttle
	mapfile_links = list('maps/faction_bases/Human_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(1,29,48,5)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc
	icon = 'code/modules/halo/icons/overmap/darter.dmi'
	faction = "unsc"
	ship_datums = list(/datum/npc_ship/unsc_shuttle)

/datum/npc_ship/innie_shuttle
	mapfile_links = list('maps/faction_bases/Innie_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(1,29,48,5)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/innie
	icon = 'code/modules/halo/icons/overmap/darter.dmi'
	faction = "Insurrection"
	ship_datums = list(/datum/npc_ship/innie_shuttle)

/obj/machinery/shuttle_spawner/cov
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cov

/obj/machinery/shuttle_spawner/unsc
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc

/obj/machinery/shuttle_spawner/innie
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/innie

/obj/machinery/shuttle_spawner/multi_choice
	name = "Long Range Requisition Console"
	desc = "\
This console identifies and maintains vulnerabilities in sector wide jamming software,\
allowing periodic long range transmission."
	ship_type_name = "Ship"
	allow_rename = 1
	var/list/choices = newlist()

/obj/machinery/shuttle_spawner/multi_choice/check_requisition_allowed()
	if(world.time < next_shuttle_at)
		visible_message("<span class = 'notice'>Unable to connect to external requisition node due to timed lockout, Examine console for more information. Attempting Reconnection....</span>")
		return 0
	return 1

/obj/machinery/shuttle_spawner/multi_choice/proc/get_spawner_choice(var/mob/user)
	var/list/categories = list()
	for(var/c in choices)
		var/datum/spawner_choice/choice = c
		if(!choice.can_mob_use(user))
			continue
		if(choice.choice_category in categories)
			categories[choice.choice_category] += choice
		else
			categories[choice.choice_category] = list(choice)
	var/chosen_category = input(user,"Choose a category","Category Choice","Cancel") in categories + list("Cancel")
	if(chosen_category == "Cancel")
		return null
	var/list/choices_available = categories[chosen_category]
	var/list/readable_choices = list()
	for(var/c in choices_available)
		var/datum/spawner_choice/choice = c
		readable_choices += choice.choice_name
	var/choice_chosen = input(user,"Make a ship choice","Ship Choice","Cancel") in readable_choices + list("Cancel")
	if(choice_chosen == "Cancel")
		return null

	return choices_available[readable_choices.Find(choice_chosen)]

/obj/machinery/shuttle_spawner/multi_choice/attack_hand(var/mob/living/user)
	if(!istype(user))
		return
	var/deploy_or_check = alert(user,"Check ship description or send spawn request?",,"Deploy","Check Description")
	var/datum/spawner_choice/final = get_spawner_choice(user)
	if(isnull(final))
		return
	switch(deploy_or_check)
		if("Check Description")
			to_chat(user,"[final.choice_name] - [final.choice_category]\n[final.choice_desc]\nCooldown:[final.cooldown_apply/10] seconds.")
			return
		if("Deploy")
			if(!check_requisition_allowed())
				return
			shuttle_refresh_time = final.cooldown_apply
			ship_to_spawn = final.spawned_ship
			. = ..()

/obj/machinery/shuttle_spawner/attackby(var/obj/item/comms_bypass_key/I, var/mob/user)
	if(istype(I))
		if(world.time > next_shuttle_at)
			to_chat(user,"<span class = 'notice'>Scanning [I] would have no effect, a ship is already available!</span>")
			return
		var/new_time = max(world.time,(next_shuttle_at - world.time)/I.cooldown_divisor)
		to_chat(user,"<span class = 'notice'>You scan [I] on [src], cutting the remaining time to [new_time/10] seconds.</span>")
		next_shuttle_at = world.time + new_time

/obj/machinery/shuttle_spawner/multi_choice/debug
	choices = newlist(\
/datum/spawner_choice/cheap_unsc_combat,\
/datum/spawner_choice/heavyarmed_unsc_combat,\
/datum/spawner_choice/experimental_unsc_combat,\
/datum/spawner_choice/unsc_slipspace_tender,\
/datum/spawner_choice/unsc_podcarrier,\
/datum/spawner_choice/unsc_trooptransport,\
/datum/spawner_choice/cheap_cov_combat,\
/datum/spawner_choice/heavyarmed_cov_combat,\
/datum/spawner_choice/experimental_cov_combat,\
/datum/spawner_choice/cov_slipspace_tender,\
/datum/spawner_choice/cov_podcarrier,\
/datum/spawner_choice/cov_trooptransport,\
/datum/spawner_choice/cheap_urf_combat,\
/datum/spawner_choice/heavyarmed_urf_combat,\
/datum/spawner_choice/experimental_urf_combat,\
/datum/spawner_choice/urf_slipspace_tender,\
/datum/spawner_choice/urf_podcarrier,\
/datum/spawner_choice/urf_trooptransport\
)

/obj/machinery/shuttle_spawner/multi_choice/unsc
	choices = newlist(\
/datum/spawner_choice/cheap_unsc_combat,\
/datum/spawner_choice/heavyarmed_unsc_combat,\
/datum/spawner_choice/experimental_unsc_combat,\
/datum/spawner_choice/unsc_slipspace_tender,\
/datum/spawner_choice/unsc_podcarrier,\
/datum/spawner_choice/unsc_trooptransport\
)

/obj/machinery/shuttle_spawner/multi_choice/urf
	choices = newlist(\
/datum/spawner_choice/cheap_urf_combat,\
/datum/spawner_choice/heavyarmed_urf_combat,\
/datum/spawner_choice/experimental_urf_combat,\
/datum/spawner_choice/urf_slipspace_tender,\
/datum/spawner_choice/urf_podcarrier,\
/datum/spawner_choice/urf_trooptransport\
)

/obj/machinery/shuttle_spawner/multi_choice/cov
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "cov_nav"
	choices = newlist(\
/datum/spawner_choice/cheap_cov_combat,\
/datum/spawner_choice/heavyarmed_cov_combat,\
/datum/spawner_choice/experimental_cov_combat,\
/datum/spawner_choice/cov_slipspace_tender,\
/datum/spawner_choice/cov_podcarrier,\
/datum/spawner_choice/cov_trooptransport\
)

/datum/spawner_choice
	var/choice_name = "Ship"
	var/choice_category = "Category"
	var/choice_desc = "Description"
	var/obj/spawned_ship = null
	var/cooldown_apply = 0

/datum/spawner_choice/proc/can_mob_use(var/mob/m)
	return 1
