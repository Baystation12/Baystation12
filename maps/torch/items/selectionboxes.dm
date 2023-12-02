/obj/item/helmetcase
	name = "pilot's helmet case"
	desc = "A solid case containing the Shuttle Pilot's flight helmet."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	var/list/helmet_options = list(
		"Standard Pilot's Helmet" = /obj/item/clothing/head/helmet/solgov/pilot,
		"Corporate Pilot's Helmet" = /obj/item/clothing/head/helmet/nt/pilot,
		"Fleet Pilot's Helmet" = /obj/item/clothing/head/helmet/solgov/pilot/fleet
	)

/obj/item/helmetcase/attack_self(mob/user)
	var/choice = input(user, "What is your choice?") as null|anything in helmet_options
	if (choice && user.use_sanity_check(src))
		var/new_helmet_path = helmet_options[choice]
		var/obj/item/new_helmet = new new_helmet_path(user.loc)
		user.drop_from_inventory(src)
		user.put_in_any_hand_if_possible(new_helmet)
		to_chat(user, SPAN_NOTICE("You take \the [new_helmet] out of \the [src]."))
		qdel(src)