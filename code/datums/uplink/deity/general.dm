/datum/uplink_item/deity/boon/ability_general
	category = /datum/uplink_category/deity_ability_general

/datum/uplink_item/deity/feat/ability_general
	category = /datum/uplink_category/deity_ability_general

/datum/uplink_item/deity/boon/ability_general/construct
	name = "Conjure Construct"
	desc = "Grant the spells of building, letting your servants construct useful buildings near an altar."
	item_cost = 10
	path = /spell/construction

/datum/uplink_item/deity/boon/ability_general/god_vision
	name = "Godsvision"
	desc = "Grants the ability for a servant to see the world like you do."
	item_cost = 20
	path = /spell/camera_connection/god_vision

/datum/uplink_item/deity/boon/ability_general/aura
	name = "Aura"
	desc = "Grants a channelable aura to a servant that slowly converts the nearby area to one more useful to you."
	item_cost = 10
	path = /spell/aoe_turf/god_aura

/datum/uplink_item/deity/boon/ability_general/shrine
	name = "Build Shrine"
	desc = "An essential ability that allows a follower to build an altar where ever they want."
	item_cost = 10
	path = /spell/aoe_turf/build_shrine

/datum/uplink_item/deity/feat/ability_general/innate_minimum
	name = "Increase Potential"
	desc = "Increase the amount of natural power you regenerate."
	item_cost = 30
	can_buy_multiples = 1

/datum/uplink_item/deity/feat/ability_general/innate_minimum/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.power_min += 5

/datum/uplink_item/deity/feat/ability_general/power_regeneration
	name = DEITY_POWER_BONUS
	desc = "Increase the amount of power you get from newly built structures and cultists."
	item_cost = 50
	can_buy_multiples = 1

/datum/uplink_item/deity/feat/ability_general/power_regeneration/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		if(!user.feats[DEITY_POWER_BONUS])
			user.feats[DEITY_POWER_BONUS] = 0
		user.feats[DEITY_POWER_BONUS] += 0.5