/decl/appearance_handler/cardborg/proc/item_equipped(var/obj/item/item, var/mob/user, var/slot)
	if(!(slot == slot_head || slot == slot_wear_suit))
		return
	if(!ishuman(user))
		return
	if(!(istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg)))
		return
	if(user in appearance_sources)
		return

	var/mob/living/carbon/human/H = user
	if(!(istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg)))
		return

	var/image/I = image(icon = 'icons/mob/robots.dmi' , icon_state = "robot", loc = H)
	I.override = 1
	I.overlays += image(icon = 'icons/mob/robots.dmi' , icon_state = "eyes-robot") //gotta look realistic
	AddAltAppearance(user, I, silicon_mob_list+H) //you look like a robot to robots! (including yourself because you're totally a robot)
	logged_in_event.register_global(src, /decl/appearance_handler/cardborg/proc/mob_joined)	// Duplicate registration request are handled for us

/decl/appearance_handler/cardborg/proc/item_removed(var/obj/item/item, var/mob/user)
	if((istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg)))
		RemoveAltAppearance(user)
		if(!appearance_sources.len)
			logged_in_event.unregister_global(src)	// Only listen to the logged in event for as long as it's relevant

/decl/appearance_handler/cardborg/proc/mob_joined(var/mob/user)
	if(issilicon(user))
		DisplayAllAltAppearancesTo(user)
