#include "errant_pisces_areas.dm"

/obj/overmap/visitable/ship/errant_pisces
	name = "XCV Ahab's Harpoon"
	desc = "Sensors detect civilian vessel with unusual signs of life aboard."
	color = "#bd6100"
	max_speed = 1/(3 SECONDS)
	burn_delay = 15 SECONDS
	fore_dir = SOUTH

/datum/map_template/ruin/away_site/errant_pisces
	name = "Errant Pisces"
	id = "awaysite_errant_pisces"
	description = "Xynergy carp trawler"
	suffixes = list("errant_pisces/errant_pisces.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/errant_pisces)

/obj/item/clothing/under/carp
	name = "space carp suit"
	desc = "A suit in a shape of a space carp. Usually worn by corporate interns who are sent to entertain children during HQ excursions."
	icon_state = "carp_suit"
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/away/errant_pisces/errant_pisces_sprites.dmi')

/obj/landmark/corpse/carp_fisher
	name = "carp fisher"
	corpse_outfits = list(/singleton/hierarchy/outfit/corpse/carp_fisher)
	species = list(SPECIES_HUMAN = 70, SPECIES_IPC = 20, SPECIES_UNATHI = 10)

/singleton/hierarchy/outfit/corpse/carp_fisher
	name = "Dead carp fisher"
	uniform = /obj/item/clothing/under/color/green
	suit = /obj/item/clothing/suit/apron/overalls
	belt = /obj/item/material/knife/combat
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hardhat/blue

/obj/computer_file_creator/ahabs_harpoon01
	name = "ahab's harpoon file spawner - sensor dump"

/obj/computer_file_creator/ahabs_harpoon01/Initialize()
	var/i_month = max(text2num(time2text(world.timeofday, "MM")) - 1, 1) // Prevent month from going below 1
	var/i_day = max(text2num(time2text(world.timeofday, "DD")) - 5, 1)
	file_name = "NETMON_SENSORDUMP-BLACKBOX"
	file_info = " \
		<h2>XCV Ahab's Harpoon Sensor Log - <i>[GLOB.using_map.game_year]-[i_month]-[i_day]</i></h2> \
		<hr> \
		\<08:33:07\> Space carp migration detected within 1 Gm.<br>\
		\<08:51:29\> Main net extended.<br>\
		\<09:00:00\> Hourly report. Security level: GREEN. Crew status: NOMINAL. SMES charge: NOMINAL.<br>\
		\<09:02:53\> Outflow cells opened.<br>\
		\<09:04:12\> Exterior airlock cycling: Port Solar Control.<br>\
		\<09:04:25\> <b>VITAL SIGNS ALERT:</b> C. BANCROFT, Retrieval Specialist, Port Solar Control<br>\
		\<09:04:33\> <b>BRAIN ACTIVITY FLATLINE:</b> C. BANCROFT, Retrieval Specialist, Port Solar Control<br>\
		\<09:04:39\> Unidentified lifesigns aboard.<br>\
		\<09:04:45\> Multiple unidentified lifesigns aboard.<br>\
		\<09:05:21\> <b>SECURITY LEVEL ALERT:</b> Elevated to RED.<br>\
		\<09:33:07\> <b>SECURITY LEVEL ALERT:</b> Logging flight and sensor data to ship black box.<br>\
		\<09:41:13\> <b>MULTIPLE VITAL SIGNS ALERTS</b><br>\
		\<09:47:03\> All vital signs alerts cleared.<br>\
		\<10:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<11:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<12:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<13:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: NOMINAL.<br>\
		\<14:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: LOW.<br>\
		\<15:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: LOW.<br>\
		\<16:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: CRITICAL.<br>\
		\<17:00:00\> Hourly report. Security level: RED. Crew status: CRITICAL. SMES charge: CRITICAL.<br>\
		\<17:03:41\> Low power. Entering hibernation. Data dumped to local drive and stored in ship black box.<br>\
		\<17:03:41\> Black box data pushed to access terminal.<br>\
		\<17:03:42\> Shutting down.<br>\
	"
	. = ..()

/obj/computer_file_creator/ahabs_harpoon02
	name = "ahab's harpoon file spawner - black box"
	file_name = "NETMON_BLACKBOX"
	file_info = "<p><i>This is the flight recorder data for the XCV Ahab's Harpoon. Its callsign and flight registration indicate that this is a medium size, long-haul commerical space carp fishing vessel, owned by Xynergy. The data recording here only includes hourly status reports, but they indicate that the ship went from nominal function at 09:00 to red alert and critical crew status by 10:00, before continuing at these levels for most of the day until SMES power failed.</i></p>\
	\
	<p><i>This data contains a wealth of information about the ship's records, manifest, and specifications, but nothing immediately useful about the events that happened on board. You may be able to glean further information if you could find more complete records.</i></p>"

/obj/computer_file_creator/ahabs_harpoon03
	name = "ahab's harpoon file spawner - captain's log"
	file_name = "captainslog"

/obj/computer_file_creator/ahabs_harpoon03/Initialize()
	var/captain_name = "[capitalize(pick(GLOB.first_names_male + GLOB.first_names_female))] [capitalize(pick(GLOB.last_names))]"
	file_info = "<p><i>This is the captain's log of the XCV Ahab's Harpoon, authored by Xynergy general manager [captain_name]. According to the log's contents, the ship embarked on its final voyage six months ago. All entries except the last one seem mundane - routine checks, inventory reports, flight path, and so on. The final entry seems to have been written in a hurry, with several typos that didn't get caught by the autocorrect:</i></p>\
	\
	<p>Had a major incident, have lost control f the ship. Hit a big shoal off Nine and scooped up a bunch but itr got the net tangled. Charlie went out to untangle it and a bunch got in. Big motherfuckers, got everywhere. Lkarger than pike. Got trhough doors. Gettim vital alerts for half the crew. Turning on distress but the emergency mode eats up a lot of powedr and it won't last forever. Solars might keep the lights on but it'll be brownouts/blackouts eventually. Going to make for engi where the blackbox comp is. Wish me luck. Please report to xyn/gov if you find this.</p>"
	. = ..()
