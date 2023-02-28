/obj/item/gunbox
	name = "sidearm kit"
	desc = "A secure box containing a sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"

/obj/item/gunbox/attack_self(mob/user)
	var/list/options = list()
	options["Classic - Secure Smartgun"] = list(/obj/item/gun/energy/gun/secure/preauthorized)
	options["Stylish - Secure Smart Revolver"] = list(/obj/item/gun/energy/revolver/secure/preauthorized)
	var/choice = input(user, "What is your choice?") as null|anything in options
	if (choice)
		var/list/chosen_weapons = options[choice]
		for (var/new_weapon in chosen_weapons)
			user.put_in_any_hand_if_possible(new new_weapon(user))
	qdel(src)
