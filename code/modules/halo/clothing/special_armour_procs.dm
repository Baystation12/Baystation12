
/obj/item/clothing/suit/armor/special/proc/toggle_eva_mode()
	set name = "Toggle Shield EVA Mode"
	set category = "EVA"

	var/mob/living/toggler = usr
	if(!istype(toggler))
		return

	for (var/datum/armourspecials/shields/s in specials)
		s.toggle_eva_mode(toggler)
