
#define STATE_INACTIVE 0
#define STATE_ARMING 1
#define STATE_ACTIVE 2
#define STATE_WARNING 3
#define STATE_DETONATE 4

/obj/item/device/landmine
	name = "landmine"
	desc = "Highly explosive"
	icon = 'code/modules/halo/weapons/icons/explosives.dmi'
	icon_state = "landmine0"
	var/det_range = 5
	var/trigger_range = 8
	var/state = STATE_INACTIVE
	var/arm_delay = 50
	var/arm_time = 0
	var/reset_warning_time = 0
	var/datum/proximity_trigger/square/prox
	var/processing = 0
	throw_range = 0

/obj/item/device/landmine/active/New()
	..()
	src.loc = get_turf(src)
	arm_landmine()

/obj/item/device/landmine/attack_self(var/mob/user)
	if(!state && do_after(user, 30))
		user.drop_item()
		set_state(STATE_ARMING)
		arm_time = world.time + arm_delay
		set_processing()
		to_chat(user,"\icon[src] <span class='notice'>You deploy [src] and place it on the ground.</span>")

/obj/item/device/landmine/attackby()
	if(state > 1)
		detonate()
	else if(prob(25))
		detonate()

/obj/item/device/landmine/bullet_act()
	detonate()

/obj/item/device/landmine/ex_act()
	detonate()

/obj/item/device/landmine/proc/set_processing()
	if(!processing)
		processing = 1
		GLOB.processing_objects.Add(src)

/obj/item/device/landmine/proc/stop_processing()
	if(processing)
		GLOB.processing_objects.Remove(src)
		processing = 0

/obj/item/device/landmine/process()
	switch(state)
		if(STATE_ARMING)
			if(world.time > arm_time)

				stop_processing()
				arm_landmine()

		if(STATE_WARNING)
			if(world.time > reset_warning_time)

				stop_processing()
				set_state(STATE_ACTIVE)

/obj/item/device/landmine/proc/trigger(var/atom/movable/triggering)
	if(istype(triggering, /mob/living))
		if(get_dist(triggering, src) < det_range)
			detonate()
		else
			warning()

/obj/item/device/landmine/proc/warning()
	reset_warning_time = world.time + 20
	if(state < STATE_WARNING)
		set_state(STATE_WARNING)
		set_processing()

/obj/item/device/landmine/proc/turfs_changed(var/list/new_turfs, var/list/old_turfs)
	//intentionally blank

/obj/item/device/landmine/proc/set_state(var/new_state)
	state = new_state
	icon_state = "landmine[new_state]"

/obj/item/device/landmine/proc/arm_landmine()
	set_state(STATE_ACTIVE)

	if(!isturf(loc))
		detonate()
	else
		prox = new(src, /obj/item/device/landmine/proc/trigger, /obj/item/device/landmine/proc/turfs_changed, trigger_range)
		prox.register_turfs()

/obj/item/device/landmine/proc/detonate()
	if(state < STATE_DETONATE)
		set_state(STATE_DETONATE)
		if(prox)
			qdel(prox)
		spawn(10)
			explosion(get_turf(src), -1, det_range / 2, det_range, det_range * 2, z_transfer = 0)
			qdel(src)

#undef STATE_INACTIVE
#undef STATE_ARMING
#undef STATE_ACTIVE
#undef STATE_WARNING
#undef STATE_DETONATE
