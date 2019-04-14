
#define ON_PROJECTILE_HIT_MESSAGES list(\
"F-H-419; Taking fire!","Multiple hull breaches!",\
"Engineering's losing air... Sealed. How many did we lose?","Get the weapons back up!","Fire, Fire!",\
"Life support's barely working! We could do with some assistance!",\
"The fuck was that?","Helmsman, dodge or die!"\
)
#define ON_DEATH_MESSAGES list(\
"FUCK! REACTOR'S CRITICAL, REPEAT: REAC-","WE'RE LOSING ATMOSPHERIC INTEGRITY, NEED IMMEDIATE ASSIS-","CRITICAL HULL INTEGRITY! WE'RE LOSing air fast ..."\
)
#define TARGET_LOSE_INTEREST_DELAY 2 MINUTES

/obj/effect/overmap/ship/npc_ship/combat
	name = "Combat Ship"
	desc=  "A ship specialised for combat."

	hull = 500 //Hardier than a civvie ship.
	var/atom/target

	var/target_range_from = 3 //Amount of tiles away from target ship will circle.

	messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	messages_on_death = ON_DEATH_MESSAGES

	var/next_fireat = 0
	var/list/projectiles_to_fire = list(/obj/item/projectile/overmap/deck_gun_proj = 0.05 SECONDS,/obj/item/projectile/overmap/deck_gun_proj = 0.1 SECONDS,/obj/item/projectile/overmap/deck_gun_proj = 0.35 SECONDS) //Associated list: [projectile type]=[fire_delay]
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
		radio_message("<span class = 'radio'>\[System\] [name]: \"I think their ship's disabled. Disengaging.\"</span>")
		target = null
		return

	var/obj/item/projectile/to_fire = pick(projectiles_to_fire)
	var/fire_delay = projectiles_to_fire[to_fire]
	to_fire = new to_fire(loc)
	to_fire.launch(target)
	next_fireat = world.time + fire_delay

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
	. = ..()

/obj/effect/overmap/ship/npc_ship/combat/unsc
	faction = "unsc"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt/unsc,/datum/npc_ship_request/fire_on_target/unsc)


/obj/effect/overmap/ship/npc_ship/combat/innie
	faction = "innie"
	ship_datums = list(/datum/npc_ship/unsc_patrol)
	available_ship_requests = newlist(/datum/npc_ship_request/halt_fake,/datum/npc_ship_request/halt/innie,/datum/npc_ship_request/fire_on_target/innie)

/datum/npc_ship_request/halt_fake
	request_name = "Halt"
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC,AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/halt_fake/do_request(var/obj/effect/overmap/ship/npc_ship/combat/ship_source,var/mob/requester)
	ship_source.radio_message("<span class = 'radio'>\[System\] [ship_source.name]: \"Slowing dow- DIE UNSC SCUM! FOR THE URF!\"</span>")
	for(var/obj/effect/overmap/ship/npc_ship/combat/innie/ship in view(7,src))
		ship_source.radio_message("<span class = 'radio'>\[System\] [ship_source.name]: \"FOR THE URF!</span>\"")
		ship.target = map_sectors["[requester.z]"]
	ship_source.target = map_sectors["[requester.z]"]
	. = ..()

/datum/npc_ship_request/halt/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/halt/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC,AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/fire_on_target
	request_name = "Fire On Target"
	request_auth_levels = list()

/datum/npc_ship_request/fire_on_target/do_request(var/obj/effect/overmap/ship/npc_ship/combat/ship_source,var/mob/requester)
	var/user_input = input(requester,"Input target name","Target Selection")
	if(isnull(user_input))
		return
	for(var/obj/object in view(7,src) + view(7,map_sectors["[requester.z]"]))
		if(object.name == "[user_input]")
			ship_source.target = object
			return

	ship_source.radio_message(requester,"<span class = 'radio'>\[Direct Comms\] [ship_source.name]: \"We can't find any nearby object with that name. Ensure name accuracy.\"</span>")
	if(ship_source.target)
		ship_source.radio_message(requester,"<span class = 'radio'>\[Direct Comms\] [ship_source.name]: \"Disengaging from current target.\"</span>")
		ship_source.target = null

/datum/npc_ship_request/fire_on_target/unsc
	request_name = "Fire On Target"
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC, AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/fire_on_target/innie
	request_name = "Fire On Target"
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
