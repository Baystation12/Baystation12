/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	slot = ACCESSORY_SLOT_UTILITY
	var/slots = 3
	var/max_w_class = ITEM_SIZE_SMALL //pocket sized
	var/obj/item/weapon/storage/internal/pockets/hold
	w_class = ITEM_SIZE_NORMAL
	high_visibility = 1
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	create_storage()

/obj/item/clothing/accessory/storage/proc/create_storage()
	hold = new/obj/item/weapon/storage/internal/pockets(src, slots, max_w_class)

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob)
	if(has_suit && hold)	//if we are part of a suit
		hold.open(user)
		return

	if(hold && hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if(has_suit)
		return

	if(hold && hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W as obj, mob/user as mob)
	if(hold)
		return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	if(hold)
		hold.emp_act(severity)
		..()

/obj/item/clothing/accessory/storage/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold)
		hold.remove_from_storage(I, T, 1)
	hold.finish_bulk_removal()
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"

/obj/item/clothing/accessory/storage/webbing_large
	name = "large webbing"
	desc = "A large collection of synthcotton pockets and pouches."
	icon_state = "webbing_large"
	slots = 4

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	slots = 5

/obj/item/clothing/accessory/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	slots = 5

/obj/item/clothing/accessory/storage/white_vest
	name = "white webbing vest"
	desc = "Durable white synthcotton vest with lots of pockets to carry essentials."
	icon_state = "vest_white"
	slots = 5

/obj/item/clothing/accessory/storage/drop_pouches
	slots = 4 //to accomodate it being slotless

/obj/item/clothing/accessory/storage/drop_pouches/create_storage()
	hold = new/obj/item/weapon/storage/internal/pouch(src, slots*BASE_STORAGE_COST(max_w_class))

/obj/item/clothing/accessory/storage/drop_pouches/black
	name = "black drop pouches"
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_black"

/obj/item/clothing/accessory/storage/drop_pouches/brown
	name = "brown drop pouches"
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_brown"

/obj/item/clothing/accessory/storage/drop_pouches/white
	name = "white drop pouches"
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_white"

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife loops."
	icon_state = "unathiharness2"
	slots = 2
	max_w_class = ITEM_SIZE_NORMAL //for knives

/obj/item/clothing/accessory/storage/knifeharness/Initialize()
	. = ..()
	hold.can_hold = list(
		/obj/item/weapon/material/hatchet,
		/obj/item/weapon/material/knife,
	)

	new /obj/item/weapon/material/knife/table/unathi(hold)
	new /obj/item/weapon/material/knife/table/unathi(hold)

/obj/item/clothing/accessory/storage/bandolier
	name = "bandolier"
	desc = "A lightweight synthethic bandolier with straps for holding ammunition or other small objects."
	icon_state = "bandolier"
	slots = 10
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/accessory/storage/bandolier/Initialize()
	. = ..()
	hold.can_hold = list(
		/obj/item/ammo_casing,
		/obj/item/weapon/grenade,
		/obj/item/weapon/material/knife,
		/obj/item/weapon/material/star,
		/obj/item/weapon/rcd_ammo,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/syringe_cartridge,
		/obj/item/weapon/plastique,
		/obj/item/clothing/mask/smokable,
		/obj/item/weapon/screwdriver,
		/obj/item/device/multitool,
		/obj/item/weapon/magnetic_ammo,
		/obj/item/ammo_magazine,
		/obj/item/weapon/net_shell,
		/obj/item/weapon/reagent_containers/glass/beaker/vial,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/marshalling_wand,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/storage/pill_bottle
	)

/obj/item/clothing/accessory/storage/bandolier/safari/Initialize()
	. = ..()

	for(var/i = 0, i < slots, i++)
		new /obj/item/weapon/net_shell(hold)
