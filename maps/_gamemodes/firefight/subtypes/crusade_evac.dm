
/obj/effect/evac_ship/spirit
	name = "Evac Spirit Spawn"
	icon_state = "x2"
	ship_type = /obj/structure/evac_ship/spirit

/obj/structure/evac_ship/spirit
	name = "Spirit Dropship"
	pilot_name = "Spirit Dropship Pilot"
	icon = 'code/modules/halo/vehicles/types/spirit.dmi'
	icon_state = "base"
	desc = "The venerable Type-25 dropship is capable of efficient transport of material and troops."

/obj/structure/evac_ship/spirit/arrival_message(var/time_left)
	world_say_pilot_message("Get on board, I'm taking you to the front lines! I'm leaving in [time_left / 10] seconds.")
