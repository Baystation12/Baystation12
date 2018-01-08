#include "bearcat_areas.dm"

/obj/effect/overmap/ship/bearcat
	name = "FTV Bearcat"
	color = "#00FFFF"
	vessel_mass = 60
	default_delay = 3 MINUTES
	speed_mod = 0.1 MINUTE
	burn_delay = 10 SECONDS

/obj/effect/overmap/ship/bearcat/New()
	name = "[pick("FTV","ITV","IEV")] [pick("Bearcat", "Firebug", "Defiant", "Unsinkable","Horizon","Vagrant")]"
	for(var/area/ship/scrap/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()

/datum/map_template/ruin/away_site/bearcat_wreck
	name = "Bearcat Wreck"
	id = "awaysite_bearcat_wreck"
	description = "A wrecked light freighter."
	suffixes = list("bearcat/bearcat-1.dmm", "bearcat/bearcat-2.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/ferry/lift)

/datum/shuttle/autodock/ferry/lift
	name = "Cargo Lift"
	shuttle_area = /area/ship/scrap/shuttle/lift
	warmup_time = 3	//give those below some time to get out of the way
	waypoint_station = "nav_bearcat_lift_bottom"
	waypoint_offsite = "nav_bearcat_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/lift
	name = "cargo lift controls"
	shuttle_tag = "Cargo Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/effect/shuttle_landmark/lift/top
	name = "Top Deck"
	landmark_tag = "nav_bearcat_lift_top"
	autoset = 1

/obj/effect/shuttle_landmark/lift/bottom
	name = "Lower Deck"
	landmark_tag = "nav_bearcat_lift_bottom"
	base_area = /area/ship/scrap/cargo/lower
	base_turf = /turf/simulated/floor

/obj/machinery/power/apc/derelict
	cell_type = /obj/item/weapon/cell/crap/empty
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	coverlocked = 0

/obj/machinery/door/airlock/autoname/command
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	req_access = list(access_heads)

/obj/machinery/door/airlock/autoname/engineering
	req_access = list(access_engine)

/turf/simulated/floor/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/wood/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/tiled/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/tiled/dark/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/tiled/white/usedup
	initial_gas = list("carbon_dioxide" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/obj/effect/landmark/deadcap
	name = "Dead Captain"
	delete_me = 1

/obj/effect/landmark/deadcap/Initialize()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/corpse = new(T)
	scramble(1,corpse,100)
	corpse.real_name = "Captain"
	corpse.name = "Captain"
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/deadcap)
	outfit.equip(corpse)
	corpse.adjustOxyLoss(corpse.maxHealth)
	corpse.setBrainLoss(corpse.maxHealth)
	var/obj/structure/bed/chair/C = locate() in T
	if(C)
		C.buckle_mob(corpse)
	. = ..()

/decl/hierarchy/outfit/deadcap
	name = "Derelict Captain"
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat
	shoes = /obj/item/clothing/shoes/black
	r_pocket = /obj/item/device/radio

/decl/hierarchy/outfit/deadcap/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)
	var/obj/item/weapon/cell/super/C = new()
	H.put_in_any_hand_if_possible(C)
