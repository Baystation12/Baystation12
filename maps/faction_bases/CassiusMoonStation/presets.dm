
/obj/machinery/door/airlock/halo/maint/moonbase_cassius_maint
	name = "Maintenance Access"
	req_access = list(access_unsc)

/obj/machinery/door/airlock/halo/moonbase_cassius_general
	req_access = list(access_unsc)

/obj/machinery/door/airlock/halo/moonbase_cassius_odst
	req_access = list(access_unsc_odst)

/obj/machinery/door/firedoor/unsc_moonbase_cassius
	req_access = list(access_unsc)

/obj/machinery/door/airlock/halo/moonbase_cassius_odst/podroom
	name = "ODST Drop Pods"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/escape_pod
	name = "Escape Pods"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/kitchen
	name = "Kitchen"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/briefA
	name = "Briefing Room A"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/briefB
	name = "Briefing Room B"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/pharmacy
	name = "Pharmacy"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/toilets
	name = "Toilet"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/locker_room
	name = "Locker Room"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/atmospherics
	name = "Atmos"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/cryopod
	name = "Cryogenics"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/aicore
	name = "AI Core"

/obj/machinery/door/airlock/halo/moonbase_cassius_general/bunkernet
	name = "Bunker Network"

//MULTI TILE//

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general
	req_access = list(access_unsc)

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/storage_room
	name = "Storage Room"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/medical
	name = "Medical Bay"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/briefing_lobby
	name = "Briefing Lobby"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/command_dec
	name = "Command Deck"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/bunks
	name = "Bunks"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/armory
	name = "Armory"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/offices
	name = "Offices"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/observation
	name = "Starboard Observation Deck"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/hangar
	name = "Hangar Bay"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/central_lobby
	name = "Central Lobby"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/garden
	name = "Garden"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/bathroom_m
	name = "Male Bathroom"

/obj/machinery/door/airlock/multi_tile/halo/moonbase_cassius_general/bathroom_f
	name = "Female Bathroom"

//MULTI TILE BLAST//

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general
	req_access = list(access_unsc)

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/gym
	name = "Gym / Observation Port"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/hangar
	name = "Hangar Bay"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/garage_external
	name = "External Garage"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/shooting_range
	name = "Shooting Range"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/garden
	name = "Garden"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/moonbase_cassius_general/umbilical_divider
	name = "Umbilical Divider"

/obj/machinery/door/window/odst_armory
	req_access = list(access_unsc_odst)

/obj/machinery/door/window/northleft/oni_entrance
	req_access = list(access_unsc_oni)

/obj/machinery/door/window/northright/oni_entrance
	req_access = list(access_unsc_oni)

/obj/machinery/door/airlock/multi_tile/halo/base_oni_door
	req_access = list(access_unsc_oni)

/obj/effect/loot_marker/bombpoints_random
	loot_type = "bombRandom"

/obj/machinery/light/spot_powerroom
	light_type = /obj/item/weapon/light/tube/large_powerroom

/obj/item/weapon/light/tube/large_powerroom
	name = "capacitor room large light tube"
	brightness_range = 10
	brightness_power = 2
	brightness_color = "#0377fc"

/obj/machinery/light/spot_cavewall
	light_type = /obj/item/weapon/light/tube/large_cavewall

/obj/item/weapon/light/tube/large_cavewall
	name = "underground large light tube"
	brightness_range = 10
	brightness_power = 2
	brightness_color = "#362F29"

/obj/effect/landmark/flank_marker
	name = "Marks spots for wall-spawn when poplocking map flanks"

/obj/effect/landmark/flank_marker/left
	name = "leftflank"

/obj/effect/landmark/flank_marker/rightflank
	name = "rightflank"

//Placeholder so runtimes don't happen//
/obj/effect/overmap/sector/exo_depot

/obj/structure/bumpstairs/road/moonbase_to_oni
	id_self = "oni_gem"
	id_target = "gem_oni"
	faction_restrict = "UNSC"

/obj/structure/bumpstairs/road/moonbase_to_oni/Initialize()
	. = ..()
	if(locate(/obj/effect/overmap/sector/exo_depot))
		return INITIALIZE_HINT_QDEL