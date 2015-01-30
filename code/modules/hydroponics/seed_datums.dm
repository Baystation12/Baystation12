// Sprite lists.
var/global/list/plant_sprites = list()         // List of all harvested product sprites.
var/global/list/plant_product_sprites = list() // List of all growth sprites plus number of growth stages.

// Debug for testing seed genes.
/client/proc/show_plant_genes()
	set category = "Debug"
	set name = "Show Plant Genes"
	set desc = "Prints the round's plant gene masks."

	if(!holder)	return

	if(!gene_tag_masks)
		usr << "Gene masks not set."
		return

	for(var/mask in gene_tag_masks)
		usr << "[mask]: [gene_tag_masks[mask]]"

// Predefined/roundstart varieties use a string key to make it
// easier to grab the new variety when mutating. Post-roundstart
// and mutant varieties use their uid converted to a string instead.
// Looks like shit but it's sort of necessary.

proc/populate_seed_list()

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
		plant_product_sprites |= icostate

	// Populate the global seed datum list.
	for(var/type in typesof(/datum/seed)-/datum/seed)
		var/datum/seed/S = new type
		seed_types[S.name] = S
		S.uid = "[seed_types.len]"
		S.roundstart = 1

	// Make sure any seed packets that were mapped in are updated
	// correctly (since the seed datums did not exist a tick ago).
	for(var/obj/item/seeds/S in world)
		S.update_seed()

	//Might as well mask the gene types while we're at it.
	var/list/used_masks = list()
	var/list/plant_traits = ALL_TRAITS
	while(plant_traits && plant_traits.len)
		var/gene_tag = pick(plant_traits)
		var/gene_mask = "[num2hex(rand(0,255))]"

		while(gene_mask in used_masks)
			gene_mask = "[num2hex(rand(0,255))]"

		used_masks += gene_mask
		plant_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask

/datum/plantgene
	var/genetype    // Label used when applying trait.
	var/list/values // Values to copy into the target seed datum.

/datum/seed

	//Tracking.
	var/uid                        // Unique identifier.
	var/name                       // Index for global list.
	var/seed_name                  // Plant name for seed packet.
	var/seed_noun = "seeds"        // Descriptor for packet.
	var/display_name               // Prettier name.
	var/roundstart                 // If set, seed will not display variety number.
	var/mysterious                 // Only used for the random seed packets.
	var/growth_stages = 0          // Number of stages the plant passes through before it is mature.
	var/list/traits = list()       // Initialized in New()
	var/list/products              // Possible fruit/other product paths.
	var/list/mutants               // Possible predefined mutant varieties, if any.
	var/list/chems                 // Chemicals that plant produces in products/injects into victim.
	var/list/consume_gasses        // The plant will absorb these gasses during its life.
	var/list/exude_gasses          // The plant will exude these gasses during its life.
	var/splat_type = /obj/effect/decal/cleanable/fruit_smudge // Graffiti decal.

/datum/seed/proc/get_trait(var/trait)
	return traits["[trait]"]

/datum/seed/proc/set_trait(var/trait,var/nval,var/ubound,var/lbound, var/degrade)
	if(!isnull(degrade)) nval *= degrade
	if(!isnull(ubound))  nval = min(nval,ubound)
	if(!isnull(lbound))  nval = max(nval,lbound)
	traits["[trait]"] =  nval

// Does brute damage to a target.
/datum/seed/proc/do_thorns(var/mob/living/carbon/human/target, var/obj/item/fruit, var/target_limb)

	if(!istype(target) || !get_trait(TRAIT_CARNIVOROUS))
		return

	if(!target_limb) target_limb = pick("l_foot","r_foot","l_leg","r_leg","l_hand","r_hand","l_arm", "r_arm","head","chest","groin")
	var/datum/organ/external/affecting = target.get_organ(target_limb)
	var/damage = 0

	if(get_trait(TRAIT_CARNIVOROUS))
		if(get_trait(TRAIT_CARNIVOROUS) == 2)
			if(affecting)
				target << "<span class='danger'>\The [fruit]'s thorns pierce your [affecting.display_name] greedily!</span>"
			else
				target << "<span class='danger'>\The [fruit]'s thorns pierce your flesh greedily!</span>"
			damage = get_trait(TRAIT_POTENCY)/2
		else
			if(affecting)
				target << "<span class='danger'>\The [fruit]'s thorns dig deeply into your [affecting.display_name]!</span>"
			else
				target << "<span class='danger'>\The [fruit]'s thorns dig deeply into your flesh!</span>"
			damage = get_trait(TRAIT_POTENCY)/5
	else
		return

	if(affecting)
		affecting.take_damage(damage, 0)
		affecting.add_autopsy_data("Thorns",damage)
	else
		target.adjustBruteLoss(damage)
	target.UpdateDamageIcon()
	target.updatehealth()

// Adds reagents to a target.
/datum/seed/proc/do_sting(var/mob/living/carbon/human/target, var/obj/item/fruit)
	if(!get_trait(TRAIT_STINGS))
		return
	if(chems && chems.len)
		target << "<span class='danger'>You are stung by \the [fruit]!</span>"
		for(var/rid in chems)
			var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/5))
			target.reagents.add_reagent(rid,injecting)

//Splatter a turf.
/datum/seed/proc/splatter(var/turf/T,var/obj/item/thrown)
	if(splat_type)
		var/obj/effect/decal/cleanable/fruit_smudge/splat = new splat_type(T)
		splat.name = "[thrown.name] [pick("smear","smudge","splatter")]"
		if(get_trait(TRAIT_BIOLUM))
			if(get_trait(TRAIT_BIOLUM_COLOUR))
				splat.l_color = get_trait(TRAIT_BIOLUM_COLOUR)
			splat.SetLuminosity(get_trait(TRAIT_BIOLUM))
		if(istype(splat))
			if(get_trait(TRAIT_PRODUCT_COLOUR))
				splat.color = get_trait(TRAIT_PRODUCT_COLOUR)

	if(chems)
		for(var/mob/living/M in T.contents)
			if(!M.reagents)
				continue
			for(var/chem in chems)
				var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/3))
				M.reagents.add_reagent(chem,injecting)

//Applies an effect to a target atom.
/datum/seed/proc/thrown_at(var/obj/item/thrown,var/atom/target)

	var/splatted
	var/turf/origin_turf = get_turf(target)

	if(get_trait(TRAIT_EXPLOSIVE))

		var/flood_dist = min(10,max(1,get_trait(TRAIT_POTENCY)/15))
		var/list/open_turfs = list()
		var/list/closed_turfs = list()
		var/list/valid_turfs = list()
		open_turfs |= origin_turf

		// Flood fill to get affected turfs.
		while(open_turfs.len)
			var/turf/T = pick(open_turfs)
			open_turfs -= T
			closed_turfs |= T
			valid_turfs |= T

			for(var/dir in alldirs)
				var/turf/neighbor = get_step(T,dir)
				if(!neighbor || (neighbor in closed_turfs) || (neighbor in open_turfs))
					continue
				if(neighbor.density || get_dist(neighbor,origin_turf) > flood_dist || istype(neighbor,/turf/space))
					closed_turfs |= neighbor
					continue
				// Check for windows.
				var/no_los
				for(var/turf/target_turf in getline(origin_turf,neighbor))
					if(target_turf.density)
						no_los = 1
						break

				if(!no_los)
					var/los_dir = get_dir(neighbor,origin_turf)
					var/list/blocked = list()
					for(var/obj/machinery/door/D in neighbor.contents)
						if(istype(D,/obj/machinery/door/window))
							blocked |= D.dir
						else
							if(D.density)
								no_los = 1
								break
					for(var/obj/structure/window/W in neighbor.contents)
						if(W.is_fulltile())
							no_los = 1
							break
						blocked |= W.dir
					if(!no_los)
						switch(los_dir)
							if(NORTHEAST)
								if((NORTH in blocked) && (EAST in blocked))
									no_los = 1
							if(SOUTHEAST)
								if((SOUTH in blocked) && (EAST in blocked))
									no_los = 1
							if(NORTHWEST)
								if((NORTH in blocked) && (WEST in blocked))
									no_los = 1
							if(SOUTHWEST)
								if((SOUTH in blocked) && (WEST in blocked))
									no_los = 1
							else
								if(los_dir in blocked)
									no_los = 1
				if(no_los)
					closed_turfs |= neighbor
					continue
				open_turfs |= neighbor

		for(var/turf/T in valid_turfs)
			for(var/mob/living/M in T.contents)
				apply_special_effect(M)
			splatter(T,thrown)
		origin_turf.visible_message("<span class='danger'>The [thrown.name] violently explodes against [target]!</span>")
		del(thrown)
		return

	if(istype(target,/mob/living))
		splatted = apply_special_effect(target,thrown)
	else if(istype(target,/turf))
		splatted = 1
		for(var/mob/living/M in target.contents)
			apply_special_effect(M)

	if(get_trait(TRAIT_JUICY) && splatted)
		splatter(origin_turf,thrown)
		origin_turf.visible_message("<span class='danger'>The [thrown.name] splatters against [target]!</span>")
		del(thrown)

/datum/seed/proc/handle_environment(var/turf/current_turf, var/datum/gas_mixture/environment)

	var/health_change = 0
	// Handle gas consumption.
	if(consume_gasses && consume_gasses.len)
		var/missing_gas = 0
		for(var/gas in consume_gasses)
			if(environment && environment.gas && environment.gas[gas] && \
			 environment.gas[gas] >= consume_gasses[gas])
				environment.adjust_gas(gas,-consume_gasses[gas],1)
			else
				missing_gas++

		if(missing_gas > 0)
			health_change += missing_gas * HYDRO_SPEED_MULTIPLIER

	// Process it.
	var/pressure = environment.return_pressure()
	if(pressure < get_trait(TRAIT_LOWKPA_TOLERANCE)|| pressure > get_trait(TRAIT_HIGHKPA_TOLERANCE))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	if(abs(environment.temperature - get_trait(TRAIT_IDEAL_HEAT)) > get_trait(TRAIT_HEAT_TOLERANCE))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	// Handle gas production.
	if(exude_gasses && exude_gasses.len)
		for(var/gas in exude_gasses)
			environment.adjust_gas(gas, max(1,round((exude_gasses[gas]*get_trait(TRAIT_POTENCY))/exude_gasses.len)))

	// Handle light requirements.
	var/area/A = get_area(current_turf)
	if(A)
		var/light_available
		if(A.lighting_use_dynamic)
			light_available = max(0,min(10,current_turf.lighting_lumcount)-5)
		else
			light_available =  5
		if(abs(light_available - get_trait(TRAIT_IDEAL_LIGHT)) > get_trait(TRAIT_LIGHT_TOLERANCE))
			health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	return health_change

/datum/seed/proc/apply_special_effect(var/mob/living/target,var/obj/item/thrown)

	var/impact = 1
	do_sting(target,thrown)
	do_thorns(target,thrown)

	// Bluespace tomato code copied over from grown.dm.
	if(get_trait(TRAIT_TELEPORTING))

		//Plant potency determines radius of teleport.
		var/outer_teleport_radius = get_trait(TRAIT_POTENCY)/5
		var/inner_teleport_radius = get_trait(TRAIT_POTENCY)/15

		var/list/turfs = list()
		if(inner_teleport_radius > 0)
			for(var/turf/T in orange(target,outer_teleport_radius))
				if(get_dist(target,T) >= inner_teleport_radius)
					turfs |= T

		if(turfs.len)
			// Moves the mob, causes sparks.
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, get_turf(target))
			s.start()
			var/turf/picked = get_turf(pick(turfs))                      // Just in case...
			new/obj/effect/decal/cleanable/molten_item(get_turf(target)) // Leave a pile of goo behind for dramatic effect...
			target.loc = picked                                          // And teleport them to the chosen location.

			impact = 1

	return impact

//Creates a random seed. MAKE SURE THE LINE HAS DIVERGED BEFORE THIS IS CALLED.
/datum/seed/proc/randomize()

	roundstart = 0
	seed_name = "strange plant"     // TODO: name generator.
	display_name = "strange plants" // TODO: name generator.
	mysterious = 1
	seed_noun = pick("spores","nodes","cuttings","seeds")
	products = list(pick(typesof(/obj/item/weapon/reagent_containers/food/snacks/grown)-/obj/item/weapon/reagent_containers/food/snacks/grown))

	set_trait(TRAIT_POTENCY,rand(5,30),200,0)
	set_trait(TRAIT_PRODUCT_ICON,pick(plant_product_sprites))
	set_trait(TRAIT_PLANT_ICON,pick(plant_sprites))
	set_trait(TRAIT_PLANT_COLOUR,"#[pick(rainbow)]")
	set_trait(TRAIT_PRODUCT_COLOUR,"#[pick(rainbow)]")
	update_growth_stages()

	if(prob(20))
		set_trait(TRAIT_HARVEST_REPEAT,1)

	if(prob(15))
		if(prob(15))
			set_trait(TRAIT_JUICY,2)
		else
			set_trait(TRAIT_JUICY,1)

	if(prob(5))
		set_trait(TRAIT_STINGS,1)

	if(prob(5))
		set_trait(TRAIT_PRODUCES_POWER,1)

	if(prob(1))
		set_trait(TRAIT_EXPLOSIVE,1)
	else if(prob(1))
		set_trait(TRAIT_TELEPORTING,1)

	if(prob(5))
		consume_gasses = list()
		var/gas = pick("oxygen","nitrogen","phoron","carbon_dioxide")
		consume_gasses[gas] = rand(3,9)

	if(prob(5))
		exude_gasses = list()
		var/gas = pick("oxygen","nitrogen","phoron","carbon_dioxide")
		exude_gasses[gas] = rand(3,9)

	chems = list()
	if(prob(80))
		chems["nutriment"] = list(rand(1,10),rand(10,20))

	var/additional_chems = rand(0,5)

	if(additional_chems)
		var/list/possible_chems = list(
			"bicaridine",
			"hyperzine",
			"cryoxadone",
			"blood",
			"water",
			"potassium",
			"plasticide",
			"mutationtoxin",
			"amutationtoxin",
			"inaprovaline",
			"space_drugs",
			"paroxetine",
			"mercury",
			"sugar",
			"radium",
			"ryetalyn",
			"alkysine",
			"thermite",
			"tramadol",
			"cryptobiolin",
			"dermaline",
			"dexalin",
			"phoron",
			"synaptizine",
			"impedrezene",
			"hyronalin",
			"peridaxon",
			"toxin",
			"rezadone",
			"ethylredoxrazine",
			"slimejelly",
			"cyanide",
			"mindbreaker",
			"stoxin"
			)

		for(var/x=1;x<=additional_chems;x++)
			if(!possible_chems.len)
				break
			var/new_chem = pick(possible_chems)
			possible_chems -= new_chem
			chems[new_chem] = list(rand(1,10),rand(10,20))

	if(prob(90))
		set_trait(TRAIT_REQUIRES_NUTRIENTS,1)
		set_trait(TRAIT_NUTRIENT_CONSUMPTION,rand(100)*0.1)
	else
		set_trait(TRAIT_REQUIRES_NUTRIENTS,0)

	if(prob(90))
		set_trait(TRAIT_REQUIRES_WATER,1)
		set_trait(TRAIT_WATER_CONSUMPTION,rand(10))
	else
		set_trait(TRAIT_REQUIRES_WATER,0)

	set_trait(TRAIT_IDEAL_HEAT,       rand(100,400))
	set_trait(TRAIT_HEAT_TOLERANCE,   rand(10,30))
	set_trait(TRAIT_IDEAL_LIGHT,      rand(2,10))
	set_trait(TRAIT_LIGHT_TOLERANCE,  rand(2,7))
	set_trait(TRAIT_TOXINS_TOLERANCE, rand(2,7))
	set_trait(TRAIT_PEST_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_WEED_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_LOWKPA_TOLERANCE, rand(10,50))
	set_trait(TRAIT_HIGHKPA_TOLERANCE,rand(100,300))

	if(prob(5))
		set_trait(TRAIT_ALTER_TEMP,rand(-5,5))

	if(prob(1))
		set_trait(TRAIT_IMMUTABLE,-1)

	var/carnivore_prob = rand(100)
	if(carnivore_prob < 5)
		set_trait(TRAIT_CARNIVOROUS,2)
	else if(carnivore_prob < 10)
		set_trait(TRAIT_CARNIVOROUS,1)

	if(prob(10))
		set_trait(TRAIT_PARASITE,1)

	var/vine_prob = rand(100)
	if(vine_prob < 5)
		set_trait(TRAIT_SPREAD,2)
	else if(vine_prob < 10)
		set_trait(TRAIT_SPREAD,1)

	if(prob(5))
		set_trait(TRAIT_BIOLUM,1)
		set_trait(TRAIT_BIOLUM_COLOUR,"#[pick(rainbow)]")

	set_trait(TRAIT_ENDURANCE,rand(60,100))
	set_trait(TRAIT_YIELD,rand(3,15))
	set_trait(TRAIT_MATURATION,rand(5,15))
	set_trait(TRAIT_PRODUCTION,get_trait(TRAIT_MATURATION)+rand(2,5))
	set_trait(TRAIT_LIFESPAN,get_trait(TRAIT_PRODUCTION)+rand(5,10))

//Returns a key corresponding to an entry in the global seed list.
/datum/seed/proc/get_mutant_variant()
	if(!mutants || !mutants.len || get_trait(TRAIT_IMMUTABLE) > 0) return 0
	return pick(mutants)

//Mutates the plant overall (randomly).
/datum/seed/proc/mutate(var/degree,var/turf/source_turf)

	if(!degree || get_trait(TRAIT_IMMUTABLE) > 0) return

	source_turf.visible_message("<span class='notice'>\The [display_name] quivers!</span>")

	//This looks like shit, but it's a lot easier to read/change this way.
	var/total_mutations = rand(1,1+degree)
	for(var/i = 0;i<total_mutations;i++)
		switch(rand(0,12))
			if(0) //Plant cancer!
				set_trait(TRAIT_LIFESPAN, get_trait(TRAIT_LIFESPAN)-rand(1,5),null,0)
				set_trait(TRAIT_ENDURANCE,get_trait(TRAIT_ENDURANCE)-rand(10,20),null,0)
				source_turf.visible_message("<span class='danger'>\The [display_name] withers rapidly!</span>")
			if(1)
				set_trait(TRAIT_NUTRIENT_CONSUMPTION,get_trait(TRAIT_NUTRIENT_CONSUMPTION)+rand(-(degree*0.1),(degree*0.1)),5,0)
				set_trait(TRAIT_WATER_CONSUMPTION,   get_trait(TRAIT_WATER_CONSUMPTION)   +rand(-degree,degree),50,0)
				set_trait(TRAIT_JUICY,              !get_trait(TRAIT_JUICY))
				set_trait(TRAIT_STINGS,             !get_trait(TRAIT_STINGS))
			if(2)
				set_trait(TRAIT_IDEAL_HEAT,          get_trait(TRAIT_IDEAL_HEAT) +      (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_HEAT_TOLERANCE,      get_trait(TRAIT_HEAT_TOLERANCE) +  (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_LOWKPA_TOLERANCE,    get_trait(TRAIT_LOWKPA_TOLERANCE)+ (rand(-5,5)*degree),80,0)
				set_trait(TRAIT_HIGHKPA_TOLERANCE,   get_trait(TRAIT_HIGHKPA_TOLERANCE)+(rand(-5,5)*degree),500,110)
				set_trait(TRAIT_EXPLOSIVE,1)
			if(3)
				set_trait(TRAIT_IDEAL_LIGHT,         get_trait(TRAIT_IDEAL_LIGHT)+(rand(-1,1)*degree),30,0)
				set_trait(TRAIT_LIGHT_TOLERANCE,     get_trait(TRAIT_LIGHT_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(4)
				set_trait(TRAIT_TOXINS_TOLERANCE,    get_trait(TRAIT_TOXINS_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(5)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_CARNIVOROUS,     get_trait(TRAIT_CARNIVOROUS)+rand(-degree,degree),2, 0)
					if(get_trait(TRAIT_CARNIVOROUS))
						source_turf.visible_message("<span class='notice'>\The [display_name] shudders hungrily.</span>")
			if(6)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_PARASITE,!get_trait(TRAIT_PARASITE))
			if(7)
				set_trait(TRAIT_LIFESPAN,            get_trait(TRAIT_LIFESPAN)+(rand(-2,2)*degree),30,10)
				if(get_trait(TRAIT_YIELD) != -1)
					set_trait(TRAIT_YIELD,           get_trait(TRAIT_YIELD)+(rand(-2,2)*degree),10,0)
			if(8)
				set_trait(TRAIT_ENDURANCE,           get_trait(TRAIT_ENDURANCE)+(rand(-5,5)*degree),100,10)
				set_trait(TRAIT_PRODUCTION,          get_trait(TRAIT_PRODUCTION)+(rand(-1,1)*degree),10, 1)
				set_trait(TRAIT_POTENCY,             get_trait(TRAIT_POTENCY)+(rand(-20,20)*degree),200, 0)
				if(prob(degree*5))
					set_trait(TRAIT_SPREAD,          get_trait(TRAIT_SPREAD)+rand(-1,1),2, 0)
					source_turf.visible_message("<span class='notice'>\The [display_name] spasms visibly, shifting in the tray.</span>")
			if(9)
				set_trait(TRAIT_MATURATION,          get_trait(TRAIT_MATURATION)+(rand(-1,1)*degree),30, 0)
				if(prob(degree*5))
					set_trait(TRAIT_HARVEST_REPEAT, !get_trait(TRAIT_HARVEST_REPEAT))
			if(10)
				if(prob(degree*2))
					set_trait(TRAIT_BIOLUM,         !get_trait(TRAIT_BIOLUM))
					if(get_trait(TRAIT_BIOLUM))
						source_turf.visible_message("<span class='notice'>\The [display_name] begins to glow!</span>")
						if(prob(degree*2))
							set_trait(TRAIT_BIOLUM_COLOUR,"#[pick(rainbow)]")
							source_turf.visible_message("<span class='notice'>\The [display_name]'s glow </span><font color='[get_trait(TRAIT_BIOLUM_COLOUR)]'>changes colour</font>!")
					else
						source_turf.visible_message("<span class='notice'>\The [display_name]'s glow dims...</span>")
			if(11)
				if(prob(degree*2))
					set_trait(TRAIT_FLOWERS,!get_trait(TRAIT_FLOWERS))
					if(get_trait(TRAIT_FLOWERS))
						source_turf.visible_message("<span class='notice'>\The [display_name] sprouts a bevy of flowers!</span>")
						if(prob(degree*2))
							set_trait(TRAIT_FLOWER_COLOUR,"#[pick(rainbow)]")
						source_turf.visible_message("<span class='notice'>\The [display_name]'s flowers </span><font=[get_trait(TRAIT_FLOWER_COLOUR)]>changes colour</font>!")
					else
						source_turf.visible_message("<span class='notice'>\The [display_name]'s flowers wither and fall off.</span>")
			if(12)
				set_trait(TRAIT_TELEPORTING,1)

	return

//Mutates a specific trait/set of traits.
/datum/seed/proc/apply_gene(var/datum/plantgene/gene)

	if(!gene || !gene.values || get_trait(TRAIT_IMMUTABLE) > 0) return

	// Splicing products has some detrimental effects on yield and lifespan.
	// We handle this before we do the rest of the looping, as normal traits don't really include lists.
	if(gene.genetype == GENE_PRODUCTS)
		for(var/trait in list(TRAIT_YIELD, TRAIT_ENDURANCE, TRAIT_LIFESPAN))
			if(get_trait(trait) > 0) set_trait(trait,get_trait(trait),null,1,0.85)

		if(!products) products = list()
		products |= gene.values["[TRAIT_PRODUCTS]"]

		if(!chems) chems = list()

		var/list/gene_value = gene.values["[TRAIT_CHEMS]"]
		for(var/rid in gene_value)

			var/list/gene_chem = gene_value[rid]

			if(!chems[rid])
				chems[rid] = gene_chem.Copy()
				continue

			for(var/i=1;i<=gene_chem.len;i++)

				if(isnull(gene_chem[i])) gene_chem[i] = 0

				if(chems[rid][i])
					chems[rid][i] = max(1,round((gene_chem[i] + chems[rid][i])/2))
				else
					chems[rid][i] = gene_chem[i]

		var/list/new_gasses = gene.values["[TRAIT_EXUDE_GASSES]"]
		if(islist(new_gasses))
			if(!exude_gasses) exude_gasses = list()
			exude_gasses |= new_gasses
			for(var/gas in exude_gasses)
				exude_gasses[gas] = max(1,round(exude_gasses[gas]*0.8))

	for(var/trait in gene.values)
		set_trait(trait,gene.values["[trait]"])

	update_growth_stages()

//Returns a list of the desired trait values.
/datum/seed/proc/get_gene(var/genetype)

	if(!genetype) return 0

	var/list/traits_to_copy
	var/datum/plantgene/P = new()
	P.genetype = genetype
	P.values = list()

	switch(genetype)
		if(GENE_PRODUCTS)
			P.values["[TRAIT_PRODUCTS]"] =       products
			P.values["[TRAIT_CHEMS]"] =          chems
			P.values["[TRAIT_EXUDE_GASSES]"] =   exude_gasses
			traits_to_copy = list(TRAIT_ALTER_TEMP,TRAIT_POTENCY,TRAIT_HARVEST_REPEAT,TRAIT_PRODUCES_POWER,TRAIT_JUICY,TRAIT_PRODUCT_ICON,TRAIT_PLANT_ICON)
		if(GENE_CONSUMPTION)
			P.values["[TRAIT_CONSUME_GASSES]"] = consume_gasses
			traits_to_copy = list(TRAIT_REQUIRES_NUTRIENTS,TRAIT_NUTRIENT_CONSUMPTION,TRAIT_REQUIRES_WATER,TRAIT_WATER_CONSUMPTION,TRAIT_CARNIVOROUS,TRAIT_PARASITE,TRAIT_STINGS)
		if(GENE_ENVIRONMENT)
			traits_to_copy = list(TRAIT_IDEAL_HEAT,TRAIT_HEAT_TOLERANCE,TRAIT_IDEAL_LIGHT,TRAIT_LIGHT_TOLERANCE,TRAIT_LOWKPA_TOLERANCE,TRAIT_HIGHKPA_TOLERANCE,TRAIT_EXPLOSIVE)
		if(GENE_RESISTANCE)
			traits_to_copy = list(TRAIT_TOXINS_TOLERANCE,TRAIT_PEST_TOLERANCE,TRAIT_WEED_TOLERANCE)
		if(GENE_VIGOUR)
			traits_to_copy = list(TRAIT_ENDURANCE,TRAIT_YIELD,TRAIT_LIFESPAN,TRAIT_SPREAD,TRAIT_MATURATION,TRAIT_PRODUCTION,TRAIT_TELEPORTING)
		if(GENE_FLOWERS)
			traits_to_copy = list(TRAIT_PLANT_COLOUR,TRAIT_PRODUCT_COLOUR,TRAIT_BIOLUM,TRAIT_BIOLUM_COLOUR,TRAIT_FLOWERS,TRAIT_FLOWER_ICON,TRAIT_FLOWER_COLOUR)

	for(var/trait in traits_to_copy)
		P.values["[trait]"] = get_trait(trait)
	return (P ? P : 0)

//Place the plant products at the feet of the user.
/datum/seed/proc/harvest(var/mob/user,var/yield_mod,var/harvest_sample,var/force_amount)

	if(!user)
		return

	var/got_product
	if(!isnull(products) && products.len && get_trait(TRAIT_YIELD) > 0)
		got_product = 1

	if(!force_amount && !got_product && !harvest_sample)
		user << "<span class='danger'>You fail to harvest anything useful.</span>"
	else
		user << "You [harvest_sample ? "take a sample" : "harvest"] from the [display_name]."

		//This may be a new line. Update the global if it is.
		if(name == "new line" || !(name in seed_types))
			uid = seed_types.len + 1
			name = "[uid]"
			seed_types[name] = src

		if(harvest_sample)
			var/obj/item/seeds/seeds = new(get_turf(user))
			seeds.seed_type = name
			seeds.update_seed()
			return

		var/total_yield = 0
		if(!isnull(force_amount))
			total_yield = force_amount
		else
			if(get_trait(TRAIT_YIELD) > -1)
				if(isnull(yield_mod) || yield_mod < 1)
					yield_mod = 0
					total_yield = get_trait(TRAIT_YIELD)
				else
					total_yield = get_trait(TRAIT_YIELD) + rand(yield_mod)
				total_yield = max(1,total_yield)

		currently_querying = list()
		for(var/i = 0;i<total_yield;i++)
			var/product_type = pick(products)
			var/obj/item/product = new product_type(get_turf(user),name)

			if(get_trait(TRAIT_PRODUCT_COLOUR))
				product.color = get_trait(TRAIT_PRODUCT_COLOUR)
				if(istype(product,/obj/item/weapon/reagent_containers/food))
					var/obj/item/weapon/reagent_containers/food/food = product
					food.filling_color = get_trait(TRAIT_PRODUCT_COLOUR)

			if(mysterious)
				product.name += "?"
				product.desc += " On second thought, something about this one looks strange."

			if(get_trait(TRAIT_BIOLUM))
				if(get_trait(TRAIT_BIOLUM_COLOUR))
					product.l_color = get_trait(TRAIT_BIOLUM_COLOUR)
				product.SetLuminosity(get_trait(TRAIT_BIOLUM))

			//Handle spawning in living, mobile products (like dionaea).
			if(istype(product,/mob/living))

				product.visible_message("<span class='notice'>The pod disgorges [product]!</span>")
				handle_living_product(product)

// When the seed in this machine mutates/is modified, the tray seed value
// is set to a new datum copied from the original. This datum won't actually
// be put into the global datum list until the product is harvested, though.
/datum/seed/proc/diverge(var/modified)

	if(get_trait(TRAIT_IMMUTABLE) > 0) return

	//Set up some basic information.
	var/datum/seed/new_seed = new
	new_seed.name = "new line"
	new_seed.uid = 0
	new_seed.roundstart = 0

	//Copy over everything else.
	if(products)       new_seed.products = products.Copy()
	if(mutants)        new_seed.mutants = mutants.Copy()
	if(chems)          new_seed.chems = chems.Copy()
	if(consume_gasses) new_seed.consume_gasses = consume_gasses.Copy()
	if(exude_gasses)   new_seed.exude_gasses = exude_gasses.Copy()

	new_seed.seed_name =            "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][seed_name]"
	new_seed.display_name =         "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][display_name]"
	new_seed.seed_noun =            seed_noun
	new_seed.traits = traits.Copy()
	new_seed.update_growth_stages()
	return new_seed

/datum/seed/proc/update_growth_stages()
	if(get_trait(TRAIT_PLANT_ICON))
		growth_stages = plant_sprites[get_trait(TRAIT_PLANT_ICON)]
	else
		growth_stages = 0

/datum/seed/New()

	set_trait(TRAIT_IMMUTABLE,            0)            // If set, plant will never mutate. If -1, plant is highly mutable.
	set_trait(TRAIT_HARVEST_REPEAT,       0)            // If 1, this plant will fruit repeatedly.
	set_trait(TRAIT_PRODUCES_POWER,       0)            // Can be used to make a battery.
	set_trait(TRAIT_JUICY,                0)            // When thrown, causes a splatter decal.
	set_trait(TRAIT_EXPLOSIVE,            0)            // When thrown, acts as a grenade.
	set_trait(TRAIT_CARNIVOROUS,          0)            // 0 = none, 1 = eat pests in tray, 2 = eat living things  (when a vine).
	set_trait(TRAIT_PARASITE,             0)            // 0 = no, 1 = gain health from weed level.
	set_trait(TRAIT_STINGS,               0)            // Can cause damage/inject reagents when thrown or handled.
	set_trait(TRAIT_YIELD,                0)            // Amount of product.
	set_trait(TRAIT_LIFESPAN,             0)            // Time before the plant dies.
	set_trait(TRAIT_SPREAD,               0)            // 0 limits plant to tray, 1 = creepers, 2 = vines.
	set_trait(TRAIT_MATURATION,           0)            // Time taken before the plant is mature.
	set_trait(TRAIT_PRODUCTION,           0)            // Time before harvesting can be undertaken again.
	set_trait(TRAIT_TELEPORTING,          0)            // Uses the bluespace tomato effect.
	set_trait(TRAIT_BIOLUM,               0)            // Plant is bioluminescent.
	set_trait(TRAIT_FLOWERS,              0)            // Plant has a flower overlay.
	set_trait(TRAIT_ALTER_TEMP,           0)            // If set, the plant will periodically alter local temp by this amount.
	set_trait(TRAIT_PRODUCT_ICON,         0)            // Icon to use for fruit coming from this plant.
	set_trait(TRAIT_PLANT_ICON,           0)            // Icon to use for the plant growing in the tray.
	set_trait(TRAIT_PRODUCT_COLOUR,       0)            // Colour to apply to product icon.
	set_trait(TRAIT_BIOLUM_COLOUR,        0)            // The colour of the plant's radiance.
	set_trait(TRAIT_FLOWER_COLOUR,        0)            // Which colour to use.
	set_trait(TRAIT_POTENCY,              1)            // General purpose plant strength value.
	set_trait(TRAIT_REQUIRES_NUTRIENTS,   1)            // The plant can starve.
	set_trait(TRAIT_REQUIRES_WATER,       1)            // The plant can become dehydrated.
	set_trait(TRAIT_WATER_CONSUMPTION,    3)            // Plant drinks this much per tick.
	set_trait(TRAIT_LIGHT_TOLERANCE,      5)            // Departure from ideal that is survivable.
	set_trait(TRAIT_TOXINS_TOLERANCE,     5)            // Resistance to poison.
	set_trait(TRAIT_PEST_TOLERANCE,       5)            // Threshold for pests to impact health.
	set_trait(TRAIT_WEED_TOLERANCE,       5)            // Threshold for weeds to impact health.
	set_trait(TRAIT_IDEAL_LIGHT,          8)            // Preferred light level in luminosity.
	set_trait(TRAIT_HEAT_TOLERANCE,       20)           // Departure from ideal that is survivable.
	set_trait(TRAIT_LOWKPA_TOLERANCE,     25)           // Low pressure capacity.
	set_trait(TRAIT_ENDURANCE,            100)          // Maximum plant HP when growing.
	set_trait(TRAIT_HIGHKPA_TOLERANCE,    200)          // High pressure capacity.
	set_trait(TRAIT_IDEAL_HEAT,           293)          // Preferred temperature in Kelvin.
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)         // Plant eats this much per tick.
	set_trait(TRAIT_PLANT_COLOUR,         "#6EF86A")    // Colour of the plant icon.
	set_trait(TRAIT_FLOWER_ICON,          "vine_fruit") // Which overlay to use.

	spawn(5)
		sleep(-1)
		update_growth_stages()


// Actual roundstart seed types after this point.
// Chili plants/variants.
/datum/seed/chili
	name = "chili"
	seed_name = "chili"
	display_name = "chili plants"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/chili)
	chems = list("capsaicin" = list(3,5), "nutriment" = list(1,25))
	mutants = list("icechili")

/datum/seed/chili/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ED3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")

/datum/seed/chili/ice
	name = "icechili"
	seed_name = "ice pepper"
	display_name = "ice-pepper plants"
	mutants = null
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/icepepper)
	chems = list("frostoil" = list(3,5), "nutriment" = list(1,50))

/datum/seed/chili/ice/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00EDC6")

// Berry plants/variants.
/datum/seed/berry
	name = "berries"
	seed_name = "berry"
	display_name = "berry bush"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/berries)
	mutants = list("glowberries","poisonberries")
	chems = list("nutriment" = list(1,10))

/datum/seed/berry/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FA1616")
	set_trait(TRAIT_PLANT_ICON,"bush")

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries)
	mutants = null
	chems = list("nutriment" = list(1,10), "uranium" = list(3,5))

/datum/seed/berry/glow/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_LIFESPAN,30)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"c9fa16")

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	display_name = "poison berry bush"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/poisonberries)
	mutants = list("deathberries")
	chems = list("nutriment" = list(1), "toxin" = list(3,5))

/datum/seed/berry/poison/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6DC961")

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/deathberries)
	chems = list("nutriment" = list(1), "toxin" = list(3,3), "lexorin" = list(1,5))

/datum/seed/berry/poison/death/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5454")

// Nettles/variants.
/datum/seed/nettle
	name = "nettle"
	seed_name = "nettle"
	display_name = "nettles"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/nettle)
	mutants = list("deathnettle")
	chems = list("nutriment" = list(1,50), "sacid" = list(0,1))

/datum/seed/nettle/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,30)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_STINGS,1)
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#728A54")

/datum/seed/nettle/death
	name = "deathnettle"
	seed_name = "death nettle"
	display_name = "death nettles"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/nettle/death)
	mutants = null
	chems = list("nutriment" = list(1,50), "pacid" = list(0,1))

/datum/seed/nettle/death/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#8C5030")
	set_trait(TRAIT_PLANT_COLOUR,"#634941")

//Tomatoes/variants.
/datum/seed/tomato
	name = "tomato"
	seed_name = "tomato"
	display_name = "tomato plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/tomato)
	mutants = list("bluetomato","bloodtomato")
	chems = list("nutriment" = list(1,10))

/datum/seed/tomato/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"tomato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D10000")
	set_trait(TRAIT_PLANT_ICON,"bush3")

/datum/seed/tomato/blood
	name = "bloodtomato"
	seed_name = "blood tomato"
	display_name = "blood tomato plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/bloodtomato)
	mutants = list("killer")
	chems = list("nutriment" = list(1,10), "blood" = list(1,5))
	splat_type = /obj/effect/decal/cleanable/blood/splatter

/datum/seed/tomato/blood/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF0000")

/datum/seed/tomato/killer
	name = "killertomato"
	seed_name = "killer tomato"
	display_name = "killer tomato plant"
	products = list(/mob/living/simple_animal/tomato)
	mutants = null

/datum/seed/tomato/killer/New()
	..()
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#A86747")

/datum/seed/tomato/blue
	name = "bluetomato"
	seed_name = "blue tomato"
	display_name = "blue tomato plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato)
	mutants = list("bluespacetomato")
	chems = list("nutriment" = list(1,20), "lube" = list(1,5))

/datum/seed/tomato/blue/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#4D86E8")
	set_trait(TRAIT_PLANT_COLOUR,"#070AAD")

/datum/seed/tomato/blue/teleport
	name = "bluespacetomato"
	seed_name = "bluespace tomato"
	display_name = "bluespace tomato plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato)
	mutants = null
	chems = list("nutriment" = list(1,20), "singulo" = list(1,5))

/datum/seed/tomato/blue/teleport/New()
	..()
	set_trait(TRAIT_TELEPORTING,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00E5FF")
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#4DA4A8")

//Eggplants/varieties.
/datum/seed/eggplant
	name = "eggplant"
	seed_name = "eggplant"
	display_name = "eggplants"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant)
	mutants = list("realeggplant")
	chems = list("nutriment" = list(1,10))

/datum/seed/eggplant/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")

/datum/seed/eggplant/eggs
	name = "realeggplant"
	seed_name = "egg-plant"
	display_name = "egg-plants"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/egg)
	mutants = null

/datum/seed/eggplant/eggs/New()
	..()
	set_trait(TRAIT_LIFESPAN,75)
	set_trait(TRAIT_PRODUCTION,12)
	set_trait(TRAIT_PRODUCT_COLOUR,"#E7EDD1")

//Apples/varieties.
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/apple)
	mutants = list("poisonapple","goldapple")
	chems = list("nutriment" = list(1,10))

/datum/seed/apple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,55)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF540A")
	set_trait(TRAIT_PLANT_ICON,"tree2")

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/apple/poisoned)
	chems = list("cyanide" = list(1,5))

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/goldapple)
	mutants = null
	chems = list("nutriment" = list(1,10), "gold" = list(1,5))

/datum/seed/apple/gold/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDD00")
	set_trait(TRAIT_PLANT_COLOUR,"#D6B44D")

//Ambrosia/varieties.
/datum/seed/ambrosia
	name = "ambrosia"
	seed_name = "ambrosia vulgaris"
	display_name = "ambrosia vulgaris"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris)
	mutants = list("ambrosiadeus")
	chems = list("nutriment" = list(1), "space_drugs" = list(1,8), "kelotane" = list(1,8,1), "bicaridine" = list(1,10,1), "toxin" = list(1,10))

/datum/seed/ambrosia/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,60)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9FAD55")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")

/datum/seed/ambrosia/deus
	name = "ambrosiadeus"
	seed_name = "ambrosia deus"
	display_name = "ambrosia deus"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus)
	mutants = null
	chems = list("nutriment" = list(1), "bicaridine" = list(1,8), "synaptizine" = list(1,8,1), "hyperzine" = list(1,10,1), "space_drugs" = list(1,10))

/datum/seed/ambrosia/deus/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#A3F0AD")
	set_trait(TRAIT_PLANT_COLOUR,"#2A9C61")

//Mushrooms/varieties.
/datum/seed/mushroom
	name = "mushrooms"
	seed_name = "chanterelle"
	seed_noun = "spores"
	display_name = "chanterelle mushrooms"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle)
	mutants = list("reishi","amanita","plumphelmet")
	chems = list("nutriment" = list(1,25))

/datum/seed/mushroom/New()
	..()
	set_trait(TRAIT_LIFESPAN,35)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBDA72")
	set_trait(TRAIT_PLANT_COLOUR,"#D9C94E")
	set_trait(TRAIT_PLANT_ICON,"mushroom")

/datum/seed/mushroom/mold
	name = "mold"
	seed_name = "brown mold"
	display_name = "brown mold"
	products = null
	mutants = null

/datum/seed/mushroom/mold/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")

/datum/seed/mushroom/plump
	name = "plumphelmet"
	seed_name = "plump helmet"
	display_name = "plump helmet mushrooms"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet)
	mutants = list("walkingmushroom","towercap")
	chems = list("nutriment" = list(2,10))

/datum/seed/mushroom/plump/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,0)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom10")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57BB0")
	set_trait(TRAIT_PLANT_COLOUR,"#9E4F9D")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")

/datum/seed/mushroom/plump/walking
	name = "walkingmushroom"
	seed_name = "walking mushroom"
	display_name = "walking mushrooms"
	products = list(/mob/living/simple_animal/mushroom)
	mutants = null

/datum/seed/mushroom/plump/walking/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FAC0F2")
	set_trait(TRAIT_PLANT_COLOUR,"#C4B1C2")

/datum/seed/mushroom/hallucinogenic
	name = "reishi"
	seed_name = "reishi"
	display_name = "reishi"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/reishi)
	mutants = list("libertycap","glowshroom")
	chems = list("nutriment" = list(1,50), "psilocybin" = list(3,5))

/datum/seed/mushroom/hallucinogenic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFB70F")
	set_trait(TRAIT_PLANT_COLOUR,"#F58A18")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/datum/seed/mushroom/hallucinogenic/strong
	name = "libertycap"
	seed_name = "liberty cap"
	display_name = "liberty cap mushrooms"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap)
	mutants = null
	chems = list("nutriment" = list(1), "stoxin" = list(3,3), "space_drugs" = list(1,25))

/datum/seed/mushroom/hallucinogenic/strong/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom8")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F2E550")
	set_trait(TRAIT_PLANT_COLOUR,"#D1CA82")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/poison
	name = "amanita"
	seed_name = "fly amanita"
	display_name = "fly amanita mushrooms"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita)
	mutants = list("destroyingangel","plastic")
	chems = list("nutriment" = list(1), "amatoxin" = list(3,3), "psilocybin" = list(1,25))

/datum/seed/mushroom/poison/New()
	..()
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF4545")
	set_trait(TRAIT_PLANT_COLOUR,"#F5F2D0")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/poison/death
	name = "destroyingangel"
	seed_name = "destroying angel"
	display_name = "destroying angel mushrooms"
	mutants = null
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/angel)
	chems = list("nutriment" = list(1,50), "amatoxin" = list(13,3), "psilocybin" = list(1,25))

/datum/seed/mushroom/poison/death/New()
	..()
	set_trait(TRAIT_MATURATION,12)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,35)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EDE8EA")
	set_trait(TRAIT_PLANT_COLOUR,"#E6D8DD")
	set_trait(TRAIT_PLANT_ICON,"mushroom5")

/datum/seed/mushroom/towercap
	name = "towercap"
	seed_name = "tower cap"
	display_name = "tower caps"
	mutants = null
	products = list(/obj/item/weapon/grown/log)

/datum/seed/mushroom/towercap/New()
	..()
	set_trait(TRAIT_LIFESPAN,80)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom7")
	set_trait(TRAIT_PRODUCT_COLOUR,"#79A36D")
	set_trait(TRAIT_PLANT_COLOUR,"#857F41")
	set_trait(TRAIT_PLANT_ICON,"mushroom8")

/datum/seed/mushroom/glowshroom
	name = "glowshroom"
	seed_name = "glowshroom"
	display_name = "glowshrooms"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom)
	mutants = null
	chems = list("radium" = list(1,20))
	splat_type = /obj/effect/glowshroom

/datum/seed/mushroom/glowshroom/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_LIFESPAN,120)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_EXPLOSIVE,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DDFAB6")
	set_trait(TRAIT_PLANT_COLOUR,"#EFFF8A")
	set_trait(TRAIT_PLANT_ICON,"mushroom7")

/datum/seed/mushroom/plastic
	name = "plastic"
	seed_name = "plastellium"
	display_name = "plastellium"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/plastellium)
	mutants = null
	chems = list("plasticide" = list(1,10))

/datum/seed/mushroom/plastic/New()
	..()
	set_trait(TRAIT_LIFESPAN,15)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_ICON,"mushroom10")

//Flowers/varieties
/datum/seed/flower
	name = "harebells"
	seed_name = "harebell"
	display_name = "harebells"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/harebell)
	chems = list("nutriment" = list(1,20))

/datum/seed/flower/New()
	..()
	set_trait(TRAIT_LIFESPAN,100)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_ICON,"flower5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#C492D6")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"flower")

/datum/seed/flower/poppy
	name = "poppies"
	seed_name = "poppy"
	display_name = "poppies"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/poppy)
	chems = list("nutriment" = list(1,20), "bicaridine" = list(1,10))

/datum/seed/flower/poppy/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B33715")
	set_trait(TRAIT_PLANT_ICON,"flower3")

/datum/seed/flower/sunflower
	name = "sunflowers"
	seed_name = "sunflower"
	display_name = "sunflowers"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/sunflower)

/datum/seed/flower/sunflower/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF700")
	set_trait(TRAIT_PLANT_ICON,"flower2")

//Grapes/varieties
/datum/seed/grapes
	name = "grapes"
	seed_name = "grape"
	display_name = "grapevines"
	mutants = list("greengrapes")
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/grapes)
	chems = list("nutriment" = list(1,10), "sugar" = list(1,5))

/datum/seed/grapes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#BB6AC4")
	set_trait(TRAIT_PLANT_COLOUR,"#378F2E")
	set_trait(TRAIT_PLANT_ICON,"vine")

/datum/seed/grapes/green
	name = "greengrapes"
	seed_name = "green grape"
	display_name = "green grapevines"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/greengrapes)
	mutants = null
	chems = list("nutriment" = list(1,10), "kelotane" = list(3,5))

/datum/seed/grapes/green/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"42ed2f")

//Everything else
/datum/seed/peanuts
	name = "peanut"
	seed_name = "peanut"
	display_name = "peanut vines"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/peanut)
	chems = list("nutriment" = list(1,10))

/datum/seed/peanuts/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,55)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96855D")
	set_trait(TRAIT_PLANT_ICON,"bush2")

/datum/seed/cabbage
	name = "cabbage"
	seed_name = "cabbage"
	display_name = "cabbages"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage)
	chems = list("nutriment" = list(1,10))

/datum/seed/cabbage/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cabbage")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84BD82")
	set_trait(TRAIT_PLANT_COLOUR,"#6D9C6B")
	set_trait(TRAIT_PLANT_ICON,"vine2")

/datum/seed/banana
	name = "banana"
	seed_name = "banana"
	display_name = "banana tree"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana)
	chems = list("banana" = list(1,10))

/datum/seed/banana/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"bananas")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFEC1F")
	set_trait(TRAIT_PLANT_COLOUR,"#69AD50")
	set_trait(TRAIT_PLANT_ICON,"tree4")

/datum/seed/corn
	name = "corn"
	seed_name = "corn"
	display_name = "ears of corn"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/corn)
	chems = list("nutriment" = list(1,10))

/datum/seed/corn/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")

/datum/seed/potato
	name = "potato"
	seed_name = "potato"
	display_name = "potatoes"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/potato)
	chems = list("nutriment" = list(1,10))

/datum/seed/potato/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_LIFESPAN,30)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D4CAB4")
	set_trait(TRAIT_PLANT_ICON,"bush2")

/datum/seed/soybean
	name = "soybean"
	seed_name = "soybean"
	display_name = "soybeans"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans)
	chems = list("nutriment" = list(1,20))

/datum/seed/soybean/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EBE7C0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/wheat
	name = "wheat"
	seed_name = "wheat"
	display_name = "wheat stalks"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/wheat)
	chems = list("nutriment" = list(1,25))

/datum/seed/wheat/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"wheat")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBD37D")
	set_trait(TRAIT_PLANT_COLOUR,"#BFAF82")
	set_trait(TRAIT_PLANT_ICON,"stalk2")

/datum/seed/rice
	name = "rice"
	seed_name = "rice"
	display_name = "rice stalks"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/ricestalk)
	chems = list("nutriment" = list(1,25))

/datum/seed/rice/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"rice")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D5E6D1")
	set_trait(TRAIT_PLANT_COLOUR,"#8ED17D")
	set_trait(TRAIT_PLANT_ICON,"stalk2")

/datum/seed/carrots
	name = "carrot"
	seed_name = "carrot"
	display_name = "carrots"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/carrot)
	chems = list("nutriment" = list(1,20), "imidazoline" = list(3,5))

/datum/seed/carrots/New()
	..()
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDB4A")
	set_trait(TRAIT_PLANT_ICON,"carrot")

/datum/seed/weeds
	name = "weeds"
	seed_name = "weed"
	display_name = "weeds"

/datum/seed/weeds/New()
	..()
	set_trait(TRAIT_LIFESPAN,100)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_POTENCY,-1)
	set_trait(TRAIT_IMMUTABLE,-1)
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FCEB2B")
	set_trait(TRAIT_PLANT_COLOUR,"#59945A")
	set_trait(TRAIT_PLANT_ICON,"bush6")

/datum/seed/whitebeets
	name = "whitebeet"
	seed_name = "white-beet"
	display_name = "white-beets"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/whitebeet)
	chems = list("nutriment" = list(0,20), "sugar" = list(1,5))

/datum/seed/whitebeets/New()
	..()
	set_trait(TRAIT_LIFESPAN,60)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EEF5B0")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"carrot2")

/datum/seed/sugarcane
	name = "sugarcane"
	seed_name = "sugarcane"
	display_name = "sugarcanes"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane)
	chems = list("sugar" = list(4,5))

/datum/seed/sugarcane/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,60)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B4D6BD")
	set_trait(TRAIT_PLANT_COLOUR,"#6BBD68")
	set_trait(TRAIT_PLANT_ICON,"stalk3")

/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon)
	chems = list("nutriment" = list(1,6))

/datum/seed/watermelon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#326B30")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")

/datum/seed/pumpkin
	name = "pumpkin"
	seed_name = "pumpkin"
	display_name = "pumpkin vine"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin)
	chems = list("nutriment" = list(1,6))

/datum/seed/pumpkin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B4D4B9")
	set_trait(TRAIT_PLANT_COLOUR,"#BAE8C1")
	set_trait(TRAIT_PLANT_ICON,"vine2")

/datum/seed/citrus
	name = "lime"
	seed_name = "lime"
	display_name = "lime trees"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown)
	chems = list("nutriment" = list(1,20))

/datum/seed/citrus/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_LIFESPAN,55)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3AF026")
	set_trait(TRAIT_PLANT_ICON,"tree")

/datum/seed/citrus/lemon
	name = "lemon"
	seed_name = "lemon"
	display_name = "lemon trees"

/datum/seed/citrus/lemon/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#F0E226")

/datum/seed/citrus/orange
	name = "orange"
	seed_name = "orange"
	display_name = "orange trees"

/datum/seed/citrus/orange/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFC20A")

/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "grass"
	products = list(/obj/item/stack/tile/grass)

/datum/seed/grass/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,60)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09FF00")
	set_trait(TRAIT_PLANT_COLOUR,"#07D900")
	set_trait(TRAIT_PLANT_ICON,"grass")

/datum/seed/cocoa
	name = "cocoa"
	seed_name = "cacao"
	display_name = "cacao tree"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod)
	chems = list("nutriment" = list(1,10), "coco" = list(4,5))

/datum/seed/cocoa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#CCA935")
	set_trait(TRAIT_PLANT_ICON,"tree2")

/datum/seed/cherries
	name = "cherry"
	seed_name = "cherry"
	seed_noun = "pits"
	display_name = "cherry tree"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/cherries)
	chems = list("nutriment" = list(1,15), "sugar" = list(1,15))

/datum/seed/cherries/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_LIFESPAN,35)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#8C0101")
	set_trait(TRAIT_PLANT_ICON,"tree2")

/datum/seed/kudzu
	name = "kudzu"
	seed_name = "kudzu"
	display_name = "kudzu vines"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/kudzupod)
	chems = list("nutriment" = list(1,50), "anti_toxin" = list(1,25))

/datum/seed/kudzu/New()
	..()
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96D278")
	set_trait(TRAIT_PLANT_COLOUR,"#6F7A63")
	set_trait(TRAIT_PLANT_ICON,"vine2")

/datum/seed/diona
	name = "diona"
	seed_name = "diona"
	seed_noun = "nodes"
	display_name = "replicant pods"
	products = list(/mob/living/carbon/alien/diona)
	product_requires_player = 1

/datum/seed/diona/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_ENDURANCE,8)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"diona")
	set_trait(TRAIT_PRODUCT_COLOUR,"#799957")
	set_trait(TRAIT_PLANT_COLOUR,"#66804B")
	set_trait(TRAIT_PLANT_ICON,"alien4")

/datum/seed/shand
	name = "shand"
	seed_name = "S'randar's hand"
	display_name = "S'randar's hand leaves"
	products = list(/obj/item/stack/medical/bruise_pack/tajaran)
	chems = list("bicaridine" = list(0,10))

/datum/seed/shand/New()
	..()
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_ICON,"tree5")

/datum/seed/mtear
	name = "mtear"
	seed_name = "Messa's tear"
	display_name = "Messa's tear leaves"
	products = list(/obj/item/stack/medical/ointment/tajaran)
	chems = list("honey" = list(1,10), "kelotane" = list(3,5))

/datum/seed/mtear/New()
	..()
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4CC5C7")
	set_trait(TRAIT_PLANT_COLOUR,"#4CC789")
	set_trait(TRAIT_PLANT_ICON,"bush7")

/datum/seed/telriis
	name = "telriis"
	seed_name = "telriis"
	display_name = "telriis grass"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/telriis_clump)

/datum/seed/telriis/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"telriis")
	set_trait(TRAIT_LIFESPAN,50)
	set_trait(TRAIT_ENDURANCE,50)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)

/datum/seed/thaadra
	name = "thaadra"
	seed_name = "thaa'dra"
	display_name = "thaa'dra lichen"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/thaadrabloom)

/datum/seed/thaadra/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"thaadra")
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)

/datum/seed/jurlmah
	name = "jurlmah"
	seed_name = "jurl'mah"
	display_name = "jurl'mah reeds"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/jurlmah)

/datum/seed/jurlmah/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"jurlmah")
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_ENDURANCE,12)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)

/datum/seed/amauri
	name = "amauri"
	seed_name = "amauri"
	display_name = "amauri plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/amauri)

/datum/seed/amauri/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"amauri")
	set_trait(TRAIT_LIFESPAN,30)
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)

/datum/seed/gelthi
	name = "gelthi"
	seed_name = "gelthi"
	display_name = "gelthi plant"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/gelthi)

/datum/seed/gelthi/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"gelthi")
	set_trait(TRAIT_LIFESPAN,20)
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,1)

/datum/seed/vale
	name = "vale"
	seed_name = "vale"
	display_name = "vale bush"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/vale)

/datum/seed/vale/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"vale")
	set_trait(TRAIT_LIFESPAN,25)
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)

/datum/seed/surik
	name = "surik"
	seed_name = "surik"
	display_name = "surik vine"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/grown/surik)

/datum/seed/surik/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"surik")
	set_trait(TRAIT_LIFESPAN,30)
	set_trait(TRAIT_ENDURANCE,18)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,7)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
