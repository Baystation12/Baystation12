#include "abandoned_hotel_areas.dm"

/obj/overmap/visitable/sector/abandoned_hotel
	name = "Cinnamon Resort"
	desc = "Sensors detect a hotel with a low power profile."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_cinnamon_hotel_1",
		"nav_cinnamon_hotel_2",
		"nav_cinnamon_hotel_3",
	)

/datum/map_template/ruin/away_site/abandoned_hotel
	name = "Cinnamon Resort"
	id = "awaysite_abandoned_hotel"
	description = "An abandoned hotel."
	suffixes = list("abandoned_hotel/abandoned_hotel-1.dmm", "abandoned_hotel/abandoned_hotel-2.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/abandoned_hotel)

// Area shenanigans

	apc_test_exempt_areas = list(
		/area/abandoned_hotel/solar = NO_SCRUBBER|NO_VENT,
		/area/abandoned_hotel/atmos = NO_SCRUBBER|NO_VENT,
		/area/abandoned_hotel/overlook = NO_APC
	)

// Landing Markers

/obj/shuttle_landmark/abandoned_hotel/one
	name = "Cinnamon Resort East"
	landmark_tag = "nav_cinnamon_hotel_1"

/obj/shuttle_landmark/abandoned_hotel/two
	name = "Cinnamon Resort West"
	landmark_tag = "nav_cinnamon_hotel_2"

/obj/shuttle_landmark/abandoned_hotel/three
	name = "Cinnamon Resort South"
	landmark_tag = "nav_cinnamon_hotel_3"

// Lore things

/obj/item/paper/abandoned_hotel/note_1
	name = "paper note"
	info = "My brand new hotel has just opened! Im so happy. I cant wait for the customers to come."


/obj/item/paper/abandoned_hotel/note_2
	name = "paper note"
	info = "I already had to lay off 3 staff members this week! Its going absolutely terrible, I dont think we are going to make it through this month."

/obj/item/paper/abandoned_hotel/note_3
	name = "paper note"
	info = "Its been a few weeks after opening and supplies are kind of running low. Im sure the delivery will arrive shortly."

/obj/item/paper/abandoned_hotel/note_4
	name = "paper note"
	info = "Its only a thing you can eat. Nothing you can not. If you cant eat what do you eat? Why am I here? Is this place hell?"

/obj/item/paper/abandoned_hotel/note_5
	name = "welcome!"
	info = "Welcome to Cinnamon Resort, one of the finest establishments out here in the frontier! Relax at the pool with your friends while you grab a drink from the bar. Hungry? Head over to the buffet where you can grab anything that you desire, for a price of course! Have a nice time here at the Cinnamon Resort!"

/obj/item/paper/abandoned_hotel/note_6
	name = "\improper Review"
	info = "2/10 Annoying staff, nothing interesting nearby. Owner is a real idiot. You dont even have good NTnet connection here. Would not recommend. Though I did like the pool, was very great."

// Blatant self referencing
/obj/decal/graffiti_bam
	name = "graffiti"
	desc = "Something scribbled on the wall. It reads: 'Bam wuz here' "
	icon = 'maps/away/abandoned_hotel/abandoned_hotel_sprites.dmi'
	icon_state = "graffiti"
