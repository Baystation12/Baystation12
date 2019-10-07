/obj/item/weapon/pickaxe/xeno
	name = "master xenoarch pickaxe"
	desc = "A miniature excavation tool for precise digging."
	icon = 'icons/obj/xenoarchaeology.dmi'
	item_state = "screwdriver_brown"
	force = 3
	throwforce = 0
	attack_verb = list("stabbed", "jabbed", "spiked", "attacked")
	matter = list(MATERIAL_STEEL = 75)
	w_class = ITEM_SIZE_SMALL
	drill_verb = "delicately picking"
	digspeed = 20
	excavation_amount = 0
	sharp = 1

/obj/item/weapon/pickaxe/xeno/examine(mob/user)
	. = ..()
	to_chat(user, "This tool has a [excavation_amount] centimetre excavation depth.")

/obj/item/weapon/pickaxe/xeno/brush
	name = "wire brush"
	icon_state = "pick_brush"
	slot_flags = SLOT_EARS
	force = 1
	attack_verb = list("prodded", "attacked")
	desc = "A wood-handled brush with thick metallic wires for clearing away dust and loose scree."
	excavation_amount = 1
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"
	sharp = 0

/obj/item/weapon/pickaxe/xeno/one_pick
	name = "2cm pick"
	icon_state = "pick1"
	excavation_amount = 2
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/pickaxe/xeno/two_pick
	name = "4cm pick"
	icon_state = "pick2"
	excavation_amount = 4
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/pickaxe/xeno/three_pick
	name = "6cm pick"
	icon_state = "pick3"
	excavation_amount = 6
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/pickaxe/xeno/four_pick
	name = "8cm pick"
	icon_state = "pick4"
	excavation_amount = 8
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/pickaxe/xeno/five_pick
	name = "10cm pick"
	icon_state = "pick5"
	excavation_amount = 10
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/pickaxe/xeno/six_pick
	name = "12cm pick"
	icon_state = "pick6"
	excavation_amount = 12

/obj/item/weapon/pickaxe/xeno/hand
	name = "hand pickaxe"
	icon_state = "pick_hand"
	item_state = "sword0"
	digspeed = 30
	desc = "A smaller, more precise version of the pickaxe."
	excavation_amount = 30
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"
	matter = list(MATERIAL_STEEL = 150)
	w_class = ITEM_SIZE_NORMAL
	force = 6
	throwforce = 3

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/weapon/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	item_state = "utility"
	desc = "A rugged case containing a set of standardized picks used in archaeological digs."
	item_state = "syringe_kit"
	storage_slots = 7
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/pickaxe/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1
	startswith = list(
		/obj/item/weapon/pickaxe/xeno/brush,
		/obj/item/weapon/pickaxe/xeno/one_pick,
		/obj/item/weapon/pickaxe/xeno/two_pick,
		/obj/item/weapon/pickaxe/xeno/three_pick,
		/obj/item/weapon/pickaxe/xeno/four_pick,
		/obj/item/weapon/pickaxe/xeno/five_pick,
		/obj/item/weapon/pickaxe/xeno/six_pick)

/obj/item/weapon/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/weapon/storage/excavation/proc/sort_picks()
	var/list/obj/item/weapon/pickaxe/xeno/picksToSort = list()
	for(var/obj/item/weapon/pickaxe/xeno/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/weapon/pickaxe/xeno/current = picksToSort[i]
			if(current.excavation_amount <= min)
				selected = i
				min = current.excavation_amount
		var/obj/item/weapon/pickaxe/xeno/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	prepare_ui()
