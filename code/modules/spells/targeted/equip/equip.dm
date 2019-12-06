//You can set duration to 0 to have the items last forever

/spell/targeted/equip_item
	name = "equipment spell"
	cast_sound = 'sound/magic/summonitems_generic.ogg'

	var/list/equipped_summons = list() //assoc list of text ids and paths to spawn

	var/list/summoned_items = list() //list of items we summoned and will dispose when the spell runs out

	var/delete_old = 1 //if the item previously in the slot is deleted - otherwise, it's dropped

/spell/targeted/equip_item/cast(list/targets, mob/user = usr)
	..()
	for(var/mob/living/L in targets)
		for(var/slot_id in equipped_summons)
			var/to_create = equipped_summons[slot_id]
			if(cmptext(slot_id,"active hand"))
				slot_id = (user.hand ? slot_l_hand : slot_r_hand)
			else if(cmptext(slot_id, "off hand"))
				slot_id = (user.hand ? slot_r_hand : slot_l_hand)
			else
				slot_id = text2num(slot_id) //because the index is text, we access this instead
			var/obj/item/new_item = summon_item(to_create)
			var/obj/item/old_item = L.get_equipped_item(slot_id)
			if(old_item)
				L.drop_from_inventory(old_item)
				if(delete_old)
					qdel(old_item)
			L.equip_to_slot(new_item, slot_id)
			new_item.pickup(L)

			if(duration)
				summoned_items += new_item //we store it in a list to remove later

	if(duration)
		spawn(duration)
			for(var/obj/item/to_remove in summoned_items)
				qdel(to_remove)

/spell/targeted/equip_item/proc/summon_item(var/newtype)
	return new newtype
