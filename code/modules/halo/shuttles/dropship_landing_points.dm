
/obj/effect/landmark/dropship_land_point
	name = "Dropship Land Point"
	var/faction = "Civilian"//The faction this landing point belongs to. Null for all-factions.
	var/active = 1 //Is this landing point available.
	var/occupied = 0 //Is this landing point currently occupied?

/obj/effect/landmark/dropship_land_point/New()
	..()
	dropship_landing_controller.add_land_point(src)

/obj/effect/landmark/dropship_land_point/inactive
	name = "Inactive Dropship Land Point"
	active = 0

/obj/effect/landmark/dropship_land_point/occupied
	name = "Occupied Dropship Land Point"
	occupied = 1

/obj/effect/landmark/dropship_land_point/unsc
	name = "UNSC Land Point"
	faction = "unsc"

/obj/effect/landmark/dropship_land_point/covenant
	name = "Covenant Land Point"
	faction = "covenant"

/obj/effect/landmark/dropship_land_point/innie
	name = "Innie Land Point"
	faction = "innie"
