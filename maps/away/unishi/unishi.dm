#include "unishi_areas.dm"
#include "unishi_jobs.dm"

/obj/effect/submap_landmark/joinable_submap/unishi
	name = "SRV Verne"
	archetype = /decl/submap_archetype/derelict/unishi

/decl/submap_archetype/derelict/unishi
	descriptor = "derelict research vessel"
	map = "SRV Verne"
	crew_jobs = list(
		/datum/job/submap/unishi_crew,
		/datum/job/submap/unishi_researcher
	)

/obj/effect/overmap/visitable/ship/unishi
	name = "SRV Verne"
	desc = "Sensor array detects unknown class medium size vessel. The vessel appears unarmed.\
	A small amount of radiation has been detected at the aft of the ship"
	vessel_mass = 5000
	max_speed = 1/(3 SECONDS)
	initial_generic_waypoints = list(
		"nav_unishi_1",
		"nav_unishi_2",
		"nav_unishi_3",
	)

/datum/map_template/ruin/away_site/unishi
	name = "University Ship"
	id = "awaysite_unishi"
	description = "CTI research ship.."
	suffixes = list("unishi/unishi-1.dmm", "unishi/unishi-2.dmm", "unishi/unishi-3.dmm")
	cost = 2
	area_usage_test_exempted_root_areas = list(/area/unishi)


/obj/effect/shuttle_landmark/nav_unishi/nav1
	name = "CTI Research Vessel Deck 1 Port"
	landmark_tag = "nav_unishi_1"

/obj/effect/shuttle_landmark/nav_unishi/nav2
	name = "CTI Research Vessel Deck 2 Starboard"
	landmark_tag = "nav_unishi_2"

/obj/effect/shuttle_landmark/nav_unishi/nav3
	name = "CTI Research Vessel Deck 3 Aft"
	landmark_tag = "nav_unishi_3"


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

/obj/machinery/power/emitter/anchored/on
	active = 1
	powered = 1

/obj/structure/closet/crate/secure/large/phoron/experimentalsm
	name = "experimental SM crate"
	desc = "Are you sure you want to open this?"

/obj/structure/closet/crate/secure/large/phoron/experimentalsm/WillContain()
	return list(/obj/machinery/power/supermatter/randomsample)

obj/item/weapon/paper/prof1
	name = "Error log"
	info = "<large> COMPUTER ID: 15231 <br> Attempting recovery of document directory. <br> Three files recovered <br> Printing file (1/2) <br> </large> ... about your concerns. I told you that the shielding is strong enough to avoid ANY leaks of radiation or hazardous materials. The entire lab is 100% isolated from the ship in terms of even the air supply. Leave me and my students the fuck alone. Your job is to maintain the fucking reactor an !#@!dqma211.<br> <large> File (2/3) Tested SM </large> This thing has a lot of potential. It doesn't produce any measurable levels of gas, or even significant thermal signature. The potential is nearly limitless. We've had to fine tune our activation procedures as even a short beam of the emitter seems to activate this thing. CTI Engineering dept still won't fucking answer where they got this thing, but it's simply amazing. I've sent an ema #@^%da12k"

obj/item/weapon/paper/prof2
	name = "Error log"
	info = "<large> COMPUTER ID: 15131 <br> Attempting recovery of document directory. <br> Three files recovered <br> Printing file (1/2) <br> </large> Email to iodc@net <br> To whom it may concern, <br> I recieved your email today in regards to the research I am conducting. You have no legal right to question our research or attempt to block it. Per article 323 of SGCL, scientific research is protected information, that you have absolutely zero claim to. The compound is secret in composition, but I can fully promise you that it contains zero traces of phoron, and thus you have no claim whatsoever to it or the technologies to it. Your threats are laughable at best, and have been forwarded to CTI legal. Do not contact me aga!#!41asjw. <br> <large> Printing file (2/2) <br> </large> Email from fuckyou@12cmal <br> We have ways of making you comply. "



/obj/machinery/computer/log_printer
	name = "Computer"
	construct_state = null
	base_type = /obj/machinery/computer/log_printer
	var/logtype
	var/used = 0

/obj/machinery/computer/log_printer/interface_interact(mob/living/user)
	if(CanInteract(user, DefaultTopicState()))
		to_chat(user, "Default Boot Device File Integrity Damaged. Startup aborted. Error log printing.")
		new logtype(loc)
		used = 1
		return TRUE

/obj/machinery/computer/log_printer/prof1
	name = "Professor's Computer"
	logtype = /obj/item/weapon/paper/prof1

/obj/machinery/computer/log_printer/prof2
	name = "Professor's Computer"
	logtype = /obj/item/weapon/paper/prof2


/obj/effect/floor_decal/cti
	name = "\improper CTI logo"
	desc = "Logo of the famed Ceti Technical Institute. Just looking at it makes you feel ashamed of your alma mater."
	icon = 'unishi.dmi'
	icon_state = "CTILogo"

/datum/reagent/toxin/phoron/safe
	name = "tericadone"
	description = "Phoron substitute currently in labratory testing"
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

