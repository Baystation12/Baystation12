
/obj/structure/supply_pod_dispenser
	name = "Supply Pod Dispenser"
	desc = "Dispenses supply pods."
	icon = 'code/modules/halo/vehicles/supply_unsc.dmi'
	icon_state = "mac_bombard_control"

	density = 1

	var/pod_to_spawn = /obj/vehicles/drop_pod/overmap/supply_pod
	var/pod_delay = 2 MINUTES
	var/next_pod = 0

/obj/structure/supply_pod_dispenser/attack_hand(var/mob/living/user)
	if(!istype(user))
		return
	if(world.time < next_pod)
		to_chat(user,"<span class = 'notice'>[src] is still on cooldown.</span>")
		return
	visible_message("<span class = 'notice'>[user] requisitions a supply pod</span>")
	next_pod = world.time + pod_delay
	var/turf/spawnloc = get_step(loc,dir)
	new pod_to_spawn (spawnloc)

/obj/structure/supply_pod_dispenser/covenant
	icon = 'code/modules/halo/vehicles/supply_cov.dmi'
	icon_state = "Covie Monitor"
	pod_to_spawn = /obj/vehicles/drop_pod/overmap/supply_pod/covenant

//leave this as a placeholder for now 20/1/20 -C
/datum/component_profile/drop_pod/supply_pod

/obj/vehicles/drop_pod/overmap/supply_pod
	name = "Resupply Canister, Capsule Type-B"
	desc = "Used to drop supplies to groundside troops. Should only be used in conjunction with drop-pod beacons."
	icon = 'code/modules/halo/vehicles/supply_unsc.dmi'
	icon_state = "UNSC_Supply"

	comp_prof = /datum/component_profile/drop_pod/supply_pod

	pod_range = 4
	drop_accuracy = 2
	launch_arm_time = 3 SECOND
	vehicle_size = 16

	capacity_flag = ITEM_SIZE_VEHICLE
	vehicle_carry_size = ITEM_SIZE_VEHICLE_LARGE

/obj/vehicles/drop_pod/supply_pod/update_object_sprites()
	return

/obj/vehicles/drop_pod/supply_pod/enter_as_position(var/mob/user,var/position = "passenger")
	to_chat(user,"<span class = 'notice'>[src] does not have any seats for people.</span>")
	return

/obj/vehicles/drop_pod/overmap/supply_pod/post_drop_effects(var/turf/drop_turf)
	anchored = 1
	density = 0
	. = ..()

/obj/vehicles/drop_pod/overmap/supply_pod/covenant
	name = "Resupply Case"
	icon = 'code/modules/halo/vehicles/supply_cov.dmi'
	icon_state = "Covenant_Supply"
