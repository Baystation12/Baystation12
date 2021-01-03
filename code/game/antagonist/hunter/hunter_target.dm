GLOBAL_DATUM_INIT(hunter_targets, /datum/antagonist/hunter_target, new)

/datum/antagonist/hunter_target
	id = MODE_HUNTER_TARGET
	role_text = "High Value Target"
	role_text_plural = "High Value Targets"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_HAS_LEADER
	welcome_text = "You are a bodyguard for an important personage aboard the ship. Keep them safe and follow their instructions, because they have a bounty on their head. Remember to pick your role using your official documents after your assignment picks theirs, and good luck!"
	leader_welcome_text = "You are a representative of some very important people, with a lot of power and money resting on your conduct. Unfortunately, you also have a bounty on your head. Remember to pick your role using your official documents, and good luck!"
	antaghud_indicator = "hudhuntertarget"
	antag_indicator = "hudhuntertarget"
	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 3
	landmark_id = "HVTSpawn"
	var/decl/hvt_role/leader_picked_role

/datum/antagonist/hunter_target/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		if(player == leader)
			var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/hunter/vip)
			outfit.equip(player)
			player.put_in_hands(new /obj/item/high_value_target_documents(get_turf(player), player))
			create_id("High Value Target", player)
		else
			var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/hunter/bodyguard)
			outfit.equip(player)
			player.put_in_hands(new /obj/item/high_value_target_documents/bodyguard(get_turf(player), player))
			create_id("Bodyguard", player)
	return 1

/obj/effect/landmark/hunter_target_start
	name = "HVTSpawn"
