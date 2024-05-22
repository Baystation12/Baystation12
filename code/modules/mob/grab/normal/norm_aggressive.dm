/datum/grab/normal/aggressive
	state_name = NORM_AGGRESSIVE

	upgrab_name = NORM_NECK
	downgrab_name = NORM_PASSIVE

	shift = 12


	stop_move = 1
	reverse_facing = 0
	can_absorb = 0
	shield_assailant = 0
	point_blank_mult = 1.5
	damage_stage = 1
	same_tile = 0
	can_throw = 1
	force_danger = 1
	breakability = 4

	icon_state = "reinforce1"

	break_chance_table = list(25, 30, 35, 40, 45, 50, 55)

/datum/grab/normal/aggressive/process_effect(obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	var/datum/pronouns/pronouns = assailant.choose_from_pronouns()

	if (assailant.incapacitated(INCAPACITATION_ALL))
		affecting.visible_message(SPAN_WARNING("\The [assailant] lets go of [pronouns.his] grab!"))
		qdel(G)
		return

	if(G.target_zone in list(BP_L_HAND, BP_R_HAND))
		affecting.drop_l_hand()
		affecting.drop_r_hand()

	// Keeps those who are on the ground down
	if(affecting.lying)
		affecting.Weaken(4)

/datum/grab/normal/aggressive/can_upgrade(obj/item/grab/G)
	if(!(G.target_zone in list(BP_CHEST, BP_HEAD)))
		to_chat(G.assailant, SPAN_WARNING("You need to be grabbing their torso or head for this!"))
		return FALSE
	var/obj/item/clothing/C = G.affecting.head
	if(istype(C)) //hardsuit helmets etc
		if((C.max_pressure_protection) && C.armor["melee"] > 20)
			to_chat(G.assailant, SPAN_WARNING("\The [C] is in the way!"))
			return FALSE
	return TRUE
