/decl/hierarchy/supply_pack/operations
	name = "Operations"

/decl/hierarchy/supply_pack/operations/contraband
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
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/operations/plasma_cutter
	name = "Equipment - Plasma Cutter"
	contains = list(/obj/item/gun/energy/plasmacutter)
	cost = 120
	containertype = /obj/structure/closet/crate/secure
	containername = "plasma cutter crate"
	access = list(list(access_mining,access_engine))

/decl/hierarchy/supply_pack/operations/orebox
	name = "Equipment - Ore box"
	contains = list(/obj/structure/ore_box)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "Ore box crate"

/decl/hierarchy/supply_pack/operations/webbing
	name = "Gear - Webbing, vests, holsters."
	num_contained = 4
	contains = list(/obj/item/clothing/accessory/storage/holster,
					/obj/item/clothing/accessory/storage/black_vest,
					/obj/item/clothing/accessory/storage/brown_vest,
					/obj/item/clothing/accessory/storage/white_vest,
					/obj/item/clothing/accessory/storage/black_drop,
					/obj/item/clothing/accessory/storage/brown_drop,
					/obj/item/clothing/accessory/storage/white_drop,
					/obj/item/clothing/accessory/storage/webbing)
	cost = 15
	containername = "webbing crate"

/decl/hierarchy/supply_pack/operations/voidsuit_engineering
	name = "EVA - Engineering voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/engineering/alt,
					/obj/item/clothing/head/helmet/space/void/engineering/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "engineering voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engine

/decl/hierarchy/supply_pack/operations/voidsuit_medical
	name = "EVA - Medical voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/medical/alt,
					/obj/item/clothing/head/helmet/space/void/medical/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "medical voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_medical_equip

/decl/hierarchy/supply_pack/operations/voidsuit_security
	name = "EVA - Security (armored) voidsuit"
	contains = list(/obj/item/clothing/suit/space/void/security/alt,
					/obj/item/clothing/head/helmet/space/void/security/alt,
					/obj/item/clothing/shoes/magboots)
	cost = 120
	containername = "security voidsuit crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_brig

/decl/hierarchy/supply_pack/operations/bureaucracy
	contains = list(/obj/item/material/clipboard,
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
					 /obj/item/paper_bin)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "office supplies crate"

//START-PRX@CODE
/decl/hierarchy/supply_pack/operations/armengi
	contains = list(/obj/item/storage/box/armband/engine)
	name = "Emergency - Engineer armband"
	cost = 10
	containername = "engineer armband crate"

/decl/hierarchy/supply_pack/operations/armsec
	contains = list(/obj/item/storage/box/armband/peace)
	name = "Emergency - Peacekeeper armband"
	cost = 10
	containername = "peacekeeper armband crate"

/decl/hierarchy/supply_pack/operations/armmed
	contains = list(/obj/item/storage/box/armband/med)
	name = "Emergency - Medical armband"
	cost = 10
	containername = "medical armband crate"
//FIN-PRX@CODE
