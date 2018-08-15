#define MISSILE_POD_PROJTYPES list(/obj/item/projectile/overmap/missile,/obj/item/projectile/overmap/missile/burrowing)

/obj/machinery/overmap_weapon_console/deck_gun_control/missile_control
	name = "Missile Control Console"

/obj/machinery/overmap_weapon_console/deck_gun_control/missile_control/New()
	if(isnull(control_tag))
		control_tag = "missile_control - [z]"

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control
	name = "Local Missile Control Console"
	fire_sound = 'code/modules/halo/sounds/deck_gun_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/missile
	deck_gun_area = null
	var/list/all_projectiles_firable = MISSILE_POD_PROJTYPES

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/aim_tool_attackself(var/mob/user)
	var/new_index = all_projectiles_firable.Find(fired_projectile) + 1
	if(new_index > all_projectiles_firable.len)
		new_index = 1
	var/obj/new_fired_projectile = all_projectiles_firable[new_index]
	for(var/obj/machinery/deck_gun/missile_pod/pod in linked_devices)
		pod.fired_projectile = new_fired_projectile
		pod.rounds_loaded = 0
	new_fired_projectile = new new_fired_projectile
	to_chat(user,"<span class = 'warning'>Missile type switched to [new_fired_projectile.name]</span>")
	qdel(new_fired_projectile)

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/New()
	if(isnull(control_tag))
		control_tag = "missile_control - [z]"

//Missile "deck gun"//
/obj/machinery/deck_gun/missile_pod
	name = "Missile Pod"
	desc = "Holds the machinery for loading and firing missiles."
	icon = 'code/modules/halo/machinery/deck_missile_pod.dmi'
	icon_state = "missile_pod"
	fire_sound = 'code/modules/halo/sounds/rocket_pod_fire.ogg'
	fired_projectile = /obj/item/projectile/overmap/missile
	round_reload_time = 25 SECONDS
	rounds_loaded = 4
	max_rounds_loadable = 4

/obj/machinery/deck_gun/missile_pod/return_list_addto()
	return list(src,src,src,src)

//Projectiles//
/obj/item/projectile/overmap/missile
	name = "missile"
	desc = "An explosive warhead on the end of a guided thruster."
	//icon = 'code/modules/halo/machinery/deck_missile_pod.dmi'
	//icon_state = "missile"
	ship_damage_projectile = /obj/item/projectile/missile_damage_proj
	step_delay = 0.75 SECOND

/obj/item/projectile/overmap/missile/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)

/obj/item/projectile/missile_damage_proj
	name = "missile"
	desc = "An explosive warhead on the end of a guided thruster."
	icon = 'code/modules/halo/machinery/deck_missile_pod.dmi'
	icon_state = "missile"

/obj/item/projectile/missile_damage_proj/on_impact(var/atom/impacted)
	explosion(loc,-1,1,3,5)
	. = ..()

/obj/item/projectile/overmap/missile/burrowing
	name = "missile (burrowing)"
	desc = "A burrowing warhead on the end of a guided thruster."
	ship_damage_projectile = /obj/item/projectile/missile_damage_proj
	step_delay = 0.75 SECOND

/obj/item/projectile/missile_damage_proj/burrowing
	name = "missile"
	desc = "An explosive warhead on the end of a guided thruster."
	damage = 200 //Same damage as a deck gun, but without the armour bypass.
	penetrating = 2

/obj/item/projectile/missile_damage_proj/Move(var/turf/new_loc,var/dir)
	if(istype(new_loc,/turf/simulated/floor))
		. = ..()
		explosion(new_loc,-1,-1.5,10)
	else
		. = ..()
