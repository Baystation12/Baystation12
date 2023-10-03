SUBSYSTEM_DEF(plants)
	name = "Plants"
	priority = SS_PRIORITY_PLANTS
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING
	init_order = SS_INIT_PLANTS
	wait = 5 SECONDS

	/// Stores generated fruit descs.
	var/static/list/product_descs = list()

	/// All seed data stored here.
	var/static/list/seeds = list()

	/// Gene obfuscation for delicious trial and error goodness.
	var/static/list/gene_tag_masks = list()

	/// Stores images of growth, fruits and seeds.
	var/static/list/plant_icon_cache = list()

	/// List of all harvested product sprites.
	var/static/list/plant_sprites = list()

	/// List of all growth sprites plus number of growth stages.
	var/static/list/plant_product_sprites = list()

	/// Stored gene masked list, rather than recreating it when needed.
	var/static/list/gene_masked_list = list()

	/// Stored datum versions of the gene masked list.
	var/static/list/plant_gene_datums = list()

	/// Plants subscribed to be processed.
	var/static/list/obj/machinery/portable_atmospherics/hydroponics/active_plants = list()

	/// The current run queue.
	var/static/list/obj/machinery/portable_atmospherics/hydroponics/queue = list()

	/// The number of plants run from the last queue.
	var/static/run_plants = 0

	/// Live count of run plants.
	var/static/run_plant_counter = 0


/datum/controller/subsystem/plants/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	return ..({"All Plants: [length(active_plants)] Run Plants: [run_plants]"})


/datum/controller/subsystem/plants/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = active_plants.Copy()
		if (!length(queue))
			return
		run_plant_counter = 0
	var/cut_until = 1
	for (var/obj/machinery/portable_atmospherics/hydroponics/plant as anything in queue)
		++cut_until
		if (QDELETED(plant))
			continue
		if (!config.run_empty_levels && !SSpresence.population(get_z(plant)))
			continue
		++run_plant_counter
		plant.Process()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	run_plants = run_plant_counter
	queue.Cut()


/datum/controller/subsystem/plants/Initialize(start_uptime)
	for (var/state in icon_states('icons/obj/flora/hydroponics_growing.dmi'))
		var/split = findtext_char(state, "-")
		if (!split)
			continue
		var/growth_level = copytext_char(state, split + 1)
		if (growth_level == "dead")
			continue
		growth_level = text2num(growth_level)
		var/plant = copytext_char(state, 1, split)
		if (!plant_sprites[plant] || plant_sprites[plant] < growth_level)
			plant_sprites[plant] = growth_level

	for (var/state in icon_states('icons/obj/flora/hydroponics_products.dmi'))
		var/split = findtext_char(state, "-")
		if (!split)
			continue
		plant_product_sprites |= copytext_char(state, 1, split)

	for (var/path in subtypesof(/datum/seed))
		var/datum/seed/seed = new path
		seed.update_growth_stages()
		seeds[seed.name] = seed
		seed.roundstart = TRUE

	for (var/obj/item/seeds/seeds)
		seeds.update_seed()

	var/list/gene_datums = GET_SINGLETON_SUBTYPE_MAP(/singleton/plantgene)
	var/list/used_masks = list()
	var/list/plant_genes = shuffle(ALL_GENES)

	for (var/tag in plant_genes)
		var/mask = uppertext(num2hex(rand(0, 0xFF)))
		while (mask in used_masks)
			mask = uppertext(num2hex(rand(0, 0xFF)))

		var/singleton/plantgene/plantgene
		for (var/key in gene_datums)
			var/singleton/plantgene/other = gene_datums[key]
			if (tag == other.gene_tag)
				gene_datums -= key
				plantgene = other

		used_masks += mask
		gene_tag_masks[tag] = mask
		plant_gene_datums[mask] = plantgene
		gene_masked_list += list(list("tag" = tag, "mask" = mask))


/datum/controller/subsystem/plants/proc/create_random_seed(station_environment)
	var/datum/seed/seed = new
	seed.randomize()
	seed.uid = length(seeds) + 1
	seed.name = "[seed.uid]"
	seeds[seed.name] = seed

	if(station_environment)
		if (seed.consume_gasses)
			seed.consume_gasses[GAS_PHORON] = null
			seed.consume_gasses[GAS_CO2] = null
		if (seed.chems && !isnull(seed.chems[/datum/reagent/acid/polyacid]))
			seed.chems[/datum/reagent/acid/polyacid] = null
			seed.chems -= null
		seed.set_trait(TRAIT_IDEAL_HEAT, 293)
		seed.set_trait(TRAIT_HEAT_TOLERANCE, 20)
		seed.set_trait(TRAIT_IDEAL_LIGHT, 4)
		seed.set_trait(TRAIT_LIGHT_TOLERANCE, 5)
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE, 25)
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE, 200)
	return seed
