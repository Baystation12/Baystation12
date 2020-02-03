/obj/machinery/overmap_weapon_console/deck_gun_control/cov_pulse_turret
	name = "Pulse Turret Control"
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"

/obj/machinery/overmap_weapon_console/deck_gun_control/cov_pulse_turret/New()
	if(isnull(control_tag))
		control_tag = "cov_pulse_turrets - [z]"
	. = ..()

/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turret
	name = "Pulse Turret Local Control"
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"
	fire_sound = 'code/modules/halo/sounds/pulse_turret_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/pulse_laser
	deck_gun_area = null

/obj/machinery/overmap_weapon_console/deck_gun_control/local/cov_pulse_turret/New()
	if(isnull(control_tag))
		control_tag = "cov_pulse_turrets - [z]"
	. = ..()

/obj/machinery/deck_gun/cov_pulse_turret
	name = "Pulse Turret"
	desc = "Fires beams of pure light at opposing vessels"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret.dmi'
	icon_state = "pulse_turret_2"
	fire_sound = 'code/modules/halo/sounds/pulse_turret_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/pulse_laser
	round_reload_time = 5 SECONDS
	rounds_loaded = 1
	max_rounds_loadable = 1
	tag_prefix = "cov_pulse_turrets"

/obj/machinery/deck_gun/cov_pulse_turret/return_list_addto()
	return list(src)

//Projectiles//
/obj/item/projectile/overmap/pulse_laser
	name = "laser"
	desc = "An incredibly hot beam of pure light"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret.dmi'
	icon_state = ""
	damage = 50
	ship_damage_projectile = /obj/item/projectile/pulse_laser_damage_proj
	step_delay = 0.0 SECONDS
	tracer_type = /obj/effect/projectile/pulse_laser_proj
	tracer_delay_time = 2 SECONDS
	ship_hit_sound = 'code/modules/halo/sounds/om_proj_hitsounds/plaser_hit_sound.wav'

/obj/item/projectile/overmap/pulse_laser/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)

/obj/effect/projectile/pulse_laser_proj
	icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
	icon_state = "pulse_proj"

/obj/item/projectile/pulse_laser_damage_proj
	name = "laser"
	desc = "An incredibly hot beam of pure light"
	icon = 'code/modules/halo/overmap/weapons/pulse_turret.dmi'
	icon_state = ""
	alpha = 0
	damage = 300
	penetrating = 2
	step_delay = 0.0 SECONDS
	kill_count = 999 //so it doesn't despawn before cutting through the ship
	tracer_type = /obj/effect/projectile/pulse_laser_dam_proj
	tracer_delay_time = 2 SECONDS
	var/warned = 0

/obj/item/projectile/pulse_laser_damage_proj/attack_mob()
	damage_type = BURN
	damtype = BURN
	. = ..()

/obj/item/projectile/pulse_laser_damage_proj/Bump(var/atom/impacted)
	if(!istype(impacted,/obj/effect/shield))
		explosion(impacted,-1,-1,1,3, adminlog = 0)

/obj/effect/projectile/pulse_laser_dam_proj
	icon = 'code/modules/halo/overmap/weapons/pulse_turret_tracers.dmi'
	icon_state = "pulse_dam_proj"

