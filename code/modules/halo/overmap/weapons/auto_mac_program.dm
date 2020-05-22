
/datum/computer_file/program/auto_mac
	filename = "mac_control_automated"
	filedesc = "MAC Automated Fire Control"
	program_icon_state = "forensic"
	nanomodule_path = /datum/nano_module/auto_mac
	available_on_ntnet = 0
	extended_desc = "Reroutes targetted_ship and firing the onboard Magnetic Accelerator Cannon to the AI subroutines."
	size = 30

/datum/nano_module/auto_mac
	name = "MAC Automated Fire Control"
	var/datum/proximity_trigger/square/prox_trigger
	var/overmap_range = 7
	var/list/hostile_factions = list("SOE","Covenant")
	var/obj/effect/overmap/ship/targetted_ship
	var/list/target_ships = list()
	var/obj/effect/overmap/host_vessel
	var/fire_interval = 5 SECONDS
	var/next_fire_at = 0
	var/projectile_type = /obj/item/projectile/overmap/auto_defense_proj
	var/sound/fire_sound = 'code/modules/halo/overmap/weapons/mac_gun_fire.ogg'
	var/obj/machinery/overmap_weapon_console/mac/linked_manual_console
	var/list/linked_devices = list()

/datum/nano_module/auto_mac/proc/process()
	target_ship()
	attempt_fire()

/datum/nano_module/auto_mac/proc/attempt_fire()
	if(world.time > next_fire_at && targetted_ship)
		//create the projectile
		var/obj/item/projectile/overmap/fired = new projectile_type(host_vessel.loc)
		fired.permutated = host_vessel
		fired.launch(targetted_ship)

		//set a delay for the next shot
		next_fire_at = world.time + fire_interval

		//play audio feedback
		play_fire_sound(host)

		//set a timer on the manual fire control
		var/obj/machinery/overmap_weapon_console/mac/M = locate() in range(7, host)
		M.next_fire_at = world.time + M.fire_delay

/datum/nano_module/auto_mac/proc/play_fire_sound(var/atom/loc_sound_origin)
	playsound(loc_sound_origin, fire_sound, 50, 1, 5, 5,1)

/datum/nano_module/auto_mac/proc/acceleration_rail_effects()
	for(var/obj/machinery/mac_cannon/accelerator/a in linked_devices)
		a.overlays += image(icon = 'code/modules/halo/overmap/weapons/mac_cannon.dmi', icon_state = "mac_accelerator_effect")
		spawn(5)
			a.overlays.Cut()

/datum/nano_module/auto_mac/proc/target_ship()
	do
		//pick a valid target if we need to
		if(!targetted_ship)
			if(target_ships.len)
				targetted_ship = pick(target_ships)

				//remove it from the potential list
				target_ships -= targetted_ship

		//validate the targetted_ship is in range
		if(targetted_ship)
			if(get_dist(host_vessel, targetted_ship) > overmap_range)
				targetted_ship = null
			break
	while(target_ships.len)

/datum/nano_module/auto_mac/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["automatic"] = prox_trigger ? 1 : 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "auto_mac.tmpl", name, 600, 250, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/auto_mac/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(!check_access(access_unsc))
		return 1

	if(href_list["toggle_automatic"])
		if(prox_trigger)
			stop_targetting()
		else
			start_targetting(user)
		return 1

/datum/nano_module/auto_mac/proc/start_targetting(var/mob/user)
	if(prox_trigger)
		stop_targetting()

	if(!host)
		to_chat(user,"<span class='warning'>Unable to locate computer!</span>")
		return 1
	var/atom/A = host
	host_vessel = map_sectors["[A.z]"]
	if(!host_vessel)
		to_chat(user,"<span class='warning'>Unable to locate ship or station!</span>")
		return 1

	prox_trigger = new (host_vessel, /datum/nano_module/auto_mac/proc/trigger_prox, /datum/nano_module/auto_mac/proc/prox_turfs_changed, overmap_range, 0, src)
	prox_trigger.register_turfs()
	GLOB.processing_objects.Add(src)

	linked_manual_console = locate() in range(1, host)
	if(linked_manual_console)
		linked_manual_console.automated = 1

	scan_linked_devices()

	for(var/obj/effect/overmap/ship/S in range(overmap_range, host_vessel))
		trigger_prox(S)

/datum/nano_module/auto_mac/proc/scan_linked_devices()
	var/devices_left = 1
	var/list/new_devices = list()
	linked_devices = null
	for(var/obj/machinery/mac_cannon/mac_device in orange(1,src))
		new_devices += mac_device
	if(new_devices.len == 0)
		devices_left = 0
	while(devices_left)
		var/start_len = new_devices.len
		for(var/obj/new_device in new_devices)
			for(var/obj/machinery/mac_cannon/adj_device in orange(1,new_device))
				if(!(adj_device in linked_devices) && !(adj_device in new_devices))
					new_devices += adj_device
		if(new_devices.len == start_len)
			devices_left = 0
	linked_devices = new_devices

/datum/nano_module/auto_mac/proc/trigger_prox(var/atom/triggering)
	if(istype(triggering, /obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = triggering
		if(S.get_faction() in hostile_factions)
			target_ships |= S

/datum/nano_module/auto_mac/proc/prox_turfs_changed(var/list/new_turfs, var/list/old_turfs)
	//intentionally blank

/datum/nano_module/auto_mac/proc/stop_targetting()
	if(prox_trigger)
		prox_trigger.unregister_turfs()
		qdel(prox_trigger)
		prox_trigger = null
	target_ships = list()
	targetted_ship = null
	GLOB.processing_objects.Remove(src)

	if(linked_manual_console)
		linked_manual_console.automated = 0

/datum/nano_module/auto_mac/Destroy()
	stop_targetting()
	. = ..()
