#define DESIGNATOR_DELAY_TIME 4 SECONDS
#define BEACON_EXPIRE_TIME 15 SECONDS

/obj/item/weapon/laser_designator
	name = "Laser Designator"
	desc = "Used to designate specific areas for bombardment with main ship weapons."
	icon = 'code/modules/halo/overmap/weapons/laser_designator.dmi'
	icon_state = "designator"
	w_class = ITEM_SIZE_SMALL
	var/obj/creator

/obj/item/weapon/laser_designator/New(var/obj/creator_console)
	. = ..()
	creator = creator_console

/obj/item/weapon/laser_designator/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	zoom(usr, 1.5)

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
	var/obj/effect/bombardment_beacon/beacon = new /obj/effect/bombardment_beacon (target_turf)
	beacon.visible_message("<span class = 'danger'>[src] winks into existence!</span>")
	beacon.loc = target_turf
	if(do_after(user,DESIGNATOR_DELAY_TIME,,1,1,,1))
		user.visible_message("<span class = 'danger'>[user] designates [target] for bombardment.</span>")
		to_chat(user,"<span class = 'danger'>Target designated for manual orbital bombardment. Signal will time-out in [BEACON_EXPIRE_TIME/10] seconds.</span>")
		beacon.activate_beacon(creator)
	else
		qdel(beacon)

/obj/item/weapon/laser_designator/covenant
	name = "Laser Designator"
	icon_state = "designator_cov"

#undef DESIGNATOR_DELAY_TIME

/obj/effect/bombardment_beacon
	name = "bombardment beacon"
	desc = "This is a marker for an orbital bombardment beacon. If you can see this, you should probably run."
	icon = 'code/modules/halo/icons/HUD/reticule.dmi'
	icon_state = "r2a"
	anchored = 1
	density = 0
	plane = EFFECTS_BELOW_LIGHTING_PLANE
	layer = POINTER_LAYER
	var/created_at = 0
	var/obj/linked_console

/obj/effect/bombardment_beacon/proc/activate_beacon(var/obj/linked_to)
	. = ..()
	linked_console = linked_to
	var/area/area_contained = loc.loc
	if(!istype(area_contained))
		name = "Bombardment Beacon [rand(0,999)]"
	else
		name = "Bombardment Beacon [rand(0,999)] - [area_contained.name]"
	created_at = world.time
	GLOB.processing_objects += src

/obj/effect/bombardment_beacon/process()
	if(world.time > (created_at + BEACON_EXPIRE_TIME))
		qdel(src)

#undef BEACON_EXPIRE_TIME