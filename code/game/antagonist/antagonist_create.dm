/datum/antagonist/proc/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement, var/preserve_appearance)

	if(!target)
		return

	update_antag_mob(target, preserve_appearance)
	if(!target.current)
		remove_antagonist(target)
		return 0
	if(flags & ANTAG_CHOOSE_NAME)
		spawn(1)
			set_antag_name(target.current)
	if(move)
		place_mob(target.current)
	update_leader()
	create_objectives(target)
	update_icons_added(target)
	greet(target)
	announce_antagonist_spawn()

/datum/antagonist/proc/create_default(var/mob/source)
	var/mob/living/M
	if(mob_path)
		M = new mob_path(get_turf(source))
	else
		M = new /mob/living/carbon/human(get_turf(source))
	M.real_name = source.real_name
	M.name = M.real_name
	M.ckey = source.ckey
	add_antagonist(M.mind, 1, 0, 1) // Equip them and move them to spawn.
	return M

/datum/antagonist/proc/create_id(var/assignment, var/mob/living/carbon/human/player, var/equip = 1)

	var/obj/item/weapon/card/id/W = new id_type(player)
	if(!W) return
	W.access |= default_access
	W.assignment = "[assignment]"
	player.set_id_info(W)
	if(equip) player.equip_to_slot_or_del(W, slot_wear_id)
	return W

/datum/antagonist/proc/create_radio(var/freq, var/mob/living/carbon/human/player)
	var/obj/item/device/radio/R

	if(freq == SYND_FREQ)
		R = new/obj/item/device/radio/headset/syndicate(player)
	else
		R = new/obj/item/device/radio/headset(player)

	R.set_frequency(freq)
	player.equip_to_slot_or_del(R, slot_l_ear)
	return R

/datum/antagonist/proc/create_nuke(var/atom/paper_spawn_loc, var/datum/mind/code_owner)

	// Decide on a code.
	var/obj/effect/landmark/nuke_spawn = locate(nuke_spawn_loc ? nuke_spawn_loc : "landmark*Nuclear-Bomb")

	var/code
	if(nuke_spawn)
		var/obj/machinery/nuclearbomb/nuke = new(get_turf(nuke_spawn))
		code = "[rand(10000, 99999)]"
		nuke.r_code = code

	if(code)
		if(!paper_spawn_loc)
			if(leader && leader.current)
				paper_spawn_loc = get_turf(leader.current)
			else
				paper_spawn_loc = get_turf(locate("landmark*Nuclear-Code"))

		if(paper_spawn_loc)
			// Create and pass on the bomb code paper.
			var/obj/item/weapon/paper/P = new(paper_spawn_loc)
			P.info = "The nuclear authorization code is: <b>[code]</b>"
			P.name = "nuclear bomb code"
			if(leader && leader.current)
				if(get_turf(P) == get_turf(leader.current) && !(leader.current.l_hand && leader.current.r_hand))
					leader.current.put_in_hands(P)

		if(!code_owner && leader)
			code_owner = leader
		if(code_owner)
			code_owner.store_memory("<B>Nuclear Bomb Code</B>: [code]", 0, 0)
			code_owner.current << "The nuclear authorization code is: <B>[code]</B>"
	else
		message_admins("<span class='danger'>Could not spawn nuclear bomb. Contact a developer.</span>")
		return

	spawned_nuke = code
	return code

/datum/antagonist/proc/greet(var/datum/mind/player)

	// Basic intro text.
	player.current << "<span class='danger'><font size=3>You are a [role_text]!</font></span>"
	if(leader_welcome_text && player == leader)
		player.current << "<span class='notice'>[leader_welcome_text]</span>"
	else
		player.current << "<span class='notice'>[welcome_text]</span>"

	if((flags & ANTAG_HAS_NUKE) && !spawned_nuke)
		create_nuke()

	show_objectives(player)

	// Clown clumsiness check, I guess downstream might use it.
	if (player.current.mind)
		if (player.current.mind.assigned_role == "Clown")
			player.current << "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself."
			player.current.mutations.Remove(CLUMSY)
	return 1

/datum/antagonist/proc/set_antag_name(var/mob/living/player)
	// Choose a name, if any.
	var/newname = sanitize(input(player, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		player.real_name = newname
		player.name = player.real_name
		player.dna.real_name = newname
	if(player.mind) player.mind.name = player.name
	// Update any ID cards.
	update_access(player)
