/obj/effect/overmap/ship/bearcat
	name = "CSV Bearcat"
	color = "#00FFFF"
	landing_areas = list(/area/ship/scrap/shuttle/ingoing, /area/ship/scrap/shuttle/pod)
	start_x = 4
	start_y = 4
	base = 1

/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"
	shuttle_area = /area/ship/scrap/shuttle/outgoing

/obj/structure/closet/crate/uranium
	name = "fissibles crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/uranium/New()
	..()
	new /obj/item/stack/material/uranium{amount=50}(src)
	new /obj/item/stack/material/uranium{amount=50}(src)