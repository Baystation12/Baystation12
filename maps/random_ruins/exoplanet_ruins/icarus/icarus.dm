/datum/map_template/ruin/exoplanet/icarus
	name = "SEV Icarus"
	id = "icarus"
	description = "The crash of the infamous SEV Icarus."
	suffixes = list("icarus/icarus.dmm")
	spawn_cost = 1
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	apc_test_exempt_areas = list(
		/area/map_template/icarus = NO_SCRUBBER|NO_VENT|NO_APC
	)

//Radiation death spawner thing from old Icarus

/obj/effect/icarus_irradiate
	name = "SEV Icarus Radiation Spawner"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"
	var/radiation_power = 20 //Dangerous but survivable for 10-15 minutes if crew is too lazy to read away map description
	var/datum/radiation_source/S
	var/req_range = 20 //to cover part of the ruin

/obj/effect/icarus_irradiate/Initialize()
	. = ..()

	name = null
	icon = null
	icon_state = null

	S = new()
	S.flat = TRUE
	S.range = req_range
	S.respect_maint = FALSE
	S.decay = FALSE
	S.source_turf = get_turf(src)
	S.update_rad_power(radiation_power)
	SSradiation.add_source(S)

	loc.set_light(0.4, 1, req_range, l_color = COLOR_LIME) //The goo doesn't last, so this is another indicator

/obj/effect/icarus_irradiate/Destroy()
	. = ..()
	QDEL_NULL(S)

//Areas

/area/map_template/icarus
	name = "SEV Icarus"
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus.dmi'
	icon_state = "icarus"

/area/map_template/icarus/bridge
	name = "SEV Icarus Bridge"
	icon_state = "bridge"

/area/map_template/icarus/eng
	name = "SEV Icarus Engineering Bay"
	icon_state = "engine"

/area/map_template/icarus/sec
	name = "SEV Icarus Brig"
	icon_state = "brig"

/area/map_template/icarus/armory
	name = "SEV Icarus Tactical Armory"
	icon_state = "armory"

/area/map_template/icarus/sci
	name = "SEV Icarus Research Division"
	icon_state = "research"

/area/map_template/icarus/driver
	icon_state = "driver"

/area/map_template/icarus/driver/west
	name = "SEV Icarus Port Mass Driver"

/area/map_template/icarus/driver/east
	name = "SEV Icarus Starboard Mass Driver"


//Objects

/obj/item/icarus_disk
	name = "disk"
	desc = "A dusty disk. Its label says: \"Deliver to SCG Expeditionary Corps Command!\". Its content is encrypted with quantum cryptography methods."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

/obj/item/toy/icarus_model
	name = "table-top SEV Icarus model"
	desc = "A small model of a spaceship mounted on a wooden stand. On the stand is engraved: \"SEV Icarus 1:278th scale\". The small lights on the hull and the engine exhaust still light up and blink."
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus.dmi'
	icon_state = "model"

/obj/item/gun/projectile/pistol/military/icarus
	name = "rusty military pistol"
	desc = "The Hephaestus Industries P20 - a mass produced kinetic sidearm in widespread service with the SCGDF. This one has seen better days, and has the name \"Alex\" engraved into it."

//SCG deco

/obj/structure/sign/icarus_dedicationplaque
	name = "\improper SEV Icarus dedication plaque"
	icon_state = "lightplaque"
	desc = "S.E.V. Icarus - Lexington Class - Sol Expeditionary Corps Registry 95498 - Tennessee Fleet Yards, Mars - First Vessel To Bear The Name - Launched 2302 - Sol Central Government - 'Never was anything great achieved without danger.'"

/obj/structure/sign/icarus_ecplaque
	name = "\improper Expeditionary Directives"
	desc = "A plaque with Expeditionary Corps logo etched in it. It looks faded and is illegible."
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus.dmi'
	icon_state = "ecplaque"

/obj/structure/sign/double/icarus_solgovflag
	name = "Sol Central Government Flag"
	desc = "A faded SCG flag. It appears to have been radiation bleached."
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus.dmi'

/obj/structure/sign/double/icarus_solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/icarus_solgovflag/right
	icon_state = "solgovflag-right"

/obj/structure/sign/icarus_solgov
	name = "\improper Faded SCG seal"
	desc = "A sign which signifies who this vessel belongs to. This one is faded."
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus.dmi'
	icon_state = "solgovseal"

/obj/effect/floor_decal/icarus_scglogo
	alpha = 230
	icon = 'maps/random_ruins/exoplanet_ruins/icarus/icarus_scglogo.dmi'
	icon_state = "center"

//Paper

/obj/item/paper/icarus_log
	name = "Printed log"
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

/obj/item/paper/icarus_roster
	name = "Printed crew manifest"
	info = "<center>\[solcrest]<BR>\
			<b>SEV Icarus</b><br>\
			Crew roster</center><br>\
			<b>Command</b><br>\
			\[list]\
			\[*]Commanding Officer: Cmd. Alex Peterson\
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
