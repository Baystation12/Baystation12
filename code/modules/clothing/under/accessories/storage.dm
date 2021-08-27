/obj/item/clothing/accessory/storage
	name = "base storage accessory"
	icon_state = "webbing"
	slot = ACCESSORY_SLOT_UTILITY
	w_class = ITEM_SIZE_NORMAL
	high_visibility = 1
	on_rolled = list("down" = "none")

	var/obj/item/storage/internal/container
	var/max_w_class = ITEM_SIZE_SMALL
	var/slots

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/accessory/storage)
	if (!slots)
		. = INITIALIZE_HINT_QDEL
		crash_with("[type] created with no slots")
	if (slots < 0)
		container = new /obj/item/storage/internal/pouch (src, (-slots) * BASE_STORAGE_COST(max_w_class))
	else
		container = new /obj/item/storage/internal/pockets (src, slots, max_w_class)

/obj/item/clothing/accessory/storage/attack_hand(mob/user)
	if (container)
		if (has_suit)
			container.open(user)
		else if (container.handle_attack_hand(user))
			..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object)
	if (!has_suit && container?.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/I, mob/user)
	if (container)
		return container.attackby(I, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	if (container)
		container.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user)
	add_fingerprint(user)
	if (!container)
		return
	container.hide_from(user)
	var/count = 0
	var/turf/T = get_turf(src)
	for (var/obj/item/I in container)
		container.remove_from_storage(I, T, TRUE)
		++count
	if (!count)
		to_chat(user, "\The [src] is empty.")
		return
	container.finish_bulk_removal()
	visible_message("\The [user] empties \the [src].", range = 5)


/obj/item/clothing/accessory/storage/pockets
	name = "pockets"
	desc = "A bag-like receptacle fastened to an article of clothing to hold small items."
	icon_state = ""
	slots = 2 STORAGE_FREEFORM
	high_visibility = FALSE
	removable = FALSE
	hidden = TRUE


/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "A sturdy mess of straps and buckles you can clip things to."
	icon_state = "webbing"
	slots = 3 STORAGE_SLOTS
	body_location = UPPER_TORSO

/obj/item/clothing/accessory/storage/webbing_large
	name = "large webbing"
	desc = "A sturdy mess of straps and buckles with small pockets and pouches."
	icon_state = "webbing_large"
	slots = 4 STORAGE_FREEFORM
	body_location = UPPER_TORSO

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "A robust black vest with lots of small pockets and pouches."
	icon_state = "vest_black"
	slots = 5 STORAGE_FREEFORM
	body_location = UPPER_TORSO

/obj/item/clothing/accessory/storage/brown_vest
	name = "brown webbing vest"
	desc = "A sturdy brown vest with lots of small pockets and pouches."
	icon_state = "vest_brown"
	slots = 5 STORAGE_FREEFORM
	body_location = UPPER_TORSO

/obj/item/clothing/accessory/storage/white_vest
	name = "white webbing vest"
	desc = "A stoic white vest with lots of small pockets and pouches."
	icon_state = "vest_white"
	slots = 5 STORAGE_FREEFORM
	body_location = UPPER_TORSO

/obj/item/clothing/accessory/storage/black_drop
	name = "black drop bag"
	desc = "A robust black leg bag with plenty of room inside."
	icon_state = "thigh_black"
	slots = 5 STORAGE_FREEFORM
	body_location = LEGS

/obj/item/clothing/accessory/storage/brown_drop
	name = "brown drop bag"
	desc = "A sturdy brown leg bag with plenty of room inside."
	icon_state = "thigh_brown"
	slots = 5 STORAGE_FREEFORM
	body_location = LEGS

/obj/item/clothing/accessory/storage/white_drop
	name = "white drop bag"
	desc = "A stoic white leg bag with plenty of room inside."
	icon_state = "thigh_white"
	slots = 5 STORAGE_FREEFORM
	body_location = LEGS

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife loops."
	icon_state = "unathiharness2"
	slots = 2 STORAGE_SLOTS
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/accessory/storage/knifeharness/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	if (container)
		container.can_hold = list(
			/obj/item/material/hatchet,
			/obj/item/material/knife
		)
		for (var/i = 1 to abs(slots))
			new /obj/item/material/knife/table/unathi (container)

/obj/item/clothing/accessory/storage/bandolier
	name = "bandolier"
	desc = "A lightweight bandolier with straps for holding ammunition or other small objects."
	icon_state = "bandolier"
	slots = 10 STORAGE_SLOTS
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/accessory/storage/bandolier/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	if (container)
		container.can_hold = list(
			/obj/item/ammo_casing,
			/obj/item/grenade,
			/obj/item/material/knife,
			/obj/item/material/star,
			/obj/item/rcd_ammo,
			/obj/item/reagent_containers/syringe,
			/obj/item/reagent_containers/hypospray,
			/obj/item/reagent_containers/hypospray/autoinjector,
			/obj/item/syringe_cartridge,
			/obj/item/plastique,
			/obj/item/clothing/mask/smokable,
			/obj/item/screwdriver,
			/obj/item/device/multitool,
			/obj/item/magnetic_ammo,
			/obj/item/ammo_magazine,
			/obj/item/net_shell,
			/obj/item/reagent_containers/glass/beaker/vial,
			/obj/item/paper,
			/obj/item/pen,
			/obj/item/photo,
			/obj/item/marshalling_wand,
			/obj/item/reagent_containers/pill,
			/obj/item/storage/pill_bottle
		)

/obj/item/clothing/accessory/storage/bandolier/safari/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	if (container)
		for(var/i = 1 to abs(slots))
			new /obj/item/net_shell (container)
