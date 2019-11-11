/datum/extension/deity_be_near
	base_type = /datum/extension/deity_be_near
	expected_type = /obj/item
	var/keep_away_instead = FALSE
	var/mob/living/deity/connected_deity
	var/threshold_base = 6
	var/expected_helmet
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/deity_be_near/New(var/datum/holder, var/mob/living/deity/connect)
	..()
	GLOB.moved_event.register(holder,src, .proc/check_movement)
	connected_deity = connect
	GLOB.destroyed_event.register(holder, src, .proc/dead_deity)
	var/obj/O = holder
	O.desc += "<br><span class='cult'>This item deals damage to its wielder the [keep_away_instead ? "closer" : "farther"] it is from a deity structure</span>"


/datum/extension/deity_be_near/Destroy()
	GLOB.moved_event.unregister(holder,src)
	GLOB.destroyed_event.unregister(holder, src)
	GLOB.item_equipped_event.unregister(holder, src)
	. = ..()

/datum/extension/deity_be_near/proc/check_movement()
	var/obj/item/I = holder
	if(!istype(I.loc, /mob/living))
		return
	var/min_dist = INFINITY
	for(var/s in connected_deity.structures)
		var/dist = get_dist(holder,s)
		if(dist < min_dist)
			min_dist = dist
	if(min_dist > threshold_base)
		deal_damage(I.loc, round(min_dist/threshold_base))
	else if(keep_away_instead && min_dist < threshold_base)
		deal_damage(I.loc, round(threshold_base/min_dist))


/datum/extension/deity_be_near/proc/deal_damage(var/mob/living/victim, var/mult)
	return

/datum/extension/deity_be_near/proc/dead_deity()
	var/obj/item/I = holder
	I.visible_message("<span class='warning'>\The [holder]'s power fades!</span>")
	qdel(src)

/datum/extension/deity_be_near/proc/wearing_full()
	var/obj/item/I = holder

	if(!ishuman(I.loc))
		return FALSE
	var/mob/living/carbon/human/H = I.loc
	if(H.get_inventory_slot(I) != slot_wear_suit)
		return FALSE
	if(expected_helmet && !istype(H.get_equipped_item(slot_head), expected_helmet))
		return FALSE
	return TRUE

/datum/extension/deity_be_near/champion/deal_damage(var/mob/living/victim,var/mult)
	victim.adjustOxyLoss(3 * mult)

/datum/extension/deity_be_near/oracle/deal_damage(var/mob/living/victim, var/mult)
	victim.adjustFireLoss(mult)

/datum/extension/deity_be_near/traitor/deal_damage(var/mob/living/victim, var/mult)
	victim.adjustHalLoss(5 * mult)