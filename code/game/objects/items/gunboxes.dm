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

/obj/item/ninja_kit
	name = "loadout selection kit"
	desc = "A secure box containing standard operation kit for special forces operatives."
	icon = 'icons/obj/tools/xenoarcheology_tools.dmi'
	icon_state = "excavation"
	var/list/faction_options = list(
		"Solar Special Operations Unit" = /obj/structure/closet/crate/ninja/sol,
		"Gilgameshi Commando" = /obj/structure/closet/crate/ninja/gcc,
		"Syndicate Mercenary" = /obj/structure/closet/crate/ninja/merc,
		"Corporate Operative" = /obj/structure/closet/crate/ninja/corpo,
		"Spider-Clan Ninja" = /obj/structure/closet/crate/ninja
	)

/obj/item/ninja_kit/attack_self(mob/user)
	var/choice = input(user, "What is your choice?") as null|anything in faction_options
	if (choice && user.use_sanity_check(src))
		var/new_item_path = faction_options[choice]
		var/obj/new_item     = new new_item_path(get_turf(src))
		to_chat(user, SPAN_NOTICE("You have chosen \the [new_item]."))
		qdel(src)
