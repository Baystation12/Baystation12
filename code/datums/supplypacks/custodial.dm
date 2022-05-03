/decl/hierarchy/supply_pack/custodial
	name = "Custodial"

/decl/hierarchy/supply_pack/custodial/janitor
	name = "Gear - Janitorial supplies"
	contains = list(/obj/item/reagent_containers/glass/bucket,
					/obj/item/mop,
					/obj/item/caution = 4,
					/obj/item/storage/bag/trash,
					/obj/item/device/lightreplacer,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/storage/box/lights/mixed,
					/obj/item/reagent_containers/glass/rag,
					/obj/item/grenade/chem_grenade/cleaner = 3,
					/obj/structure/mopbucket)
	cost = 20
	containertype = /obj/structure/closet/crate/large
	containername = "janitorial supplies crate"

/decl/hierarchy/supply_pack/custodial/mousetrap
	num_contained = 3
	contains = list(/obj/item/storage/box/mousetraps)
	name = "Misc - Pest control"
	cost = 10
	containername = "pest control crate"

/decl/hierarchy/supply_pack/custodial/lightbulbs
	name = "Spares - Replacement lights"
	contains = list(/obj/item/storage/box/lights/mixed = 3)
	cost = 10
	containername = "replacement lights crate"

/decl/hierarchy/supply_pack/custodial/cleaning
	name = "Gear - Cleaning supplies"
	contains = list(/obj/item/mop,
					/obj/item/grenade/chem_grenade/cleaner = 3,
					/obj/item/storage/box/detergent = 3,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/rag,
					/obj/item/reagent_containers/spray/cleaner = 2,
					/obj/item/soap)
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "cleaning supplies crate"

/decl/hierarchy/supply_pack/custodial/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/storage/box/bodybags = 3)
	cost = 10
	containername = "body bag crate"

/decl/hierarchy/supply_pack/custodial/janitorbiosuits
	name = "Gear - Janitor biohazard equipment"
	contains = list(/obj/item/clothing/head/bio_hood/janitor,
					/obj/item/clothing/suit/bio_suit/janitor,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/oxygen)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "janitor biohazard equipment crate"