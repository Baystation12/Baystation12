/datum/uplink_category
	var/name = ""
	var/list/datum/uplink_item/items

/datum/uplink_category/New()
	..()
	items = list()

/datum/uplink_category/proc/can_view(obj/item/device/uplink/U)
	for(var/datum/uplink_item/item in items)
		if(item.can_view(U))
			return 1
	return 0

/datum/uplink_category/ammunition
	name = "Ammunition"

/datum/uplink_category/grenades
	name = "Grenades"

/datum/uplink_category/visible_weapons
	name = "Loud & Dangerous Weaponry"

/datum/uplink_category/stealthy_weapons
	name = "Disguised & Inconspicuous Weaponry"

/datum/uplink_category/stealth_items
	name = "Stealth & Camouflage Accessories"

/datum/uplink_category/tools
	name = "Devices & Tools"

/datum/uplink_category/implants
	name = "Implants"

/datum/uplink_category/medical
	name = "Medical & Food"

/datum/uplink_category/hardsuit_modules
	name = "Hardsuit Modules"

/datum/uplink_category/services
	name = "Jamming & Announcements"

/datum/uplink_category/badassery
	name = "Badassery"

/datum/uplink_category/telecrystals
	name = "Telecrystal Materialization"
