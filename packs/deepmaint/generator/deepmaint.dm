/**
	For the sake of dungeon generator being modular and not tied exclusively to deepmaint,
	most of the objects and modifications required exclusively for it will be kept here.
*/


GLOBAL_LIST_EMPTY(free_deepmaint_ladders)
GLOBAL_LIST_EMPTY(small_deepmaint_room_templates)
GLOBAL_LIST_EMPTY(big_deepmaint_room_templates)

/proc/populateDeepMaintMapLists()
	if(!length(GLOB.small_deepmaint_room_templates))
		for(var/item in subtypesof(/datum/map_template/deepmaint_template/room))
			var/datum/map_template/deepmaint_template/temp = item
			var/datum/map_template/deepmaint_template/S = new temp()
			GLOB.small_deepmaint_room_templates += S

	if(!length(GLOB.big_deepmaint_room_templates))
		for(var/item in subtypesof(/datum/map_template/deepmaint_template/big))
			var/datum/map_template/deepmaint_template/temp = item
			var/datum/map_template/deepmaint_template/S = new temp()
			GLOB.big_deepmaint_room_templates += S

/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint
	name = "deepmaint room"

/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint/New()
	. = ..()
	my_map = pick(GLOB.small_deepmaint_room_templates)

/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint/big
	name = "deepmaint core room"

/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint/big/New()
	. = ..()
	my_map = pick(GLOB.big_deepmaint_room_templates)


/proc/check_deepmaint_list()
	return length(GLOB.free_deepmaint_ladders)

/obj/procedural/jp_DungeonGenerator/deepmaint
	name = "Deep Maintenance Procedural Generator"

/**
	Finds a line of walls adjacent to the line of turfs given
*/
/obj/procedural/jp_DungeonGenerator/deepmaint/proc/checkForWalls(list/line)
	var/turf/t1 = line[1]
	var/turf/t2 = line[2]
	var/direction = get_dir(t1, t2)
	var/list/walls = list()
	for(var/turf/A in getAdjacent(t1))
		var/length = length(line)
		var/turf/T = A
		walls += T
		while(length > 0)
			length = length - 1
			T = get_step(T, direction)
			if (T.is_wall())
				walls += T
				if(length(walls) == length(line))
					return walls
			else
				walls = list()
				break


	return list()


/obj/procedural/jp_DungeonGenerator/deepmaint/proc/makeLadders()
	var/ladders_to_place = 3
	if(numRooms < ladders_to_place)
		return
	var/list/obj/procedural/jp_dungeonroom/done_rooms = list()
	while(ladders_to_place > 0)
		if(numRooms > 1)
			if(length(done_rooms) == length(out_rooms))
				testing("Deepmaint generator went through all rooms, but couldn't place all ladders! Ladders left - [ladders_to_place]")
				break
		var/obj/procedural/jp_dungeonroom/picked_room = pick(out_rooms)
		if(picked_room in done_rooms)
			continue
		var/list/turf/viable_turfs = list()
		for (var/turf/simulated/floor/F in range(roomMinSize + 1, picked_room.centre))
			//not under walls
			if (F.is_wall())
				continue

			if (F.contains_dense_objects()) //There's a lot of things rangine from tables to mechs or closets that can be on the chosen turf, so we'll ignore all turfs that have something aside lighting overlay
				continue


			//No turfs in space
			if (istype(F, /turf/space))
				continue

			//To be valid, the floor needs to have a wall in a cardinal direction
			for (var/d in GLOB.cardinal)
				var/turf/T = get_step(F, d)
				if (T.is_wall())
					viable_turfs[F] = T //We put this floor and its wall into the possible turfs list
					break

		if(length(viable_turfs) == 0)
			done_rooms += picked_room
			continue

		var/turf/ladder_turf = pick(viable_turfs)
		GLOB.free_deepmaint_ladders += ladder_turf
		ladders_to_place--
		done_rooms += picked_room

/obj/procedural/jp_DungeonGenerator/deepmaint/proc/populateCorridors()
	var/area/bluespace_interlude/platform/P = new
	for(var/turf/T in path_turfs)
		ChangeArea(T, P)
		if(prob(30))
			new /obj/decal/cleanable/dirt(T)

/obj/procedural/dungenerator/deepmaint
	name = "Deep Maint Gen"

/obj/procedural/dungenerator/deepmaint/New()
	. = ..()
	populateDeepMaintMapLists()
	var/start = get_game_time()
	var/obj/procedural/jp_DungeonGenerator/deepmaint/generate = new /obj/procedural/jp_DungeonGenerator/deepmaint(src)
	testing("Beginning procedural generation of [name] -  Z-level [z].")
	generate.name = name
	generate.setArea(locate(50, 50, z), locate(110, 110, z))
	generate.setWallType(/turf/simulated/floor/bluespace/interlude)
	generate.setFloorType(/turf/simulated/floor/tiled/techmaint)
	generate.setAllowedRooms(list(/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint/big))
	generate.setNumRooms(2) //3 deepmaints "core" rooms
	generate.setExtraPaths(0)
	generate.setMinPathLength(0)
	generate.setMaxPathLength(0)
	generate.setMinLongPathLength(0)
	generate.setLongPathChance(0)
	generate.setPathEndChance(100)
	generate.setRoomMinSize(10)
	generate.setRoomMaxSize(10)
	generate.setPathWidth(1)
	generate.generate()

	sleep(90)

	generate.setArea(locate(20, 20, z), locate(100, 100, z))
	generate.setAllowedRooms(list(/obj/procedural/jp_dungeonroom/preexist/square/submap/deepmaint))
	generate.setNumRooms(8) // 25 smaller rooms
	generate.setExtraPaths(1)
	generate.setMinPathLength(0)
	generate.setMaxPathLength(60) //Small Rooms are 60 at most appart
	generate.setMinLongPathLength(0)
	generate.setLongPathChance(0)
	generate.setPathEndChance(100)
	generate.setRoomMinSize(5)
	generate.setRoomMaxSize(5)
	generate.setPathWidth(2)
	generate.setUsePreexistingRegions(TRUE)
	generate.setDoAccurateRoomPlacementCheck(TRUE)
	generate.generate()
	generate.populateCorridors()
	generate.makeLadders()
	testing("Finished procedural generation of [name]. [generate.errString(generate.out_error)] -  Z-level [z], in [(get_game_time() - start) / 10] seconds.")


/turf/simulated/floor/bluespace/interlude
	name = "\improper bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"
	dynamic_lighting = FALSE
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
	var/list/victims

/turf/simulated/floor/bluespace/interlude/Initialize(mapload, ...)
	. = ..()
	set_light(3, 1, l_color = "#0066ff")
	desc = "Infinite, otherwordly energy swirling and morphing endlessly."

/turf/simulated/floor/bluespace/interlude/Entered(atom/movable/AM)
	if (istype(AM, /mob/living/simple_animal/hostile/bluespace) || istype(AM, /mob/observer))
		return

	LAZYADD(victims, weakref(AM))
	START_PROCESSING(SSobj, src)

/turf/simulated/floor/bluespace/interlude/Exited(atom/movable/AM)
	LAZYREMOVE(victims, weakref(AM))

/turf/simulated/floor/bluespace/interlude/Process()
	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (isnull(AM) || get_turf(AM) != src)
			victims -= W
			continue
		if (istype(AM, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = AM
			var/target_limb = pick(BP_ALL_LIMBS)
			var/obj/item/organ/external/limb = H.get_organ(target_limb)
			if (!limb)
				continue
			limb.take_external_damage(0, 10)
			if (prob(5))
				to_chat(H, SPAN_DANGER("You feel a sharp, burning pain in your [limb]!"))
		else if (istype(AM, /mob/living/exosuit))
			var/mob/living/exosuit/suit = AM
			suit.apply_damage(200, DAMAGE_BRUTE, BP_LEGS_FEET)
			suit.apply_damage(rand(80, 120), DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_DISPERSED)
		else
			if (!AM.damage_health(10, DAMAGE_BURN))
				if (!istype(AM, /obj/sparks) && !istype(AM, /obj/effect))
					visible_message(SPAN_DANGER("\The [AM] disintegrates in a flash of blue light!"))
					playsound(AM.loc, 'sound/magic/summon_carp.ogg', 50, 1)
				qdel(AM)
	if(!LAZYLEN(victims))
		return PROCESS_KILL

/area/bluespace_interlude/platform
	name = "Bluespace Interlude - Platform"
	requires_power = FALSE
	base_turf = /turf/simulated/floor/bluespace/interlude
	forced_ambience = list('sound/ambience/bluespace_interlude_ambience.ogg')
	sound_env = LARGE_ENCLOSED

/area/bluespace_interlude/surroundings
	name = "Bluespace Interlude - Surroundings"
	base_turf = /turf/simulated/floor/bluespace/interlude
	forced_ambience = list('sound/ambience/bluespace_interlude_ambience.ogg')
	sound_env = LARGE_ENCLOSED

/obj/random/rare
