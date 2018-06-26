/decl/hierarchy/supply_pack/operations
	name = "Operations"

/decl/hierarchy/supply_pack/operations/ranks_ec
	name = "Ranks - Expeditionary Corps pins"
	contains = list(/obj/item/weapon/storage/box/ranks,
					/obj/item/weapon/storage/box/ranks/officer)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Expeditionary Corps rank pins crate"
	access = access_senadv

/decl/hierarchy/supply_pack/operations/ranks_fleet
	name = "Ranks - Fleet tabs"
	contains = list(/obj/item/weapon/storage/box/ranks/fleet,
					/obj/item/weapon/storage/box/large/ranks/fleet)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Fleet rank tabs crate"
	access = access_senadv
