
#define ON_PROJECTILE_HIT_MESSAGES list(\
"F-H-419; Taking fire!","Multiple hull breaches!",\
"Engineering's losing air... Sealed. How many did we lose?","Get the weapons back up!","Fire, Fire!",\
"Life support's barely working! We could do with some assistance!"\
)
#define ON_DEATH_MESSAGES list(\
"FUCK! REACTOR'S CRITICAL, REPEAT: REAC-","WE'RE LOSING ATMOSPHERIC INTEGRITY, NEED IMMEDIATE ASSIS-","CRITICAL HULL INTEGRITY! WE'RE LOSing air fast ..."\
)

/obj/effect/overmap/ship/npc_ship/combat
	name = "Combat Ship"
	desc=  "A ship specialised for combat."

	hull = 200 //Hardier than a civvie ship.
	var/atom/target

	var/target_range_from = 3 //Amount of tiles away from target ship will circle.

	messages_on_hit = ON_PROJECTILE_HIT_MESSAGES
	messages_on_death = ON_DEATH_MESSAGES

	var/next_fireat = 0
	var/list/projectiles_to_fire = list(/obj/item/projectile/overmap/mac = 10 SECONDS) //Associated list: [projectile type]=[fire_delay]

/obj/effect/overmap/ship/npc_ship/combat/proc/fire_at_target()
	var/obj/item/projectile/to_fire = pick(projectiles_to_fire)
	var/fire_delay = projectiles_to_fire[to_fire]
	to_fire = new to_fire(loc)
	to_fire.launch(target)
	next_fireat = world.time + fire_delay

/obj/effect/overmap/ship/npc_ship/combat/process()
	if(hull <= initial(hull)/4)
		return
	if(target && (target in view(7,src)))
		if(world.time > next_fireat)
			var/obj/effect/overmap/ship/npc_ship/targ_ship = target
			if(istype(targ_ship))
				if(targ_ship.hull > initial(targ_ship.hull)/4)
					fire_at_target()
			else
				fire_at_target()
		target_loc = pick(view(target_range_from,target)-view(target_range_from-1,target)) //Let's emulate a "circling" behaviour.
	..()

/obj/effect/overmap/ship/npc_ship/combat/take_projectiles(var/obj/item/projectile/overmap/proj)
	target = proj.overmap_fired_by
	. = ..()

/obj/effect/overmap/ship/npc_ship/combat/parse_action_request(var/request,var/mob/requester)
	if(request == "Fire on target")
		var/user_input = input(requester,"Input target name","Target Selection")
		if(isnull(user_input))
			return
		for(var/obj/object in view(7,src) + view(7,map_sectors["[requester.z]"]))
			if(object.name == "[user_input]")
				target = object
	. = ..()

/obj/effect/overmap/ship/npc_ship/combat/unsc
	ship_datums = list(/datum/npc_ship/unsc_patrol)

/obj/effect/overmap/ship/npc_ship/combat/unsc/get_requestable_actions(var/auth_level)
	var/list/requestable_actions = list()
	if(auth_level >= AUTHORITY_LEVEL_UNSC)
		requestable_actions += "Fire on target"
	. = ..() + requestable_actions

/obj/effect/overmap/ship/npc_ship/combat/innie
	ship_datums = list(/datum/npc_ship/ccv_comet)

/obj/effect/overmap/ship/npc_ship/combat/innie/get_requestable_actions(var/auth_level)
	var/list/requestable_actions = list()
	if(auth_level == AUTHORITY_LEVEL_INNIE)
		requestable_actions += "Fire on target"
	else
		requestable_actions += ..()
	return requestable_actions

/obj/effect/overmap/ship/npc_ship/combat/innie/parse_action_request(var/request,var/mob/requester)
	if(request == "Cargo Inspection" || "Halt")
		to_chat(requester,"<span class = 'comradio'>[src.name] : Slowing do- DIE UNSC SCUM! FOR THE URF!</span>")
		for(var/obj/effect/overmap/ship/npc_ship/combat/innie/ship in view(7,src))
			GLOB.global_headset.autosay("FOR THE URF!","[ship.name]","[halo_frequencies.innie_channel]")
			ship.target = map_sectors["[requester.z]"]
		target = map_sectors["[requester.z]"]
		return
	. = ..()

#undef ON_PROJECTILE_HIT_MESSAGES
#undef ON_DEATH_MESSAGES
