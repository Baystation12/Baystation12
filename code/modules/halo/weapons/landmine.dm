
#define STATE_INACTIVE 4
#define STATE_ARMING 5
#define STATE_ACTIVE 6
#define STATE_WARNING 7
#define STATE_DETONATE 8
#define STATE_QDEL 9

/obj/item/device/landmine
	name = "incomplete anti-personnel mine"
	desc = "A partially completed landmine. It needs a device assembly with a proximity sensor and igniter added."
	icon = 'code/modules/halo/weapons/icons/explosives.dmi'
	icon_state = "shell"
	var/obj/item/device/assembly_holder/assembly
	var/det_range = 5
	var/trigger_range = 8
	var/state = 0
	var/arm_delay = 50
	var/arm_time = 0
	var/reset_warning_time = 0
	var/datum/proximity_trigger/square/prox
	var/processing = 0
	throw_range = 0
	var/list/beakers = list()
	var/list/allowed_containers = list(/obj/item/weapon/reagent_containers/glass/beaker,\
		/obj/item/weapon/reagent_containers/glass/bottle,\
		/obj/item/weapon/reagent_containers/glass/beaker/vial,\
		/obj/item/weapon/reagent_containers/glass/beaker/large)

/obj/item/device/landmine/New()
	create_reagents(1000)
	. = ..()


/obj/item/device/landmine/Initialize()
	. = ..()
	if(state == STATE_ACTIVE)
		arm_landmine()

/obj/item/device/landmine/attack_self(var/mob/user)
	if(state == STATE_INACTIVE)
		if(do_after(user, 30))
			user.drop_item()
			set_state(STATE_ARMING)
			arm_time = world.time + arm_delay
			set_processing()
			to_chat(user,"\icon[src] <span class='notice'>You deploy [src] and place it on the ground.</span>")
	else if(state > STATE_INACTIVE)
		to_chat(user,"\icon[src] <span class='notice'>[src] has already been activated!</span>")
	else
		to_chat(user,"\icon[src] <span class='notice'>You must finish [src] before it can be deployed.</span>")

/obj/item/device/landmine/bullet_act()
	. = detonate()

/obj/item/device/landmine/ex_act()
	. = detonate()

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

		if(STATE_DETONATE)
			do_det_effect()
			set_state(STATE_QDEL)

		if(STATE_QDEL)
			stop_processing()
			if(prox)
				qdel(prox)
			qdel(src)

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
	if(new_state >= STATE_INACTIVE)
		icon_state = "landmine[new_state]"
	else
		icon_state = "shell"

/obj/item/device/landmine/proc/arm_landmine()
	set_state(STATE_ACTIVE)

	if(!isturf(loc))
		detonate()
	else
		prox = new(src, /obj/item/device/landmine/proc/trigger, /obj/item/device/landmine/proc/turfs_changed, trigger_range)
		prox.register_turfs()
	update_icon()

/obj/item/device/landmine/proc/detonate()
	if(beakers.len > 1)
		if(state < STATE_DETONATE)
			set_state(STATE_DETONATE)
			set_processing()
	return 1

/obj/item/device/landmine/proc/do_det_effect()

	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)
	beakers = list()

	//explosion(get_turf(src), -1, det_range / 2, det_range, det_range * 2, z_transfer = 0)

/obj/item/device/landmine/update_icon()
	. = ..()
	if(state == STATE_ACTIVE)
		alpha = 70
		blend_mode = BLEND_MULTIPLY