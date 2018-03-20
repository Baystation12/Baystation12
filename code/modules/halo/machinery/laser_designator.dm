#define DESIGNATOR_DELAY_TIME 5 SECONDS
#define BEACON_EXPIRE_TIME 15 SECONDS

/obj/item/weapon/laser_designator
	name = "Laser Designator"
	icon = 'code/modules/halo/machinery/laser_designator.dmi'
	icon_state = "designator"
	w_class = ITEM_SIZE_SMALL
	var/obj/creator

/obj/item/weapon/laser_designator/New(var/obj/creator_console)
	. = ..()
	creator = creator_console

/obj/item/weapon/laser_designator/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	if(adjacent) //Let's NOT designate ourselves for bombardment.
		return
	var/turf/target_turf
	if(!isturf(target))
		target_turf = target.loc
	else
		target_turf = target

	if(target_turf.z == GLOB.using_map.overmap_z) //Let's also not designate overmap tiles for bombardment.
		return

	user.visible_message("<span class = 'danger'>[user] starts designating [target] for bombardment!</span>")
	if(do_after(user,DESIGNATOR_DELAY_TIME,,1,1,,1))
		user.visible_message("<span class = 'danger'>[user] designates [target] for bombardment.</span>")
		to_chat(user,"<span class = 'danger'>Target designated for manual orbital bombardment. Signal will time-out in [BEACON_EXPIRE_TIME/10] seconds.</span>")
		var/obj/beacon = new /obj/effect/bombardment_beacon (creator)
		beacon.loc = target_turf

#undef DESIGNATOR_DELAY_TIME

/obj/effect/bombardment_beacon
	name = "bombardment beacon"
	invisibility = 101
	var/created_at = 0
	var/obj/linked_console

/obj/effect/bombardment_beacon/New(var/obj/linked_to)
	linked_console = linked_to
	var/beacons_existing = 0
	for(var/obj/effect/bombardment_beacon/b in world)
		beacons_existing += 1
	var/area/area_contained = loc.loc
	if(!istype(area_contained))
		name = "Bombardment Beacon [beacons_existing]"
	else
		name = "Bombardment Beacon [beacons_existing] - [area_contained.name]"
	created_at = world.time
	GLOB.processing_objects += src

/obj/effect/bombardment_beacon/process()
	if(world.time > (created_at + BEACON_EXPIRE_TIME))
		qdel(src)

#undef BEACON_EXPIRE_TIME