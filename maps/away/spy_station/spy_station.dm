#include "spy_station_areas.dm"

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

// Obj

/obj/item/spy_station_disk1
	name = "disk"
	desc = "A dusty disk. Its label says: \"Deliver to SCG Fleet Command!\". Its content is encrypted with quantum cryptography methods."
	icon = 'icons/obj/datadisks.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY


/obj/item/paper/spy_station1
	name = "Signal Detected!"
	info = {"
	<center><b>Station #23 \"Everest\"</b></center>
	<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
	<i>Contact established.... Signal locked....</i>
	<i>Unable to write data to dr@$%......</i>
	<i>Detecting medium-sized object. Return signal indicates presence of metallic composition of unknown alien origin...</i>
	<i>Additional bearing acquired..... 132*.... De%#$%ted....  unk?№:%--о Al:6Х*3hip%%:4000001000.....</i>
	<i>Extreme electromagnetic pulse detected........ Emergency system shu----0010001010......</i>
	"}


/obj/item/paper/spy_station2
	name = "Signal 234"
	info = {"
	<center><img src=sollogo.png> <img src=fleetlogo.png></center>
	<center><h3><u>Signal 234 monitoring report</u></h3></center><hr>
	<b>Data recovered from scan:</b><br>
	Large vessel with expansive cargo bay. Likely a freighter.<br>
	Life Signs: <b>None detected</b>.<br>
	<b>Transponder signal</b> intercepted; however, the original data was corrupted by interference. The corrupted file has been forwarded to the IT specialist for analysis
	No engine heat signature detected, yet the vessel is in motion.
	<hr>Deploy drones for reconnassance mission?
	<i>This is not within our jurisdiction. Transponder data identifies the vessel as belonging to the Free Trade Union</i>
	"}


/obj/item/paper/spy_station3
	name = "Signal 47"
	info = {"
	<center><img src=sollogo.png> <img src=fleetlogo.png></center>
	<center><h3><u>Signal 47 monitoring report</u></h3></center><hr>
	<b>Data recovered from scan:</b><br>
	We have detected a sector with a broad-range signal emission. It is likely a jamming beacon, we're working to get through it.<br>
	<hr><i>Send a report to Command.</i>
	"}