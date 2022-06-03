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
	breakability = 4

	grab_slowdown = 10
	upgrade_cooldown = 20

	can_downgrade_on_resist = 0

	icon_state = "reinforce"

	break_chance_table = list(35, 40, 45, 50, 55, 60, 65)


/datum/grab/normal/struggle/process_effect(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		affecting.visible_message("<span class='warning'>[affecting] isn't prepared to fight back as [assailant] tightens \his grip!</span>")
		G.done_struggle = TRUE
		G.upgrade(TRUE)

/datum/grab/normal/struggle/enter_as_up(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting == assailant)
		G.done_struggle = TRUE
		G.upgrade(TRUE)
		return

	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		affecting.visible_message("<span class='warning'>[affecting] isn't prepared to fight back as [assailant] tightens \his grip!</span>")
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		affecting.visible_message("<span class='warning'>[affecting] struggles against [assailant]!</span>")
		G.done_struggle = FALSE
		addtimer(CALLBACK(G, .proc/handle_resist), 1 SECOND)
		resolve_struggle(G)

/datum/grab/normal/struggle/proc/resolve_struggle(var/obj/item/grab/G)
	set waitfor = FALSE
	if(do_after(G.assailant, upgrade_cooldown, G, DO_DEFAULT | DO_USER_CAN_MOVE))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		G.downgrade()

/datum/grab/normal/struggle/can_upgrade(var/obj/item/grab/G)
	return G.done_struggle

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
