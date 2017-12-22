/obj/item/weapon/pickaxe/brush
	name = "brush"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_brush"
	item_state = "syringe_0"
	slot_flags = SLOT_EARS
	digspeed = 20
	desc = "Thick metallic wires for clearing away dust and loose scree (1 centimetre excavation depth)."
	excavation_amount = 1
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/one_pick
	name = "2cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick1"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (2 centimetre excavation depth)."
	excavation_amount = 2
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/two_pick
	name = "4cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick2"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (4 centimetre excavation depth)."
	excavation_amount = 4
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/three_pick
	name = "6cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick3"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (6 centimetre excavation depth)."
	excavation_amount = 6
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/four_pick
	name = "8cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick4"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (8 centimetre excavation depth)."
	excavation_amount = 8
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/five_pick
	name = "10cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick5"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (10 centimetre excavation depth)."
	excavation_amount = 10
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/six_pick
	name = "12cm pick"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick6"
	item_state = "syringe_0"
	digspeed = 20
	desc = "A miniature excavation tool for precise digging (12 centimetre excavation depth)."
	excavation_amount = 12
	drill_sound = 'sound/items/Screwdriver.ogg'
	drill_verb = "delicately picking"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/pickaxe/hand
	name = "hand pickaxe"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "pick_hand"
	item_state = "syringe_0"
	digspeed = 30
	desc = "A smaller, more precise version of the pickaxe (30 centimetre excavation depth)."
	excavation_amount = 30
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"
	w_class = ITEM_SIZE_SMALL

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/weapon/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	desc = "A set of picks for excavation."
	item_state = "syringe_kit"
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/weapon/pickaxe/brush,
	/obj/item/weapon/pickaxe/one_pick,
	/obj/item/weapon/pickaxe/two_pick,
	/obj/item/weapon/pickaxe/three_pick,
	/obj/item/weapon/pickaxe/four_pick,
	/obj/item/weapon/pickaxe/five_pick,
	/obj/item/weapon/pickaxe/six_pick,
	/obj/item/weapon/pickaxe/hand)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_SMALL
	use_to_pickup = 1

/obj/item/weapon/storage/excavation/Initialize()
	. = ..()
	new /obj/item/weapon/pickaxe/brush(src)
	new /obj/item/weapon/pickaxe/one_pick(src)
	new /obj/item/weapon/pickaxe/two_pick(src)
	new /obj/item/weapon/pickaxe/three_pick(src)
	new /obj/item/weapon/pickaxe/four_pick(src)
	new /obj/item/weapon/pickaxe/five_pick(src)
	new /obj/item/weapon/pickaxe/six_pick(src)

/obj/item/weapon/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/weapon/storage/excavation/proc/sort_picks()
	var/list/obj/item/weapon/pickaxe/picksToSort = list()
	for(var/obj/item/weapon/pickaxe/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/weapon/pickaxe/current = picksToSort[i]
			if(current.excavation_amount <= min)
				selected = i
				min = current.excavation_amount
		var/obj/item/weapon/pickaxe/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	prepare_ui()
