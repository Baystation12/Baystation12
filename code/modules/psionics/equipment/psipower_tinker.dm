/obj/item/psychic_power/tinker
	name = "psychokinetic crowbar"
	icon_state = "tinker"
	force = 1
	var/emulating = "Crowbar"

/obj/item/psychic_power/tinker/IsCrowbar()
	return emulating == "Crowbar"

/obj/item/psychic_power/tinker/IsWrench()
	return emulating == "Wrench"

/obj/item/psychic_power/tinker/IsScrewdriver()
	return emulating == "Screwdriver"

/obj/item/psychic_power/tinker/IsWirecutter()
	return emulating == "Wirecutters"

/obj/item/psychic_power/tinker/attack_self()

	if(!owner || loc != owner)
		return

	var/choice = input("Select a tool to emulate.","Power") as null|anything in list("Crowbar","Wrench","Screwdriver","Wirecutters","Dismiss")
	if(!choice)
		return

	if(!owner || loc != owner)
		return

	if(choice == "Dismiss")
		sound_to(owner, 'sound/effects/psi/power_fail.ogg')
		owner.drop_from_inventory(src)
		return

	emulating = choice
	name = "psychokinetic [lowertext(emulating)]"
	to_chat(owner, "<span class='notice'>You begin emulating \a [lowertext(emulating)].</span>")
	sound_to(owner, 'sound/effects/psi/power_fabrication.ogg')
