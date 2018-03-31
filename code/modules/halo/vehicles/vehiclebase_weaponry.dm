
/obj/item/weapon/gun/vehicle_turret
	name = "Vehicle Turret"

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"
	w_class = ITEM_SIZE_LARGE
	can_rename = 0

	var/obj/vehicles/linked_vehicle
	var/obj/item/projectile/projectile_fired = /obj/item/projectile/bullet/hmg127_he //The typepath of the projectile fired by this gun.

	fire_delay = 7

	burst = 1

/obj/item/weapon/gun/vehicle_turret/New(var/vehicle)
	linked_vehicle = vehicle
	. = ..()

/obj/item/weapon/gun/vehicle_turret/dropped(var/mob/user)
	qdel(src)

//Inside-vehicle attack related procs.
/obj/item/weapon/gun/vehicle_turret/afterattack(atom/target, var/mob/living/carbon/human/user, inrange, params)
	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return
	if(!linked_vehicle.comp_prof.gunner_fire_check(user,linked_vehicle))
		user.drop_from_inventory(src)
		return
	for(var/i = 0,i<burst,i++)
	//	linked_vehicle.controller.gunner_turret_fire(user,target)
		if(i == 0) //First shot: Don't delay.
			relay_fire_action(user,target)
			continue
		spawn(burst_delay * i)
			relay_fire_action(user,target)
	next_fire_time = world.time + fire_delay

/obj/item/weapon/gun/vehicle_turret/proc/relay_fire_action(var/mob/user,var/atom/target)
	playsound(user, fire_sound, 50, 1)
	var/obj/item/projectile/new_projectile_fired = new projectile_fired
	new_projectile_fired.permutated += linked_vehicle
	new_projectile_fired.loc = pick(linked_vehicle.locs)
	new_projectile_fired.launch(target)

#undef REFILL_SUCCEED
#undef REFILL_FAIL