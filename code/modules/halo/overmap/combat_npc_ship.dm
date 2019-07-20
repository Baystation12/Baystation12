
#define ON_PROJECTILE_HIT_MESSAGES list(\
"F-H-419; Taking fire!","Multiple hull breaches!",\
"Engineering's losing air... Sealed. How many did we lose?","Get the weapons back up!","Fire, Fire!",\
"Life support's barely working! We could do with some assistance!",\
"The fuck was that?","Helmsman, dodge or die!"\
)
#define ON_DEATH_MESSAGES list(\
"FUCK! REACTOR'S CRITICAL, REPEAT: REAC-","WE'RE LOSING ATMOSPHERIC INTEGRITY, NEED IMMEDIATE ASSIS-","CRITICAL HULL INTEGRITY! WE'RE LOSing air fast ..."\
)
#define TARGET_LOSE_INTEREST_DELAY 5 MINUTES

/obj/effect/overmap/ship/npc_ship/combat
	name = "Combat Ship"
	desc=  "A ship specialised for combat."

	hull = 3000 //Hardier than a civvie ship.
	var/atom/target

	var/target_range_from = 3 //Amount of tiles away from target ship will circle.

	messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	messages_on_death = ON_DEATH_MESSAGES

	var/next_fireat = 0
	var/list/projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.05 SECONDS) //Associated list: [projectile type]=[fire_delay]
	var/target_disengage_at = 0

	available_ship_requests = newlist(/datum/npc_ship_request/halt,/datum/npc_ship_request/fire_on_target)

/obj/effect/overmap/ship/npc_ship/combat/ship_targetedby_defenses()
	target_disengage_at = 1
	target_loc = pick(GLOB.overmap_tiles_uncontrolled)

/obj/effect/overmap/ship/npc_ship/combat/proc/fire_at_target()
	if(is_player_controlled())
		return
	if(target_disengage_at == 0)
		target_disengage_at = world.time + TARGET_LOSE_INTEREST_DELAY
	if(target_disengage_at != 0 && world.time > target_disengage_at)
		radio_message(null,"They must be disabled now! Disengaging.")
		target = null
		target_disengage_at = 0
		return

	var/cumulative_delay = 0
	for(var/proj_type in projectiles_to_fire)
		var/fire_delay = projectiles_to_fire[proj_type]
		var/obj/item/projectile/proj_fired = new proj_type(loc)
		proj_fired.launch(target)
		cumulative_delay += fire_delay
		sleep(fire_delay)

	next_fireat = world.time + cumulative_delay

/obj/effect/overmap/ship/npc_ship/combat/process()
	if(hull <= initial(hull)/4)
		return
	if(is_player_controlled())
		return ..()
	if(target && (target in view(7,src)))
		if(world.time > next_fireat)
			var/obj/effect/overmap/ship/npc_ship/targ_ship = target
			if(istype(targ_ship))
				if(targ_ship.hull > initial(targ_ship.hull)/4)
					fire_at_target()
			else
				fire_at_target()
		var/list/target_locs = view(target_range_from,target)-view(target_range_from-1,target)
		if(target_locs.len > 0)
			target_loc = pick(target_locs) //Let's emulate a "circling" behaviour.
	..()

/obj/effect/overmap/ship/npc_ship/combat/take_projectiles(var/obj/item/projectile/overmap/proj)
	target = proj.overmap_fired_by
	target_disengage_at = world.time + TARGET_LOSE_INTEREST_DELAY
	for(var/obj/effect/overmap/ship/npc_ship/combat/ship in range(7,src))
		if(ship.faction == faction && !(ship.target))
			ship.target = target
			ship.target_disengage_at = target_disengage_at
	. = ..()

/obj/item/projectile/overmap/mac/npc
	damage = 250 //1/4 the damage of the bertels' MAC

/obj/item/projectile/overmap/beam/npc
	damage = 500

//UNSC//
/obj/effect/overmap/ship/npc_ship/combat/unsc
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/prowler.dmi','code/modules/halo/icons/overmap/corvette.dmi')
	faction = "UNSC"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt/unsc,/datum/npc_ship_request/fire_on_target/unsc)

/obj/effect/overmap/ship/npc_ship/combat/unsc/generate_ship_name()
	. = ..()
	name = "UNSC [name]"

/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 2.5 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 2 SECONDS, /obj/item/projectile/overmap/mac/npc = 15 SECONDS)

//INNIE//
/obj/effect/overmap/ship/npc_ship/combat/innie
	icon = 'code/modules/halo/icons/overmap/innie_prowler.dmi'
	faction = "Insurrection"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt_fake,/datum/npc_ship_request/halt/innie,/datum/npc_ship_request/fire_on_target/innie)

/obj/effect/overmap/ship/npc_ship/combat/innie/generate_ship_name()
	. = ..()
	if(prob(50))
		name = "URF [name]"

/obj/effect/overmap/ship/npc_ship/combat/innie/pick_ship_icon()
	if(!findtextEx(name,"URF"))
		. = ..()

/obj/effect/overmap/ship/npc_ship/combat/innie/medium_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 1 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/innie/heavily_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 0.5 SECONDS, /obj/item/projectile/overmap/mac/npc = 20 SECONDS)

//COVENANT//
/obj/effect/overmap/ship/npc_ship/combat/covenant
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/kig_missionary.dmi')
	faction = "Covenant"
	message_language = "Sangheili"
	ship_datums = list(/datum/npc_ship/cov_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt/cov,/datum/npc_ship_request/fire_on_target/cov)

/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/pulse_laser = 0.3 SECONDS,/obj/item/projectile/overmap/plas_torp = 0.5 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/pulse_laser = 0.2 SECONDS,/obj/item/projectile/overmap/plas_torp = 1 SECONDS, /obj/item/projectile/overmap/beam/npc = 25 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/flood
	messages_on_hit = list("... / - -","- / .... / -","..",".","....")
	messages_on_death = list("... / --- / ...")
	faction = "Flood"
	message_language = "Flood"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt_fake_flood)

/obj/effect/overmap/ship/npc_ship/combat/flood/load_mapfile()
	return

#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
