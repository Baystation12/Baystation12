/datum/grab/normal/struggle
	state_name = NORM_STRUGGLE
	fancy_desc = "holding"

	upgrab_name = NORM_AGGRESSIVE
	downgrab_name = NORM_PASSIVE

	shift = 8

	stop_move = 1
	reverse_facing = 0
	can_absorb = 0
	point_blank_mult = 1
	same_tile = 0
	breakability = 3

	grab_slowdown = 10
	upgrade_cooldown = 20

	can_downgrade_on_resist = 0

	icon_state = "reinforce"

	var/done_struggle = FALSE

	break_chance_table = list(5, 20, 30, 80, 100)


/datum/grab/normal/struggle/process_effect(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting.incapacitated() || affecting.a_intent == I_HELP)
		affecting.visible_message("<span class='warning'>[affecting] isn't prepared to fight back as [assailant] tightens \his grip!</span>")
		done_struggle = TRUE
		G.upgrade(TRUE)

/datum/grab/normal/struggle/enter_as_up(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting.incapacitated() || affecting.a_intent == I_HELP)
		affecting.visible_message("<span class='warning'>[affecting] isn't prepared to fight back as [assailant] tightens \his grip!</span>")
		done_struggle = TRUE
		G.upgrade(TRUE)
	else
		affecting.visible_message("<span class='warning'>[affecting] struggles against [assailant]!</span>")
		spawn(10)
			handle_resist(G)
		if(do_after(assailant, upgrade_cooldown, G, can_move = 1))
			done_struggle = TRUE
			G.upgrade(TRUE)
		else
			G.downgrade()

/datum/grab/normal/struggle/can_upgrade(var/obj/item/grab/G)
	return done_struggle

/datum/grab/normal/struggle/on_hit_disarm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to pin.</span>")
	return 0

/datum/grab/normal/struggle/on_hit_grab(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to jointlock.</span>")
	return 0

/datum/grab/normal/struggle/on_hit_harm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to dislocate.</span>")
	return 0

/datum/grab/normal/struggle/resolve_openhand_attack(var/obj/item/grab/G)
	return 0
