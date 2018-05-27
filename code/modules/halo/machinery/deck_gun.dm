#define DECK_GUN_ROUND_RELOAD_TIME 2 SECONDS//Time it takes a deck gun to reload a single round.
#define DECK_GUN_BASE_MAXROUNDS 5
#define DECK_GUN_FIRE_DELAY_LOWER 0.35 SECONDS
#define DECK_GUN_FIRE_DELAY_UPPER 0.5 SECONDS

/obj/machinery/overmap_weapon_console/deck_gun_control
	name = "Global Deck Gun Control"
	desc = "Allows simultaneous control of all connected deck guns via local consoles."
	icon = 'code/modules/halo/machinery/deck_gun.dmi'
	icon_state = "deck_gun_control_global"
	anchored = 1
	density = 1
	var/control_tag = null//Unique identifier tag so gun control consoles don't get linked cross-ship

/obj/machinery/overmap_weapon_console/deck_gun_control/New()
	if(isnull(control_tag))
		control_tag = "deck_gun_control - [z]"

/obj/machinery/overmap_weapon_console/deck_gun_control/aim_tool_attackself(var/mob/user)
	for(var/obj/machinery/overmap_weapon_console/ctrl in linked_devices)
		ctrl.aim_tool_attackself(user)

/obj/machinery/overmap_weapon_console/deck_gun_control/scan_linked_devices()
	var/list/devices = list()
	for(var/obj/machinery/overmap_weapon_console/deck_gun_control/local/ctrl in world)
		if(ctrl.control_tag == control_tag)
			devices += ctrl
	linked_devices = devices

/obj/machinery/overmap_weapon_console/deck_gun_control/fire(var/atom/target,var/mob/living/user,var/click_params)
	scan_linked_devices()
	for(var/obj/machinery/overmap_weapon_console/deck_gun_control/console in linked_devices)
		console.fire(target,user,click_params)//Fire with all linked consoles.

/obj/machinery/overmap_weapon_console/deck_gun_control/local
	name = "Local Deck Gun Control"
	desc = "A control console to allow for local override of a single set of deck guns"
	requires_ammo = 1
	var/currently_firing = 0 //Has a fire-order been given recently?
	var/area/deck_gun_area = null //Area-defines to scan for deck guns.

/obj/machinery/overmap_weapon_console/deck_gun_control/local/scan_linked_devices()
	var/list/devices = list()
	var/area/dg_area = locate(deck_gun_area) in world
	if(dg_area)
		for(var/obj/machinery/deck_gun/dg in dg_area.contents)
			devices += dg
	linked_devices = devices

/obj/machinery/overmap_weapon_console/deck_gun_control/local/consume_loaded_ammo(var/mob/user)
	var/list/valid_deck_guns = list()
	for(var/obj/machinery/deck_gun/dg in linked_devices)
		if(dg.can_fire())
			valid_deck_guns += dg.return_list_addto() //Return a list of guns that can fire. For fire-animation and ammo-depletion purposes.
	if(valid_deck_guns.len > 0)
		return valid_deck_guns
	return 0

/obj/machinery/overmap_weapon_console/deck_gun_control/local/can_fire(var/atom/target,var/mob/user)
	. = ..()
	if(currently_firing)
		to_chat(user,"<span class = 'warning'>Control console still processing last fire-order.</span>")
		return 0

/obj/machinery/overmap_weapon_console/deck_gun_control/local/fire(var/atom/target,var/mob/living/user,var/click_params)
	scan_linked_devices()
	if(!can_fire(target,user,click_params))
		return 0
	var/obj/overmap_sector = map_sectors["[z]"]
	var/directly_above = 0
	if(target.loc == overmap_sector.loc)
		directly_above = 1
	var/list/available_deck_guns = consume_loaded_ammo()

	currently_firing = 1
	for(var/obj/machinery/deck_gun/gun in available_deck_guns)
		if(gun.can_fire(target,user,click_params))
			gun.rounds_loaded--
			gun.next_reload_time = world.time + DECK_GUN_ROUND_RELOAD_TIME
			fired_projectile = gun.fired_projectile
			gun.do_fire_animation()
			fire_sound = gun.fire_sound
			fire_projectile(target,user,directly_above)
			sleep(rand(DECK_GUN_FIRE_DELAY_LOWER,DECK_GUN_FIRE_DELAY_UPPER))
	fire_sound = initial(fire_sound)
	fired_projectile = initial(fired_projectile)
	currently_firing = 0
	return 1

/obj/machinery/deck_gun
	name = "Deck Gun"
	desc = "The firing mechanism of a deck gun."
	icon = 'code/modules/halo/machinery/deck_gun.dmi'
	icon_state = "deck_gun"
	anchored = 1
	var/sound/fire_sound = 'code/modules/halo/sounds/deck_gun_fire.ogg'
	var/obj/item/projectile/overmap/fired_projectile = /obj/item/projectile/overmap/deck_gun_proj
	var/round_reload_time = DECK_GUN_ROUND_RELOAD_TIME //Time it takes to reload a single round.
	var/next_reload_time = 0
	var/rounds_loaded = DECK_GUN_BASE_MAXROUNDS
	var/max_rounds_loadable = DECK_GUN_BASE_MAXROUNDS

/obj/machinery/deck_gun/process()
	if(world.time > next_reload_time && next_reload_time != 0)
		reload_gun()
		next_reload_time = world.time + round_reload_time

/obj/machinery/deck_gun/proc/do_fire_animation()
	flick("[icon_state]_fire",src)

/obj/machinery/deck_gun/proc/return_list_addto()
	return list(src,src)

/obj/machinery/deck_gun/proc/reload_gun()
	var/new_rounds = ++rounds_loaded
	if(new_rounds > max_rounds_loadable)
		next_reload_time = 0
		rounds_loaded = max_rounds_loadable
		GLOB.processing_objects -= src
	else
		rounds_loaded = new_rounds

/obj/machinery/deck_gun/proc/can_fire()
	if(rounds_loaded > 0)
		return 1
	GLOB.processing_objects += src
	if(next_reload_time == 0)
		next_reload_time = world.time + round_reload_time
	return 0

/obj/machinery/deck_gun/chaingun
	name = "Deck Chaingun"
	desc = "A deck gun modified to fire multiple times per fire-input."
	icon = 'code/modules/halo/machinery/deck_chaingun.dmi'
	icon_state = "deck_gatling3"
	max_rounds_loadable = 12
	rounds_loaded = 12

/obj/machinery/deck_gun/chaingun/can_fire()
	. = ..()
	if(.)
		icon_state = "[initial(icon_state)]_spin"
	icon_state = "[initial(icon_state)]"

/obj/machinery/deck_gun/chaingun/return_list_addto()
	return list(src,src,src,src,src,src) //Instead of once, fire us 6 times.

//PROJECTILE DEFINES//
/obj/item/projectile/deck_gun_damage_proj
	name = "bullet"
	desc = "oh hello"

	step_delay = 0.1 SECONDS
	damtype = BRUTE
	damage = 200

/obj/item/projectile/deck_gun_damage_proj/get_structure_damage()
	return damage * 10 //Counteract the /10 from wallcode damage processing.

/obj/item/projectile/deck_gun_damage_proj/Bump(var/atom/impacted)
	var/turf/simulated/wall/wall = impacted
	if(istype(wall) && wall.reinf_material)
		damage *= wall.reinf_material.brute_armor //negates the damage loss from reinforced walls
	. = ..()

/obj/item/projectile/overmap/deck_gun_proj
	name = "deck gun round"
	desc = "thanks for examining this"
	step_delay = 0.3 SECONDS
	accuracy = 50 //miss chance of impacted overmap objects halved.
	ship_damage_projectile = /obj/item/projectile/deck_gun_damage_proj

/obj/item/projectile/overmap/deck_gun_proj/New()
	. = ..()
	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)

/obj/item/projectile/overmap/deck_gun_proj/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	if(prob(15)) //It's a deck-gun round. Small chance it doesn't burn up in-atmosphere and lands harmlessly
		var/turf/turf_spawn_debris = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
		new /obj/item/weapon/material/shard/shrapnel (turf_spawn_debris)
		new /obj/item/stack/material/steel/ten (turf_spawn_debris)
