/obj/machinery/overmap_weapon_console/boarding_beacon_launcher
	name = "Boarding Beacon Launcher"
	desc = "Launches disposable boarding-beacons at a selected target. Sensitive location data on each beacon requires that they self-destruct after 30 seconds."
	icon = 'code/modules/halo/machinery/boarding_beacon_console.dmi'
	icon_state = "base"
	anchored = 1
	density = 1
	fired_projectile = /obj/item/projectile/overmap/boarding_beacon
	fire_sound = 'code/modules/halo/sounds/deck_gun_fire.ogg'

/obj/item/projectile/overmap/boarding_beacon
	icon = 'code/modules/halo/machinery/boarding_beacon_proj.dmi'
	icon_state = "beacon"
	ship_damage_projectile = /obj/item/projectile/boarding_beacon

/obj/item/projectile/boarding_beacon
	name = "boarding beacon"
	icon = 'code/modules/halo/machinery/boarding_beacon_proj.dmi'
	icon_state = "beacon"

/obj/item/projectile/boarding_beacon/on_impact(var/atom/impacted)
	new /obj/structure/boarding_beacon (loc,null)
	qdel()

#define BOARDING_BEACON_DESTROYDELAY 10 SECONDS

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
