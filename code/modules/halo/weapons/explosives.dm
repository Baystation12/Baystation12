
/obj/item/device/landmine
	name = "landmine"
	desc = "Highly explosive"
	icon = 'code/modules/halo/weapons/icons/explosives.dmi'
	icon_state = "landmine0"
	var/state = 0
	var/arm_delay = 50
	var/arm_time = 0
	var/datum/proximity_trigger/square/prox

/obj/item/device/landmine/active/New()
	..()
	src.loc = get_turf(src)
	arm_landmine()

/obj/item/device/landmine/attack_self(var/mob/user)
	if(!state)
		state = 1
		icon_state = "landmine1"
		arm_time = world.time + arm_delay
		GLOB.processing_objects.Add(src)

/obj/item/device/landmine/process()
	if(world.time > arm_time)
		//stop us from processing
		GLOB.processing_objects.Remove(src)

		arm_landmine()

/obj/item/device/landmine/proc/trigger(var/atom/movable/triggering)
	if(istype(triggering, /mob/living))
		detonate()

/obj/item/device/landmine/proc/turfs_changed(var/list/new_turfs, var/list/old_turfs)

/obj/item/device/landmine/proc/arm_landmine()
	state = 2
	icon_state = "landmine2"

	if(!istype(src.loc, /turf))
		detonate()
	else
		prox = new(src, /obj/item/device/landmine/proc/trigger, /obj/item/device/landmine/proc/turfs_changed, 9)
		prox.register_turfs()

/obj/item/device/landmine/attackby()
	if(state == 2)
		detonate()
	else if(prob(25))
		detonate()

/obj/item/device/landmine/bullet_act()
	detonate()

/obj/item/device/landmine/ex_act()
	detonate()

/obj/item/device/landmine/proc/detonate()
	if(state != 3)
		state = 3
		spawn(10)
			explosion(get_turf(src), -1, 1, 2, 15, z_transfer = 0)
			qdel(src)

