#include "casino_areas.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/ship/casino
	name = "passenger liner"
	desc = "Sensors detect an undamaged vessel without any signs of activity."
	color = "#bd6100"
	vessel_mass = 100
	default_delay = 30 SECONDS
	speed_mod = 5 SECONDS
	burn_delay = 20 SECONDS
	triggers_events = 0
	generic_waypoints = list(
		"nav_casino_1",
		"nav_casino_2",
		"nav_casino_3",
		"nav_casino_4",
		"nav_casino_antag",
		"nav_casino_hangar",

	restricted_waypoints = list(
		"Casino Cutter" = list("nav_casino_hangar"),
	)
	)

/obj/effect/overmap/ship/casino/New(nloc, max_x, max_y)
	name = "IPV [pick("Fortuna","Gold Rush","Ebisu","Lucky Paw","Four Leaves")], \a [name]"
	..()

/datum/map_template/ruin/away_site/casino
	name = "Casino"
	id = "awaysite_casino"
	description = "A casino ship!"
	suffixes = list("casino/casino.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/casino_cutter)

/obj/effect/shuttle_landmark/nav_casino/nav1
	name = "Casino Ship Navpoint #1"
	landmark_tag = "nav_casino_1"

/obj/effect/shuttle_landmark/nav_casino/nav2
	name = "Casino Ship Navpoint #2"
	landmark_tag = "nav_casino_2"

/obj/effect/shuttle_landmark/nav_casino/nav3
	name = "Casino Ship Navpoint #3"
	landmark_tag = "nav_casino_3"

/obj/effect/shuttle_landmark/nav_casino/nav4
	name = "Casino Ship Navpoint #4"
	landmark_tag = "nav_casino_4"

/obj/effect/shuttle_landmark/nav_casino/nav5
	name = "Casino Ship Navpoint #5"
	landmark_tag = "nav_casino_antag"

/datum/shuttle/autodock/overmap/casino_cutter
	name = "Casino Cutter"
	warmup_time = 15
	move_time = 60
	shuttle_area = /area/casino/casino_cutter
	current_location = "nav_casino_hangar"
	landmark_transition = "nav_casino_transit"
	fuel_consumption = 0.5//it's small
	range = 1
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nav_casino/cutter_hangar
	name = "Casino Hangar"
	landmark_tag = "nav_casino_hangar"
	base_area = /area/casino/casino_hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_casino/cutter_transit
	name = "In transit"
	landmark_tag = "nav_casino_transit"

/obj/machinery/computer/shuttle_control/explore/casino_cutter
	name = "cutter control console"
	shuttle_tag = "Casino Cutter"

/obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "roulette_r"
	density = 0
	anchored = 1
	var/busy=0

/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"<span class='notice'>You cannot spin now! \The [src] is already spinning.</span> ")
		return
	visible_message("<span class='notice'>\ [user]  spins the roulette and throws inside little ball.</span>")
	busy = 1
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	spawn(5 SECONDS)
		visible_message("<span class='notice'>\The [src] stops spinning, the ball landing on [n], [color].</span>")
		busy=0

/obj/structure/casino/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets! "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "roulette_l"
	density = 0
	anchored = 1

/obj/structure/casino/bj_table
	name = "blackjack table"
	desc = "This is a blackjack table. "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "bj_left"
	density = 0
	anchored = 1

/obj/structure/casino/bj_table/bj_right
	icon_state = "bj_right"

/obj/structure/casino/oh_bandit
	name = "one armed bandit"
	desc = "Turned off slot machine. "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "slot_machine"
	density = 0
	anchored = 1

/obj/structure/casino/craps
	name = "craps table"
	desc = "Craps table: roll dice!"
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "craps_top"
	density = 0
	anchored = 1

/obj/structure/casino/craps/craps_down
	icon_state = "craps_down"

//========================used bullet casings=======================
/obj/item/ammo_casing/a556/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


/obj/item/ammo_casing/c45/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/a50/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
