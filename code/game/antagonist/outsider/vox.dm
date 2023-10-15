GLOBAL_DATUM_INIT(vox_raiders, /datum/antagonist/vox, new)
GLOBAL_LIST_EMPTY(vox_artifact_spawners)

/datum/antagonist/vox
	id = MODE_VOXRAIDER
	role_text = "Vox Raider"
	role_text_plural = "Vox Raiders"
	landmark_id = "Vox-Spawn"
	welcome_text = "Scrap has been hard to find lately, and the Shroud requires replacement parts. Do not disappoint your kin."
	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudraider"

	hard_cap = 5
	hard_cap_round = 10
	initial_spawn_req = 3
	initial_spawn_target = 4

	id_type = /obj/item/card/id/syndicate

	base_to_load = /singleton/map_template/ruin/antag_spawn/vox_raider
	var/pending_item_spawn = TRUE
	faction = "vox raider"
	no_prior_faction = TRUE

/datum/antagonist/vox/add_antagonist(datum/mind/player, ignore_role, do_not_equip, move_to_spawn, do_not_announce, preserve_appearance)
	if(pending_item_spawn)
		for(var/obj/voxartifactspawner/S as anything in GLOB.vox_artifact_spawners)
			S.spawn_artifact()
		pending_item_spawn = FALSE
	..()

/datum/antagonist/vox/build_candidate_list(datum/game_mode/mode, ghosts_only)
	candidates = list()
	for(var/datum/mind/player in mode.get_players_for_role(id))
		if (ghosts_only && !(isghostmind(player) || isnewplayer(player.current)))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!")
			continue
		if (player.special_role)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])!")
			continue
		if (player in pending_antagonists)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role!")
			continue
		if (player_is_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!")
			continue
		if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
			log_debug("[player.current.ckey] is not whitelisted")
			continue
		var/result = can_become_antag_detailed(player)
		if (result)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: [result]")
			continue
		candidates |= player

	return candidates

/datum/antagonist/vox/get_potential_candidates(datum/game_mode/mode, ghosts_only)
	var/candidates = list()

	for(var/datum/mind/player in mode.get_players_for_role(id))
		if(ghosts_only && !(isghostmind(player) || isnewplayer(player.current)))
		else if(config.use_age_restriction_for_antags && player.current.client.player_age < minimum_player_age)
		else if(player.special_role)
		else if (player in pending_antagonists)
		else if(!can_become_antag(player))
		else if(player_is_antag(player))
		else if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
		else
			candidates |= player

	return candidates

/datum/antagonist/vox/can_become_antag_detailed(datum/mind/player, ignore_role)
	if(!is_alien_whitelisted(player.current, all_species[SPECIES_VOX]))
		return "Player doesn't have vox whitelist"
	..()

/datum/antagonist/vox/equip(mob/living/carbon/human/vox/player)
	if(!..())
		return FALSE

	player.set_species(SPECIES_VOX)
	var/singleton/hierarchy/outfit/vox_raider = outfit_by_type(/singleton/hierarchy/outfit/vox_raider)
	vox_raider.equip(player)


	return TRUE


/obj/structure/voxuplink
	name = "Shoal beacon"
	desc = "A pulsating mass of flesh and steel."
	icon = 'maps/antag_spawn/vox/vox.dmi'
	icon_state = "printer"
	breakable = FALSE
	anchored = TRUE
	density = TRUE
	var/favors = 0
	var/working = FALSE
	var/ignore_wl = FALSE
	var/rewards = list(
		"Slug Launcher - 2" = list(2, /obj/item/gun/launcher/alien/slugsling),
		"Soundcannon - 2" = list(2, /obj/item/gun/energy/sonic),
		"Flux Cannon - 4" = list(4, /obj/item/gun/energy/darkmatter),
		"Lightly Armored Suit - 3" =list(3, /obj/item/clothing/head/helmet/space/vox/carapace, /obj/item/clothing/suit/space/vox/carapace),
		"Raider Suit - 6" = list(6, /obj/item/clothing/head/helmet/space/vox/raider, /obj/item/clothing/suit/space/vox/raider),
		"Arkmade Hardsuit - 8" = list(8, /obj/item/rig/vox),
		"Makeshift Armored Vest - 1" = list(1, /obj/item/clothing/suit/armor/vox_scrap),
		"Request medical supplies from Shoal - 1" = list(1, /obj/random/firstaid),
		"Request equipment from Shoal - 1" = list(1, /obj/random/loot),
		"Protein Source - 1" = list(1, /mob/living/simple_animal/passive/meatbeast)
		)

/obj/structure/voxuplink/attack_hand(mob/living/carbon/human/user)
	var/obj/item/organ/internal/voxstack/stack = user.internal_organs_by_name[BP_STACK]
	if(istype(stack) || ignore_wl)
		if(!working)
			var/choice = input(user, "What would you like to request from Apex? You have [favors] favors left!", "Shoal Beacon") as null|anything in rewards
			if(choice && !working)
				if(rewards[choice][1] <= favors)
					working = TRUE
					on_update_icon()
					to_chat(user, SPAN_NOTICE("The Apex rewards you with \the [choice]."))
					sleep(20)
					working = FALSE
					on_update_icon()
					favors -= rewards[choice][1]
					for(var/I in rewards[choice])
						if(!isnum(I))
							new I(get_turf(src))
				else
					to_chat(user, SPAN_WARNING("You aren't worthy of \the [choice]!"))
		else
			to_chat(user, SPAN_WARNING("\The [src.name] is still working!"))
	else
		to_chat(user, SPAN_WARNING("You don't know what to do with \the [src.name]."))
	..()

/obj/structure/voxuplink/use_tool(obj/item/I, mob/user)
	if(istype(I, /obj/item/voxartifact))
		var/obj/item/voxartifact/A = I
		favors += A.favor_value
		qdel(A)
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [A] into \the [src]."),
			SPAN_NOTICE("You return \the [A] back to the Apex with \the [src].")
		)
		return TRUE
	if(istype(I, /obj/item/bluecrystal))
		var/obj/item/bluecrystal/A = I
		favors += A.favor_value
		qdel(A)
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [A] into \the [src]."),
			SPAN_NOTICE("You offer \the [A.name] to the Apex.")
		)
		return TRUE
	return ..()

/obj/structure/voxuplink/MouseDrop_T(obj/structure/voxartifactbig/I, mob/user)
	if(istype(I, /obj/structure/voxartifactbig))
		favors += I.favor_value
		qdel(I)
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [I] into \the [src]."),
			SPAN_NOTICE("You return \the [I] back to the Apex with \the [src].")
		)
		return TRUE
	return ..()

/obj/structure/voxuplink/on_update_icon()
	if(working)
		icon_state = "printer-working"
	else
		icon_state = "printer"

/obj/item/voxartifact
	name = "Apex shard"
	desc = "An odd-looking piece of organic matter, You can hear faint humming from the inside."
	icon = 'icons/obj/urn.dmi'
	icon_state = "urn"
	var/favor_value = 4
	var/open_chance = 1
	var/icons = list(
	"unknown2",
	"Green lump",
	"ano112",
	"ano72"
	)

/obj/item/voxartifact/Initialize()
	. = ..()
	icon_state = pick(icons)

/obj/item/voxartifact/attack_self(mob/living/carbon/human/user)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts tinkering with [src.name]."),
		SPAN_NOTICE("You start to analyze \the [src.name]."),
	)
	var/obj/item/organ/internal/voxstack/stack = user.internal_organs_by_name[BP_STACK]
	if (istype(stack))
		if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER))
			to_chat(user, SPAN_NOTICE("\The [src.name] disappears after a moment, leaving something behind.\nYou were able to send it back to arkship, but Apex did not appreciate your actions."))
			var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
			s.set_up(3, 1, src)
			s.start()
			activate()
	else
		if (do_after(user, 60 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER))
			if(rand(open_chance))
				to_chat(user, SPAN_NOTICE("After tinkering with [src.name] for some time, it suddenly disappears leaving something behind!"))
				var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
				s.set_up(10, 1, src)
				s.start()
				activate()
			else
				to_chat(user, SPAN_NOTICE("You are unable to learn anything useful about [src.name]."))

/obj/item/voxartifact/proc/activate()
	new /obj/random/loot(get_turf(src))
	new /obj/item/bluecrystal(get_turf(src))
	qdel(src)

/obj/structure/voxartifactbig
	name = "biopod"
	desc = "A bizarre structure made out of chitin-like material."
	icon = 'maps/antag_spawn/vox/vox.dmi'
	icon_state = "pod_big"
	density = TRUE
	var/favor_value = 12

/obj/voxartifactspawner
	name = "landmark"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = INVISIBILITY_ABSTRACT

/obj/voxartifactspawner/Initialize(mapload)
	GLOB.vox_artifact_spawners += src
	return ..()

/obj/voxartifactspawner/Destroy()
	GLOB.vox_artifact_spawners -= src
	return ..()

/obj/voxartifactspawner/proc/spawn_artifact()
	var/item_list = list(
	/obj/item/voxartifact = 3,
	/obj/structure/voxartifactbig = 1,
	)
	var/to_spawn = pickweight(item_list)
	new to_spawn(get_turf(src))
	qdel(src)

/obj/item/bluecrystal
	name = "Bluespace crystal"
	desc = "Unusual looking crystal with eerie deep blue shimmering, holding it in your hand makes you feel like if your hand was sinking in to it."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "ansible_crystal"
	w_class = ITEM_SIZE_TINY
	var/favor_value = 1

/obj/structure/voxanalyzer
	name = "oddity analyzer"
	desc = "An old, dusty machine meant to analyze various bluespace anomalies and send research data directly to SCGEC Observatory."
	icon = 'icons/obj/machines/research/xenoarcheology_scanner.dmi'
	icon_state = "scanner"
	breakable = FALSE
	anchored = FALSE
	density = TRUE
	var/points = 0
	var/crystal_value = 4
	var/working = FALSE
	var/activated = FALSE
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/rewards = list(
		"Stasis Bag - 2" = list(2, /obj/item/bodybag/cryobag),
		"Coagulant Autoinjector - 1" = list(1, /obj/item/reagent_containers/hypospray/autoinjector/coagulant),
		"Iatric monitor - 1" = list(1, /obj/item/organ/internal/augment/active/iatric_monitor),
		"Internal Air System - 1" = list(1, /obj/item/organ/internal/augment/active/internal_air_system),
		"Adaptive Binoculars - 1" = list(1, /obj/item/organ/internal/augment/active/item/adaptive_binoculars),
		"Advanced Armored Vest - 4" = list(4, /obj/item/clothing/suit/armor/pcarrier/merc, /obj/item/clothing/head/helmet/merc),
		"Nerve Dampeners - 6" = list(6, /obj/item/organ/internal/augment/active/nerve_dampeners),
		"Hazard Hardsuit - 12" = list(12, /obj/item/rig/hazard),
		)

/obj/structure/voxanalyzer/attack_hand(mob/living/carbon/human/user)
	if(activated)
		if(!working)
			visible_message(SPAN_NOTICE("<b>\The [src]'s</b> microphone transmits, \"Nice find! We can send you a few of our prototypes in exchange for data about these crystals.\""))
			var/choice = input(user, "Choose a prototype.\n [points] crystals sent.", "Oddity analyzer") as null|anything in rewards
			if (choice)
				if((rewards[choice][1] <= points) && choice)
					points -= rewards[choice][1]
					for(var/I in rewards[choice])
						if(!isnum(I))
							new I(get_turf(src))
				else
					to_chat(user, SPAN_WARNING("\The [src.name] doesn't respond, maybe you should be less greedy next time?"))
		else
			to_chat(user, SPAN_WARNING("\The [src.name] is used by someone!"))
	else
		to_chat(user, SPAN_WARNING("\The [src.name] seems to be powered down."))
	..()

/obj/structure/voxanalyzer/use_tool(obj/item/I, mob/user)
	if(istype(I, /obj/item/bluecrystal))
		if(!activated)
			to_chat(user, SPAN_INFO("As soon as you bring [I] closer to [src] it powers up with shower of sparks!."))
			var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
			s.set_up(3, 1, src)
			s.start()
			activated = TRUE
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts analyzing [I.name]."),
			SPAN_NOTICE("You begin to analyze [I.name]."),
		)
		working = TRUE
		on_update_icon()
		if (do_after(user, 1 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER))
			points += crystal_value
			qdel(I)
			to_chat(user, SPAN_NOTICE("You finish analyzing \the [I.name]."))
		working = FALSE
		on_update_icon()
		return TRUE
	return ..()

/obj/structure/voxanalyzer/on_update_icon()
	if(working)
		icon_state = "scanner_active"
	else
		icon_state = "scanner"
