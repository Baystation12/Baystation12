/singleton/hierarchy/supply_pack/operations
	name = "Operations"

/singleton/hierarchy/supply_pack/operations/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/storage/pill_bottle/zoom,
					/obj/item/storage/pill_bottle/happy,
					/obj/item/storage/pill_bottle/three_eye,
					/obj/item/reagent_containers/food/drinks/bottle/pwine)

	name = "UNLISTED - Contraband crate"
	cost = 30
	containername = "unlabeled crate"
	contraband = 1
	supply_method = /singleton/supply_method/randomized

/singleton/hierarchy/supply_pack/operations/plasma_cutter
	name = "Equipment - Plasma Cutter"
	contains = list(/obj/item/gun/energy/plasmacutter)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "plasma cutter crate"
	access = list(list(access_mining,access_engine))

/singleton/hierarchy/supply_pack/operations/orebox
	name = "Equipment - Ore box"
	contains = list(/obj/structure/ore_box)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "Ore box crate"

/singleton/hierarchy/supply_pack/operations/webbing
	name = "Gear - Webbing, vests"
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/clothing/accessory/storage/brown_vest,
					/obj/item/clothing/accessory/storage/white_vest,
					/obj/item/clothing/accessory/storage/black_drop,
					/obj/item/clothing/accessory/storage/brown_drop,
					/obj/item/clothing/accessory/storage/white_drop,
					/obj/item/clothing/accessory/storage/webbing)
	cost = 15
	containername = "webbing crate"

/singleton/hierarchy/supply_pack/operations/voidsuit_engineering
	name = "EVA - Engineering voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engine

/singleton/hierarchy/supply_pack/operations/voidsuit_medical
	name = "EVA - Medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt,
					/obj/item/clothing/head/helmet/space/void/medical/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_medical_equip

/singleton/hierarchy/supply_pack/operations/voidsuit_security
	name = "EVA - Security (armored) voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig

/singleton/hierarchy/supply_pack/operations/bureaucracy
	contains = list(
		/obj/item/material/clipboard,
		/obj/item/material/clipboard,
		/obj/item/pen/retractable/red,
		/obj/item/pen/retractable/blue,
		/obj/item/pen/green,
		/obj/item/device/camera_film,
		/obj/item/folder/blue,
		/obj/item/folder/red,
		/obj/item/folder/yellow,
		/obj/item/hand_labeler,
		/obj/item/tape_roll,
		/obj/structure/filingcabinet/chestdrawer{anchored = FALSE},
		/obj/item/paper_bin,
		/obj/item/storage/pill_bottle/tacks
	)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "office supplies crate"

/singleton/hierarchy/supply_pack/operations/minergear
	name = "Shaft miner equipment"
	contains = list(/obj/item/storage/backpack/industrial,
					/obj/item/storage/backpack/satchel/eng,
					/obj/item/device/radio/headset/headset_cargo,
					/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/black,
					/obj/item/device/scanner/gas,
					/obj/item/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/shovel,
					/obj/item/pickaxe,
					/obj/item/device/scanner/mining,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "shaft miner equipment crate"
	access = access_mining
