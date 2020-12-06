/decl/hierarchy/supply_pack/operations
	name = "Operations"

/decl/hierarchy/supply_pack/operations/cargotrain
	name = "Equipment - Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "cargo train tug crate"

/decl/hierarchy/supply_pack/operations/cargotrailer
	name = "Equipment - Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "cargo train trolley crate"

/decl/hierarchy/supply_pack/operations/contraband
	num_contained = 5
	contains = list(/obj/item/seeds/bloodtomatoseed,
					/obj/item/weapon/storage/pill_bottle/zoom,
					/obj/item/weapon/storage/pill_bottle/happy,
					/obj/item/weapon/storage/pill_bottle/three_eye,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine)

	name = "UNLISTED - Contraband crate"
	cost = 30
	containername = "unlabeled crate"
	contraband = 1
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/operations/plasma_cutter
	name = "Equipment - Plasma Cutter"
	contains = list(/obj/item/weapon/gun/energy/plasmacutter)
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
					/obj/item/clothing/accessory/storage/drop_pouches/black,
					/obj/item/clothing/accessory/storage/drop_pouches/brown,
					/obj/item/clothing/accessory/storage/drop_pouches/white,
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
	contains = list(/obj/item/weapon/material/clipboard,
					 /obj/item/weapon/material/clipboard,
					 /obj/item/weapon/pen/retractable/red,
					 /obj/item/weapon/pen/retractable/blue,
					 /obj/item/weapon/pen/green,
					 /obj/item/device/camera_film,
					 /obj/item/weapon/folder/blue,
					 /obj/item/weapon/folder/red,
					 /obj/item/weapon/folder/yellow,
					 /obj/item/weapon/hand_labeler,
					 /obj/item/weapon/tape_roll,
					 /obj/structure/filingcabinet/chestdrawer{anchored = 0},
					 /obj/item/weapon/paper_bin)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "office supplies crate"

