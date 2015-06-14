/datum/antagonist/proc/create_objectives(var/datum/mind/player)
	if(config.objectives_disabled)
		return 0
	if(global_objectives && global_objectives.len)
		player.objectives |= global_objectives
	return 1

/datum/antagonist/proc/apply(var/datum/mind/player)

	if(flags & ANTAG_HAS_LEADER && !leader)
		leader = current_antagonists[1]

	// Get the mob.
	if((flags & ANTAG_OVERRIDE_MOB) && (!player.current || (mob_path && !istype(player.current, mob_path))))
		var/mob/holder = player.current
		player.current = new mob_path(get_turf(player.current))
		player.transfer_to(player.current)
		if(holder) qdel(holder)

	player.original = player.current
	return player.current

/datum/antagonist/proc/equip(var/mob/living/carbon/human/player)

	if(!istype(player))
		return 0

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			player.drop_from_inventory(thing)
			if(thing.loc != player)
				qdel(thing)
	return 1

	if(flags & ANTAG_SET_APPEARANCE)
		player.change_appearance(APPEARANCE_ALL, player.loc, player, valid_species, state = z_state)

/datum/antagonist/proc/unequip(var/mob/living/carbon/human/player)
	if(!istype(player))
		return 0
	return 1

/datum/antagonist/proc/greet(var/datum/mind/player)

	// Basic intro text.
	player.current << "<span class='danger'><font size=3>You are a [role_text]!</font></span>"
	if(leader_welcome_text && player.current == leader)
		player.current << "<span class='notice'>[leader_welcome_text]</span>"
	else
		player.current << "<span class='notice'>[welcome_text]</span>"
	show_objectives(player)

	// Choose a name, if any.
	if(flags & ANTAG_CHOOSE_NAME)
		spawn(5)
			var/newname = sanitize(input(player.current, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
			if (newname)
				player.current.real_name = newname
				player.current.name = player.current.real_name
			player.name = player.current.name
			// Update any ID cards.
			update_access(player.current)

	// Clown clumsiness check, I guess downstream might use it.
	if (player.current.mind)
		if (player.current.mind.assigned_role == "Clown")
			player.current << "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself."
			player.current.mutations.Remove(CLUMSY)
	return 1

/datum/antagonist/proc/update_access(var/mob/living/player)
	for(var/obj/item/weapon/card/id/id in player.contents)
		id.name = "[player.real_name]'s ID Card"
		id.registered_name = player.real_name

/datum/antagonist/proc/random_spawn()
	create_global_objectives()
	attempt_spawn(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
	finalize()

/datum/antagonist/proc/create_id(var/assignment, var/mob/living/carbon/human/player)

	var/obj/item/weapon/card/id/W = new id_type(player)
	if(!W) return
	W.name = "[player.real_name]'s ID Card"
	W.access |= default_access
	W.assignment = "[assignment]"
	W.registered_name = player.real_name
	player.equip_to_slot_or_del(W, slot_wear_id)
	return W

/datum/antagonist/proc/create_radio(var/freq, var/mob/living/carbon/human/player)
	var/obj/item/device/radio/R = new /obj/item/device/radio/headset(player)
	R.set_frequency(freq)
	player.equip_to_slot_or_del(R, slot_l_ear)
	return R

/datum/antagonist/proc/make_nuke(var/atom/paper_spawn_loc, var/datum/mind/code_owner)

	// Decide on a code.
	var/obj/effect/landmark/nuke_spawn = locate(nuke_spawn_loc ? nuke_spawn_loc : "landmark*Nuclear-Bomb")

	var/code
	if(nuke_spawn)
		var/obj/machinery/nuclearbomb/nuke = new(get_turf(nuke_spawn))
		code = "[rand(10000, 99999)]"
		nuke.r_code = code

	if(code)
		if(!paper_spawn_loc)
			paper_spawn_loc = get_turf(locate("landmark*Nuclear-Code"))
		if(paper_spawn_loc)
			// Create and pass on the bomb code paper.
			var/obj/item/weapon/paper/P = new(paper_spawn_loc)
			P.info = "The nuclear authorization code is: <b>[code]</b>"
			P.name = "nuclear bomb code"
		if(code_owner)
			code_owner.store_memory("<B>Nuclear Bomb Code</B>: [code]", 0, 0)
			code_owner.current << "The nuclear authorization code is: <B>[code]</B>"

	else
		world << "<span class='danger'>Could not spawn nuclear bomb. Contact a developer.</span>"
		return

	spawned_nuke = code
	return code
