#define ACCELERATOR_OVERLAY_ICON_STATE "lrport1"
#define AMMO_LIMIT 1
#define LOAD_AMMO_DELAY 140
#define CAPACITOR_DAMAGE_AMOUNT 0.8
#define CAPACITOR_MAX_STORED_CHARGE 150000
#define CAPACITOR_RECHARGE_TIME 30 //This is in seconds.

/turf/unsimulated/floor/lava/glassed_turf
	var/cool_at = 0
	var/cooling_delay = 5 MINUTES
	var/turf_replacewith = /turf/unsimulated/floor/scorched

/turf/unsimulated/floor/lava/glassed_turf/New()
	cool_at = world.time + cooling_delay
	GLOB.processing_objects += src
	. = ..()

/turf/unsimulated/floor/lava/glassed_turf/process()
	if(world.time >= cool_at)
		GLOB.processing_objects -= src
		new turf_replacewith (locate(x,y,z))


/obj/machinery/Energy_projector
	name = "An Energy projector component."
	desc = "A component for an Energy projector."
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = ""
	density = 1
	anchored = 1


/obj/machinery/Energy_projector/cannon
	name = "Plasma projector"
	desc = "A plasma cannon capable of launching powerful plasma beams"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "lrport"

/obj/machinery/Energy_projector/energy_loader
	name = "Energy loading console"
	desc = "A console used for the loading of plasma to the cannon."
	icon_state = "covie_console"
	var/list/linked_consoles = list()
	var/list/contained_rounds = list()
	var/loading = 0

/obj/machinery/Energy_projector/energy_loader/proc/update_ammo()
	for(var/obj/machinery/overmap_weapon_console/console in linked_consoles)
		for(var/obj/round in contained_rounds)
			if(round in console.loaded_ammo)
				continue
			console.loaded_ammo += round

/obj/machinery/Energy_projector/energy_loader/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[contained_rounds.len]/[AMMO_LIMIT] plasma charges loaded.</span>")

/obj/machinery/Energy_projector/energy_loader/attack_hand(var/mob/user)
	if(loading)
		return
	if(contained_rounds.len >= AMMO_LIMIT)
		to_chat(user,"<span class = 'notice'>The Energy projector cannot load any more plasma.</span>")
		return
	visible_message("[user] activates the projector's loading mechanism.")
	loading = 1
	playsound(loc, 'code/modules/halo/overmap/weapons/mac_gun_load.ogg', 100,1, 255)
	spawn(140) //Loading sound take 70 seconds to complete
		var/obj/new_round = new /obj/overmap_weapon_ammo/Projector_laser
		contents += new_round
		contained_rounds += new_round
		loading = 0

/obj/machinery/overmap_weapon_console/Projector
	name = "Energy Fire Control"
	desc = "A console used to control the firing of powerful plasma beams"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "covie_console"
	fire_sound = 'code/modules/halo/sounds/pulse_turret_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/beam
	requires_ammo = 1 //RESET THIS TO 1 WHEN TESTING DONE

/obj/machinery/overmap_weapon_console/Projector/proc/clear_linked_devices()
	for(var/obj/machinery/Energy_projector/energy_loader/loader in linked_devices)
		loader.linked_consoles -= src
	linked_devices.Cut()

/obj/machinery/overmap_weapon_console/Projector/scan_linked_devices()
	var/devices_left = 1
	var/list/new_devices = list()
	clear_linked_devices()
	for(var/obj/machinery/Energy_projector/projector_device in orange(5,src))
		new_devices += projector_device
	if(new_devices.len == 0)
		devices_left = 0
	while(devices_left)
		var/start_len = new_devices.len
		for(var/obj/new_device in new_devices)
			for(var/obj/machinery/Energy_projector/adj_device in orange(5,new_device))
				if(!(adj_device in linked_devices) && !(adj_device in new_devices))
					new_devices += adj_device
		if(new_devices.len == start_len)
			devices_left = 0
	linked_devices = new_devices
	for(var/obj/machinery/Energy_projector/energy_loader/loader  in linked_devices)
		loader.linked_consoles += src
		loader.update_ammo()

/obj/machinery/overmap_weapon_console/Projector/proc/do_power_check(var/mob/user)
	var/overall_stored_charge = list(0,0)//Contains the current and maximum possible stored charge. Format: (Current,Max)
	for(var/obj/machinery/mac_cannon/capacitor/capacitor in linked_devices)
		overall_stored_charge[1] += capacitor.capacitor[1]
		overall_stored_charge[2] += capacitor.capacitor[2]
		capacitor.restart_power_drain()
	if(overall_stored_charge[1] < overall_stored_charge[2])
		to_chat(user,"<span class = 'warning'>The plasma batteries are not sufficiently charged to fire!</span>")
		return 0
	return 1

/obj/machinery/overmap_weapon_console/Projector/proc/acceleration_rail_effects()
	for(var/obj/machinery/Energy_projector/cannon/E in linked_devices)
		E.overlays += image(icon,icon_state = ACCELERATOR_OVERLAY_ICON_STATE)
		spawn(5)
			E.overlays.Cut()

/obj/machinery/overmap_weapon_console/Projector/consume_external_ammo()
	var/obj/to_remove = loaded_ammo[loaded_ammo.len]
	for(var/obj/machinery/Energy_projector/energy_loader/loader in linked_devices)
		if(to_remove in loader.contained_rounds)
			loader.contained_rounds -= to_remove
	loaded_ammo -= to_remove
	qdel(to_remove)

/obj/machinery/overmap_weapon_console/Projector/fire(atom/target,var/mob/user)
	scan_linked_devices()
	if(!do_power_check(user))
		return

	. = ..()

	if(.)
		play_fire_sound()
		acceleration_rail_effects()
		if(istype(target,/obj/effect/overmap))
			play_fire_sound(target)
//------------------------------------------------------------------------------------------------------//
/obj/machinery/Energy_projector/plasma_battery
	name = "Plasma battery"
	desc = "A battery full of plasma used to power the energy projector"
	icon_state = "drained"

	var/list/capacitor = list(0,CAPACITOR_MAX_STORED_CHARGE) //Format: (Current, MAX)
	//Each capacitor contributes a certain amount of damage, modeled after the frigate's MAC.
	var/recharging = 0

/obj/machinery/Energy_projector/plasma_battery/examine(var/mob/user)
	. =..()
	if(capacitor[1] == capacitor[2])
		to_chat(user,"<span class = 'warning'>[name]'s coils crackle and hum, electricity periodically arcing between them.</span>")

/obj/machinery/Energy_projector/plasma_battery/proc/draw_powernet_power(var/amount)
	var/area/area_contained = loc.loc
	if(!istype(area_contained))
		return
	var/datum/powernet/area_powernet = area_contained.apc.terminal.powernet
	if(isnull(area_powernet))
		return
	return area_powernet.draw_power(amount)

/obj/machinery/Energy_projector/plasma_battery/proc/restart_power_drain()
	if(capacitor[1] == capacitor[2])
		return
	recharging = 1

/obj/machinery/Energy_projector/plasma_battery/process()
	if(recharging && (world.time > recharging))
		var/drained = draw_powernet_power(CAPACITOR_MAX_STORED_CHARGE/CAPACITOR_RECHARGE_TIME)
		var/new_stored = capacitor[1] + drained
		if(new_stored > capacitor[2])
			capacitor[1] = capacitor[2]
			recharging = 0
			icon_state = "full"
			return
		else
			icon_state="in_use"
			capacitor[1] = new_stored
		recharging = world.time + 1 SECOND

/obj/item/projectile/overmap/beam
	name = "Super laser"
	desc = "An incredibly hot beam of pure light"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
	icon_state = "pulse_mega_proj"
	damage = 2000
	ship_damage_projectile = /obj/item/projectile/projector_laser_damage_proj
	step_delay = 0.0 SECONDS
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 2 SECONDS
	ship_hit_sound = 'code/modules/halo/sounds/om_proj_hitsounds/eprojector_hit_sound.wav'

/obj/item/projectile/overmap/beam/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	if(initial(kill_count) - kill_count > 1)
		console_fired_by.visible_message("<span class = 'notice'>[console_fired_by] emits a warning: \"Beam impact dissipated due to atmospheric interference. Orbit the object to perform glassing.\"</span>")
		return
	hit.glassed += 1
	for(var/mob/m in GLOB.mobs_in_sectors[hit])
		to_chat(m,"<span class = 'danger'>A wave of heat washes over you as the atmosphere boils and the ground liquefies. [hit] is being glassed!</span>")
	var/turf/turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	if(istype(turf_to_explode,/turf/simulated/open)) // if the located place is an open space it goes to the next z-level
		var/prev_index = hit.map_z.Find(z_level)
		if(hit.map_z.len > 1 && prev_index != 1)
			z_level = hit.map_z[prev_index++]
			turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)

	for(var/turf/simulated/F in circlerange(turf_to_explode,25))
		if(!istype(F,/turf/simulated/open) && !istype(F,/turf/unsimulated/floor/lava) && !istype(F,/turf/space))
			if(hit.map_z.Find(z_level) < hit.map_z.len)
				var/turf/under_loc = GetBelow(F)
				if(istype(under_loc,/turf/simulated/floor) || istype(under_loc,/turf/unsimulated))
					F.ChangeTurf(/turf/simulated/open)
					under_loc.ChangeTurf(/turf/unsimulated/floor/lava/glassed_turf)
				else
					F.ChangeTurf(/turf/unsimulated/floor/lava/glassed_turf)
			else
				F.ChangeTurf(/turf/unsimulated/floor/lava/glassed_turf)


/obj/effect/projectile/projector_laser_proj
	icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
	icon_state = "pulse_mega_proj"

/obj/item/projectile/projector_laser_damage_proj
	name = "laser"
	desc = "An incredibly hot beam of pure light"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret.dmi'
	icon_state = ""
	alpha = 0
	damage = 900
	penetrating = 8
	step_delay = 0.0 SECONDS
	kill_count = 999 //so it doesn't despawn before cutting through the ship
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 5 SECONDS
	var/warned = 0

/obj/item/projectile/projector_laser_damage_proj/attack_mob()
	damage_type = BURN
	damtype = BURN
	. = ..()

/obj/item/projectile/projector_laser_damage_proj/Bump(var/atom/impacted)
	var/turf/simulated/wall/wall = impacted
	if(istype(wall) && wall.reinf_material)
		damage *= wall.reinf_material.brute_armor //negates the damage loss from reinforced walls
	. = ..()


/obj/item/projectile/projector_laser_damage_proj/check_penetrate(var/atom/a)
	. = ..()
	explosion(a,2,3,4,5, adminlog = 0)
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
