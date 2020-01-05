#define AUTO_DEFENSE_LOCKON_DELAY 21 SECONDS
#define AUTO_DEFENSE_FIRE_DELAY 3 SECONDS

/obj/effect/overmap/ship/npc_ship/automated_defenses
	name = "Automated Defenses"
	desc = "An automated defense emplacment. Stay away."
	icon = 'code/modules/halo/icons/overmap/faction_misc.dmi'
	icon_state = "SMAC"

	faction = "civilian"
	available_ship_requests = newlist(/datum/npc_ship_request/automated_defense_process)
	hull = 2500
	messages_on_hit = list("Automated Defense system taking hostile weapons fire.")
	messages_on_death = list("Automated Defense system has sustained critical damage. Shutting down.")
	var/defense_range = 7
	block_slipspace = 1
	var/obj/item/projectile/overmap/proj_fired = /obj/item/projectile/overmap/auto_defense_proj
	anchored = 1

/obj/effect/overmap/ship/npc_ship/automated_defenses/Initialize()
	. = ..()
	GLOB.overmap_tiles_uncontrolled -= range(defense_range*2,src)

/obj/effect/overmap/ship/npc_ship/automated_defenses/can_board() //Now you can board them, any time you want!
	return 0

/obj/effect/overmap/ship/npc_ship/automated_defenses/take_projectiles(var/obj/item/projectile/overmap/proj,var/add_proj = 1)
	. = ..()
	for(var/datum/npc_ship_request/automated_defense_process/p in available_ship_requests)
		p.start_target_fire_at = 1

/datum/npc_ship_request/automated_defense_process
	request_auth_levels = list()
	request_requires_processing = 1
	var/obj/effect/overmap/ship/current_target
	var/obj/previous_target
	var/start_target_fire_at = 0
	var/firing_on_target = 0
	var/next_fire_at = 0

/datum/npc_ship_request/automated_defense_process/do_request_process(var/obj/effect/overmap/ship/npc_ship/automated_defenses/ship_source) //Return 1 in this to stop normal NPC ship move processing.
	. = 1
	if(!istype(ship_source))
		return 0
	var/list/in_range = range(ship_source.defense_range,ship_source)
	firing_on_target = 0
	if(previous_target)
		previous_target.overlays.Cut()
	if(current_target)
		current_target.overlays.Cut()
		if(current_target in in_range)
			if(current_target.get_faction() == ship_source.get_faction())
				previous_target = current_target
				current_target = null
				return
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
		if(current_target.get_faction() == ship_source.get_faction())
			current_target = null
			return
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
			if(!ship.block_slipspace && ship.get_faction() != ship_source.get_faction())
				unauthed_ships += ship
		if(unauthed_ships.len == 0)
			previous_target = current_target
			current_target = null
			return
		current_target = pick(unauthed_ships)
		var/obj/effect/overmap/ship/npc_ship/npc = current_target
		if(istype(npc))
			npc.ship_targetedby_defenses()
		if(current_target == previous_target)
			start_target_fire_at = world.time //Don't need to lock on again if it's the same ship.

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
	explosion(A.loc,5,10,15,30)
	. = ..()

/obj/item/projectile/auto_defense_proj/covenant
	name = "glassing beam"
	desc = "A high-power glassing beam, this time pointed directly at a vessel."
	opacity = 0
	tracer_type = /obj/effect/projectile/projector_laser_proj
	tracer_delay_time = 5 SECONDS

//FACTION DEFINES//
/datum/npc_ship/unsc_defenseplatform
	mapfile_links = list('maps/faction_bases/Human_Defense.dmm')
	fore_dir = EAST
	map_bounds = list(50,146,165,107)

/datum/npc_ship/innie_defenseplatform
	mapfile_links = list('maps/faction_bases/Innie_Defense.dmm')
	fore_dir = EAST
	map_bounds = list(50,146,165,107)

/datum/npc_ship/cov_defenseplatform
	mapfile_links = list('maps/faction_bases/Covenant_Defense.dmm')
	fore_dir = WEST
	map_bounds = list(29,70,66,32)

/obj/effect/overmap/ship/npc_ship/automated_defenses/unsc
	icon_state = "SMAC"
	faction = "unsc"
	ship_name_list = list()
	ship_datums = list(/datum/npc_ship/unsc_defenseplatform)

/obj/effect/overmap/ship/npc_ship/automated_defenses/unsc/generate_ship_name()
	name = "ODP [pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Kilo", "Lima", "Mike", "Sierra", "Tango", "Uniform", "Whiskey", "X-ray", "Zulu", "kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

/obj/effect/overmap/ship/npc_ship/automated_defenses/innie
	icon_state = "SMAC"
	faction = "innie"
	ship_name_list = list()
	ship_datums = list(/datum/npc_ship/innie_defenseplatform)

/obj/effect/overmap/ship/npc_ship/automated_defenses/innie/generate_ship_name()
	name = "ODP [pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Kilo", "Lima", "Mike", "Sierra", "Tango", "Uniform", "Whiskey", "X-ray", "Zulu", "kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

/obj/effect/overmap/ship/npc_ship/automated_defenses/cov
	icon_state = "cov_defenseplatform"
	faction = "covenant"
	proj_fired = /obj/item/projectile/overmap/auto_defense_proj/covenant
	ship_datums = list(/datum/npc_ship/cov_defenseplatform)
	ship_name_list = list(\
	"Woe of the Treacherous",
	"Faithful Vanguard",
	"Ardent Shield",
	"Unyielding Faith",
	"Resolute Prophecy",
	"Journey's Shield",
	"Vanguard of Charity"
	)
