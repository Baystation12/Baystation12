/obj/effect/overmap/sector/dante
	name = "Dante"

/obj/effect/overmap/sector/achlys
	name = "Achlys"

/obj/effect/overmap/sector/achlys/New()
	. = ..()
	loot_distributor.loot_list["evidence"] = list(/obj/item/weapon/research/sekrits,/obj/item/weapon/research,/obj/item/weapon/research,/obj/item/weapon/research)
	loot_distributor.loot_list["autolathes"] = list(/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked,/obj/machinery/autolathe/ammo_fabricator/hacked)

/obj/effect/landmark/dropship_land_point/achlys_north
	name = "Achlys North Hanger"

/obj/effect/landmark/dropship_land_point/achlys_south
	name = "Achlys South Hanger"

/obj/effect/landmark/dropship_land_point/dante_north
	name = "UNSC Dante Hanger Alpha"
	faction = "UNSC"

/obj/effect/landmark/dropship_land_point/dante_south
	name = "UNSC Dante Hanger Bravo"
	faction = "UNSC"