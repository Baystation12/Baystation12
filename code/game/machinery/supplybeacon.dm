// Used to deploy the bacon.
/obj/item/supply_beacon
	name = "inactive supply beacon"
	icon = 'icons/obj/machines/supplybeacon.dmi'
	desc = "An inactive, hacked supply beacon stamped with the Nyx Rapid Fabrication logo. Good for one (1) ballistic supply pod shipment."
	icon_state = "beacon"
	var/deploy_path = /obj/machinery/power/supply_beacon
	var/deploy_time = 30

/obj/item/supply_beacon/supermatter
	name = "inactive supermatter supply beacon"
	deploy_path = /obj/machinery/power/supply_beacon/supermatter

/obj/item/supply_beacon/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] begins setting up \the [src]."))
	if(!do_after(user, deploy_time, src, DO_PUBLIC_UNIQUE))
		return
	if(!user.unEquip(src))
		return
	var/obj/S = new deploy_path(get_turf(user))
	user.visible_message(SPAN_NOTICE("\The [user] deploys \the [S]."))
	qdel(src)

/obj/machinery/power/supply_beacon
	name = "supply beacon"
	desc = "A bulky moonshot supply beacon. Someone has been messing with the wiring."
	icon = 'icons/obj/machines/supplybeacon.dmi'
	icon_state = "beacon"

	anchored = FALSE
	density = TRUE

	var/target_drop_time
	var/drop_delay = 450
	var/expended
	var/drop_type

/obj/machinery/power/supply_beacon/New()
	..()
	if(!drop_type) drop_type = pick(supply_drop_random_loot_types())

/obj/machinery/power/supply_beacon/supermatter
	name = "supermatter supply beacon"
	drop_type = "supermatter"

/obj/machinery/power/supply_beacon/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(!use_power && isWrench(W))
		if(!anchored && !connect_to_network())
			to_chat(user, SPAN_WARNING("This device must be placed over an exposed cable."))
			return TRUE
		anchored = !anchored
		user.visible_message(SPAN_NOTICE("\The [user] [anchored ? "secures" : "unsecures"] \the [src]."))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		return TRUE
	return ..()

/obj/machinery/power/supply_beacon/physical_attack_hand(mob/user)
	if(expended)
		update_use_power(POWER_USE_OFF)
		to_chat(user, SPAN_WARNING("\The [src] has used up its charge."))
		return TRUE

	if(anchored)
		if(use_power)
			deactivate(user)
		else
			activate(user)
		return TRUE
	else
		to_chat(user, SPAN_WARNING("You need to secure the beacon with a wrench first!"))
		return TRUE

/obj/machinery/power/supply_beacon/proc/activate(mob/user)
	if(expended)
		return
	if(surplus() < 500)
		if(user) to_chat(user, SPAN_NOTICE("The connected wire doesn't have enough current."))
		return
	set_light(3, 3, "#00ccaa")
	icon_state = "beacon_active"
	update_use_power(POWER_USE_IDLE)
	admin_attacker_log(user, "has activated \a [src] at [get_area(src)]")
	if(user) to_chat(user, SPAN_NOTICE("You activate the beacon. The supply drop will be dispatched soon."))

/obj/machinery/power/supply_beacon/proc/deactivate(mob/user, permanent)
	if(permanent)
		expended = 1
		icon_state = "beacon_depleted"
	else
		icon_state = "beacon"
	set_light(0)
	update_use_power(POWER_USE_OFF)
	target_drop_time = null
	if(user) to_chat(user, SPAN_NOTICE("You deactivate the beacon."))

/obj/machinery/power/supply_beacon/Destroy()
	if(use_power)
		deactivate()
	..()

/obj/machinery/power/supply_beacon/Process()
	if(expended)
		return PROCESS_KILL
	if(!use_power)
		return
	if(draw_power(500) < 500)
		deactivate()
		return
	if(!target_drop_time)
		target_drop_time = world.time + drop_delay
	else if(world.time >= target_drop_time)
		deactivate(permanent = 1)
		var/drop_x = src.x-2
		var/drop_y = src.y-2
		var/drop_z = src.z
		command_announcement.Announce("Nyx Rapid Fabrication priority supply request #[rand(1000,9999)]-[rand(100,999)] recieved. Shipment dispatched via ballistic supply pod for immediate delivery. Have a nice day.", "Thank You For Your Patronage")
		spawn(rand(100,300))
			new /datum/random_map/droppod/supply(null, drop_x, drop_y, drop_z, supplied_drop = drop_type) // Splat.
