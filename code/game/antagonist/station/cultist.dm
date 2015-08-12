var/datum/antagonist/cultist/cult

/proc/iscultist(var/mob/player)
	if(!cult || !player.mind)
		return 0
	if(player.mind in cult.current_antagonists)
		return 1

/datum/antagonist/cultist
	id = MODE_CULTIST
	role_text = "Cultist"
	role_text_plural = "Cultists"
	bantype = "cultist"
	restricted_jobs = list("Chaplain", "AI", "Cyborg")
	protected_jobs = list("Internal Affairs Agent", "Head of Security", "Captain", "Security Officer", "Warden", "Detective")
	role_type = BE_CULTIST
	feedback_tag = "cult_objective"
	antag_indicator = "cult"
	welcome_text = "You have a talisman in your possession; one that will help you start the cult on this station. Use it well and remember - there are others."
	victory_text = "The cult wins! It has succeeded in serving its dark masters!"
	loss_text = "The staff managed to stop the cult!"
	victory_feedback_tag = "win - cult win"
	loss_feedback_tag = "loss - staff stopped the cult"
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	max_antags = 200 // No upper limit.
	max_antags_round = 200
	var/allow_narsie = 1

	var/datum/mind/sacrifice_target
	var/list/sacrificed = list()
	var/list/harvested = list()
	var/cult_rating = 0
	var/cult_level = 1

/datum/antagonist/cultist/New()
	..()
	cult = src

/datum/antagonist/cultist/create_global_objectives()

	if(!..())
		return

	global_objectives = list()
	if(prob(50))
		global_objectives |= new /datum/objective/cult/survive
	else
		global_objectives |= new /datum/objective/cult/eldergod

	var/datum/objective/cult/sacrifice/sacrifice = new()
	sacrifice.find_target()
	sacrifice_target = sacrifice.target
	global_objectives |= sacrifice

/datum/antagonist/cultist/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	var/obj/item/weapon/book/tome/T = new(get_turf(player))
	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	for(var/slot in slots)
		player.equip_to_slot(T, slot)
		if(T.loc == player)
			break
	var/obj/item/weapon/storage/S = locate() in player.contents
	if(S && istype(S))
		T.loc = S

/datum/antagonist/cultist/greet(var/datum/mind/player)
	if(!..())
		return 0

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	player.current << "<span class='danger'>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</span>"
	if(show_message)
		player.current.visible_message("<span class='notice'>[player.current] looks like they just reverted to their old faith!</span>")
	remove_cult_magic(player.current)

/datum/antagonist/cultist/add_antagonist(var/datum/mind/player)
	if(!..())
		return
	player << "<span class='cult'>You catch a glimpse of the Realm of Nar-Sie, the Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of That Which Waits. Assist your new compatriots in their dark dealings. Their goals are yours, and yours are theirs. You serve the Dark One above all else. Bring It back.</span>"

/datum/antagonist/cultist/can_become_antag(var/datum/mind/player)
	if(!..())
		return 0
	for(var/obj/item/weapon/implant/loyalty/L in player.current)
		if(L && (L.imp_in == player.current))
			return 0
	return 1

/datum/antagonist/cultist/update_antag_mob(var/datum/mind/player)
	..()
	add_cultiness(20)
	add_cult_magic(player.current)

/datum/antagonist/cultist/proc/add_cultiness(var/amount)
	cult_rating += amount
	if(cult_rating >= 100 && cult_level < 2)
		cult_level = 2
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				H.current << "<span class='cult'>The veil between this world and beyond grows thin, and your power grows.</span>"
				add_cult_magic(H.current)
		for(var/mob/dead/observer/D)
			add_ghost_magic(D)
	if(cult_rating >= 200 && cult_level < 3)
		cult_level = 3
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				H.current << "<span class='cult'>You feel that the fabric of reality is tearing. You can feel the Geometer of Blood's presence growing stronger.</span>"
				add_cult_magic(H.current)
		for(var/mob/dead/observer/D)
			add_ghost_magic(D)
	if(cult_rating >= 300 && cult_level < 4)
		cult_level = 4
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				H.current << "<span class='cult'>The world is at end. The veil is as thin as ever. The time has come.</span>"
				add_cult_magic(H.current)
		for(var/mob/dead/observer/D)
			add_ghost_magic(D)

/datum/antagonist/cultist/proc/add_cult_magic(var/mob/M)
	M.verbs += /mob/proc/convert_rune
	M.verbs += /mob/proc/teleport_rune
	M.verbs += /mob/proc/tome_rune
	M.verbs += /mob/proc/wall_rune
	M.verbs += /mob/proc/ajorney_rune
	M.verbs += /mob/proc/defile_rune

	if(cult_level >= 2)
		M.verbs += /mob/proc/armor_rune
		M.verbs += /mob/proc/sacrifice_rune
		M.verbs += /mob/proc/manifest_rune
		M.verbs += /mob/proc/drain_rune

		if(cult_level >= 3)
			M.verbs += /mob/proc/weapon_rune
			M.verbs += /mob/proc/shell_rune
			M.verbs += /mob/proc/bloodboil_rune
			M.verbs += /mob/proc/confuse_rune
			M.verbs += /mob/proc/revive_rune

			if(cult_level >= 4)
				M.verbs += /mob/proc/tearreality_rune

	M.verbs += /mob/proc/stun_imbue
	M.verbs += /mob/proc/emp_imbue

	M.verbs += /mob/proc/cult_communicate

/datum/antagonist/cultist/proc/remove_cult_magic(var/mob/M)
	M.verbs -= /mob/proc/convert_rune
