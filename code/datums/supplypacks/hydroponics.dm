/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"
	containertype = /obj/structure/closet/crate/hydroponics

/decl/hierarchy/supply_pack/hydroponics/hydroponics // -- Skie
	name = "Gear - Hydroponics Supplies"
	contains = list(/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,
					/obj/item/weapon/material/hatchet,
					/obj/item/weapon/material/minihoe,
					/obj/item/device/scanner/plant,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/clothing/suit/apron,
					/obj/item/weapon/material/minihoe,
					/obj/item/weapon/storage/box/botanydisk
					)
	cost = 15
	containername = "hydroponics supply crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Samples - Mundane Seeds"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/appleseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/harebell,
					/obj/item/seeds/lemonseed,
					/obj/item/seeds/orangeseed,
					/obj/item/seeds/grassseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	cost = 10
	containername = "seeds crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/weedcontrol
	name = "Gear - Weed control"
	contains = list(/obj/item/weapon/material/hatchet = 2,
					/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
					/obj/item/clothing/mask/gas = 2,
					/obj/item/weapon/grenade/chem_grenade/antiweed = 2)
	cost = 25
	containername = "weed control crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Samples - Exotic seeds"
	contains = list(/obj/item/seeds/replicapod = 2,
					/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random = 6,
					/obj/item/seeds/kudzuseed)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "exotic Seeds crate"
	access = access_xenobiology

/decl/hierarchy/supply_pack/hydroponics/watertank
	name = "Liquid - Water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"

/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Equipment - Beekeeping"
	contains = list(/obj/item/beehive_assembly,
					/obj/item/bee_smoker,
					/obj/item/honey_frame = 5,
					/obj/item/bee_pack)
	cost = 40
	containername = "beekeeping crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/hydrotray
	name = "Equipment - Hydroponics tray"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0})
	cost = 30
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "hydroponics tray crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/pottedplant
	name = "Deco - Potted plants"
	num_contained = 1
	contains = list(/obj/structure/flora/pottedplant,
					/obj/structure/flora/pottedplant/large,
					/obj/structure/flora/pottedplant/fern,
					/obj/structure/flora/pottedplant/overgrown,
					/obj/structure/flora/pottedplant/bamboo,
					/obj/structure/flora/pottedplant/largebush,
					/obj/structure/flora/pottedplant/thinbush,
					/obj/structure/flora/pottedplant/mysterious,
					/obj/structure/flora/pottedplant/smalltree,
					/obj/structure/flora/pottedplant/unusual,
					/obj/structure/flora/pottedplant/orientaltree,
					/obj/structure/flora/pottedplant/smallcactus,
					/obj/structure/flora/pottedplant/tall,
					/obj/structure/flora/pottedplant/sticky,
					/obj/structure/flora/pottedplant/smelly,
					/obj/structure/flora/pottedplant/small,
					/obj/structure/flora/pottedplant/aquatic,
					/obj/structure/flora/pottedplant/shoot,
					/obj/structure/flora/pottedplant/flower,
					/obj/structure/flora/pottedplant/crystal,
					/obj/structure/flora/pottedplant/subterranean,
					/obj/structure/flora/pottedplant/minitree,
					/obj/structure/flora/pottedplant/stoutbush,
					/obj/structure/flora/pottedplant/drooping,
					/obj/structure/flora/pottedplant/tropical,
					/obj/structure/flora/pottedplant/dead,
					/obj/structure/flora/pottedplant/decorative)
	cost = 8
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "potted plant crate"
	supply_method = /decl/supply_method/randomized