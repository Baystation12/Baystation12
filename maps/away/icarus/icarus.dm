#include "icarus_areas.dm"

/obj/effect/overmap/visitable/sector/icarus
	name = "forest planetoid"
	desc = "Sensors detect anomalous radiation area with the presence of artificial structures."
	icon_state = "globe"
	known = 0
	in_space = 0
	initial_generic_waypoints = list(
		"nav_icarus_1",
		"nav_icarus_2",
		"nav_icarus_antag"
	)

/obj/effect/overmap/visitable/sector/icarus/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/icarus/irradiate
	var/radiation_power = 20//20 Bq. Dangerous but survivable for 10-15 minutes if crew is too lazy to read away map description
	var/datum/radiation_source/S
	var/req_range = 100//to cover whole level

/obj/effect/icarus/irradiate/Initialize()
	. = ..()
	S = new()
	S.flat = TRUE
	S.range = req_range
	S.respect_maint = FALSE
	S.decay = FALSE
	S.source_turf = get_turf(src)
	S.update_rad_power(radiation_power)
	SSradiation.add_source(S)

/obj/effect/icarus/irradiate/Destroy()
	. = ..()
	QDEL_NULL(S)

/datum/map_template/ruin/away_site/icarus
	name = "Fallen Icarus"
	id = "awaysite_icarus"
	description = "The crashlanding site of the SEV Icarus."
	suffixes = list("icarus/icarus-1.dmm", "icarus/icarus-2.dmm")
	cost = 2
	generate_mining_by_z = list(1, 2)
	area_usage_test_exempted_root_areas = list(/area/icarus)
	area_coherency_test_exempt_areas = list(/area/icarus/vessel, /area/icarus/open)
	apc_test_exempt_areas = list(
		/area/icarus/vessel = NO_APC,
		/area/icarus/open = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/effect/shuttle_landmark/nav_icarus/nav1
	name = "Planetary Navpoint #1"
	landmark_tag = "nav_icarus_1"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/nav_icarus/nav2
	name = "Planetary Navpoint #2"
	landmark_tag = "nav_icarus_2"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/nav_icarus/nav3
	name = "Planetary Navpoint #3"
	landmark_tag = "nav_icarus_antag"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/structure/broken_cryo/icarus
	remains_type = /obj/item/icarus/dead_personnel

/obj/item/icarus/dead_personnel
	name = "partial skeleton remains"
	desc = "Human bones wrapped in the shredded remnants of a familiar black uniform."
	icon = 'maps/away/icarus/icarus_sprites.dmi'
	icon_state = "dead_personnel"
	w_class = ITEM_SIZE_LARGE//pile of bones

/obj/item/weapon/disk/icarus
	name = "black box backup disk"
	desc = "Digital storage. Inscription says: \"Deliver to Sol Goverment Expeditionary Corps Command!\". Content is encrypted with quantum crypthography methods."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

/obj/item/weapon/paper/icarus/log
	name = "Printed piece of paper"
	info = "\[LOG\]: Orbit stabilized. Next correction burst, est.: 2 hrs 12 m<br>\
			\[LOG\]: Orbit stabiliztion. Announcing...<br>\
			\[ANN\]: Attention all hands, SEV Icarus is stabilizing orbit in 30 seconds. Prepare for possible gravitational spikes.<br>\
			\[LOG\]: Announcing complete.<br>\
			\[LOG\]: Preparing for burst: heating up impulse mass.<br>\
			\[WARN\]: Minor pressure alert, Reactor Cooling Loop 3.<br>\
			\[LOG\]: Burst ready. Bursting in 5 seconds.<br>\
			\[LOG\]: Orbit stabilized. Next correction burst, est.: 1 hr 47 m.<br>\
			\[ADM\]: Preparing shuttles for landing. Current status: required refuilling. <br>\
			\[REQ\]: Request to Engineering, Please refuel Shuttle #2... Sent.<br>\
			\[WARN\]: Minor pressure alert, Reactor Cooling Loop 1.<br>\
			\[RET\]: Request completed.<br>\
			\[LOG\]: Manual correction {Engine->Cooling->Pumps}: calculating new trend.<br>\
			\[LOG\]: Calculating complete. Notify ADMIN...<br>\
			\[ERR\]: Positive feedback loop in Engine Core! Prepare for emergency procedures.<br>\
			\[ERR\]: Positive feedback loop in Engine Core! Prepare for emergency procedures.<br>\
			\[ERR\]: Positive feedback loop in Engine Core! Prepare for emergency procedures.<br>\
			\[ERR\]: Positive feedback loop in Engine Core! Prepare for emergency procedures.<br>\
			\[ERR\]: Positive feedback loop in Engine Core! Prepare for emergency procedures.<br>\
			\[LOG\]: This error was muted for 120 seconds.<br>\
			\[WARN\]: Multiple hull breaches detected.<br>\
			\[WARN\]: Unexepected orbit change, calculating corrective burst.<br>\
			\[LOG\]: Preparing for burst: heating up impulse mass.<br>\
			\[ERR\]: Impulse mass: not found<br>\
			\[LOG\]: Orbit stabilizing: failed.<br>\
			\[WARN\]: Impact imminent... Preparing blackbox backup... Ready.<br>\
			\[LOG\]: Emergency shutdown!<br>\
			\[LOG\]: Now you can you safely turn off your computer.<br>"


/obj/item/weapon/paper/icarus/crew_roster
	name = "Printed piece of paper"
	info = "<center>\[solcrest]<BR>\
			<b>SEV Icarus</b><br>\
			Crew roster</center><br>\
			<b>Command</b><br>\
			\[list]\
			\[*]Commanding Officer: Cmd. Angela Peterson\
			\[*]Executive Officer: Lt. Semyon Andors \
			\[*]CMO: Lt. Toko Nashamura\
			\[*]CE: Ens. Anna Lawrence\
			\[*]COS: Lt. Rand Forbarra\
			\[*]CSO: Dr. Carl Jozziliny\
			\[*]BO: Ens. Gordon Johnson\
			\[/list]<br>\
			<b>Medical dept.</b><br>\
			\[list]\
			\[*]Physician: S. Expl. John Fors\
			\[*]Nurse: Expl. Antony Laffer\
			\[/list]<br>\
			<b>Engineering dept.</b><br>\
			\[list]\
			\[*]Engineer: Expl. Ronda Atkins\
			\[*]Engineer: Expl. Peter Napp\
			\[/list]<br>\
			<b>Security dept.</b><br>\
			\[list]\
			\[*]SO: S. Expl. Nuri Batyam\
			\[*]SO: Expl. Benjamin Tho\
			\[*]SO: Expl. Tetha-12-Alpha\
			\[/list]<br>\
			<b>Exploration team.</b><br>\
			\[list]\
			\[*]Ch. Expl. Alex Warda\
			\[*]S. Expl. William Lions\
			\[*]Expl. Hope Bafflow\
			\[*]Expl. Yuri Meadows\
			\[*]Dr. Tetha-12-Beta\
			\[list]"

/obj/item/toy/ship_model
	name = "table-top SEV Icarus model"
	desc = "A small model of a spaceship mounted on a wooden stand. On the stand is engraved: \"SEV Icarus 1:278th scale\". The small lights on the hull and the engine exhaust still light up and blink."
	icon = 'maps/away/icarus/icarus_sprites.dmi'
	icon_state = "model"

//to pass tests and make vesrion not depending on Torch code. Sol gov floor decal had to go though :(
/obj/structure/sign/icarus/solgov
	name = "\improper SolGov Seal"
	desc = "A familiar seal showing this vessel is SolGov property."
	icon = 'maps/away/icarus/icarus_sprites.dmi'
	icon_state = "solgovseal"

/obj/item/clothing/under/icarus/ec_uniform
	name = "expeditionary uniform"
	desc = "An older model of the utility uniform of the SCG Expeditionary Corps. It has a patch on the left sleeve signifying the wearer served on the SEV Icarus."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	icon = 'maps/away/icarus/icarus_sprites.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/away/icarus/icarus_sprites.dmi')

/obj/structure/sign/double/icarus/solgovflag
	name = "Sol Central Government Flag"
	desc = "The iconic flag of the Sol Central Government, a symbol with many different meanings."
	icon = 'maps/away/icarus/icarus_sprites.dmi'

/obj/structure/sign/double/icarus/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/icarus/solgovflag/right
	icon_state = "solgovflag-right"