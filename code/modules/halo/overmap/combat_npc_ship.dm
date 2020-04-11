
#define ON_PROJECTILE_HIT_MESSAGES list(\
"Multiple hull breaches!",\
"Engineering's losing air... Sealed. How many did we lose?","Get the weapons back up!","Fire, Fire!",\
"Life support's barely working! We could do with some assistance!",\
"The fuck was that?","Helmsman, dodge or die!"\
)
#define ON_DEATH_MESSAGES list(\
"MULTIPLE SYSTEMS FAILING! EMERGENCY CODE F-H-419!","FUCK! REACTOR'S CRITICAL, REPEAT: REAC-","WE'RE LOSING ATMOSPHERIC INTEGRITY, NEED IMMEDIATE ASSIS-","CRITICAL HULL INTEGRITY! WE'RE LOSing air fast ..."\
)
#define TARGET_LOSE_INTEREST_DELAY 5 MINUTES

/obj/effect/overmap/ship/npc_ship/combat
	name = "Combat Ship"
	desc=  "A ship specialised for combat."

	hull = 1500 //Hardier than a civvie ship.
	var/obj/effect/overmap/ship/npc_ship/target

	var/target_range_from = 3 //Amount of tiles away from target ship will circle.

	messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	messages_on_death = ON_DEATH_MESSAGES
	var/list/messages_disengage = list("They must be disabled now! Disengaging.")
	var/list/messages_target_found = list("Hostile located, firing on target") //always ends with " [target]. ([target.x],[target.y])"

	var/next_fireat = 0
	var/list/projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.05 SECONDS) //Associated list: [projectile type]=[fire_delay]
	var/list/projectiles_nextfire_at = list()
	var/target_disengage_at = 0

	available_ship_requests = newlist(/datum/npc_ship_request/halt,/datum/npc_ship_request/fire_on_target)

/obj/effect/overmap/ship/npc_ship/combat/Initialize()
	. = ..()
	for(var/proj_type in projectiles_to_fire)
		projectiles_nextfire_at[proj_type] = 0

/obj/effect/overmap/ship/npc_ship/combat/ship_targetedby_defenses()
	if(isnull(target))
		target_disengage_at = 1
		target_loc = pick(GLOB.overmap_tiles_uncontrolled)

/obj/effect/overmap/ship/npc_ship/combat/proc/fire_at_target()
	if(is_player_controlled())
		return
	if(target_disengage_at == 0)
		target_disengage_at = world.time + TARGET_LOSE_INTEREST_DELAY
	if(target_disengage_at != 0 && world.time > target_disengage_at)
		radio_message(pick(messages_disengage))
		target = null
		target_disengage_at = 0
		return

	var/lowest_delay = 0
	for(var/proj_type in projectiles_to_fire)
		if(world.time < projectiles_nextfire_at[proj_type])
			continue
		var/fire_delay = projectiles_to_fire[proj_type]
		var/obj/item/projectile/proj_fired = new proj_type(loc)
		proj_fired.launch(target)
		if(fire_delay < lowest_delay)
			lowest_delay = fire_delay
		projectiles_nextfire_at[proj_type] = world.time + fire_delay

	next_fireat = world.time + lowest_delay

/obj/effect/overmap/ship/npc_ship/combat/proc/find_target()
	var/list/targets = list()
	target = null

	//scan ships in range
	for(var/obj/effect/overmap/ship/ship in range(7,src))

		var/obj/effect/overmap/ship/npc_ship/npc = ship
		if(istype(npc) && npc.hull <= initial(npc.hull)/4)
			continue

		//check if they're a hostile faction
		var/datum/faction/their_faction = ship.my_faction
		var/faction_name
		if(isnull(their_faction))
			faction_name = ship.get_faction()
		else
			faction_name = their_faction.name
		if(isnull(my_faction) || isnull(faction_name))
			continue
		if(faction_name in my_faction.enemy_factions)
			targets += ship

	if(targets.len > 0)
		//pick one at random
		target = pick(targets)
		radio_message( pick(messages_target_found) + " [target]. ([target.x],[target.y])")
		target_loc = null

/obj/effect/overmap/ship/npc_ship/combat/process()
	if(hull <= initial(hull)/4)
		return ..()
	if(is_player_controlled())
		return ..()

	if(target)
		//check if they're in range
		if(get_dist(src, target) > 10)//Slightly higher than view range for the sake of pursuit
			target = null
		else
			//open fire
			fire_at_target()

			var/list/target_locs = trange(target_range_from,target)
			for(var/m in target_locs)
				if(istype(m,/turf/unsimulated/map/edge))
					target_locs -= m
			if(target_locs.len > 0)
				target_loc = pick(target_locs)
	else
		find_target()

	..()

/obj/effect/overmap/ship/npc_ship/combat/take_projectiles(var/obj/item/projectile/overmap/proj)
	target = proj.overmap_fired_by
	target_disengage_at = world.time + TARGET_LOSE_INTEREST_DELAY
	for(var/obj/effect/overmap/ship/npc_ship/combat/ship in range(7,src))
		if(ship.get_faction() == get_faction() && !(ship.target))
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
	available_ship_requests = newlist(/datum/npc_ship_request/halt/unsc,/datum/npc_ship_request/fire_on_target/unsc,/datum/npc_ship_request/control_fleet/unsc,/datum/npc_ship_request/add_to_fleet/unsc,/datum/npc_ship_request/give_control/unsc)
	radio_channel = RADIO_FLEET

/obj/effect/overmap/ship/npc_ship/combat/unsc/generate_ship_name()
	. = ..()
	name = "UNSC [name]"

/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 2.5 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/corvette.dmi','code/modules/halo/icons/overmap/Cruiser.dmi')
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/missile = 2 SECONDS, /obj/item/projectile/overmap/mac/npc = 15 SECONDS)

//INNIE//
/obj/effect/overmap/ship/npc_ship/combat/innie
	icon = 'code/modules/halo/icons/overmap/innie_prowler.dmi'
	faction = "Insurrection"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt_fake,/datum/npc_ship_request/halt/innie,/datum/npc_ship_request/fire_on_target/innie,/datum/npc_ship_request/control_fleet/innie,/datum/npc_ship_request/add_to_fleet/innie,/datum/npc_ship_request/give_control/innie)
	radio_channel = RADIO_INNIE

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
	projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.2 SECONDS,/obj/item/projectile/overmap/missile = 0.5 SECONDS, /obj/item/projectile/overmap/mac/npc = 20 SECONDS)

//COVENANT//
/obj/effect/overmap/ship/npc_ship/combat/covenant
	ship_name_list = list(\
	"Woe of the Treacherous",
	"Faithful Vanguard",
	"Ardent Shield",
	"Unyielding Faith",
	"Resolute Prophecy",
	"Journey's Shield",
	"Shadow of Inquisitor",
	"Spear of Truth",
	"The Remembered Sacrifice",
	"Understood Silence",
	"Unified Demise",
	"Sundered Oath",
	"Templar Of Light",
	"Flayer Of Heresy",
	"Holy Martyr",
	"Sunderer Of Will",
	"Spire Of Gospel",
	"Ascendance Of Glory",
	"Slayer Of The Damned",
	"Heart of faith",
	"Voice of the heavens",
	"Essence of Loyalty",
	"Courage and Zeal",
	"Confirmation of Purity",
	"Redemption Through Servitude",
	"Vanguard of Charity",
	"Faithful's Endeavour"
	)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/kig_missionary.dmi','code/modules/halo/icons/overmap/SDV.dmi')
	faction = "Covenant"
	radio_language = "Sangheili"
	radio_channel = RADIO_COV
	ship_datums = list(/datum/npc_ship/cov_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt/cov,/datum/npc_ship_request/fire_on_target/cov,/datum/npc_ship_request/control_fleet/cov,/datum/npc_ship_request/add_to_fleet/cov,/datum/npc_ship_request/give_control/cov)

/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/pulse_laser = 0.2 SECONDS,/obj/item/projectile/overmap/plas_torp = 0.5 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed
	projectiles_to_fire = list(/obj/item/projectile/overmap/pulse_laser = 0.1 SECONDS,/obj/item/projectile/overmap/plas_torp = 1 SECONDS, /obj/item/projectile/overmap/beam/npc = 20 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/flood
	messages_on_hit = list("... / - -","- / .... / -","..",".","....")
	messages_on_death = list("... / --- / ...")
	messages_disengage = list("... / - -","- / .... / -","..",".","....")
	messages_target_found = list("... / - -","- / .... / -","..",".","....")
	faction = "Flood"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt_fake_flood)
	projectiles_to_fire = list(/obj/item/projectile/overmap/flood_pod = 5 SECONDS)

/obj/effect/overmap/ship/npc_ship/combat/flood/load_mapfile()
	return

#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
