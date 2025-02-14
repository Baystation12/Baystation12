var/global/list/fusion_reactions

/singleton/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100
	var/priority = 100

/singleton/fusion_reaction/proc/handle_reaction_special(obj/fusion_em_field/holder)
	return 0

/proc/get_fusion_reaction(p_react, s_react, m_energy)
	if(!fusion_reactions)
		fusion_reactions = list()
		for(var/rtype in typesof(/singleton/fusion_reaction) - /singleton/fusion_reaction)
			var/singleton/fusion_reaction/cur_reaction = new rtype()
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

// Gaseous/reagent fuels
//  hydrogen
//  helium
//  lithium
//  boron

// Things that probably should be avoided
//  nitrogen
//  oxygen
//  phoron

// H2 shouldn't really be used for this but adding more gases will make a big mess

/singleton/fusion_reaction/hydrogen_hydrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_HYDROGEN
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_HELIUM = 1)
	priority = 10

/singleton/fusion_reaction/deuterium_deuterium
	p_react = GAS_DEUTERIUM
	s_react = GAS_DEUTERIUM
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_TRITIUM = 0.5, GAS_HELIUM = 1)
	priority = 0
	radiation = 1

/singleton/fusion_reaction/deuterium_helium
	p_react = GAS_DEUTERIUM
	s_react = GAS_HELIUM
	energy_consumption = 1
	energy_production = 5
	minimum_reaction_temperature = 10000
	radiation = 2

/singleton/fusion_reaction/deuterium_tritium
	p_react = GAS_DEUTERIUM
	s_react = GAS_TRITIUM
	energy_consumption = 1
	energy_production = 1
	products = list(GAS_HELIUM = 1)
	radiation = 3

/singleton/fusion_reaction/deuterium_lithium
	p_react = GAS_DEUTERIUM
	s_react = "lithium"
	energy_consumption = 2
	energy_production = 2
	radiation = 3
	products = list(GAS_HELIUM = 2)

/singleton/fusion_reaction/hydrogen_lithium
	p_react = GAS_HYDROGEN
	s_react = "lithium"
	energy_consumption = 1
	energy_production = 2
	products = list(GAS_HELIUM = 2)
	instability = 1

/singleton/fusion_reaction/helium_lithium
	p_react = GAS_HELIUM
	s_react = "lithium"
	energy_consumption = 1
	energy_production = 5
	instability = 1
	radiation = 1

/singleton/fusion_reaction/helium_helium
	p_react = GAS_HELIUM
	s_react = GAS_HELIUM
	energy_consumption = 2
	energy_production = 4
	minimum_reaction_temperature = 30000
	priority = 10
	radiation = 3

/singleton/fusion_reaction/hydrogen_nitrogen
	p_react = GAS_HYDROGEN
	s_react = GAS_NITROGEN
	energy_consumption = 2
	energy_production = 3
	products = list(GAS_HELIUM = 1, "carbon" = 1)
	minimum_reaction_temperature = 30000
	radiation = 2

/singleton/fusion_reaction/carbon_carbon
	p_react = "carbon"
	s_react = "carbon"
	energy_consumption = 3
	energy_production = 2
	products = list(GAS_HELIUM = 2, GAS_NEON = 0.5, GAS_HYDROGEN = 0.5, GAS_OXYGEN = 0.5, "sodium" = 1)
	instability = 1
	minimum_reaction_temperature = 30000
	radiation = 10

/singleton/fusion_reaction/hydrogen_carbon
	p_react = GAS_HYDROGEN
	s_react = "carbon"
	energy_consumption = 4
	energy_production = 5
	minimum_reaction_temperature = 50000
	radiation = 10

/singleton/fusion_reaction/hydrogen_oxygen
	p_react = GAS_HYDROGEN
	s_react = GAS_OXYGEN
	energy_consumption = 3
	energy_production = 2
	products = list(GAS_NITROGEN = 1, GAS_HELIUM = 1)
	minimum_reaction_temperature = 50000
	radiation = 10

/singleton/fusion_reaction/helium_neon
	p_react = GAS_HELIUM
	s_react = GAS_NEON
	energy_consumption = 2
	energy_production = 3
	products = list("silicon" = 1)
	minimum_reaction_temperature = 50000
	radiation = 12

/singleton/fusion_reaction/oxygen_oxygen
	p_react = GAS_OXYGEN
	s_react = GAS_OXYGEN
	energy_consumption = 3
	energy_production = 2
	products = list("silicon"= 1, "phosphorus"= 1, "sulfur"= 1, GAS_HELIUM = 0.5, GAS_HYDROGEN = 2, GAS_DEUTERIUM = 0.5)
	minimum_reaction_temperature = 60000
	instability = 2
	radiation = 5

/singleton/fusion_reaction/helium_silicon
	p_react = GAS_HELIUM
	s_react = "silicon"
	energy_consumption = 3
	energy_production = 2
	products = list("sulfur" = 10)
	minimum_reaction_temperature = 60000
	instability = 1
	radiation = 3

/singleton/fusion_reaction/helium_sulfur
	p_react = GAS_HELIUM
	s_react = "sulfur"
	energy_consumption = 3
	energy_production = 2
	products = list(GAS_ARGON = 1)
	minimum_reaction_temperature = 70000
	instability = 1
	radiation = 3

/singleton/fusion_reaction/helium_argon
	p_react = GAS_HELIUM
	s_react = GAS_ARGON
	energy_consumption = 3
	energy_production = 1
	products = list("titanium" = 10)
	minimum_reaction_temperature = 70000
	instability = 1
	radiation = 3

/singleton/fusion_reaction/helium_titanium
	p_react = GAS_HELIUM
	s_react = "titanium"
	energy_consumption = 3
	energy_production = 0
	products = list("iron" = 10)
	minimum_reaction_temperature = 80000
	instability = 1
	radiation = 3

/singleton/fusion_reaction/phoron_iron
	p_react = "iron"
	s_react = GAS_PHORON
	energy_consumption = 5
	energy_production = 0
	instability = 2
	products = list("silver" = 30, "gold" = 20, "platinum" = 10)
	radiation = 5

// VERY UNIDEAL REACTIONS.
/singleton/fusion_reaction/phoron_supermatter
	p_react = "supermatter"
	s_react = GAS_PHORON
	energy_consumption = 0
	energy_production = 5
	radiation = 40
	instability = 20

/singleton/fusion_reaction/phoron_supermatter/handle_reaction_special(obj/fusion_em_field/holder)

	wormhole_event(GetConnectedZlevels(holder))

	var/turf/origin = get_turf(holder)
	holder.Rupture()
	qdel(holder)
	var/radiation_level = rand(100, 200)

	// Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	SSradiation.z_radiate(locate(1, 1, holder.z), radiation_level, 1)

	for(var/mob/living/mob in GLOB.alive_mobs)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mob
				H.hallucination(rand(100,150), 51)

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.fuel_type == MATERIAL_SUPERMATTER)
			explosion(get_turf(I), 6)
			spawn(5)
				if(I && I.loc)
					qdel(I)

	sleep(5)
	explosion(origin, 8)

	return 1


// High end reactions.
/singleton/fusion_reaction/boron_hydrogen
	p_react = GAS_BORON
	s_react = GAS_HYDROGEN
	minimum_energy_level = 15000
	energy_consumption = 3
	energy_production = 12
	radiation = 3
	instability = 2.5
	products = list(GAS_HELIUM = 1)
