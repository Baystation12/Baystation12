
/datum/game_mode/firefight
	var/sound/sound_crash = sound('code/modules/halo/sound/crash.ogg', volume = 50)
	var/sound/sound_flyby = sound('code/modules/halo/sound/start.ogg', volume = 50)
	var/list/resupply_procs = list(/datum/game_mode/firefight/proc/spawn_resupply)
	var/min_crates = 3
	var/max_crates = 5

	var/list/supply_obj_types = list(\
		/obj/structure/closet/crate/random/unsc_guns,\
		/obj/structure/closet/crate/random/unsc_advguns,\
		/obj/structure/closet/crate/random/unsc_sniper,\
		/obj/structure/closet/crate/random/unsc_landmine,\
		/obj/structure/closet/crate/random/unsc_armour,\
		/obj/structure/closet/crate/random/unsc_turret,\
		/obj/structure/closet/crate/random/unsc_medic,\
		/obj/structure/closet/crate/random/unsc_misc,\
		/obj/structure/closet/crate/random/unsc_tools,\
		/obj/structure/closet/crate/random/unsc_food,\
		/obj/structure/closet/crate/random/unsc_missile,\
		/obj/structure/closet/crate/random/unsc_splaser,\
		/obj/structure/repair_bench,\
		/obj/structure/closet/crate/random/unsc_mats,\
		/obj/machinery/floodlight)

	var/flare_type = /obj/item/device/flashlight/flare

	var/list/supply_always_spawn = list()
	var/list/many_players_bonus = list(/obj/structure/closet/crate/random/unsc_guns)

	var/list/recently_spawned_supplies = list()

	var/list/debris_structures = list(\
		/obj/structure/grille/broken=5,\
		/obj/structure/grille=4,\
		/obj/structure/lattice=3,\
		/obj/structure/destructible/barrel=2,\
		/obj/structure/destructible/explosive=2,\
		/obj/structure/girder=1,\
		/obj/structure/foamedmetal=1)

	var/list/debris_objs = list(\
		/obj/item/salvage/metal=5,
		/obj/item/stack/rods/ten=3,\
		/obj/item/stack/material/steel/ten=2,\
		/obj/item/stack/cable_coil/random=1,\
		/obj/item/weapon/weldingtool=1,\
		/obj/item/weapon/wrench=1)

/datum/game_mode/firefight/proc/process_resupply()
	if(world.time > time_next_resupply)
		time_next_resupply = world.time + interval_resupply
		do_resupply()

/datum/game_mode/firefight/proc/do_resupply()
	if(!GLOB.available_resupply_points.len)
		//log_and_message_admins("Warning: No resupply points available")
		return

	var/turf/center_turf = locate(world.maxx/2, world.maxy/2, 1)
	var/obj/effect/landmark/S = pick(GLOB.available_resupply_points)
	GLOB.available_resupply_points -= S
	var/turf/drop_turf = get_turf(S)
	var/dir_text = "<span class='em'>[dir2text(get_dir(center_turf, S))]</span> of you"

	//random form of resupply
	var/chosen_proc = pickweight(resupply_procs)
	var/pilot_message = call(src, chosen_proc)(drop_turf)

	//work out the message
	pilot_message = replacetext(pilot_message, "%DIRTEXT%", dir_text)

	playsound(drop_turf, "explosion", 100, 1)
	for(var/mob/M in range(21, drop_turf))
		to_chat(M, "<span class='warning'>You hear multiple thudding impacts to the [dir2text(get_dir(M, S))].</span>")

	//tell the players
	to_world("\
		<span class='radio'>\
			<span class='name'>[pilot_name]</span> \
			<b>\[Emergency Freq\]</b> \
			<span class='message'>\"[pilot_message]\"</span>\
		</span>")

	qdel(S)

/datum/game_mode/firefight/proc/spawn_ship_debris(var/turf/epicentre)
	. = "A clump of debris from your ship has crashed down to the %DIRTEXT%. See if you can salvage it for resources."

	for(var/turf/spawn_turf in range(SUPPLY_SPREAD_RADIUS, epicentre))
		//closer to the center has more goodies
		var/cur_dist = get_dist(epicentre, spawn_turf)
		var/spawn_chance = 100 * ((SUPPLY_SPREAD_RADIUS - cur_dist) / SUPPLY_SPREAD_RADIUS)
		spawn_chance = Clamp(spawn_chance, 0, 100)
		if(prob(spawn_chance))
			//low chance to spawn a useful supply crate
			if(prob(2))
				var/spawn_type = pickweight(supply_obj_types)
				new spawn_type(spawn_turf)
			else
				//spawn some random crap
				var/spawn_type = pickweight(debris_structures + debris_objs)
				new spawn_type(spawn_turf)
				if(prob(10))
					spawn_type = pick(debris_objs)
					new spawn_type(spawn_turf)

	//play a cool sound to everyone
	for(var/mob/M in GLOB.player_list)
		sound_to(M, sound_crash)

/datum/game_mode/firefight/proc/spawn_resupply(var/turf/epicentre)
	. = "Supply run completed, I've dropped off my cargo to the %DIRTEXT%. \
		[pick("Good luck!","Hang in there!","Evacuation is coming!")]"

	var/num_crates = rand(min_crates,max_crates)
	var/list/must_spawn = supply_always_spawn.Copy()
	num_crates += must_spawn.len
	var/drop_crates = num_crates

	//drop a light on the supply drop to make it a bit easier to find
	var/obj/item/device/flashlight/F = new flare_type(epicentre)
	F.on = 1
	F.update_icon()

	//smoke visual effect to make it more obvious
	spawn(0)
		var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
		S.set_up(5,0,epicentre)
		S.start()

	//add more supplies with more players
	var/num_players = survivors_left()
	if(num_players >= 5)
		must_spawn.Add(many_players_bonus)

	var/failed_attempts = 0

	var/turf/spawn_turf
	while(num_crates > 0)

		if(!spawn_turf)
			//pick a random turf nearby
			spawn_turf = locate(\
				epicentre.x - SUPPLY_SPREAD_RADIUS + rand(0,SUPPLY_SPREAD_RADIUS*2),\
				epicentre.y - SUPPLY_SPREAD_RADIUS + rand(0,SUPPLY_SPREAD_RADIUS*2),\
				epicentre.z)

		//make sure we dont double up turfs
		if(!spawn_turf || turf_contains_dense_objects(spawn_turf))
			failed_attempts++
			if(failed_attempts > 10)
				message_admins("RESUPPLY: failed to find a valid turf after 10 attempts. \
					Successfully spawned [num_crates]/[drop_crates] crates.")
				break
			continue

		//spawn a crate
		var/spawn_type
		if(must_spawn.len)
			spawn_type = pick(must_spawn)
			must_spawn -= spawn_type
		else
			//cycle the spawn lists
			if(!supply_obj_types.len)
				supply_obj_types = recently_spawned_supplies
				recently_spawned_supplies = list()

			//pick a random thing to spawn
			spawn_type = pick(supply_obj_types)

			//dont spawn this thing again for a while
			recently_spawned_supplies += spawn_type
			supply_obj_types -= spawn_type

		//spawn the item
		var/obj/O = new spawn_type(spawn_turf)
		O.anchored = 0
		spawn_turf = null

		//this crate is finished
		num_crates -= 1

	//play a cool sound to everyone
	for(var/mob/M in GLOB.player_list)
		sound_to(M, sound_flyby)
