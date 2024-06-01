/datum/antagonist/proc/create_antagonist(datum/mind/target, move, gag_announcement, preserve_appearance)

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
	if(!gag_announcement)
		announce_antagonist_spawn()

/datum/antagonist/proc/create_default(mob/source)
	var/mob/living/M
	if(mob_path)
		M = new mob_path(get_turf(source))
	else
		M = new /mob/living/carbon/human(get_turf(source))
	M.ckey = source.ckey

	if(!M.ckey && source.mind)
		M.ckey = source.mind.key

	add_antagonist(M.mind, 1, 0, 1) // Equip them and move them to spawn.
	return M

/datum/antagonist/proc/create_id(assignment, mob/living/carbon/human/player, equip = 1)

	var/obj/item/card/id/W = new id_type(player)
	if(!W) return
	W.access |= default_access
	W.assignment = "[assignment]"
	player.set_id_info(W)
	if(equip) player.equip_to_slot_or_del(W, slot_wear_id)
	return W

/datum/antagonist/proc/create_radio(freq, mob/living/carbon/human/player)
	var/obj/item/device/radio/R

	switch(freq)
		if(SYND_FREQ)
			R = new/obj/item/device/radio/headset/syndicate(player)
		if(RAID_FREQ)
			R = new/obj/item/device/radio/headset/raider(player)
		if(V_RAID_FREQ)
			R = new/obj/item/device/radio/headset/vox_raider(player)
		else
			R = new/obj/item/device/radio/headset(player)
			R.set_frequency(freq)

	player.equip_to_slot_or_del(R, slot_l_ear)
	return R

/datum/antagonist/proc/greet(datum/mind/player)

	// Basic intro text.
	to_chat(player.current, SPAN_DANGER(FONT_LARGE("You are a [role_text]!")))
	if(leader_welcome_text && player == leader)
		to_chat(player.current, SPAN_CLASS("antagdesc", "[get_leader_welcome_text(player.current)]"))
	else
		to_chat(player.current, SPAN_CLASS("antagdesc", "[get_welcome_text(player.current)]"))
	if (config.objectives_disabled == CONFIG_OBJECTIVE_NONE || !length(player.objectives))
		to_chat(player.current, get_antag_text(player.current))

	src.show_objectives_at_creation(player)
	return 1

/datum/antagonist/proc/set_antag_name(mob/living/player)
	// Choose a name, if any.
	var/newname = sanitize(input(player, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		player.real_name = newname
		player.SetName(player.real_name)
		if(player.dna)
			player.dna.real_name = newname
	if(player.mind) player.mind.name = player.name
	// Update any ID cards.
	update_access(player)
