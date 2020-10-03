#include "verne_areas.dm"
#include "verne_jobs.dm"
#include "verne_shuttles.dm"
#include "verne_radio.dm"

/obj/effect/submap_landmark/joinable_submap/verne
	name = "SRV Verne"
	archetype = /decl/submap_archetype/derelict/verne

/decl/submap_archetype/derelict/verne
	descriptor = "active research vessel"
	map = "SRV Verne"
	crew_jobs = list(
		/datum/job/submap/CTI_pilot,
		/datum/job/submap/CTI_engineer,
		/datum/job/submap/CTI_Undergraduate_Xenoscience_Researcher,
	)

/obj/effect/overmap/visitable/ship/verne
	name = "SRV Verne"
	desc = "Sensor array detects a large vessel, identifying itself as 'SRV Verne'"
	vessel_mass = 10000
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	fore_dir = NORTH
	initial_restricted_waypoints = list(
			"SRV Venerable Catfish" = list("nav_hangar_verne", "nav_verne_4")
	)
	initial_generic_waypoints = list(
		"nav_verne_1",
		"nav_verne_2",
		"nav_verne_3",
	)

/datum/map_template/ruin/away_site/verne
	name = "Active University Ship"
	id = "awaysite_verne"
	description = "Active CTI research ship"
	suffixes = list("verne/verne-1.dmm", "verne/verne-2.dmm", "verne/verne-3.dmm")
	cost = 2
	spawn_weight = 0.33
	area_usage_test_exempted_root_areas = list(/area/verne)
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/verne,
		/datum/shuttle/autodock/ferry/verne,
	)
	apc_test_exempt_areas = list(
		/area/verne/engineering/external = NO_SCRUBBER|NO_VENT,
		/area/verne/engineering/powergen = NO_SCRUBBER|NO_VENT,
		/area/verne/engineering/thrusters = NO_SCRUBBER|NO_VENT,
		/area/verne/catfish/engineering = NO_SCRUBBER|NO_VENT,
		/area/verne/lift = NO_SCRUBBER|NO_VENT|NO_APC,
	)
	area_coherency_test_subarea_count = list(
		/area/verne/engineering/external = 20,
	)

/var/const/access_verne = "ACCESS_VERNE"
/datum/access/verne
	id = access_verne
	desc = "Verne Access"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/verne
	access = list(access_verne)

/obj/machinery/alarm/verne
	req_access = list(access_verne)

/obj/machinery/power/apc/verne
	req_access = list(access_verne)
	cell_type = /obj/item/weapon/cell/hyper

/obj/machinery/power/supermatter/randomsample
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

/obj/machinery/power/supermatter/randomsample
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

/obj/machinery/power/supermatter/randomsample/Initialize()
	. = ..()
	nitrogen_retardation_factor = rand(0.01, 1)	//Higher == N2 slows reaction more
	thermal_release_modifier = rand(100, 1000000)		//Higher == more heat released during reaction
	phoron_release_modifier = rand(0, 100000)		//Higher == less phoron released by reaction
	oxygen_release_modifier = rand(0, 100000)		//Higher == less oxygen released at high temperature/power
	radiation_release_modifier = rand(0, 100)    //Higher == more radiation released with more power.
	reaction_power_modifier =  rand(0, 100)			//Higher == more overall power

	power_factor = rand(0, 20)
	decay_factor = rand(50, 70000)			//Affects how fast the supermatter power decays
	critical_temperature = rand(3000, 5000)	//K
	charging_factor = rand(0, 1)
	damage_rate_limit = rand( 1, 10)		//damage rate cap at power = 300, scales linearly with power

/obj/machinery/power/supermatter/inert
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"
	thermal_release_modifier = 0 //Basically inert
	phoron_release_modifier = 100000000000
	oxygen_release_modifier = 100000000000
	radiation_release_modifier = 1

/obj/structure/closet/crate/secure/large/phoron/experimentalsm
	name = "experimental supermatter crate"
	desc = "Are you sure you want to open this?"

/obj/structure/closet/crate/secure/large/phoron/experimentalsm/WillContain()
	return list(/obj/machinery/power/supermatter/randomsample)

/obj/effect/floor_decal/cti
	name = "\improper CTI logo"
	desc = "Logo of the famed Ceti Technical Institute. Just looking at it makes you feel ashamed of your alma mater."
	icon = 'verne.dmi'
	icon_state = "CTILogo"

/datum/reagent/toxin/phoron/safe
	name = "tericadone"
	description = "Phoron substitute currently in laboratory testing"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ffc4ff"

/obj/item/weapon/reagent_containers/glass/bottle/tericadone
	name = "tericadone bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/tericadone/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/phoron/safe , 60)
	update_icon()

/datum/reagent/toxin/phoron/safe/touch_mob(var/mob/living/L, var/amount)
	return

/datum/reagent/toxin/phoron/safe/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/toxin/phoron/safe/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/toxin/phoron/safe/touch_turf(var/turf/simulated/T)
	return

/datum/chemical_reaction/oxycodone/nophoron
	catalysts = list(/datum/reagent/toxin/phoron/safe = 5)

/datum/chemical_reaction/peridaxon/nophoron
	catalysts = list(/datum/reagent/toxin/phoron/safe = 5)

/datum/chemical_reaction/leporazine/nophoron
	catalysts = list(/datum/reagent/toxin/phoron/safe = 5)

/datum/chemical_reaction/dexalin/nophoron
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/phoron/safe = 0.1)

/datum/chemical_reaction/clonexadone/nophoron
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1, /datum/reagent/toxin/phoron/safe = 0.1)

/obj/machinery/suit_storage_unit/engineering/verne
	req_access = list(access_verne)

/obj/machinery/suit_storage_unit/ceti/verne
	req_access = list(access_verne)

/obj/machinery/turretid/verne
	name = "turret control panel"
	enabled = 1
	lethal = 1
	icon_state = "control_kill"
	locked = 1
	check_arrest = 0
	check_records = 0
	check_weapons = 0
	check_access = 1
	check_anomalies = 1
	req_access = list(access_verne)

/obj/machinery/power/smes/buildable/preset/verne
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/smes_coil/super_io = 2,
		/obj/item/weapon/stock_parts/smes_coil/super_capacity = 2,
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/smes/buildable/preset/verne/shuttle
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/smes_coil/super_io = 1,
		/obj/item/weapon/stock_parts/smes_coil/super_capacity = 1,
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/item/weapon/paper/verne
	name = "power usage"
	info = "Verne Pilots and Engineers, remember to turn off the thrusters when you're done with maneuvers.\
	<BR>Power usage settles at 137 kW with them off, just under the ICRER-2 150 kW standard operating range.\
	<BR>When you're performing maneuvers, put the ICRER-2 up to 180 kW, turn the gas cooler on, and remember to feed it Coolant!\
	<BR>After you're done with maneuvers or if an hour has passed, drop it down to 150 kW and turn the gas cooler off. \
	<BR>Otherwise it'll explode. \
	<BR>If it explodes, you'll totally destroy the aft Engineering Stack, stranding us. \
	<BR><b>Your follow up to this matter is required and appreciated.</b>"

/obj/item/weapon/paper/verne/manifest
	name = "crew manifest"
	info = "<center>\<b>SRV Verne</b><br>\
			Crew roster</center><br>\
			<b>Command</b><br>\
			\[list]\
			\[*]Co-Consul Professor, A Shift: Dr. Andre Richardson\
			\[*]Co-Consul Professor, B Shift: Dr. David Schoonhoven\
			\[*]Senior Phsyician: Dr. Remaldo-12\
			\[*]Head Engineer: Jonah French\
			\[*]Security Officer: Chantel Osborne\
			\[/list]<br>\
			<b>Medical Department.</b><br>\
			\[list]\
			\[*]Physician: Dr. Milli Newman\
			\[*]Nurse: Fatimah Hayes\
			\[/list]<br>\
			<b>Service Department.</b><br>\
			\[list]\
			\[*]Cook, A Shift: Cavan Kaur\
			\[*]Cook, A Shift: Jibril-59\
			\[*]Cook, B Shift: Lilly-Ann Mora\
			\[*]Cook, B Shift: Malaikah Owen\
			\[/list]<br>\
			\[*]Non-Essential Systems Technician: Neel Barrett\
			\[list]\
			<b>Supermatter Undergraduate Teams.</b><br>\
			\[*]Reactor Team Manhattan, A Shift: 4 Students, 2 Employees.\
			\[*]Reactor Team Neutrino, B Shift: 2 Students, 1 Employee.\
			\[*]Reactor Team Pluton, A2 Shift: 6 Students, 3 Employees.\
			\[*]Reactor Team Euphrate, B2 Shift: 4 Students, 3 Employees.\
			\[/list]\
			<b>Xenoscience Undergraduate Teams.</b><br>\
			\[list]\
			\[*]Survey Team Theta, A Shift: 3 Students, 2 Employees.\
			\[*]Survey Team Promethia, B Shift: 2 Students, 2 Employees.\
			\[*]Survey Team Delphi, A2 Shift: 2 Students, 2 Employees.\
			\[*]Survey Team Cyrenica, B2 Shift: 2 Students, 2 Employees.\
			\[/list]"

/obj/item/weapon/paper/verne/briefing
	name = "Survey Team Cyrenica briefing"
	info = "Good waking, Survey Team Cyrenica.<BR>\
		Dr. Schoonhoven and I have been negotiating the routing we intended to take the SRV Verne for this expedition.<BR>\
		This matter was improperly discussed during the initial expedition planning, and I promise, we will be making amends upon our return to Tau-Ceti.\
		After your last shift, the executive decision was made to put the SRV Verne onto extended automation.<BR>\
		You will be alone during the initial day of your shift. <BR>\
		The routing Dr. Schoonhoven and I negotiated will take us further than ever before. This comes with consequences; I trust you will be careful during your Survey missions. <BR>\
		We will be making history with this expedition. You will have earned the honor of having chased the God of the Sun.<BR>\
		I have scheduled support staff to awake during the second day of your shift. They will be awake for 48 hours, to provide overlapping coverage to Survey Team Theta, after you have entered stasis.<BR>\
		Your scheduled support staff are;<BR>\
		Physician Dr. Milli Newman<BR>\
		Non-Essential Systems Technician Neel Barrett.<BR>\
		They will awake 24 hours after your shift begins.<BR>\
		Your shift will last for the standard 48 hours.<BR>\
		Your duties remain unchanged;<BR>\
		Survey the Exoplanet you have been brought to.<BR>\
		The students will be performing their studies as required.<BR>\
		If you feel any nearby sites are of value, you have my permission to divert to them.<BR>\
		Given our tenuous staffing, it comes with my highest recommendations that you are aware of any other active vessels in your system if they are amenable to working with you or to assist you if required. <BR>\
		I firmly request you do not touch the Supermatter Testing facilities, as I have scheduled later classes to awake to perform their studies using the stock we have remaining.<BR>\
		Our supplies remain at acceptable levels at this time, but I will permit barter or trading if required.\
		Do not sell the resources your fellow students will require.<BR>\
		I await your results.<BR>\
		Dr. Andre Richardson"
