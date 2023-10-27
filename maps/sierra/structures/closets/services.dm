/*
 * Sierra Service
 */


/obj/structure/closet/chefcloset_sierra
	name = "chef's closet"
	desc = "It's a storage unit for foodservice equipment."
	closet_appearance = /singleton/closet_appearance/wardrobe/sierra/chef

/obj/structure/closet/chefcloset_sierra/WillContain()
	return list(
		/obj/item/clothing/head/soft/mime,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/clothing/head/chefhat,
		/obj/item/clothing/suit/chef/classic,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/beret/infinity
	)

/obj/structure/closet/secure_closet/hydroponics_sierra //done so that it has no access reqs
	name = "hydroponics locker"
	req_access = list()
	closet_appearance = /singleton/closet_appearance/secure_closet/sierra/hydroponics

/obj/structure/closet/secure_closet/hydroponics_sierra/WillContain()
	return list(
		/obj/item/clothing/head/soft/green,
		/obj/item/storage/plants,
		/obj/item/device/scanner/plant,
		/obj/item/material/minihoe,
		/obj/item/clothing/gloves/thick/botany,
		/obj/item/material/hatchet,
		/obj/item/wirecutters/clippers,
		/obj/item/reagent_containers/spray/plantbgone,
		new /datum/atom_creator/weighted(list(/obj/item/clothing/suit/apron, /obj/item/clothing/suit/apron/overalls)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/hydroponics, /obj/item/storage/backpack/satchel/hyd)),
		new /datum/atom_creator/simple(/obj/item/storage/backpack/messenger/hyd, 50)
	)

/obj/structure/closet/jcloset/sierra
	name = "custodial closet"
	desc = "It's a storage unit for janitorial equipment."
	closet_appearance = /singleton/closet_appearance/wardrobe/sierra/janitor

/obj/structure/closet/jcloset/sierra/WillContain()
	return list(
		/obj/item/clothing/head/beret/purple,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/under/rank/janitor,
		/obj/item/clothing/head/soft/darkred,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/gloves/thick,
		/obj/item/device/flashlight/upgraded,
		/obj/item/caution = 4,
		/obj/item/device/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/grenade/chem_grenade/cleaner = 2,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/storage/box/detergent,
		/obj/item/holosign_creator,
		/obj/item/clothing/glasses/hud/janitor,
		/obj/item/storage/belt/janitor,
		/obj/item/clothing/mask/plunger,
		/obj/item/soap,
		/obj/item/clothing/head/beret/infinity
	)

/obj/structure/closet/secure_closet/bar_sierra
	name = "bar locker"
	desc = "It's a storage unit for bar equipment."
	req_access = list(access_bar)
	closet_appearance = /singleton/closet_appearance/cabinet/secure
	anchored = TRUE
	//open_sound = 'sound/machines/wooden_closet_open.ogg'
	//close_sound = 'sound/machines/wooden_closet_close.ogg'


/obj/structure/closet/secure_closet/bar_sierra/WillContain()
	return list(
		/obj/item/clothing/head/soft/black,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/reagent_containers/food/drinks/shaker,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/glass_jar,
		/obj/item/book/manual/barman_recipes,
		/obj/item/storage/box/ammo/beanbags,
		/obj/item/clothing/under/rank/bartender,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/gloves/white,
		/obj/item/storage/box/lights/bulbs/bar,
		/obj/item/clothing/shoes/laceup,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/paper/sierra/bar_permit,
		/obj/item/gun/projectile/shotgun/doublebarrel,
		/obj/item/clothing/head/beret/infinity
	)

/obj/structure/closet/secure_closet/chaplain_sierra
	name = "chaplain's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/chaplain
	req_access = list(access_chapel_office)

/obj/structure/closet/secure_closet/chaplain_sierra/WillContain()
	return list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/storage/candle_box = 3,
		/obj/item/deck/tarot,
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/nullrod,
		/obj/item/storage/bible,
		/obj/item/storage/belt/general,
		/obj/item/material/urn,
		/obj/item/device/taperecorder
	)

/obj/structure/closet/secure_closet/chief_steward_sierra
	name = "chief steward's locker"
	req_access = list(access_chief_steward)
	closet_appearance = /singleton/closet_appearance/cabinet/secure

/obj/structure/closet/secure_closet/chief_steward_sierra/WillContain()
	return list(
		/obj/item/storage/belt/general,
		/obj/item/clothing/head/chefhat,
		/obj/item/clothing/suit/chef/classic,
		/obj/item/clothing/suit/chef,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/clothing/glasses/science,
		/obj/item/storage/box/glasses,
		/obj/item/storage/plants,
		/obj/item/device/scanner/plant,
		/obj/item/clothing/accessory/armband/hydro,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/device/megaphone,
		/obj/item/device/flashlight/upgraded,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/device/camera_film = 2,
		/obj/item/device/radio/headset/sierra_chief_steward,
		/obj/item/device/radio/headset/sierra_chief_steward/alt,
	)
