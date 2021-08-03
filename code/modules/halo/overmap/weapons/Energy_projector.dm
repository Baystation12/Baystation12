
#define OBJECTS_UNGLASSABLE list(/obj/machinery/computer/capture_node)

/turf/unsimulated/floor/lava/glassed_turf
	var/cool_at = 0
	var/cooling_delay = 2.5 MINUTES
	var/turf_replacewith = /turf/unsimulated/floor/scorched

/turf/unsimulated/floor/lava/glassed_turf/New()
	cool_at = world.time + cooling_delay
	GLOB.processing_objects += src
	. = ..()

/turf/unsimulated/floor/lava/glassed_turf/process()
	if(world.time >= cool_at)
		GLOB.processing_objects -= src
		ChangeTurf(turf_replacewith)

/turf/unsimulated/floor/lava/glassed_turf/to_space
	turf_replacewith = /turf/space
	cooling_delay = 1 MINUTE

/obj/machinery/mac_cannon/ammo_loader/energy_projector
	weapon_name = "Energy Projector"
	name = "Energy loading console"
	desc = "A console used for the loading of plasma to the cannon."
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "covie_console"
	ammo_cap = 1

/obj/machinery/mac_cannon/accelerator/energy_projector
	name = "Plasma projector"
	desc = "A plasma cannon capable of launching powerful plasma beams"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "lrport"

/obj/machinery/mac_cannon/capacitor/energy_projector
	name = "Plasma battery"
	desc = "A battery full of plasma used to power the energy projector"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "drained"

/obj/machinery/overmap_weapon_console/mac/energy_projector
	name = "Energy Fire Control"
	desc = "A console used to control the firing of powerful plasma beams"
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "covie_console"
	fire_sound = 'code/modules/halo/sounds/pulse_turret_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/beam
	requires_ammo = 1
	accelerator_overlay_icon_state = "lrport1"

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/energy_projector
	name = "Energy Projector Orbital Cleansing Console"
	desc = "Controls the firing of the Energy Projector on a lower power setting to allow for concentrated cleansing of manually designated targets."
	icon = 'code/modules/halo/overmap/weapons/plasma_cannon.dmi'
	icon_state = "covie_console"
	fire_sound = 'code/modules/halo/sounds/pulse_turret_fire.ogg'
	designator_spawn = /obj/item/weapon/laser_designator/covenant

/obj/machinery/overmap_weapon_console/mac/orbital_bombard/energy_projector/bombard_impact(var/turf/bombard)
	var/obj/item/projectile/overmap/beam/b = new (loc)
	b.do_glassing_effect(bombard,3)
	qdel(b)

/obj/item/projectile/overmap/beam
	name = "Super laser"
	desc = "An incredibly hot beam of pure light"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
	icon_state = "pulse_mega_proj"
	damage = 1250
	ship_damage_projectile = /obj/item/projectile/projector_laser_damage_proj
	step_delay = 0.0 SECONDS
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 2 SECONDS
	ship_hit_sound = 'code/modules/halo/sounds/om_proj_hitsounds/eprojector_hit_sound.wav'

/obj/item/projectile/overmap/beam/proc/do_glassing_effect(var/turf/to_glass,var/glass_radius = 20,var/glassed_turf_use = /turf/unsimulated/floor/lava/glassed_turf)
	if(istype(to_glass,/turf/simulated/open)) // if the located place is an open space it goes to the next z-level
		to_glass = GetBelow(to_glass)
	if(isnull(to_glass))
		return
	spawn() //Let's not hold the entire server hostage as we do this
		for(var/turf/simulated/F in circlerange(to_glass,glass_radius))
			if(!istype(F,/turf/unsimulated/floor/lava) && !istype(F,/turf/space))
				if(!isnull(GetBelow(F)))
					var/turf/under_loc = GetBelow(F)
					if(istype(under_loc,/turf/simulated/floor) || istype(under_loc,/turf/unsimulated))
						F.ChangeTurf(/turf/simulated/open)
						under_loc.ChangeTurf(glassed_turf_use)
					else
						F.ChangeTurf(glassed_turf_use)
				else
					F.ChangeTurf(glassed_turf_use)
				for(var/atom/a in F.contents)
					if(a.type in OBJECTS_UNGLASSABLE)
						continue
					F.Entered(a,F) //Make the lava do it's thing, then just delete it.
					if(a)
						qdel(a)

/obj/item/projectile/overmap/beam/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	if(initial(kill_count) - kill_count > 1)
		console_fired_by.visible_message("<span class = 'notice'>[console_fired_by] emits a warning: \"Beam impact dissipated due to atmospheric interference. Orbit the object to perform glassing.\"</span>")
		return
	if(!hit.CanUntargetedBombard(console_fired_by))
		return
	hit.glassed += 1
	hit.update_icon()
	for(var/mob/m in GLOB.mobs_in_sectors[hit])
		to_chat(m,"<span class = 'danger'>A wave of heat washes over you as the atmosphere boils and the ground liquefies. [hit] is being glassed!</span>")
	var/turf/turf_to_explode = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	do_glassing_effect(turf_to_explode)

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
	penetrating = 2
	step_delay = 0.0 SECONDS
	kill_count = 999 //so it doesn't despawn before cutting through the ship
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 5 SECONDS
	var/warned = 0
	var/obj/item/projectile/overmap/beam/glass_effect_beam

/obj/item/projectile/projector_laser_damage_proj/attack_mob()
	damage_type = BURN
	damtype = BURN
	. = ..()

/obj/item/projectile/projector_laser_damage_proj/check_penetrate(var/atom/a)
	. = ..()
	if(isnull(glass_effect_beam))
		glass_effect_beam = new
	explosion(get_turf(a),-1,-1,2,5, adminlog = 0)
	glass_effect_beam.do_glassing_effect(a,3,/turf/unsimulated/floor/lava/glassed_turf/to_space)//Value of 3 chosen due to min light damage radius of MACs
	if(!warned)
		warned = 1
		var/obj/effect/overmap/sector/S = map_sectors["[src.z]"]
		S.adminwarn_attack()

/obj/item/projectile/projector_laser_damage_proj/Destroy()
	. = ..()
	qdel(glass_effect_beam)

#undef AMMO_LIMIT
#undef ACCELERATOR_OVERLAY_ICON_STATE
#undef LOAD_AMMO_DELAY
#undef CAPACITOR_DAMAGE_AMOUNT
#undef CAPACITOR_MAX_STORED_CHARGE
#undef CAPACITOR_RECHARGE_TIME

#undef OBJECTS_UNGLASSABLE