/datum/extension/interactive/ntos/device/telescreen

/datum/extension/interactive/ntos/device/telescreen/extension_act(href, href_list, mob/user)
	. = ..()
	var/obj/item/modular_computer/telescreen/telescreen = holder
	if (istype(telescreen))
		if (CanPhysicallyInteractWith(user, telescreen))
			user.set_machine(telescreen)
		else
			user.unset_machine(telescreen)
