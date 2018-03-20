
/obj/machinery/button/toggle/weapon_vendor_unlock/heavy
	name = "Heavy Weapon Vendor Unlocker"
	desc = "A button that removes all access restrictions from heavy weapon vendors in the area."

/obj/machinery/button/toggle/weapon_vendor_unlock/heavy/modify_vendors_inarea(var/lock = 0)
	var/area/contained_area = get_contained_area()
	for(var/obj/machinery/vending/armory/heavy/vendor in contained_area.contents)
		if(lock)
			vendor.req_access = req_access.Copy()
		else
			vendor.req_access = list()