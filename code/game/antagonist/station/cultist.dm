#define CULTINESS_PER_CULTIST 40
#define CULTINESS_PER_SACRIFICE 40
#define CULTINESS_PER_TURF 1

#define CULT_RUNES_1 200
#define CULT_RUNES_2 400
#define CULT_RUNES_3 1000

#define CULT_GHOSTS_1 400
#define CULT_GHOSTS_2 800
#define CULT_GHOSTS_3 1200

#define CULT_MAX_CULTINESS 1200 // When this value is reached, the game stops checking for updates so we don't recheck every time a tile is converted in endgame

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
	restricted_jobs = list(/datum/job/lawyer, /datum/job/captain, /datum/job/hos)
	protected_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/detective)
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain, /datum/job/psychiatrist)
	feedback_tag = "cult_objective"
	antag_indicator = "hudcultist"
	welcome_text = "You have a tome in your possession; one that will help you start the cult. Use it well and remember - there are others."
	victory_text = "The cult wins! It has succeeded in serving its dark masters!"
	loss_text = "The staff managed to stop the cult!"
	victory_feedback_tag = "win - cult win"
	loss_feedback_tag = "loss - staff stopped the cult"
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 6
	initial_spawn_req = 4
	initial_spawn_target = 6
	antaghud_indicator = "hudcultist"

	var/allow_narsie = 1
	var/powerless = 0
	var/datum/mind/sacrifice_target
	var/list/obj/effect/rune/teleport/teleport_runes = list()
	var/list/rune_strokes = list()
	var/list/sacrificed = list()
	var/cult_rating = 0
	var/list/cult_rating_bounds = list(CULT_RUNES_1, CULT_RUNES_2, CULT_RUNES_3, CULT_GHOSTS_1, CULT_GHOSTS_2, CULT_GHOSTS_3)
	var/max_cult_rating = 0
	var/conversion_blurb = "You catch a glimpse of the Realm of Nar-Sie, the Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of That Which Waits. Assist your new compatriots in their dark dealings. Their goals are yours, and yours are theirs. You serve the Dark One above all else. Bring It back."

	faction = "cult"

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
	if(istype(S))
		T.forceMove(S)

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	to_chat(player.current, "<span class='danger'>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</span>")
	player.memory = ""
	if(show_message)
		player.current.visible_message("<span class='notice'>[player.current] looks like they just reverted to their old faith!</span>")
	remove_cult_magic(player.current)
	remove_cultiness(CULTINESS_PER_CULTIST)

/datum/antagonist/cultist/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
	. = ..()
	if(.)
		to_chat(player, "<span class='cult'>[conversion_blurb]</span>")
		if(player.current && !istype(player.current, /mob/living/simple_animal/construct))
			player.current.add_language(LANGUAGE_CULT)

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	. = ..()
	if(. && player.current && !istype(player.current, /mob/living/simple_animal/construct))
		player.current.remove_language(LANGUAGE_CULT)

/datum/antagonist/cultist/update_antag_mob(var/datum/mind/player)
	. = ..()
	add_cultiness(CULTINESS_PER_CULTIST)
	add_cult_magic(player.current)

/datum/antagonist/cultist/proc/add_cultiness(var/amount)
	cult_rating += amount
	var/old_rating = max_cult_rating
	max_cult_rating = max(max_cult_rating, cult_rating)
	if(old_rating >= CULT_MAX_CULTINESS)
		return
	var/list/to_update = list()
	for(var/i in cult_rating_bounds)
		if((old_rating < i) && (max_cult_rating >= i))
			to_update += i

	if(to_update.len)
		update_cult_magic(to_update)

/datum/antagonist/cultist/proc/update_cult_magic(var/list/to_update)
	if(CULT_RUNES_1 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>The veil between this world and beyond grows thin, and your power grows.</span>")
				add_cult_magic(H.current)
	if(CULT_RUNES_2 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>You feel that the fabric of reality is tearing.</span>")
				add_cult_magic(H.current)
	if(CULT_RUNES_3 in to_update)
		for(var/datum/mind/H in cult.current_antagonists)
			if(H.current)
				to_chat(H.current, "<span class='cult'>The world is at end. The veil is as thin as ever.</span>")
				add_cult_magic(H.current)

	if((CULT_GHOSTS_1 in to_update) || (CULT_GHOSTS_2 in to_update) || (CULT_GHOSTS_3 in to_update))
		for(var/mob/observer/ghost/D in SSmobs.mob_list)
			add_ghost_magic(D)

/datum/antagonist/cultist/proc/offer_uncult(var/mob/M)
	if(!iscultist(M) || !M.mind)
		return

	to_chat(M, "<span class='cult'>Do you want to abandon the cult of Nar'Sie? <a href='?src=\ref[src];confirmleave=1'>ACCEPT</a></span>")

/datum/antagonist/cultist/Topic(href, href_list)
	if(href_list["confirmleave"])
		cult.remove_antagonist(usr.mind, 1)

/datum/antagonist/cultist/proc/remove_cultiness(var/amount)
	cult_rating = max(0, cult_rating - amount)

/datum/antagonist/cultist/proc/add_cult_magic(var/mob/M)
	M.verbs += Tier1Runes

	if(max_cult_rating >= CULT_RUNES_1)
		M.verbs += Tier2Runes

		if(max_cult_rating >= CULT_RUNES_2)
			M.verbs += Tier3Runes

			if(max_cult_rating >= CULT_RUNES_3)
				M.verbs += Tier4Runes

/datum/antagonist/cultist/proc/remove_cult_magic(var/mob/M)
	M.verbs -= Tier1Runes
	M.verbs -= Tier2Runes
	M.verbs -= Tier3Runes
	M.verbs -= Tier4Runes
