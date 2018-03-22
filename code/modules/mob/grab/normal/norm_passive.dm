/datum/grab/normal/passive
	state_name = NORM_PASSIVE
	fancy_desc = "holding"

	upgrab_name = NORM_STRUGGLE

	shift = 8

	stop_move = 0
	reverse_facing = 0
	can_absorb = 0
	shield_assailant = 0
	point_blank_mult = 1
	same_tile = 0

	icon_state = "reinforce"

	break_chance_table = list(15, 60, 100)

/datum/grab/normal/passive/on_hit_disarm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to pin.</span>")
	return 0

/datum/grab/normal/passive/on_hit_grab(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to jointlock.</span>")
	return 0

/datum/grab/normal/passive/on_hit_harm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to dislocate.</span>")
	return 0

/datum/grab/normal/passive/resolve_openhand_attack(var/obj/item/grab/G)
	return 0
