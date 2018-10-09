
/datum/armourspecials/gear
	var/gear_type
	var/obj/item/spawned_gear
	var/equip_slot

/datum/armourspecials/gear/on_equip(var/obj/source_armour)
	if(!user)
		return

	if(!spawned_gear)
		spawned_gear = new gear_type(source_armour)
		spawned_gear.canremove = 0
	return user.equip_to_slot_if_possible(spawned_gear, equip_slot, 1, 0)

/datum/armourspecials/gear/on_drop(var/obj/source_armour)
	if(!user)
		return

	user.drop_from_inventory(spawned_gear, null)
	spawned_gear.loc = null
