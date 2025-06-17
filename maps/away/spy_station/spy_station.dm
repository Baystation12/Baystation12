#ifndef AWAY_SPY_STATION
#define AWAY_SPY_STATION


/area/spy_station
	icon = 'maps/away/spy_station/spy_station_sprites.dmi'


/area/spy_station/cent
	name = "\improper Central Corridor"
	icon_state = "corridor"


/area/spy_station/com
	name = "\improper Bridge"
	icon_state = "command"


/area/spy_station/barrack
	name = "\improper Barrack"
	icon_state = "barracks"


/area/spy_station/toilet
	name = "\improper Toilet"
	icon_state = "toilet"


/area/spy_station/med
	name = "\improper Medical Center"
	icon_state = "med"


/area/spy_station/lc
	name = "\improper SCL Office"
	icon_state = "offise"


/area/spy_station/canteen
	name = "\improper Canteen"
	icon_state = "eat"


/area/spy_station/engin
	name = "\improper Engineering"
	icon_state = "Eng"


/area/spy_station/dock
	name = "\improper Corridor Dock"
	icon_state = "dock"


/area/spy_station/solar
	name = "\improper Solars"
	icon_state = "solar"


/obj/overmap/visitable/sector/spy_station
	name = "Unknown Station"
	desc = "Sensors detect a small station. No further scanning is possible. Interference: camouflage radio network."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_spy_station_1",
		"nav_spy_station_2",
		"nav_spy_station_3",
		"nav_spy_station_antag"
	)


/datum/map_template/ruin/away_site/spy_station
	name = "Spy Station"
	id = "awaysite_spy_station"
	description = "SCGDF station that investigates sensor contacts in deep space."
	suffixes = list("spy_station/spy_station.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/spy_station)


/obj/shuttle_landmark/nav_spy_station/nav1
	name = "West Landing Spot"
	landmark_tag = "nav_spy_station_1"


/obj/shuttle_landmark/nav_spy_station/nav2
	name = "South Landing Spot"
	landmark_tag = "nav_spy_station_2"


/obj/shuttle_landmark/nav_spy_station/nav3
	name = "Northeast Landing Spot"
	landmark_tag = "nav_spy_station_3"


/obj/shuttle_landmark/nav_spy_station/nav4
	name = "Southeast Landing Spot"
	landmark_tag = "nav_spy_station_4"


/obj/item/spy_station_disk1
	name = "disk"
	desc = "A dusty disk. Its label says: \"Deliver to SCG Fleet Command!\". Its content is encrypted with quantum cryptography methods."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/spy_station_disk2
	name = "disk"
	desc = "A dusty disk. Its label says: \"List of classified military radio frequencies.\". Its content is encrypted with quantum cryptography methods."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/paper/spy_station1
	name = "Signal Detected!"
	info = {"
	<center><b>Station #23 \"Everest\"</b></center>
	<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
	<i>Contact.... Signal located....</i>
	<i>Unable to write data to dr@$%......</i>
	<i>Detection of medium-sized signature, return signal indicates presence of alloys of unknown origin...</i>
	<i>Additional bearing received by system..... 132*.... De%#$%ted....  unk?№:%--o Al:6X*3hip%%:4000001000.....</i>
	<i>Abnormal electromagnetic pulse detected........ Emergency system shu----0010001010......</i>
	"}


/obj/item/paper/spy_station2
	name = "Signal 234"
	info = {"
	<center><img src=sollogo.png> <img src=fleetlogo.png></center>
	<center><h3><u>Signal 234 monitoring report</u></h3></center><hr>
	<b>Data recovered from the scanning:</b><br>
	Large-sized vessel with a big compartment most likely intended for cargo shipping.<br>
	Life Signs: <b>None</b>.<br>
	<b>Transponder signal</b> was intercepted; however, its original readings were corrupted by interference. Sent the corrupted file to the IT specialist.
	Engines heat trace is not present, but the vessel is moving.
	<hr>Send drones for a recon mission?
	<i>This is not our concern. Transponder data indicates that it's a Free Trade Union vessel.</i>
	"}


/obj/item/paper/spy_station3
	name = "Signal 47"
	info = {"
	<center><img src=sollogo.png> <img src=fleetlogo.png></center>
	<center><h3><u>Signal 47 monitoring report</u></h3></center><hr>
	<b>Data recovered from scans:</b><br>
	Found a sector with a serious signal disturbance. This appears to be active jamming, we're trying to overcome it.
	<hr><i>Send report to Command.</i>
	"}


#endif
