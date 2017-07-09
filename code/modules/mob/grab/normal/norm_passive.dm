/datum/grab/normal/passive
	state_name = NORM_PASSIVE
	fancy_desc = "holding"

	upgrab_name = NORM_AGGRESSIVE

	shift = 8

	stop_move = 0
	reverse_facing = 0
	can_absorb = 0
	shield_assailant = 0
	point_blank_mult = 1
	same_tile = 0

	icon_state = "reinforce"

	break_chance_table = list(15, 60, 100)

/datum/grab/normal/passive/upgrade_effect(var/obj/item/grab/normal/G)

/datum/grab/normal/passive/on_hit_disarm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to pin.</span>")

/datum/grab/normal/passive/on_hit_grab(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to jointlock.</span>")

/datum/grab/normal/passive/on_hit_harm(var/obj/item/grab/normal/G)
	to_chat(G.assailant, "<span class='warning'>Your grip isn't strong enough to dislocate.</span>")

/datum/grab/normal/on_hit_special(var/obj/item/grab/G)
	return 0