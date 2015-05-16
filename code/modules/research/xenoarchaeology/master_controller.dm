
/datum/controller/game_controller
	var/list/artifact_spawning_turfs = list()
	var/list/digsite_spawning_turfs = list()

#define XENOARCH_SPAWN_CHANCE 0.5
#define DIGSITESIZE_LOWER 4
#define DIGSITESIZE_UPPER 12
#define ARTIFACTSPAWNNUM_LOWER 6
#define ARTIFACTSPAWNNUM_UPPER 12

datum/controller/game_controller/proc/SetupXenoarch()
	//create digsites
	for(var/turf/simulated/mineral/M in block(locate(1,1,1), locate(world.maxx, world.maxy, world.maxz)))
		if(isnull(M.geologic_data))
			M.geologic_data = new/datum/geosample(M)

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		digsite_spawning_turfs.Add(M)
		var/digsite = get_random_digsite_type()
		var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER)
		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)
		while(turfs_to_process.len)
			var/turf/simulated/mineral/archeo_turf = pop(turfs_to_process)

			if(target_digsite_size > 1)
				var/list/viable_adjacent_turfs = orange(1, archeo_turf)
				for(var/turf/simulated/mineral/T in orange(1, archeo_turf))
					if(T.finds)
						continue
					if(T in processed_turfs)
						continue
					viable_adjacent_turfs.Add(T)

				for(var/turf/simulated/mineral/T in viable_adjacent_turfs)
					if(prob(target_digsite_size/viable_adjacent_turfs.len))
						turfs_to_process.Add(T)
						target_digsite_size -= 1
						if(target_digsite_size <= 0)
							break

			processed_turfs.Add(archeo_turf)
			if(isnull(archeo_turf.finds))
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5,95)))
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5,45)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(55,95)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5,30)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(35,75)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(75,95)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range)
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					archeo_turf.overlays += archeo_turf.archaeo_overlay

			//have a chance for an artifact to spawn here, but not in animal or plant digsites
			if(isnull(M.artifact_find) && digsite != 1 && digsite != 2)
				artifact_spawning_turfs.Add(archeo_turf)

	//create artifact machinery
	var/num_artifacts_spawn = rand(ARTIFACTSPAWNNUM_LOWER, ARTIFACTSPAWNNUM_UPPER)
	while(artifact_spawning_turfs.len > num_artifacts_spawn)
		pick_n_take(artifact_spawning_turfs)

	var/list/artifacts_spawnturf_temp = artifact_spawning_turfs.Copy()
	while(artifacts_spawnturf_temp.len > 0)
		var/turf/simulated/mineral/artifact_turf = pop(artifacts_spawnturf_temp)
		artifact_turf.artifact_find = new()

#undef XENOARCH_SPAWN_CHANCE
#undef DIGSITESIZE_LOWER
#undef DIGSITESIZE_UPPER
#undef ARTIFACTSPAWNNUM_LOWER
#undef ARTIFACTSPAWNNUM_UPPER
