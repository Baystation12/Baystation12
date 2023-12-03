/obj/item/selection
	abstract_type = /obj/item/selection
	icon = 'icons/obj/tools/xenoarcheology_tools.dmi'
	icon_state = "excavation"
	var/list/selection_options


/obj/item/selection/attack_self(mob/living/user)
	var/response = input(user, null, "Select Replacement Item") as null | anything in selection_options
	if (isnull(response) || !(response in selection_options))
		return
	if (!user.use_sanity_check(src))
		to_chat(user, SPAN_WARNING("You're not able to do that right now."))
		return
	user.drop_from_inventory(src)
	var/obj/obj = selection_options[response]
	obj = new obj (user.loc)
	if (isitem(obj))
		user.put_in_any_hand_if_possible(obj)
	to_chat(user, SPAN_ITALIC("You take \the [obj] out of \the [src]."))
	qdel(src)


/obj/item/selection/siderm
	name = "sidearm kit"
	desc = "A secure box containing a sidearm."
	selection_options = list(
		"Classic - Secure Smartgun" = /obj/item/gun/energy/gun/secure/preauthorized,
		"Stylish - Secure Smart Revolver" = /obj/item/gun/energy/revolver/secure/preauthorized
	)
