/*
 * Torch Service
 */

/obj/structure/closet/chefcloset_torch
	name = "chef's closet"
	desc = "It's a storage unit for foodservice equipment."
	icon_state = "black"
	icon_closed = "black"

	will_contain = list(
		/obj/item/device/radio/headset/headset_service,
		/obj/item/weapon/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/head/chefhat,
		/obj/item/clothing/suit/chef/classic
	)

/obj/structure/closet/secure_closet/hydroponics_torch //done so that it has no access reqs
	name = "hydroponics locker"
	req_access = list()
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	will_contain = list(
		/obj/item/weapon/storage/plants,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/hatchet,
		/obj/item/weapon/wirecutters/clippers,
		/obj/item/weapon/reagent_containers/spray/plantbgone
	)

/obj/structure/closet/secure_closet/hydroponics_torch/New()
	..()
	switch(rand(1,2))
		if(1)
			new /obj/item/clothing/suit/apron(src)
		if(2)
			new /obj/item/clothing/suit/apron/overalls(src)

/obj/structure/closet/jcloset_torch
	name = "custodial closet"
	desc = "It's a storage unit for janitorial equipment."
	icon_state = "mixed"
	icon_closed = "mixed"

	will_contain = list(
		/obj/item/device/radio/headset/headset_service,
		/obj/item/weapon/cartridge/janitor,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight,
		/obj/item/weapon/caution = 4,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/storage/bag/trash,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/weapon/soap/nanotrasen
	)
