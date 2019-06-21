// Defining all of this here so it's centralized.
// Used by the exosuit HUD to get a 1-10 value representing charge, ammo, etc.
/obj/item/mech_equipment
	name = "exosuit hardpoint system"
	icon = 'icons/mecha/mech_equipment.dmi'
	icon_state = ""
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_PLASTIC = 5000, MATERIAL_OSMIUM = 500)
	force = 10

	var/restricted_hardpoints
	var/mob/living/exosuit/owner
	var/list/restricted_software
	var/equipment_delay = 0
	var/active_power_use = 1 KILOWATTS // How much does it consume to perform and accomplish usage
	var/passive_power_use = 0          // For gear that for some reason takes up power even if it's supposedly doing nothing (mech will idly consume power)
	var/layer_offset = 0               // Special cases where you need your object to render further in front of things or behind them

/obj/item/mech_equipment/attack() //Generally it's not desired to be able to attack with items
	return 0

/obj/item/mech_equipment/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	
	if (owner && loc == owner && ((user in owner.pilots) || user == owner) && owner.get_cell().check_charge(active_power_use * CELLRATE)) //Mantain CELLRATE as multiplier to keep old mech balance
		if(target in owner.contents)
			return
		return 1
	else 
		to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to use \the [src]"))
		return 0

/obj/item/mech_equipment/attack_self(var/mob/user)
	if (owner && loc == owner && ((user in owner.pilots) || user == owner) && owner.get_cell().check_charge(active_power_use * CELLRATE)) //Mantain CELLRATE as multiplier to keep old mech balance
		return 1
	else 
		to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to manipulate \the [src]"))
		return 0

/obj/item/mech_equipment/proc/installed(var/mob/living/exosuit/_owner)
	owner = _owner
	//generally attached. Nothing should be able to grab it
	canremove = FALSE

/obj/item/mech_equipment/proc/uninstalled()
	canremove = TRUE
	owner = null

/obj/item/mech_equipment/proc/get_effective_obj()
	return src

/obj/item/mech_equipment/mounted_system
	var/holding_type
	var/obj/item/holding

/obj/item/mech_equipment/mounted_system/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		return holding.attack_self(user)

/obj/item/mech_equipment/mounted_system/New()
	..()
	if(holding_type)
		holding = new holding_type(src)
	if(holding)
		if(!icon_state)
			icon = holding.icon
			icon_state = holding.icon_state
		name = holding.name
		desc = "[holding.desc] This one is suitable for installation on an exosuit."

/obj/item/mech_equipment/mounted_system/get_effective_obj()
	return (holding ? holding : src)

/obj/item/mech_equipment/mounted_system/get_hardpoint_status_value()
	return (holding ? holding.get_hardpoint_status_value() : null)

/obj/item/mech_equipment/mounted_system/get_hardpoint_maptext()
	return (holding ? holding.get_hardpoint_maptext() : null)

/obj/item/proc/get_hardpoint_status_value()
	return null

/obj/item/proc/get_hardpoint_maptext()
	return null

/obj/item/mech_equipment/mounted_system/get_cell()
	if(owner && loc == owner)
		return owner.get_cell()
	return null
