/obj/machinery/overmap_weapon_console/boarding_beacon_launcher
	name = "Boarding Beacon Launcher"
	desc = "Launches disposable boarding-beacons at a selected target. Sensitive location data on each beacon requires that they self-destruct after 30 seconds."
	icon = 'code/modules/halo/machinery/overmap_weapon_base.dmi'
	icon_state = "wep_base"
	anchored = 1
	density = 1
	fired_projectile = /obj/item/projectile/overmap/boarding_beacon
	fire_sound = 'code/modules/halo/sounds/deck_gun_fire.ogg'

/obj/item/projectile/overmap/boarding_beacon
	ship_damage_projectile = /obj/item/projectile/boarding_beacon

/obj/item/projectile/boarding_beacon/on_impact(var/atom/impacted)
	new /obj/machinery/boarding_beacon (loc)
	qdel()

#define BOARDING_BEACON_DESTROYDELAY 5 SECONDS

/obj/machinery/boarding_beacon
	name = "Location Beacon"
	desc = "A beacon broadcasting its location to the void."

	var/destroy_at = -1
	var/obj/effect/landmark/drop_point_created = /obj/effect/landmark/drop_pod_landing

/obj/machinery/boarding_beacon/New(var/turf/loc,var/stop_auto_destroy)
	. = ..()
	if(stop_auto_destroy)
		return
	destroy_at = world.time + BOARDING_BEACON_DESTROYDELAY
	drop_point_created = new drop_point_created (loc)
	drop_point_created.name = "Boarding Beacon"

/obj/machinery/boarding_beacon/process()
	if(destroy_at == -1)
		GLOB.processing_objects -= src
		return
	if(world.time >= destroy_at)
		qdel(drop_point_created)
		qdel()
