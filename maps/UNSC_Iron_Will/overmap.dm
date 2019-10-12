/obj/effect/overmap/ship/unscironwill
	name = "UNSC Iron WIll"
	desc = "A standard contruction-model corvette."

	icon = 'Heavycorvette.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "UNSC"
	flagship = 1

	map_bounds = list(3,52,148,101)

	parent_area_type = /area/corvette/unscironwill

/obj/machinery/button/toggle/alarm_button/corvette
	area_base = /area/corvette/unscironwill
