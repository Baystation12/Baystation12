/obj/item/gunbox
	name = "sidearm kit"
	desc = "A secure box containing a sidearm."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "excavation"
	var/list/gun_options = list(
		"Classic - Secure Smartgun" = /obj/item/gun/energy/gun/secure/preauthorized,
		"Stylish - Secure Smart Revolver" = /obj/item/gun/energy/revolver/secure/preauthorized
	)

/obj/item/gunbox/attack_self(mob/user)
	var/choice = input(user, "What is your choice?") as null|anything in gun_options
	if (choice && user.use_sanity_check(src))
		var/new_weapon_path = gun_options[choice]
		var/obj/item/new_weapon = new new_weapon_path(user.loc)
		user.drop_from_inventory(src)
		user.put_in_any_hand_if_possible(new_weapon)
		to_chat(user, SPAN_NOTICE("You take \the [new_weapon] out of \the [src]."))
		qdel(src)
