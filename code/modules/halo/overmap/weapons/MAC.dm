#define CAPACITOR_DAMAGE_AMOUNT 20 //5 Direct MAC shots to down a fully charged shield from a 20-capacitor MAC.
#define CAPACITOR_MAX_STORED_CHARGE 50000
#define BASE_AMMO_LIMIT 3
#define LOAD_AMMO_DELAY 70

/obj/machinery/mac_cannon
	name = "MAC Component"
	desc = "A component for a MAC."
	icon = 'code/modules/halo/overmap/weapons/mac_cannon.dmi'
	icon_state = "mac_connector"
	density = 1
	anchored = 1

/obj/machinery/mac_cannon/ammo_loader
	var/weapon_name = "MAC"
	name = "ammunition loading console"
	desc = "A console used for the management of loading ammunition"
	icon_state = "mac_ammo_loader"
	var/load_sound = 'code/modules/halo/overmap/weapons/mac_gun_load.ogg'
	var/load_delay = 7 SECONDS //This should ideally be the same length as the loading sound clip.
	var/ammo_cap = BASE_AMMO_LIMIT
	var/list/linked_consoles = list()
	var/list/contained_rounds = list()
	var/loading = 0
	ai_access_level = 4

/obj/machinery/mac_cannon/ammo_loader/New()
	name = "[weapon_name] [name]"
	. = ..()

/obj/machinery/mac_cannon/ammo_loader/proc/update_ammo()
	for(var/obj/machinery/overmap_weapon_console/console in linked_consoles)
		for(var/obj/round in contained_rounds)
			if(round in console.loaded_ammo)
				continue
			console.loaded_ammo += round

/obj/machinery/mac_cannon/ammo_loader/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[contained_rounds.len]/[ammo_cap] rounds loaded.</span>")

/obj/machinery/mac_cannon/ammo_loader/attack_hand(var/mob/user)
	if(loading)
		return
	if(contained_rounds.len >= ammo_cap)
		to_chat(user,"<span class = 'notice'>The [weapon_name] cannot load any more rounds.</span>")
		return
	visible_message("[user] activates the [weapon_name]'s loading mechanism.")
	loading = 1
	playsound(loc,load_sound, 100,1, 255)
	spawn(load_delay) //Loading sound take 7 seconds to complete
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

	var/charge_time = 10 SECONDS
	//Each capacitor contributes a certain amount of damage, modeled after the frigate's MAC.
	var/charged_at = 0

/obj/machinery/mac_cannon/capacitor/examine(var/mob/user)
	. =..()
	if(world.time >= charged_at)
		to_chat(user,"<span class = 'warning'>[name]'s coils crackle and hum, electricity periodically arcing between them.</span>")

/obj/machinery/mac_cannon/capacitor/proc/set_requires_charge()
	charged_at = world.time + charge_time

/obj/machinery/mac_cannon/capacitor/proc/is_charged()
	return world.time >= charged_at

//MAC CANNON CONSOLE//
/obj/machinery/overmap_weapon_console/mac
	name = "MAC Fire Control"
	desc = "A console used to control the firing of MAC rounds in ship-to-ship combat."
	icon = 'code/modules/halo/overmap/weapons/mac_cannon.dmi'
	icon_state = "mac_fire_control"
	fire_sound = 'code/modules/halo/overmap/weapons/mac_gun_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/mac
	requires_ammo = 1
	var/accelerator_overlay_icon_state = "mac_accelerator_effect"
	var/automated = 0

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
	for(var/obj/machinery/mac_cannon/capacitor/capacitor in linked_devices)
		if(!capacitor.is_charged())
			to_chat(user,"<span class = 'warning'>The capacitors are not sufficiently charged to fire!</span>")
			return 0
	return 1

/obj/machinery/overmap_weapon_console/mac/proc/acceleration_rail_effects()
	for(var/obj/machinery/mac_cannon/accelerator/a in linked_devices)
		a.overlays += image(icon,icon_state = accelerator_overlay_icon_state)
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

	if(automated)
		to_chat(user, "<span class='warning'>Manual fire control disabled due to automated fire control!</span>")
		return

	. = ..()

	if(.)
		play_fire_sound()
		acceleration_rail_effects()
		if(istype(target,/obj/effect/overmap))
			play_fire_sound(target)

/obj/machinery/overmap_weapon_console/mac/play_fire_sound(var/obj/effect/overmap/overmap_object = map_sectors["[z]"],var/turf/loc_soundfrom = src.loc)
	if(isnull(fire_sound) || !istype(overmap_object) || isnull(loc_soundfrom))
		return
	if(overmap_object.map_z.len ==0)
		return

	for(var/z_level in overmap_object.map_z)
		playsound(locate(loc_soundfrom.x,loc_soundfrom.y,z_level), src.fire_sound, 20,1, 255,,1)

/obj/machinery/overmap_weapon_console/mac/get_linked_device_damage_mod()
	var/damage_mod = 0
	for(var/obj/machinery/mac_cannon/capacitor/cap in linked_devices)
		damage_mod += CAPACITOR_DAMAGE_AMOUNT
		cap.set_requires_charge()
	return damage_mod

#undef CAPACITOR_DAMAGE_AMOUNT

//MAC ORBITAL BOMBARD TYPE//
/obj/machinery/overmap_weapon_console/mac/orbital_bombard
	name = "MAC Orbital Bombardment Console"
	desc = "Controls a limited power setting for orbital bombardment"
	icon_state = "mac_bombard_control"
	var/designator_spawn = /obj/item/weapon/laser_designator
	ai_access_level = 4

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/New()
	. = ..()
	var/obj/ld = new designator_spawn (loc)
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

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/proc/bombard_impact(var/atom/hit_turf)
	explosion(hit_turf,4,6,7,20, adminlog = 0)

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/fire(var/atom/target,var/mob/user)
	if(!do_power_check(user))
		return

	. = ..()
	if(.)
		var/turf/target_turf = target.loc

		play_fire_sound()
		var/obj/effect/overmap/targ_overmap = map_sectors["[target.z]"]
		play_fire_sound(targ_overmap,target_turf)
		bombard_impact(target_turf)
		targ_overmap.adminwarn_attack()

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/attackby(var/obj/item/weapon/W, var/mob/user)
	var/obj/item/weapon/laser_designator/designator = W
	if(istype(W))
		designator.creator = src
		to_chat(user,"Device linked to console. Designated targets will now be relayed for firing.")

//MAC OVERMAP PROJECTILE//
/obj/item/projectile/overmap/mac
	name = "MAC Slug"
	step_delay = 0.5
	ship_damage_projectile = /obj/item/projectile/mac_round
	ship_hit_sound = 'code/modules/halo/sounds/om_proj_hitsounds/mac_cannon_impact.wav'

//MAC SHIPHIT PROJECTILE//
/obj/item/projectile/mac_round
	name = "MAC Slug"
	penetrating = 1
	var/warned = 0

/obj/item/projectile/mac_round/check_penetrate(var/atom/impacted)
	. = ..()
	if(!.)
		return
	var/increase_from_damage = round(damage/250)
	if(increase_from_damage > 2)
		increase_from_damage -= 2
		increase_from_damage = round(increase_from_damage * 0.5)
		increase_from_damage += 2
	explosion(impacted,0 + increase_from_damage,2 + increase_from_damage,3 + increase_from_damage,4 + increase_from_damage, adminlog = 0)
	if(!warned)
		warned = 1
		var/obj/effect/overmap/sector/S = map_sectors["[src.z]"]
		S.adminwarn_attack()

#undef AMMO_LIMIT
#undef ACCELERATOR_OVERLAY_ICON_STATE
#undef LOAD_AMMO_DELAY
#undef CAPACITOR_DAMAGE_AMOUNT
#undef CAPACITOR_MAX_STORED_CHARGE
#undef CAPACITOR_RECHARGE_TIME