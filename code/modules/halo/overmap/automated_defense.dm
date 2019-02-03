#define AUTO_DEFENSE_LOCKON_DELAY 12 SECONDS
#define AUTO_DEFENSE_FIRE_DELAY 5 SECONDS

/obj/effect/overmap/ship/npc_ship/automated_defenses
	name = "Automated Defenses"
	icon = 'code/modules/halo/icons/overmap/human_stations.dmi'
	icon_state = "s_station_1"

	faction = "civilian"
	available_ship_requests = newlist(/datum/npc_ship_request/automated_defense_process)
	hull = 2500
	messages_on_hit = list("Automated Defense system taking hostile weapons fire.")
	messages_on_death = list("Automated Defense system has sustained critical damage. Shutting down.")
	var/defense_range = 7
	var/obj/item/projectile/overmap/proj_fired = /obj/item/projectile/overmap/auto_defense_proj

/obj/effect/overmap/ship/npc_ship/automated_defenses/Initialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(defense_range,src)

/datum/npc_ship_request/automated_defense_process
	request_auth_levels = list()
	request_requires_processing = 1
	var/obj/effect/overmap/ship/current_target
	var/obj/previous_target
	var/start_target_fire_at = 0
	var/firing_on_target = 0
	var/next_fire_at = 0

/datum/npc_ship_request/automated_defense_process/do_request_process(var/obj/effect/overmap/ship/npc_ship/automated_defenses/ship_source) //Return 1 in this to stop normal NPC ship move processing.
	if(!istype(ship_source))
		return 0
	var/list/in_range = range(ship_source.defense_range,ship_source)
	firing_on_target = 0
	if(previous_target)
		previous_target.overlays.Cut()
	if(current_target)
		current_target.overlays.Cut()
		if(current_target in in_range)
			if(start_target_fire_at != 0 && world.time > start_target_fire_at)
				firing_on_target = 1
				current_target.overlays += icon('icons/effects/Targeted.dmi',"locked")
			else
				current_target.overlays += icon('icons/effects/Targeted.dmi',"locking")
				if(start_target_fire_at == 0)
					start_target_fire_at = world.time + AUTO_DEFENSE_LOCKON_DELAY
		else
			start_target_fire_at = 0

	if(firing_on_target)
		if(world.time > next_fire_at)
			var/obj/item/projectile/overmap/fired = new ship_source.proj_fired (ship_source.loc)
			fired.permutated = ship_source
			fired.launch(current_target)
			previous_target = current_target
			current_target = null
			next_fire_at = world.time + AUTO_DEFENSE_FIRE_DELAY
	else
		var/list/unauthed_ships = list()
		for(var/obj/effect/overmap/ship in in_range)
			if(ship.get_faction() != "civilian" && ship.get_faction() != ship_source.get_faction())
				unauthed_ships += ship
		if(unauthed_ships.len == 0)
			return 1
		current_target = pick(unauthed_ships)
		var/obj/effect/overmap/ship/npc_ship/npc = current_target
		if(istype(npc))
			npc.ship_targetedby_defenses()
		if(current_target == previous_target)
			start_target_fire_at = world.time //Don't need to lock on again if it's the same ship.

	return 1

/obj/item/projectile/overmap/auto_defense_proj
	name = "SMAC Round"
	desc = "A massive ferromagnetic slug propelled to ludicrous speeds."
	ship_hit_sound = 'code/modules/halo/sounds/om_proj_hitsounds/mac_cannon_impact.wav'
	step_delay = 0.5
	ship_damage_projectile = /obj/item/projectile/auto_defense_proj


/obj/item/projectile/overmap/auto_defense_proj/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	return

/obj/item/projectile/overmap/auto_defense_proj/covenant
	name = "glassing beam"
	desc = "A high-power glassing beam, this time pointed directly at a vessel."
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 5 SECONDS
	ship_damage_projectile = /obj/item/projectile/auto_defense_proj/covenant

/obj/item/projectile/auto_defense_proj
	name = "SMAC Round"
	desc = "A massive ferromagnetic slug propelled to ludicrious speeds."
	damage = 9999999
	penetrating = 999
	kill_count = 999

/obj/item/projectile/auto_defense_proj/check_penetrate(var/atom/A)
	. = ..()
	explosion(A.loc,5,10,15,30)

/obj/item/projectile/auto_defense_proj/covenant
	name = "glassing beam"
	desc = "A high-power glassing beam, this time pointed directly at a vessel."
	opacity = 0
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 5 SECONDS

//FACTION DEFINES//
/obj/effect/overmap/ship/npc_ship/automated_defenses/unsc
	faction = "unsc"
	ship_name_list = list()

/obj/effect/overmap/ship/npc_ship/automated_defenses/unsc/generate_ship_name()
	name = "ODP [pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Kilo", "Lima", "Mike", "Sierra", "Tango", "Uniform", "Whiskey", "X-ray", "Zulu", "kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

/obj/effect/overmap/ship/npc_ship/automated_defenses/cov
	faction = "covenant"
	proj_fired = /obj/item/projectile/auto_defense_proj/covenant
	ship_name_list = list(\
	"Woe of the Treacherous",
	"Faithful Vanguard",
	"Ardent Shield",
	"Unyielding Faith",
	"Resolute Prophecy"
	)