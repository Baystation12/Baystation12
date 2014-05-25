#define MUTINY_RECRUITMENT_COOLDOWN 5

datum/game_mode/mutiny
	var/datum/mutiny_fluff/fluff
	var/datum/directive/current_directive
	var/obj/item/weapon/mutiny/auth_key/captain/captains_key
	var/obj/item/weapon/mutiny/auth_key/secondary/secondary_key
	var/obj/machinery/emergency_authentication_device/ead
	var/datum/mind/head_loyalist
	var/datum/mind/head_mutineer
	var/recruit_loyalist_cooldown = 0
	var/recruit_mutineer_cooldown = 0
	var/list/loyalists = list()
	var/list/mutineers = list()
	var/list/body_count = list()

	name = "mutiny"
	config_tag = "mutiny"
	required_players = 7
	ert_disabled = 1

	uplink_welcome = "Mutineers Uplink Console:"
	uplink_uses = 0

	New()
		fluff = new(src)

	proc/reveal_directives()
		spawn(rand(1 MINUTE, 3 MINUTES))
			fluff.announce_incoming_fax()
			spawn(rand(3 MINUTES, 5 MINUTES))
				send_pda_message()
			spawn(rand(3 MINUTES, 5 MINUTES))
				fluff.announce_directives()
				spawn(rand(2 MINUTES, 3 MINUTE))
					fluff.announce_ert_unavailable()

	// Returns an array in case we want to expand on this later.
	proc/get_head_loyalist_candidates()
		var/list/candidates[0]
		for(var/mob/loyalist in player_list)
			if(loyalist.mind && loyalist.mind.assigned_role == "Captain")
				candidates.Add(loyalist.mind)
		return candidates

	proc/get_head_mutineer_candidates()
		var/list/candidates[0]
		for(var/mob/mutineer in player_list)
			if(mutineer.client.prefs.be_special & BE_MUTINEER)
				for(var/job in command_positions - "Captain")
					if(mutineer.mind && mutineer.mind.assigned_role == job)
						candidates.Add(mutineer.mind)
		return candidates

	proc/get_directive_candidates()
		var/list/candidates[0]
		for(var/T in typesof(/datum/directive) - /datum/directive)
			var/datum/directive/D = new T(src)
			if (D.meets_prerequisites())
				candidates.Add(D)
		return candidates

	proc/send_pda_message()
		var/obj/item/device/pda/pda = null
		for(var/obj/item/device/pda/P in head_mutineer.current)
			pda = P
			break

		if (!pda)
			return 0

		if (!pda.silent)
			playsound(pda.loc, 'sound/machines/twobeep.ogg', 50, 1)
			for (var/mob/O in hearers(3, pda.loc))
				O.show_message(text("\icon[pda] *[pda.ttone]*"))

		head_mutineer.current << fluff.get_pda_body()
		return 1

	proc/get_equipment_slots()
		return list(
			"left pocket" = slot_l_store,
			"right pocket" = slot_r_store,
			"backpack" = slot_in_backpack,
			"left hand" = slot_l_hand,
			"right hand" = slot_r_hand)

	proc/equip_head_loyalist()
		var/mob/living/carbon/human/H = head_loyalist.current
		captains_key = new(H)
		H.equip_in_one_of_slots(captains_key, get_equipment_slots())
		H.update_icons()
		H.verbs += /mob/living/carbon/human/proc/recruit_loyalist

	proc/equip_head_mutineer()
		var/mob/living/carbon/human/H = head_mutineer.current
		secondary_key = new(H)
		H.equip_in_one_of_slots(secondary_key, get_equipment_slots())
		H.update_icons()
		H.verbs += /mob/living/carbon/human/proc/recruit_mutineer

	proc/add_loyalist(datum/mind/M)
		add_faction(M, "loyalist", loyalists)

	proc/add_mutineer(datum/mind/M)
		add_faction(M, "mutineer", mutineers)

	proc/add_faction(datum/mind/M, faction, list/faction_list)
		if(!can_be_recruited(M, faction))
			M.current << "\red Recruitment canceled; your role has already changed."
			head_mutineer.current << "\red Could not recruit [M]. Their role has changed."
			return

		if(M in loyalists)
			loyalists.Remove(M)

		if(M in mutineers)
			mutineers.Remove(M)

		M.special_role = faction
		faction_list.Add(M)

		if(faction == "mutineer")
			M.current << fluff.mutineer_tag("You have joined the mutineers!")
			head_mutineer.current << fluff.mutineer_tag("[M] has joined the mutineers!")
		else
			M.current << fluff.loyalist_tag("You have joined the loyalists!")
			head_loyalist.current << fluff.loyalist_tag("[M] has joined the loyalists!")

		update_icon(M)

	proc/was_bloodbath()
		var/list/remaining_loyalists = loyalists - body_count
		if (!remaining_loyalists.len)
			return 1

		var/list/remaining_mutineers = mutineers - body_count
		if (!remaining_mutineers.len)
			return 1

		return 0

	proc/replace_nuke_with_ead()
		for(var/obj/machinery/nuclearbomb/N in world)
			ead = new(N.loc, src)
			del(N)

	proc/unbolt_vault_door()
		var/obj/machinery/door/airlock/vault = locate(/obj/machinery/door/airlock/vault)
		vault.locked = 0

	proc/can_be_recruited(datum/mind/M, role)
		if(!M) return 0
		if(!M.special_role) return 1
		switch(role)
			if("loyalist")
				return M.special_role == "mutineer"
			if("mutineer")
				return M.special_role == "loyalist"

	proc/round_outcome()
		world << "<center><h4>Breaking News</h4></center><br><hr>"
		if (was_bloodbath())
			world << fluff.no_victory()
			return

		var/directives_completed = current_directive.directives_complete()
		var/ead_activated = ead.activated
		if (directives_completed && ead_activated)
			world << fluff.loyalist_major_victory()
		else if (directives_completed && !ead_activated)
			world << fluff.loyalist_minor_victory()
		else if (!directives_completed && ead_activated)
			world << fluff.mutineer_minor_victory()
		else if (!directives_completed && !ead_activated)
			world << fluff.mutineer_major_victory()

		world << sound('sound/machines/twobeep.ogg')

	proc/update_all_icons()
		spawn(0)
			for(var/datum/mind/M in mutineers)
				update_icon(M)

			for(var/datum/mind/M in loyalists)
				update_icon(M)
		return 1

	proc/update_icon(datum/mind/M)
		if(!M.current || !M.current.client)
			return 0

		for(var/image/I in head_loyalist.current.client.images)
			if(I.loc == M.current && (I.icon_state == "loyalist" || I.icon_state == "mutineer"))
				del(I)

		for(var/image/I in head_mutineer.current.client.images)
			if(I.loc == M.current && (I.icon_state == "loyalist" || I.icon_state == "mutineer"))
				del(I)

		if(M in loyalists)
			var/I = image('icons/mob/mob.dmi', loc=M.current, icon_state = "loyalist")
			head_loyalist.current.client.images += I

		if(M in mutineers)
			var/I = image('icons/mob/mob.dmi', loc=M.current, icon_state = "mutineer")
			head_mutineer.current.client.images += I

		return 1

	proc/check_antagonists_ui(admins)
		var/turf/captains_key_loc = captains_key ? captains_key.get_loc_turf() : "Lost or Destroyed"
		var/turf/secondary_key_loc = secondary_key ? secondary_key.get_loc_turf() : "Lost or Destroyed"
		var/txt = {"
			<h5>Context:</h5>
			<p>
				[current_directive.get_description()]
			</p>
			<h5>Orders:</h5>
			<ol>
				[fluff.get_orders()]
			</ol>
			<br>
			<h5>Authentication:</h5>
			<b>Captain's Key:</b> [captains_key_loc]
			<a href='?src=\ref[admins];choice=activate_captains_key'>Activate</a><br>
			<b>Secondary Key:</b> [secondary_key_loc]
			<a href='?src=\ref[admins];choice=activate_secondary_key'>Activate</a><br>
			<b>EAD: [ead ? ead.get_status() : "Lost or Destroyed"]</b>
			<a href='?src=\ref[admins];choice=activate_ead'>Activate</a><br>
			<hr>
		"}

		if(head_loyalist)
			txt += check_role_table("Head Loyalist", list(head_loyalist), admins, 0)

		var/list/loyal_crew = loyalists - head_loyalist
		if(loyal_crew.len)
			txt += check_role_table("Loyalists", loyal_crew, admins, 0)

		if(head_mutineer)
			txt += check_role_table("Head Mutineer", list(head_mutineer), admins, 0)

		var/list/mutiny_crew = mutineers - head_mutineer
		if(mutiny_crew.len)
			txt += check_role_table("Mutineers", mutiny_crew, admins, 0)

		if(body_count.len)
			txt += check_role_table("Casualties", body_count, admins, 0)

		return txt

/datum/game_mode/mutiny/announce()
	fluff.announce()

/datum/game_mode/mutiny/pre_setup()
	var/list/loyalist_candidates = get_head_loyalist_candidates()
	if(!loyalist_candidates || loyalist_candidates.len == 0)
		world << "\red Mutiny mode aborted: no valid candidates for head loyalist."
		return 0

	var/list/mutineer_candidates = get_head_mutineer_candidates()
	if(!mutineer_candidates || mutineer_candidates.len == 0)
		world << "\red Mutiny mode aborted: no valid candidates for head mutineer."
		return 0

	var/list/directive_candidates = get_directive_candidates()
	if(!directive_candidates || directive_candidates.len == 0)
		world << "\red Mutiny mode aborted: no valid candidates for Directive X."
		return 0

	head_loyalist = pick(loyalist_candidates)
	head_mutineer = pick(mutineer_candidates)
	current_directive = pick(directive_candidates)

	return 1

/datum/game_mode/mutiny/post_setup()
	head_loyalist.current << "You are the Head Loyalist!"
	head_loyalist.special_role = "head_loyalist"
	equip_head_loyalist()

	head_mutineer.current << "You are the Head Mutineer!"
	head_mutineer.special_role = "head_mutineer"
	equip_head_mutineer()

	loyalists.Add(head_loyalist)
	mutineers.Add(head_mutineer)

	replace_nuke_with_ead()
	current_directive.initialize()
	unbolt_vault_door()

	update_all_icons()
	spawn(0)
		reveal_directives()
	..()

/datum/game_mode/mutiny/check_antagonists_topic(href, href_list[])
	switch(href_list["choice"])
		if("activate_captains_key")
			ead.captains_key = 1
			return 1
		if("activate_secondary_key")
			ead.secondary_key = 1
			return 1
		if("activate_ead")
			ead.activated = 1
			return 1
		else
			return 0

/mob/living/carbon/human/proc/recruit_loyalist()
	set name = "Recruit Loyalist"
	set category = "Mutiny"

	var/datum/game_mode/mutiny/mode = get_mutiny_mode()
	if (!mode || src != mode.head_loyalist.current)
		return

	var/list/candidates = list()
	for (var/mob/living/carbon/human/P in oview(src))
		if(!stat && P.client && mode.can_be_recruited(P.mind, "loyalist"))
			candidates += P

	if(!candidates.len)
		src << "\red You aren't close enough to anybody that can be recruited."
		return

	if(world.time < mode.recruit_loyalist_cooldown)
		src << "\red Wait [MUTINY_RECRUITMENT_COOLDOWN] seconds before recruiting again."
		return

	mode.recruit_loyalist_cooldown = world.time + (MUTINY_RECRUITMENT_COOLDOWN SECONDS)

	var/mob/living/carbon/human/M = input("Select a person to recruit", "Loyalist recruitment", null) as mob in candidates

	if (M)
		src << "Attempting to recruit [M]..."
		log_admin("[src]([src.ckey]) attempted to recruit [M] as a loyalist.")
		message_admins("\red [src]([src.ckey]) attempted to recruit [M] as a loyalist.")

		var/choice = alert(M, "Asked by [src]: Will you help me complete Directive X?", "Loyalist recruitment", "No", "Yes")
		if(choice == "Yes")
			mode.add_loyalist(M.mind)
		else if(choice == "No")
			M << "\red You declined to join the loyalists."
			mode.head_loyalist.current << "\red <b>[M] declined to support the loyalists.</b>"

/mob/living/carbon/human/proc/recruit_mutineer()
	set name = "Recruit Mutineer"
	set category = "Mutiny"

	var/datum/game_mode/mutiny/mode = get_mutiny_mode()
	if (!mode || src != mode.head_mutineer.current)
		return

	var/list/candidates = list()
	for (var/mob/living/carbon/human/P in oview(src))
		if(!stat && P.client && mode.can_be_recruited(P.mind, "mutineer"))
			candidates += P

	if(!candidates.len)
		src << "\red You aren't close enough to anybody that can be recruited."
		return

	if(world.time < mode.recruit_mutineer_cooldown)
		src << "\red Wait [MUTINY_RECRUITMENT_COOLDOWN] seconds before recruiting again."
		return

	mode.recruit_mutineer_cooldown = world.time + (MUTINY_RECRUITMENT_COOLDOWN SECONDS)

	var/mob/living/carbon/human/M = input("Select a person to recruit", "Mutineer recruitment", null) as mob in candidates

	if (M)
		src << "Attempting to recruit [M]..."
		log_admin("[src]([src.ckey]) attempted to recruit [M] as a mutineer.")
		message_admins("\red [src]([src.ckey]) attempted to recruit [M] as a mutineer.")

		var/choice = alert(M, "Asked by [src]: Will you help me stop Directive X?", "Mutineer recruitment", "No", "Yes")
		if(choice == "Yes")
			mode.add_mutineer(M.mind)
		else if(choice == "No")
			M << "\red You declined to join the mutineers."
			mode.head_mutineer.current << "\red <b>[M] declined to support the mutineers.</b>"

/proc/get_mutiny_mode()
	if(!ticker || !istype(ticker.mode, /datum/game_mode/mutiny))
		return null

	return ticker.mode
