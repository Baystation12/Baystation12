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


/datum/grab/normal/struggle/process_effect(obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if (assailant.incapacitated(INCAPACITATION_ALL))
		affecting.visible_message(SPAN_WARNING("[assailant] lets go of \his grab!"))
		qdel(G)
		return

	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		affecting.visible_message(SPAN_WARNING("[affecting] isn't prepared to fight back as [assailant] tightens \his grip!"))
		G.done_struggle = TRUE
		G.upgrade(TRUE)

/datum/grab/normal/struggle/enter_as_up(obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if(affecting == assailant)
		G.done_struggle = TRUE
		G.upgrade(TRUE)
		return

	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		affecting.visible_message(SPAN_WARNING("[affecting] isn't prepared to fight back as [assailant] tightens \his grip!"))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		affecting.visible_message(SPAN_WARNING("[affecting] struggles against [assailant]!"))
		G.done_struggle = FALSE
		addtimer(new Callback(G, PROC_REF(handle_resist)), 1 SECOND)
		resolve_struggle(G)

/datum/grab/normal/struggle/proc/resolve_struggle(obj/item/grab/G)
	set waitfor = FALSE
	if(do_after(G.assailant, upgrade_cooldown, G, DO_DEFAULT | DO_USER_CAN_MOVE))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		G.downgrade()

/datum/grab/normal/struggle/can_upgrade(obj/item/grab/G)
	return G.done_struggle

/datum/grab/normal/struggle/on_hit_disarm(obj/item/grab/normal/G)
	to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to pin."))
	return FALSE

/datum/grab/normal/struggle/on_hit_grab(obj/item/grab/normal/G)
	to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to jointlock."))
	return FALSE

/datum/grab/normal/struggle/on_hit_harm(obj/item/grab/normal/G)
	to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to dislocate."))
	return FALSE

/datum/grab/normal/struggle/resolve_openhand_attack(obj/item/grab/G)
	return FALSE
