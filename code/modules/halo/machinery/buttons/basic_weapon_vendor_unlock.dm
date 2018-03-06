
/obj/machinery/button/toggle/weapon_vendor_unlock
	name = "Basic Weapon Vendor Unlocker"
	desc = "A button that removes all access restrictions from basic weapon vendors in the area."

	req_access = list(308)

/obj/machinery/button/toggle/weapon_vendor_unlock/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>Access restrictions are [active ? "inactive":"active"]</span>")

/obj/machinery/button/toggle/weapon_vendor_unlock/proc/get_contained_area()
	if(isarea(loc))
		return loc
	if(isarea(loc.loc))
		return loc.loc

/obj/machinery/button/toggle/weapon_vendor_unlock/proc/modify_vendors_inarea(var/lock = 0)
	var/area/contained_area = get_contained_area()
	for(var/obj/machinery/vending/armory/hybrid/vendor in contained_area.contents)
		if(lock)
			vendor.req_access = req_access.Copy()
		else
			vendor.req_access = list()

/obj/machinery/button/toggle/weapon_vendor_unlock/activate(mob/living/user)
	if(active)
		active = 0
		modify_vendors_inarea(1)
	else
		active = 1
		modify_vendors_inarea()
