/obj/machinery/overmap_weapon_console/boarding_beacon_launcher
	name = "Boarding Beacon Launcher"
	desc = "Launches disposable boarding-beacons at a selected target. Firing at a planet will instead create drop-pod beacons. Sensitive location data on each beacon requires that they self-destruct after 30 seconds."
	icon = 'code/modules/halo/machinery/boarding_beacon_console.dmi'
	icon_state = "base"
	anchored = 1
	density = 1
	fired_projectile = /obj/item/projectile/overmap/boarding_beacon
	fire_sound = 'code/modules/halo/sounds/deck_gun_fire.ogg'
	fire_delay = 1 SECOND
	var/drop_beacon_faction = "UNSC" //The faction to assign to the drop pod beacon we create on hitting a planet.

/obj/machinery/overmap_weapon_console/boarding_beacon_launcher/innie
	drop_beacon_faction = "Insurrection"

/obj/machinery/overmap_weapon_console/boarding_beacon_launcher/covenant
	drop_beacon_faction = "Covenant"
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"

/obj/item/projectile/overmap/boarding_beacon
	icon = 'code/modules/halo/machinery/boarding_beacon_proj.dmi'
	icon_state = "beacon"
	ship_damage_projectile = /obj/item/projectile/boarding_beacon

/obj/item/projectile/overmap/boarding_beacon/on_impact(var/obj/effect/overmap/ship/npc_ship/ship)
	if(istype(ship) && !istype(ship,/obj/effect/overmap/ship/npc_ship/automated_defenses) && ship.unload_at == 0)
		ship.load_mapfile()
	. = ..()

/obj/item/projectile/overmap/boarding_beacon/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	var/turf/beacon_on = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	var/obj/item/drop_pod_beacon/beacon = new /obj/item/drop_pod_beacon/invis (beacon_on)
	beacon.faction_tag = console_fired_by:drop_beacon_faction
	beacon.activate()

/obj/item/projectile/boarding_beacon
	name = "boarding beacon"
	icon = 'code/modules/halo/machinery/boarding_beacon_proj.dmi'
	icon_state = "beacon"
	step_delay = 0.3 SECONDS

/obj/item/projectile/boarding_beacon/on_impact(var/atom/impacted)
	new /obj/structure/boarding_beacon (loc)
	. = ..()

#define BOARDING_BEACON_DESTROYDELAY 30 SECONDS

/obj/structure/boarding_beacon
	name = "Location Beacon"
	desc = "A beacon broadcasting its location to the void."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	density = 0
	anchored = 1

	var/destroy_at = 0
	var/obj/effect/landmark/drop_pod_landing/drop_point_created

/obj/structure/boarding_beacon/New(var/turf/loc,var/stop_auto_destroy = null)
	if(stop_auto_destroy)
		destroy_at = -1
		return
	destroy_at = world.time + BOARDING_BEACON_DESTROYDELAY
	GLOB.processing_objects += src
	. = ..()

/obj/structure/boarding_beacon/process()
	if(isnull(drop_point_created))
		drop_point_created = new /obj/effect/landmark/drop_pod_landing (loc)
		drop_point_created.loc = loc
		drop_point_created.name = "Boarding Beacon"
	if(destroy_at == -1)
		GLOB.processing_objects -= src
		return
	if(world.time >= destroy_at)
		GLOB.processing_objects -= src
		qdel(drop_point_created)
		qdel(src)
