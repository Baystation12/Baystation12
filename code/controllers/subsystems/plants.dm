PROCESSING_SUBSYSTEM_DEF(plants)
	name = "Plants"
	priority = SS_PRIORITY_PLANTS
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING
	init_order = SS_INIT_PLANTS
	wait = 60

	process_proc = /obj/machinery/portable_atmospherics/hydroponics/Process

	var/list/product_descs = list()         // Stores generated fruit descs.
	var/list/seeds = list()                 // All seed data stored here.
	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.
	var/list/plant_icon_cache = list()      // Stores images of growth, fruits and seeds.
	var/list/plant_sprites = list()         // List of all harvested product sprites.
	var/list/plant_product_sprites = list() // List of all growth sprites plus number of growth stages.
	var/list/gene_masked_list = list()		// Stored gene masked list, rather than recreating it when needed.
	var/list/plant_gene_datums = list()		// Stored datum versions of the gene masked list.

/datum/controller/subsystem/processing/plants/Initialize()
	// Build the icon lists.
	for(var/icostate in icon_states('icons/obj/hydroponics_growing.dmi'))
		var/split = findtext(icostate,"-")
		if(!split)
			// invalid icon_state
			continue

		var/ikey = copytext(icostate,(split+1))
		if(ikey == "dead")
			// don't count dead icons
			continue
		ikey = text2num(ikey)
		var/base = copytext(icostate,1,split)

		if(!(plant_sprites[base]) || (plant_sprites[base]<ikey))
			plant_sprites[base] = ikey

	for(var/icostate in icon_states('icons/obj/hydroponics_products.dmi'))
		var/split = findtext(icostate,"-")
		if(split)
			plant_product_sprites |= copytext(icostate,1,split)

	// Populate the global seed datum list.
	for(var/type in typesof(/datum/seed)-/datum/seed)
		var/datum/seed/S = new type
		S.update_growth_stages()
		seeds[S.name] = S
		S.roundstart = 1

	// Make sure any seed packets that were mapped in are updated
	// correctly (since the seed datums did not exist a tick ago).
	for(var/obj/item/seeds/S in world)
		S.update_seed()

	//Might as well mask the gene types while we're at it.
	var/list/gene_datums = decls_repository.get_decls_of_subtype(/decl/plantgene)
	var/list/used_masks = list()
	var/list/plant_traits = ALL_GENES
	while(plant_traits && plant_traits.len)
		var/gene_tag = pick(plant_traits)
		var/gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		while(gene_mask in used_masks)
			gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		var/decl/plantgene/G

		for(var/D in gene_datums)
			var/decl/plantgene/P = gene_datums[D]
			if(gene_tag == P.gene_tag)
				G = P
				gene_datums -= D
		used_masks += gene_mask
		plant_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask
		plant_gene_datums[gene_mask] = G
		gene_masked_list.Add(list(list("tag" = gene_tag, "mask" = gene_mask)))
	. = ..()

// Proc for creating a random seed type.
/datum/controller/subsystem/processing/plants/proc/create_random_seed(var/survive_on_station)
	var/datum/seed/seed = new()
	seed.randomize()
	seed.uid = seeds.len + 1
	seed.name = "[seed.uid]"
	seeds[seed.name] = seed

	if(survive_on_station)
		if(seed.consume_gasses)
			seed.consume_gasses[GAS_PHORON] = null
			seed.consume_gasses[GAS_CO2] = null
		if(seed.chems && !isnull(seed.chems[/datum/reagent/acid/polyacid]))
			seed.chems[/datum/reagent/acid/polyacid] = null // Eating through the hull will make these plants completely inviable, albeit very dangerous.
			seed.chems -= null // Setting to null does not actually remove the entry, which is weird.
		seed.set_trait(TRAIT_IDEAL_HEAT,293)
		seed.set_trait(TRAIT_HEAT_TOLERANCE,20)
		seed.set_trait(TRAIT_IDEAL_LIGHT,4)
		seed.set_trait(TRAIT_LIGHT_TOLERANCE,5)
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE,25)
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE,200)
	return seed
