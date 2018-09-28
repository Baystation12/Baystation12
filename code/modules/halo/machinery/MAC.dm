#define CAPACITOR_DAMAGE_AMOUNT 0.8
#define CAPACITOR_MAX_STORED_CHARGE 50000
#define CAPACITOR_RECHARGE_TIME 10 //This is in seconds.
#define ACCELERATOR_OVERLAY_ICON_STATE "mac_accelerator_effect"
#define MAC_AMMO_LIMIT 3

/obj/machinery/mac_cannon
	name = "MAC Component"
	desc = "A component for a MAC."
	icon = 'code/modules/halo/machinery/mac_cannon.dmi'
	icon_state = "mac_connector"
	density = 1
	anchored = 1

/obj/machinery/mac_cannon/ammo_loader
	name = "MAC ammunition loading console"
	desc = "A console used for the management of loading MAC rounds."
	icon_state = "mac_ammo_loader"
	var/list/linked_consoles = list()
	var/list/contained_rounds = list()
	var/loading = 0

/obj/machinery/mac_cannon/ammo_loader/proc/update_ammo()
	for(var/obj/machinery/overmap_weapon_console/console in linked_consoles)
		for(var/obj/round in contained_rounds)
			if(round in console.loaded_ammo)
				continue
			console.loaded_ammo += round

/obj/machinery/mac_cannon/ammo_loader/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[contained_rounds.len]/[MAC_AMMO_LIMIT] rounds loaded.</span>")

/obj/machinery/mac_cannon/ammo_loader/attack_hand(var/mob/user)
	if(loading)
		return
	if(contained_rounds.len >= MAC_AMMO_LIMIT)
		to_chat(user,"<span class = 'notice'>The MAC cannot load any more rounds.</span>")
		return
	visible_message("[user] activates the MAC's loading mechanism.")
	loading = 1
	playsound(loc, 'code/modules/halo/machinery/mac_gun_load.ogg', 100,1, 255)
	spawn(70) //Loading sound take 70 seconds to complete
		var/obj/new_round = new /obj/overmap_weapon_ammo/mac
		contents += new_round
		contained_rounds += new_round
		loading = 0

/obj/machinery/mac_cannon/accelerator
	name = "MAC accelerator rail"
	desc = "A series of massive magnets intended to accelerate a MAC round."
	icon_state = "mac_accelerator"

//MAC CANNON CAPACITOR//
/obj/machinery/mac_cannon/capacitor
	name = "MAC Capacitor"
	desc = "A powerful capacitor used to store and channel the energy required for acceleration of a MAC round."
	icon_state = "mac_capacitor"

	var/list/capacitor = list(0,CAPACITOR_MAX_STORED_CHARGE) //Format: (Current, MAX)
	//Each capacitor contributes a certain amount of damage, modeled after the frigate's MAC.
	var/recharging = 0

/obj/machinery/mac_cannon/capacitor/examine(var/mob/user)
	. =..()
	if(capacitor[1] == capacitor[2])
		to_chat(user,"<span class = 'warning'>[name]'s coils crackle and hum, electricity periodically arcing between them.</span>")

/obj/machinery/mac_cannon/capacitor/proc/draw_powernet_power(var/amount)
	var/area/area_contained = loc.loc
	if(!istype(area_contained))
		return
	var/datum/powernet/area_powernet = area_contained.apc.terminal.powernet
	if(isnull(area_powernet))
		return
	return area_powernet.draw_power(amount)

/obj/machinery/mac_cannon/capacitor/proc/restart_power_drain()
	if(capacitor[1] == capacitor[2])
		return
	recharging = 1

/obj/machinery/mac_cannon/capacitor/process()
	if(recharging && (world.time > recharging))
		var/drained = draw_powernet_power(CAPACITOR_MAX_STORED_CHARGE/CAPACITOR_RECHARGE_TIME)
		var/new_stored = capacitor[1] + drained
		if(new_stored > capacitor[2])
			capacitor[1] = capacitor[2]
			recharging = 0
			return
		else
			capacitor[1] = new_stored
		recharging = world.time + 1 SECOND

//MAC CANNON CONSOLE//
/obj/machinery/overmap_weapon_console/mac
	name = "MAC Fire Control"
	desc = "A console used to control the firing of MAC rounds in ship-to-ship combat."
	icon = 'code/modules/halo/machinery/mac_cannon.dmi'
	icon_state = "mac_fire_control"
	fire_sound = 'code/modules/halo/machinery/mac_gun_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/mac
	requires_ammo = 1 //RESET THIS TO 1 WHEN TESTING DONE

/obj/machinery/overmap_weapon_console/mac/proc/clear_linked_devices()
	for(var/obj/machinery/mac_cannon/ammo_loader/loader in linked_devices)
		loader.linked_consoles -= src
	linked_devices.Cut()

/obj/machinery/overmap_weapon_console/mac/scan_linked_devices()
	var/devices_left = 1
	var/list/new_devices = list()
	clear_linked_devices()
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
	for(var/obj/machinery/mac_cannon/ammo_loader/loader in linked_devices)
		loader.linked_consoles += src
		loader.update_ammo()

/obj/machinery/overmap_weapon_console/mac/proc/do_power_check(var/mob/user)
	var/overall_stored_charge = list(0,0)//Contains the current and maximum possible stored charge. Format: (Current,Max)
	for(var/obj/machinery/mac_cannon/capacitor/capacitor in linked_devices)
		overall_stored_charge[1] += capacitor.capacitor[1]
		overall_stored_charge[2] += capacitor.capacitor[2]
		capacitor.restart_power_drain()
	if(overall_stored_charge[1] < overall_stored_charge[2])
		to_chat(user,"<span class = 'warning'>The capacitors are not sufficiently charged to fire!</span>")
		return 0
	return 1

/obj/machinery/overmap_weapon_console/mac/proc/acceleration_rail_effects()
	for(var/obj/machinery/mac_cannon/accelerator/a in linked_devices)
		a.overlays += image(icon,icon_state = ACCELERATOR_OVERLAY_ICON_STATE)
		spawn(5)
			a.overlays.Cut()

/obj/machinery/overmap_weapon_console/mac/consume_external_ammo()
	var/obj/to_remove = loaded_ammo[loaded_ammo.len]
	for(var/obj/machinery/mac_cannon/ammo_loader/loader in linked_devices)
		if(to_remove in loader.contained_rounds)
			loader.contained_rounds -= to_remove
	loaded_ammo -= to_remove
	qdel(to_remove)

/obj/machinery/overmap_weapon_console/mac/fire(atom/target,var/mob/user)
	scan_linked_devices()
	if(!do_power_check(user))
		return

	. = ..()

	if(.)
		play_fire_sound()
		acceleration_rail_effects()
		if(istype(target,/obj/effect/overmap))
			play_fire_sound(target)

/obj/machinery/overmap_weapon_console/mac/play_fire_sound(var/obj/effect/overmap/overmap_object = map_sectors["[z]"],var/turf/loc_soundfrom = src.loc)
	if(isnull(src.fire_sound))
		return

	for(var/z_level in overmap_object.map_z)
		playsound(locate(loc_soundfrom.x,loc_soundfrom.y,z_level), src.fire_sound, 100,1, 255)

/obj/machinery/overmap_weapon_console/mac/get_linked_device_damage_mod()
	var/damage_mod = 0
	for(var/obj/machinery/mac_cannon/capacitor/cap in linked_devices)
		var/damage_capacitor = (cap.capacitor[1]/cap.capacitor[2]) * CAPACITOR_DAMAGE_AMOUNT
		damage_mod += damage_capacitor
		cap.capacitor[1] = 0
		cap.restart_power_drain()
	return damage_mod

#undef CAPACITOR_DAMAGE_AMOUNT

//MAC ORBITAL BOMBARD TYPE//
/obj/machinery/overmap_weapon_console/mac/orbital_bombard
	name = "MAC Orbital Bombardment Console"
	desc = "Controls a limited power setting for orbital bombardment"
	icon_state = "mac_bombard_control"

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/New()
	. = ..()
	var/obj/ld = new /obj/item/weapon/laser_designator (src)
	ld.loc = loc
	ld = new /obj/item/weapon/laser_designator (src)
	ld.loc = loc

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/attack_hand(var/mob/user)

	var/beacon_selection = get_beacon_from_name((input(user,"Bombardment Beacon Selection","Select a beacon to fire on.","Cancel") in get_overmap_adjacent_bombard_beacons() + list("Cancel")))

	if(isnull(beacon_selection) || beacon_selection == "Cancel")
		to_chat(user,"<span class = 'notice'>Firing sequence cancelled.</span>")
		return

	fire(beacon_selection,user)

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/proc/get_overmap_adjacent_bombard_beacons()
	var/list/adjacent_beacon_names = list()
	var/obj/current_overmap = map_sectors["[z]"]
	for(var/obj/effect/bombardment_beacon/b in world)
		if(b.linked_console != src)
			continue
		if(istype(map_sectors["[b.z]"],/obj/effect/overmap/sector) && map_sectors["[b.z]"] in orange(1,current_overmap))
			adjacent_beacon_names += b.name

	return adjacent_beacon_names

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/proc/get_beacon_from_name(var/beacon_name)
	for(var/obj/effect/bombardment_beacon/b in world)
		if(b.name == beacon_name)
			return b

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/fire_projectile()
	return

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/fire(var/atom/target,var/mob/user)
	if(!do_power_check(user))
		return

	. = ..()
	if(.)
		var/turf/target_turf = target.loc

		play_fire_sound()
		var/obj/effect/overmap/targ_overmap = map_sectors["target.z"]
		play_fire_sound(targ_overmap,target_turf)
		explosion(target_turf,4,5,6,20)

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/attackby(var/obj/item/weapon/W, var/mob/user)
	var/obj/item/weapon/laser_designator/designator = W
	if(istype(W))
		designator.creator = src
		to_chat(user,"Device linked to console. Designated targets will now be relayed for firing.")

//MAC OVERMAP PROJECTILE//
/obj/item/projectile/overmap/mac
	name = "MAC Slug"
	step_delay = 0.5 SECONDS
	ship_damage_projectile = /obj/item/projectile/mac_round

//MAC SHIPHIT PROJECTILE//
/obj/item/projectile/mac_round
	name = "MAC Slug"
	penetrating = 2

/obj/item/projectile/mac_round/check_penetrate(var/atom/impacted)
	. = ..()
	explosion(impacted,rand(2,3),rand(4,6),rand(6,8),rand(10,20))

#undef MAC_AMMO_LIMIT
#undef ACCELERATOR_OVERLAY_ICON_STATE