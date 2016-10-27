var/list/fusion_reactions

/decl/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100

/decl/fusion_reaction/proc/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	return 0

proc/get_fusion_reaction(var/p_react, var/s_react, var/m_energy)
	if(!fusion_reactions)
		fusion_reactions = list()
		for(var/rtype in typesof(/decl/fusion_reaction) - /decl/fusion_reaction)
			var/decl/fusion_reaction/cur_reaction = new rtype()
			if(!fusion_reactions[cur_reaction.p_react])
				fusion_reactions[cur_reaction.p_react] = list()
			fusion_reactions[cur_reaction.p_react][cur_reaction.s_react] = cur_reaction
			if(!fusion_reactions[cur_reaction.s_react])
				fusion_reactions[cur_reaction.s_react] = list()
			fusion_reactions[cur_reaction.s_react][cur_reaction.p_react] = cur_reaction

	if(fusion_reactions.Find(p_react))
		var/list/secondary_reactions = fusion_reactions[p_react]
		if(secondary_reactions.Find(s_react))
			return fusion_reactions[p_react][s_react]

// Material fuels
//  deuterium
//  tritium
//  phoron
//  supermatter

// Virtual fuels
//  helium-3
//  lithium-6
//  boron-11

// Basic power production reactions.
/decl/fusion_reaction/deuterium_deuterium
	p_react = "deuterium"
	s_react = "deuterium"
	energy_consumption = 1
	energy_production = 1.75
	radiation = 1

// Advanced production reactions (todo)
/decl/fusion_reaction/deuterium_helium
	p_react = "deuterium"
	s_react = "helium-3"
	energy_consumption = 1
	energy_production = 5
	radiation = 2

/decl/fusion_reaction/deuterium_tritium
	p_react = "deuterium"
	s_react = "tritium"
	energy_consumption = 1
	energy_production = 1
	products = list("helium-3" = 1)
	instability = 0.5
	radiation = 3

/decl/fusion_reaction/deuterium_lithium
	p_react = "deuterium"
	s_react = "lithium"
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list("tritium"= 1)
	instability = 1

/decl/fusion_reaction/phoron_supermatter
	p_react = "supermatter"
	s_react = "phoron"
	energy_consumption = 0
	energy_production = 5
	radiation = 20
	instability = 20

/decl/fusion_reaction/phoron_supermatter/handle_reaction_special(var/obj/effect/fusion_em_field/holder)

	wormhole_event()

	var/turf/origin = get_turf(holder)
	holder.Rupture()
	qdel(holder)

	// Copied from the SM for proof of concept.
	for(var/mob/living/mob in living_mob_list_)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mob
				H.hallucination += rand(100,150)
			mob.apply_effect(rand(100,200), IRRADIATE)

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.fuel_type == "supermatter")
			explosion(get_turf(I), 1, 2, 3)
			spawn(5)
				if(I && I.loc)
					qdel(I)

	sleep(5)
	explosion(origin, 1, 2, 5)

	return 1


/*
/decl/fusion_reaction/boron_hydrogen
	// very high energy level required

/decl/fusion_reaction/hydrogen_hydrogen
	//  Proton-proton at absurd energy levels (using supermatter or something to boost mega-energy that high?)
*/