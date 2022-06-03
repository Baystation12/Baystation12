SUBSYSTEM_DEF(init_misc_late)
	name = "Misc Initialization (Late)"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE


/datum/controller/subsystem/init_misc_late/UpdateStat(time)
	if (initialized)
		return
	..()


/datum/controller/subsystem/init_misc_late/Initialize(start_uptime)
	GLOB.using_map.build_away_sites()
	GLOB.using_map.build_exoplanets()
	var/decl/asset_cache/asset_cache = decls_repository.get_decl(/decl/asset_cache)
	asset_cache.load()
	init_recipes()
	init_xenoarch()


GLOBAL_VAR_INIT(microwave_maximum_item_storage, 0)
GLOBAL_LIST_EMPTY(microwave_recipes)
GLOBAL_LIST_EMPTY(microwave_accepts_reagents)
GLOBAL_LIST_EMPTY(microwave_accepts_items)

/datum/controller/subsystem/init_misc_late/proc/init_recipes()
	var/list/reagents = list()
	var/list/items = list(
		/obj/item/holder = TRUE,
		/obj/item/reagent_containers/food/snacks/grown = TRUE
	)
	for (var/datum/recipe/recipe as anything in subtypesof(/datum/recipe))
		recipe = new recipe
		GLOB.microwave_recipes += recipe
		for (var/type in recipe.reagents)
			reagents[type] = TRUE
		for (var/type in recipe.items)
			items[type] = TRUE
		GLOB.microwave_maximum_item_storage = max(GLOB.microwave_maximum_item_storage, length(recipe.items))
	for (var/type in reagents)
		GLOB.microwave_accepts_reagents += type
	for (var/type in items)
		GLOB.microwave_accepts_items += type


GLOBAL_LIST(xeno_artifact_turfs)
GLOBAL_LIST(xeno_digsite_turfs)

/datum/controller/subsystem/init_misc_late/proc/init_xenoarch()
	var/list/queue = list()
	var/list/site_turfs = list()
	var/list/artifact_turfs = list()
	var/datum/map/map = GLOB.using_map
	if (!map)
		GLOB.xeno_artifact_turfs = list()
		GLOB.xeno_digsite_turfs = list()
		return
	var/list/banned_levels = map.admin_levels + map.escape_levels
	for (var/turf/simulated/mineral/M in world)
		if (!M.density)
			continue
		if (M.z in banned_levels)
			continue
		if (!M.geologic_data)
			M.geologic_data = new (M)
		if (!prob(0.5))
			continue
		var/has_space = TRUE
		for (var/turf/T as anything in site_turfs)
			if (T.z != M.z)
				continue
			if (abs(T.x - M.x) > 3)
				continue
			if (abs(T.y - M.y) > 3)
				continue
			has_space = FALSE
			break
		if (!has_space)
			continue
		site_turfs += M
		queue.Cut()
		queue += M
		for (var/turf/simulated/mineral/T in orange(2, M))
			if (!T.density)
				continue
			if (T.finds)
				continue
			queue += T
		var/site_turf_count = rand(4, 12)
		if (site_turf_count < queue.len)
			for (var/i = queue.len - site_turf_count to 1 step -1)
				var/selected = rand(1, queue.len)
				queue.Cut(selected, selected + 1)
		var/site_type = get_random_digsite_type()
		for (var/turf/simulated/mineral/T as anything in queue)
			if (!T.finds)
				var/list/finds = list()
				if (prob(50))
					finds += new /datum/find (site_type, rand(10, 190))
				else if (prob(75))
					finds += new /datum/find (site_type, rand(10, 90))
					finds += new /datum/find (site_type, rand(110, 190))
				else
					finds += new /datum/find (site_type, rand(10, 50))
					finds += new /datum/find (site_type, rand(60, 140))
					finds += new /datum/find (site_type, rand(150, 190))
				var/datum/find/F = finds[1]
				if (F.excavation_required <= F.view_range)
					T.archaeo_overlay = "overlay_archaeo[rand(1, 3)]"
					T.update_icon()
				T.finds = finds
			if (site_type == DIGSITE_GARDEN)
				continue
			if (site_type == DIGSITE_ANIMAL)
				continue
			artifact_turfs += T
		CHECK_TICK
	GLOB.xeno_digsite_turfs = site_turfs
	GLOB.xeno_artifact_turfs = list()
	for (var/i = rand(6, 12) to 1 step -1)
		var/len = artifact_turfs.len
		if (len < 1)
			break
		var/selected = rand(1, len)
		var/turf/simulated/mineral/T = artifact_turfs[selected]
		artifact_turfs.Cut(selected, selected + 1)
		GLOB.xeno_artifact_turfs += T
		T.artifact_find = new
