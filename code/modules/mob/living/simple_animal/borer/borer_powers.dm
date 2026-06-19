/mob/living/simple_animal/borer/proc/can_use_borer_ability(silent = FALSE, requires_host_value = TRUE, usable_while_docile = FALSE, check_last_special = TRUE)

	if(controlling)
		return FALSE

	if(requires_host_value)
		if(!host)
			if(!silent)
				to_chat(src, SPAN_WARNING("You must be within a host body to use this action."))
			return FALSE
	else
		if(host)
			if(!silent)
				to_chat(src, SPAN_WARNING("You cannot be within a host body when using this action."))
			return FALSE

	if(stat)
		if(!silent)
			to_chat(src, SPAN_WARNING("You cannot perform this action in your current state."))
		return FALSE
	if(docile && !usable_while_docile)
		if(!silent)
			to_chat(src, SPAN_NOTICE("You are feeling far too docile to perform this action."))
		return FALSE
	if(check_last_special && world.time < last_special)
		if(!silent)
			to_chat(src, SPAN_NOTICE("You cannot perform this action so soon after the last."))
		return FALSE
	return TRUE

// BRAIN WORM ZOMBIES AAAAH.
/mob/living/simple_animal/borer/proc/replace_brain()

	var/mob/living/carbon/human/H = host

	if(!istype(host))
		to_chat(src, SPAN_WARNING("This host does not have a suitable brain."))
		return

	to_chat(src, SPAN_DANGER("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of [H]."))

	H.add_language(LANGUAGE_BORER_GLOBAL)

	if(host.is_dead())
		H.verbs |= /mob/living/carbon/human/proc/jumpstart

	H.verbs |= /mob/living/carbon/human/proc/psychic_whisper
	if(!neutered)
		H.verbs |= /mob/living/carbon/proc/spawn_larvae

	if(H.client)
		H.ghostize(0)

	if(src.mind)
		src.mind.special_role = "Borer Husk"
		src.mind.transfer_to(host)

	H.ChangeToHusk()

	var/obj/item/organ/internal/borer/B = new(H)
	if(islist(chemical_types))
		B.chemical_types = chemical_types.Copy()
	H.internal_organs_by_name[BP_BRAIN] = B
	H.internal_organs |= B

	var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
	affecting.implants -= src

	var/s2h_id = src.last_cid
	var/s2h_ip= src.last_address
	src.last_cid = null
	src.last_address = null
	if(!H.last_cid)
		H.last_cid = s2h_id
	if(!H.last_address)
		H.last_address = s2h_ip

/mob/living/carbon/human/proc/jumpstart()
	set category = "Abilities"
	set name = "Jumpstart body"
	set desc = "Revive the dead body you are currently occupying."

	if(stat != 2)
		to_chat(usr, SPAN_WARNING("Your host is already alive."))
		return

	verbs -= /mob/living/carbon/human/proc/jumpstart
	visible_message(SPAN_DANGER("With a hideous, rattling moan, [src] shudders back to life!"))

	rejuvenate()
	restore_blood()
	fixblood()
	UpdateLyingBuckledAndVerbStatus()

	var/list/faculties = SSpsi.faculties_by_id

	for(var/faculty in faculties)
		set_psi_rank(faculty, 3, defer_update = TRUE)
	psi.update()
	resuscitate()

/mob/living/simple_animal/borer/verb/assess_psi()
	set category = "Abilities"
	set name = "Assess Psi"
	set desc = "Check psi potential of your host."

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = FALSE))
		return

	host.show_psi_assay(src)

/mob/living/simple_animal/borer/verb/scan_health()
	set category = "Abilities"
	set name = "Scan Body"
	set desc = "Scan body for damage."

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = FALSE))
		return

	if(deep_link)
		var/scan_results = display_medical_data(host.get_raw_medical_data(), SKILL_MAX)
		scan_results += "<A href='byond://?src=\ref[usr];mach_close=scanconsole'>Close</A>"
		show_browser(usr, scan_results, "window=scanconsole;size=430x600")
	else
		var/scan_results = medical_scan_results(host, TRUE, SKILL_MASTER)
		to_chat(src, "<br>[scan_results]<br>")

/mob/living/simple_animal/borer/proc/weaken_connection()
	deep_link = FALSE
	max_chemicals = initial(max_chemicals)
	chem_gen_amount = initial(chem_gen_amount)

	chemical_types -= bonus_chemical_types

	if(host)
		to_chat(host, SPAN_NOTICE("The deep mental connection fades to a lighter presence."))

/mob/living/simple_animal/borer/proc/strengthen_connection()
	deep_link = TRUE
	max_chemicals = 500
	chem_gen_amount = 2

	chemical_types += bonus_chemical_types

	if(host)
		to_chat(src, SPAN_NOTICE("Host agreed to integrate. Your abilities are strengthened."))
		to_chat(host, SPAN_NOTICE("Something merges with your thoughts, and through a new two-way connection, you figure out a weakness of this entity, its sugar."))

/mob/living/simple_animal/borer/verb/enforce_connection()
	set category = "Abilities"
	set name = "Toggle Integration"
	set desc = "Strengthen or weaken neural connection with your host to improve your capabilities."

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = TRUE))
		return

	var/mob/original_host = host

	if(deep_link)
		if(alert("Do you wish to weaken established neural connection to the brain? It will take time.",,"Yes", "No") == "Yes")
			set_ability_cooldown(120 SECONDS)
			if(!do_after(src, 120 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT))
				return
			weaken_connection()
			to_chat(src, SPAN_NOTICE("You've successfully weakened your connection to host's brain."))
	else
		if(host.is_dead())
			to_chat(src, SPAN_WARNING("The host's brain is non-functional."))
			return
		if(psi_boost)
			to_chat(src, SPAN_WARNING("Stop applying psionic enhancements first."))
			return

		if(alert("Attempt to establish a deep neural connection with the host's brain? This can improve your abilities, but requires a consent from the host. Refusal might damage you.",,"Yes", "No") == "Yes")
			if(!host.client)
				to_chat(src, SPAN_WARNING("The host is not conscious enough for this."))
				return
			set_ability_cooldown(30 SECONDS)
			if(!controlling && alert(host,"Something is trying to integrate more deeply with your consciousness, do you allow this?",,"Yes", "No") == "Yes")
				if(host && original_host == host)
					strengthen_connection()
			else
				apply_damage(5) // 25% of health
				set_ability_cooldown(60 SECONDS)
				to_chat(src, SPAN_DANGER("Host rejected your integration attempt! The neural backlash damages you."))

/mob/living/simple_animal/borer/verb/revive_host()
	set category = "Abilities"
	set name = "Revive (250)"
	set desc = "Perform a basic revival of your host from death."

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = TRUE))
		return

	if(!host.is_dead())
		to_chat(src, SPAN_WARNING("Your host is already alive!"))
		return TRUE
	if(!deep_link && (world.time - host.timeofdeath) > 6000)
		to_chat(src, SPAN_WARNING("\The [host] has been dead for too long to revive."))
		return TRUE
	if(chemicals >= 250)
		chemicals -= 250

		for(var/mob/observer/G in GLOB.dead_mobs)
			if(G.mind && G.mind.current == host && G.client)
				to_chat(G, SPAN_NOTICE(FONT_LARGE("<b>Your body has been revived, <b>Re-Enter Corpse</b> to return to it.</b>")))
				break

		host.visible_message(SPAN_NOTICE("\The [host] shudders violently!"))
		host.adjustOxyLoss(-rand(30,45))
		host.basic_revival()

		if(deep_link)
			host.adjustOxyLoss(-30)
			host.adjustBrainLoss(-30)
			host.resuscitate()

		set_ability_cooldown(60 SECONDS)
	else
		to_chat(src, SPAN_WARNING("You do not have enough chemicals stored to revive."))
		return

/mob/living/simple_animal/borer/verb/rejuvenate_host()
	set category = "Abilities"
	set name = "Rejuvenate (500)"
	set desc = "Fully heal your host at will."

	if(!deep_link)
		to_chat(src, SPAN_WARNING("This ability requires a deeper level of connection with the host."))
		return

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = TRUE))
		return

	if(chemicals >= 500)
		chemicals -= 500

		to_chat(src, SPAN_NOTICE("You channel your stored chemicals into [host], flooding them with regenerative compounds."))

		host.rejuvenate()
		host.resuscitate()
		host.visible_message(SPAN_WARNING("[host] suddenly convulses as their body rapidly regenerates!"), SPAN_WARNING("You feel a strange energy coursing through you."))
		set_ability_cooldown(60 SECONDS)
	else
		to_chat(src, SPAN_WARNING("You do not have enough chemicals stored to rejuvenate."))
		return

/mob/living/simple_animal/borer/verb/clear_mind()
	set category = "Abilities"
	set name = "Clear Mind (50)"
	set desc = "Purge host's hallucinations or reduce stun effects."

	var/val = deep_link ? 100 : 50

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = TRUE))
		return

	if(host.is_dead())
		return

	if(chemicals >= 50)
		chemicals -= 50

		if(deep_link)
			host.adjustBrainLoss(-10)

		host.drowsyness = max(host.drowsyness - val, 0)
		host.AdjustParalysis(-val)
		host.AdjustStunned(-val)
		host.AdjustWeakened(-val)
		host.adjust_hallucination(-val)

		set_ability_cooldown(5 SECONDS)
		to_chat(src, SPAN_NOTICE("You channel your psychic energy to clear your host's mind, stabilizing their consciousness."))
		to_chat(host, SPAN_NOTICE("A soothing psychic presence clears your mind, sharpening your focus and reducing mental fatigue."))
	else
		to_chat(src, SPAN_WARNING("You do not have enough chemicals stored to clear mind."))
		return

/mob/living/simple_animal/borer/proc/reset_psi()
	if(psi_boost)
		psi_boost = FALSE

		if(host && host.psi)
			host.psi.reset()
			to_chat(host, SPAN_NOTICE("You feel like your mind narrows."))

		to_chat(src, SPAN_NOTICE("You stopped enhancing psionic abilities."))

/mob/living/simple_animal/borer/proc/boost_psi()
	if(host)
		var/boost_val = deep_link ? 2 : 1
		var/boosted_psipower = deep_link ? 150 : 100

		var/list/faculties = SSpsi.faculties_by_id
		for(var/faculty in faculties)
			var/boosted_rank = host.psi ? host.psi.get_rank(faculty) : 0
			boosted_rank = min(max_psi_rank, boosted_rank + boost_val)

			host.set_psi_rank(faculty, boosted_rank, take_larger = TRUE, temporary = TRUE)

		host.psi.max_stamina = boosted_psipower
		host.psi.update(force = TRUE)

		psi_boost = TRUE

		to_chat(src, SPAN_NOTICE("You start enhancing psionic abilities."))
		to_chat(host, SPAN_NOTICE("You feel like your mind expands."))

/mob/living/simple_animal/borer/verb/toggle_psi_boost()
	set category = "Abilities"
	set name = "Toggle Psi Boost"
	set desc = "Toggle psionic enhancements for your host."

	if(!can_use_borer_ability(requires_host_value = TRUE, usable_while_docile = TRUE, check_last_special = TRUE))
		return

	if(psi_boost)
		reset_psi()
	else
		boost_psi()

	set_ability_cooldown(15 SECONDS)
