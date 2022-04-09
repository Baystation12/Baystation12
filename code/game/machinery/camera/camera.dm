/obj/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	layer = CAMERA_LAYER

	var/list/network = list(NETWORK_EXODUS)
	var/c_tag = null
	var/c_tag_order = 999
	var/number = 0 //camera number in area
	var/status = 1
	anchored = TRUE
	var/invuln = null
	var/bugged = 0
	var/obj/item/camera_assembly/assembly = null

	var/toughness = 5 //sorta fragile

	// WIRES
	wires = /datum/wires/camera

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0
	var/busy = 0

	var/on_open_network = 0

	var/affected_by_emp_until = 0

	var/is_helmet_cam = FALSE

/obj/machinery/camera/examine(mob/user)
	. = ..()
	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>It is completely demolished.</span>")

/obj/machinery/camera/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1

	upgradeEmpProof()
	upgradeXRay()

	to_chat(user, "\The [src] has been upgraded. It now has X-Ray capability and EMP resistance.")
	return 1

/obj/machinery/camera/apply_visual(mob/living/carbon/human/M)
	if(!M.client)
		return
	M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
	M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
	M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
	M.machine_visual = src
	return 1

/obj/machinery/camera/remove_visual(mob/living/carbon/human/M)
	if(!M.client)
		return
	M.clear_fullscreen("fishbed",0)
	M.clear_fullscreen("scanlines")
	M.clear_fullscreen("whitenoise")
	M.machine_visual = null
	return 1

/obj/machinery/camera/New()
	assembly = new(src)
	assembly.state = 4

	update_icon()

	/* // Use this to look for cameras that have the same c_tag.
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if(C != src && C.c_tag == src.c_tag && tempnetwork.len)
			to_world_log("[src.c_tag] [src.x] [src.y] [src.z] conflicts with [C.c_tag] [C.x] [C.y] [C.z]")
	*/
	if(!src.network || src.network.len < 1)
		if(loc)
			error("[src.name] in [get_area(src)] (x:[src.x] y:[src.y] z:[src.z] has errored. [src.network?"Empty network list":"Null network list"]")
		else
			error("[src.name] in [get_area(src)]has errored. [src.network?"Empty network list":"Null network list"]")
		ASSERT(src.network)
		ASSERT(src.network.len > 0)
	..()

/obj/machinery/camera/Initialize()
	. = ..()
	if(!c_tag)
		number = 1
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/camera/C in A)
				if(C == src) continue
				if(C.number)
					number = max(number, C.number+1)
			c_tag = "[A.name][number == 1 ? "" : " #[number]"]"
		invalidateCameraCache()


/obj/machinery/camera/Destroy()
	deactivate(null, 0) //kick anyone viewing out
	if(assembly)
		qdel(assembly)
		assembly = null
	return ..()

/obj/machinery/camera/Process()
	if((stat & EMPED) && world.time >= affected_by_emp_until)
		stat &= ~EMPED
		cancelCameraAlarm()
		update_icon()
		update_coverage()
	return internal_process()

/obj/machinery/camera/emp_act(severity)
	if(!isEmpProof() && prob(100/severity))
		if(!affected_by_emp_until || (world.time < affected_by_emp_until))
			affected_by_emp_until = max(affected_by_emp_until, world.time + (90 SECONDS / severity))
		else
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			update_icon()
			update_coverage()
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/camera/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage())

/obj/machinery/camera/ex_act(severity)
	if(src.invuln)
		return

	//camera dies if an explosion touches it!
	if(severity <= 2 || prob(50))
		destroy()

	..() //and give it the regular chance of being deleted outright

/obj/machinery/camera/hitby(AM as mob|obj)
	..()
	if (istype(AM, /obj))
		var/obj/O = AM
		if (O.throwforce >= src.toughness)
			visible_message("<span class='warning'><B>[src] was hit by [O].</B></span>")
		take_damage(O.throwforce)

/obj/machinery/camera/proc/setViewRange(var/num = 7)
	src.view_range = num
	cameranet.update_visibility(src, 0)

/obj/machinery/camera/physical_attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.species.can_shred(user))
		set_status(0)
		user.do_attack_animation(src)
		visible_message("<span class='warning'>\The [user] slashes at [src]!</span>")
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
		add_hiddenprint(user)
		destroy()
		return TRUE

/obj/machinery/camera/attackby(obj/item/W as obj, mob/living/user as mob)
	update_coverage()
	var/datum/wires/camera/camera_wires = wires
	// DECONSTRUCTION
	if(isScrewdriver(W))
//		to_chat(user, "<span class='notice'>You start to [panel_open ? "close" : "open"] the camera's panel.</span>")
		//if(toggle_panel(user)) // No delay because no one likes screwdrivers trying to be hip and have a duration cooldown
		panel_open = !panel_open
		user.visible_message("<span class='warning'>[user] screws the camera's panel [panel_open ? "open" : "closed"]!</span>",
		"<span class='notice'>You screw the camera's panel [panel_open ? "open" : "closed"].</span>")
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

	else if((isWirecutter(W) || isMultitool(W)) && panel_open)
		return wires.Interact(user)

	else if(isWelder(W) && (camera_wires.CanDeconstruct() || (stat & BROKEN)))
		if(weld(W, user))
			if(assembly)
				assembly.dropInto(loc)
				assembly.anchored = TRUE
				assembly.camera_name = c_tag
				assembly.camera_network = english_list(network, "Exodus", ",", ",")
				assembly.update_icon()
				assembly.dir = src.dir
				if(stat & BROKEN)
					assembly.state = 2
					to_chat(user, "<span class='notice'>You repaired \the [src] frame.</span>")
					cancelCameraAlarm()
				else
					assembly.state = 1
					to_chat(user, "<span class='notice'>You cut \the [src] free from the wall.</span>")
					new /obj/item/stack/cable_coil(src.loc, length=2)
				assembly = null //so qdel doesn't eat it.
			qdel(src)
			return

	// OTHER
	else if (can_use() && istype(W, /obj/item/paper) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = W
		var/itemname = X.name
		var/info = X.info
		to_chat(U, "You hold \a [itemname] up to the camera ...")
		for(var/mob/living/silicon/ai/O in GLOB.living_mob_list_)
			if(!O.client) continue
			if(U.name == "Unknown") to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras ...")
			else to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U];trackname=[U.name]'>[U]</a></b> holds \a [itemname] up to one of your cameras ...")
			show_browser(O, text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))

	else if(W.damtype == BRUTE || W.damtype == BURN) //bashing cameras
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (W.force >= src.toughness)
			user.do_attack_animation(src)
			visible_message("<span class='warning'><b>[src] has been [pick(W.attack_verb)] with [W] by [user]!</b></span>")
			if (istype(W, /obj/item)) //is it even possible to get into attackby() with non-items?
				var/obj/item/I = W
				if (I.hitsound)
					playsound(loc, I.hitsound, 50, 1, -1)
		take_damage(W.force)

	else
		..()

/obj/machinery/camera/proc/deactivate(user as mob, var/choice = 1)
	// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
	if(istype(user, /mob/living/silicon/ai))
		user = null

	if(choice != 1)
		return

	set_status(!src.status)
	if (!(src.status))
		if(user)
			visible_message("<span class='notice'> [user] has deactivated [src]!</span>")
		else
			visible_message("<span class='notice'> [src] clicks and shuts down. </span>")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = "[initial(icon_state)]1"
		add_hiddenprint(user)
	else
		if(user)
			visible_message("<span class='notice'> [user] has reactivated [src]!</span>")
		else
			visible_message("<span class='notice'> [src] clicks and reactivates itself. </span>")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		icon_state = initial(icon_state)
		add_hiddenprint(user)

/obj/machinery/camera/proc/take_damage(var/force, var/message)
	//prob(25) gives an average of 3-4 hits
	if (force >= toughness && (force > toughness*4 || prob(25)))
		destroy()

//Used when someone breaks a camera
/obj/machinery/camera/proc/destroy()
	set_broken(TRUE)
	wires.RandomCutAll()

	triggerCameraAlarm()
	queue_icon_update()
	update_coverage()

	//sparks
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, loc)
	spark_system.start()
	playsound(loc, "sparks", 50, 1)

/obj/machinery/camera/proc/set_status(var/newstatus)
	if (status != newstatus)
		status = newstatus
		update_coverage()

/obj/machinery/camera/check_eye(mob/user)
	if(!can_use()) return -1
	if(isXRay()) return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0

/obj/machinery/camera/on_update_icon()
	pixel_x = 0
	pixel_y = 0

	var/turf/T = get_step(get_turf(src), turn(src.dir, 180))
	if(istype(T, /turf/simulated/wall))
		if(dir == SOUTH)
			pixel_y = 21
		else if(dir == WEST)
			pixel_x = 10
		else if(dir == EAST)
			pixel_x = -10

	if (!status || (stat & BROKEN))
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = initial(icon_state)

/obj/machinery/camera/proc/triggerCameraAlarm(var/duration = 0)
	alarm_on = 1
	GLOB.camera_alarm.triggerAlarm(loc, src, duration)

/obj/machinery/camera/proc/cancelCameraAlarm()
	if(wires.IsIndexCut(CAMERA_WIRE_ALARM))
		return

	alarm_on = 0
	GLOB.camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & (EMPED|BROKEN))
		return 0
	return 1

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(!pos)
		return list()

	if(isXRay())
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/simulated/wall/T = null
	for(var/i = 1, i <= 8; i += i)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			//If someone knows a better way to do this, let me know. -Giacom
			switch(i)
				if(NORTH)
					src.set_dir(SOUTH)
				if(SOUTH)
					src.set_dir(NORTH)
				if(WEST)
					src.set_dir(EAST)
				if(EAST)
					src.set_dir(WEST)
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(var/mob/M)

	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C

	return null

/obj/machinery/camera/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)

	if(busy)
		return 0

	if(WT.remove_fuel(0, user))
		to_chat(user, "<span class='notice'>You start to weld \the [src]..</span>")
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		busy = 1
		if(do_after(user, 100, src) && WT.isOn())
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			busy = 0
			return 1

	busy = 0
	return 0

/obj/machinery/camera/proc/add_network(var/network_name)
	add_networks(list(network_name))

/obj/machinery/camera/proc/remove_network(var/network_name)
	remove_networks(list(network_name))

/obj/machinery/camera/proc/add_networks(var/list/networks)
	var/network_added
	network_added = 0
	for(var/network_name in networks)
		if(!(network_name in src.network))
			network += network_name
			network_added = 1

	if(network_added)
		update_coverage(1)

/obj/machinery/camera/proc/remove_networks(var/list/networks)
	var/network_removed
	network_removed = 0
	for(var/network_name in networks)
		if(network_name in src.network)
			network -= network_name
			network_removed = 1

	if(network_removed)
		update_coverage(1)

/obj/machinery/camera/proc/replace_networks(var/list/networks)
	if(networks.len != network.len)
		network = networks
		update_coverage(1)
		return

	for(var/new_network in networks)
		if(!(new_network in network))
			network = networks
			update_coverage(1)
			return

/obj/machinery/camera/proc/clear_all_networks()
	if(network.len)
		network.Cut()
		update_coverage(1)

/obj/machinery/camera/proc/nano_structure()
	var/cam[0]
	cam["name"] = sanitize(c_tag)
	cam["deact"] = !can_use()
	cam["camera"] = "\ref[src]"
	cam["x"] = get_x(src)
	cam["y"] = get_y(src)
	cam["z"] = get_z(src)
	return cam

// Resets the camera's wires to fully operational state. Used by one of Malfunction abilities.
/obj/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	set_broken(FALSE) // Fixes the camera and updates the icon.
	wires.CutAll()
	wires.MendAll()
	update_coverage()
