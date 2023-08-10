/obj/turbolift_map_holder/farfleet
	name = "Farfleet turbolift map placeholder"
	icon = 'icons/obj/structures/turbolift_preview_2x2.dmi'
	depth = 2
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/farfleet_first,
		/area/turbolift/farfleet_second
	)

/area/turbolift/farfleet_second
	name = "lift (upper deck)"
	lift_floor_label = "Deck 1"
	lift_floor_name = "Hangar Deck"
	lift_announce_str = "Arriving at Hangar Deck: Секция гаупвахты. Секция экипажа. Ангар шаттла. Оружейная десанта. Хранилище аномальных материалов."
	base_turf = /turf/simulated/floor

/area/turbolift/farfleet_first
	name = "lift (lower deck)"
	lift_floor_label = "Deck 2"
	lift_floor_name = "Operating Deck"
	lift_announce_str = "Arriving at Operating Deck: Мостик. Инженерный отсек. Атмосферный отсек. "
	base_turf = /turf/simulated/floor
