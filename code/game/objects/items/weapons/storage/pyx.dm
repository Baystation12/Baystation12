/obj/item/storage/fancy/pyx
	name = "pyx"
	desc = "A small golden container used to carry consecrated hosts for administering communion."
	icon = 'icons/obj/pyx.dmi'
	icon_state ="pyx"
	item_state = "syringe_case"
	throw_speed = 1
	throw_range = 5
	open_sound = 'sound/effects/storage/pillbottle.ogg'
	max_storage_space = null
	sealed = TRUE
	storage_slots = 3
	key_type = list(/obj/item/reagent_containers/food/snacks/eucharist)

/obj/item/storage/fancy/pyx/on_update_icon()
	ClearOverlays()
	icon_state = "[initial(icon_state)][opened ? "0" : ""]"
	if (!opened)
		return
	for (var/i = 1 to length(contents))
		if (istype(contents[i], /obj/item/reagent_containers/food/snacks/eucharist))
			AddOverlays(image(icon, "pyx1"))
			break
