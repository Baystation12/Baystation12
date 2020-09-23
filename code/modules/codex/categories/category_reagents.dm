/datum/codex_category/reagents/
	name = "Reagents"
	desc = "Chemicals and reagents, both natural and artificial."

/datum/codex_category/reagents/Initialize()

	for(var/thing in subtypesof(/datum/reagent))
		// General Details
		var/datum/reagent/reagent = thing
		if(initial(reagent.hidden_from_codex))
			continue
		var/chem_name = lowertext(initial(reagent.name))
		var/datum/codex_entry/entry = new( \
		 _display_name = "[chem_name] (chemical)", \
		 _associated_strings = list(chem_name, "[chem_name] pill"))

		// General Description(s)
		entry.lore_text += "<p>[initial(reagent.codex_lore) ? initial(reagent.codex_lore) : initial(reagent.description)]</p>"
		if (initial(reagent.codex_mechanics))
			entry.mechanics_text += "<p>[initial(reagent.codex_mechanics)]</p>"

		// Taste Description
		if (initial(reagent.taste_description))
			entry.lore_text += "<p>It apparently tastes of [initial(reagent.taste_description)].</p>"

		// Overdose
		if (initial(reagent.overdose))
			entry.mechanics_text += "<p>The overdose level is [initial(reagent.overdose)] units.</p>"

		// Alcohol Notes
		if (istype(reagent, /datum/reagent/ethanol))
			entry.mechanics_text += "<p>When ingested, alcohol increases hunger and thirst and makes you drunk. Skrell have a 5 times modifier to alcoholic effects. Diona are unaffected by alcohol.</p>\
				<p>Combining alcohol and painkillers, such as Tramadol, can cause an inability to breathe or stop your heart.</p>"

		// Acid Notes
		if (istype(reagent, /datum/reagent/acid))
			entry.mechanics_text += "<p>It causes internal organ damage if ingested or injected.</p>\
				<p>It can cause severe injury or even death if splashed on someone.</p>\
				<p>It can melt items and vines when splashed on them.</p>"

		// Toxin Notes
		if (istype(reagent, /datum/reagent/toxin))
			var/datum/reagent/toxin/reagent_toxin = reagent
			entry.mechanics_text += "<p>It has a toxin strength level of [initial(reagent_toxin.strength)].</p>"

		// Chemical Effects
		var/effect_descriptor
		var/effect_level
		if (initial(reagent.toxin_blood))
			effect_level = initial(reagent.toxin_blood)
			if (effect_level <= 1)
				effect_descriptor = "mildly"
			else if (effect_level <= 2)
				effect_descriptor = "moderately"
			else
				effect_descriptor = "highly"
			entry.mechanics_text += "<p>It is [effect_descriptor] toxic when in the bloodstream.</p>"

			if (LAZYLEN(initial(reagent.toxin_immune_species)))
				var/toxin_immune_species = jointext(initial(reagent.toxin_immune_species), ", ")
				entry.mechanics_text += "<p>[toxin_immune_species] are immune to the toxic effects.</p>"

		if (initial(reagent.toxin_touch))
			effect_level = initial(reagent.toxin_touch)
			if (effect_level <= 1)
				effect_descriptor = "mildly"
			else if (effect_level <= 2)
				effect_descriptor = "moderately"
			else
				effect_descriptor = "highly"
			entry.mechanics_text += "<p>When contacting skin or splashing someone, it is [effect_descriptor] toxic.</p>"

		if (initial(reagent.flammable_touch) || initial(reagent.flammable_touch_mob))
			entry.mechanics_text += "<p>When [initial(reagent.flammable_touch) ? "contacting skin or " : null]splashing someone, it can make them flammable.</p>"

		if (initial(reagent.sugar_factor))
			entry.mechanics_text += "<p>It has a sugar-induced drug-like effect on Unathi.</p>"

		if (initial(reagent.dissolves_text))
			entry.mechanics_text += "<p>It can be used to dissolve text on papers and books.</p>"

		if (initial(reagent.vehicle_fuel_mod) != 1 || initial(reagent.vehicle_fuel_flammable))
			effect_level = initial(reagent.vehicle_fuel_mod) * 100
			if (initial(reagent.vehicle_fuel_flammable))
				entry.mechanics_text += "<p>It has a [effect_level]% efficiency modifier when used as fuel for vehicles such as bikes, and is combustible.<p>"
			else
				entry.mechanics_text += "<p>It has a [effect_level]% efficiency modifier when used as fuel for vehicles such as bikes.</p>"

		// Hydroponics Tray effects
		effect_level = toxin_reagents[reagent]
		if (effect_level)
			if (effect_level < 0)
				entry.mechanics_text += "<p>It counteracts chemicals toxic to plants when injected into a hydroponics tray.</p>"
			else
				if (effect_level <= 1)
					effect_descriptor = "mildly"
				else if (effect_level <= 2)
					effect_descriptor = "moderately"
				else
					effect_descriptor = "highly"
				entry.mechanics_text += "<p>It is [effect_descriptor] toxic to plants when injected into a hydroponics tray.</p>"

		effect_level = nutrient_reagents[reagent]
		if (effect_level)
			if (effect_level <= 0.66)
				effect_descriptor = "mildly"
			else if (effect_level <= 1.33)
				effect_descriptor = "moderately"
			else
				effect_descriptor = "highly"
			entry.mechanics_text += "<p>It is [effect_descriptor] nutritious to plants when injected into a hydroponics tray.</p>"

		effect_level = weedkiller_reagents[reagent]
		if (effect_level)
			if (effect_level > 0)
				entry.mechanics_text += "<p>It encourages weed growth when injected into a hydroponics tray.</p>"
			else
				if (effect_level >= -2)
					effect_descriptor = "mildly"
				else if (effect_level >= -4)
					effect_descriptor = "moderately"
				else
					effect_descriptor = "highly"
				entry.mechanics_text += "<p>It is [effect_descriptor] effective at killing weeds when injected into a hydroponics tray.</p>"

		effect_level = pestkiller_reagents[reagent]
		if (effect_level)
			if (effect_level > 0)
				entry.mechanics_text += "<p>It encourages pest growth when injected into a hydroponics tray.</p>"
			else
				if (effect_level >= -2)
					effect_descriptor = "mildly"
				else if (effect_level >= -4)
					effect_descriptor = "moderately"
				else
					effect_descriptor = "highly"
				entry.mechanics_text += "<p>It is [effect_descriptor] effective at killing pests when injected into a hydroponics tray.</p>"

		effect_level = water_reagents[reagent]
		if (effect_level)
			if (effect_level < 0)
				entry.mechanics_text += "<p>It has a negative impact on water levels when injected into a hydroponics tray.</p>"
			else
				entry.mechanics_text += "<p>It is [effect_level] times as effective as water when injected into a hydroponics tray.</p>"

		var/beneficial_effects = beneficial_reagents[reagent]
		if (LAZYLEN(beneficial_effects))
			effect_level = beneficial_effects[1]
			if (effect_level)
				if (effect_level < 0)
					effect_descriptor = "degrades"
				else
					effect_descriptor = "improves"
				effect_descriptor += " the plants health by a "
				effect_level = abs(effect_level)
				if (effect_level <= 1)
					effect_descriptor += "small"
				else if (effect_level <= 2)
					effect_descriptor += "moderate"
				else
					effect_descriptor += "large"
				entry.mechanics_text += "<p>It [effect_descriptor] amount when injected into a hydroponics tray.</p>"

			effect_level = beneficial_effects[2]
			if (effect_level)
				if (effect_level <= 0.1)
					effect_descriptor = "small"
				else if (effect_level <= 0.2)
					effect_descriptor = "moderate"
				else
					effect_descriptor = "large"
				entry.mechanics_text += "<p>It improves crop yield by a [effect_descriptor] amount when injected into a hydroponics tray.</p>"

			effect_level = beneficial_effects[3] + mutagenic_reagents[reagent]
			if (effect_level)
				if (mutagenic_reagents[reagent])
					entry.mechanics_text += "<p>It adds a [effect_level]% chance per unit of causing mutations when injected into a hydroponics tray and acts as a catalyst for mutations.</p>"
				else
					entry.mechanics_text += "<p>It adds a [effect_level]% chance per unit of causing mutations when injected into a hydroponics tray if a catalyst for mutations is also present.</p>"

		// Nutriments
		if (istype(reagent, /datum/reagent/nutriment))
			var/datum/reagent/nutriment/nutriment = reagent
			if (istype(nutriment, /datum/reagent/nutriment/protein))
				entry.mechanics_text += "<p>It contains animal protein which is toxic to Skrell, but especially beneficial to Unathi.</p>"

			if (!initial(nutriment.injectable))
				entry.mechanics_text += "<p>It is toxic if injected.</p>"

			if (initial(nutriment.nutriment_factor))
				entry.mechanics_text += "<p>It provides nutrition and helps with hunger.</p>"

			if (initial(nutriment.hydration_factor))
				entry.mechanics_text += "<p>It provides hydration and helps with thirst.</p>"

		// Drinks
		if (istype(reagent, /datum/reagent/drink))
			var/datum/reagent/drink/drink = reagent
			if (initial(drink.nutrition))
				entry.mechanics_text += "<p>It provides nutrition and helps with hunger.</p>"

			if (initial(drink.hydration))
				entry.mechanics_text += "<p>It provides hydration and helps with thirst.</p>"

			if (initial(drink.adj_dizzy))
				entry.mechanics_text += "<p>It can [initial(drink.adj_dizzy) > 1 ? "cause" : "counteract"] dizziness.</p>"

			if (initial(drink.adj_drowsy))
				entry.mechanics_text += "<p>It can [initial(drink.adj_drowsy) > 1 ? "cause" : "counteract"] drowsiness.</p>"

			if (initial(drink.adj_sleepy))
				entry.mechanics_text += "<p>It can [initial(drink.adj_sleepy) > 1 ? "cause" : "counteract"] sleepiness.</p>"

			if (initial(drink.adj_temp))
				entry.mechanics_text += "<p>It can [initial(drink.adj_temp) > 1 ? "increase" : "decrease"] temperature.</p>"

		// Integrated Circuits Chemical Cell Usage
		var/obj/item/integrated_circuit/passive/power/chemical_cell/chemical_cell = new()
		if (chemical_cell.fuel[reagent])
			entry.mechanics_text += "<p>It can be used in an integrated circuit's chemical cell and has a charge rate of [chemical_cell.fuel[reagent]].</p>"

		// Temperature Breakdown
		var/list/production_strings = list()
		if (initial(reagent.heating_point))
			for (var/heating_product in initial(reagent.heating_products))
				var/datum/reagent/R = heating_product
				production_strings += "<li>[initial(R.name)]</li>"
			entry.mechanics_text += "<hr /><p>It breaks down into the following when temperature is above [initial(reagent.heating_point)]K:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		production_strings = list()
		if (initial(reagent.chilling_point))
			for (var/chilling_product in initial(reagent.chilling_products))
				var/datum/reagent/R = chilling_product
				production_strings += "<li>[initial(R.name)]</li>"
			entry.mechanics_text += "<hr /><p>It breaks down into the following when temperature is below [initial(reagent.chilling_point)]K:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		// Material Sources
		production_strings = list()
		for (var/material/material in SSmaterials.materials)
			if (material.hidden_from_codex || !LAZYLEN(material.chem_products) || !(reagent in material.chem_products))
				continue
			production_strings += "<li>[material.name]</li>"
		if (length(production_strings))
			entry.mechanics_text += "<hr /><p>It can be acquired from grinding the following materials:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		// Gas Sources
		production_strings = list()
		for (var/thing2 in subtypesof(/decl/xgm_gas))
			var/decl/xgm_gas/gas = thing2
			if (initial(gas.hidden_from_codex) || initial(gas.breathed_product) != reagent)
				continue
			production_strings += "<li>[initial(gas.name)]</li>"
		if (length(production_strings))
			entry.mechanics_text += "<hr /><p>It is a byproduct of inhaling the following gasses:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		// Side Effects
		production_strings = list() // Triggered effects
		var/list/production_strings2 = list() // Cured effects
		for (var/thing2 in subtypesof(/datum/medical_effect))
			var/datum/medical_effect/medical_effect = new thing2
			if (medical_effect.hidden_from_codex)
				continue

			if (LAZYACCESS(medical_effect.triggers, reagent))
				production_strings += "<li>[medical_effect.name] in doses above [medical_effect.triggers[reagent]]</li>"

			if (LAZYISIN(medical_effect.cures, reagent))
				production_strings2 += "<li>[medical_effect.name]</li>"

		if (length(production_strings))
			entry.mechanics_text += "<hr /><p>It can cause the following side effects:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		if (length(production_strings2))
			entry.mechanics_text += "<hr /><p>It can cure the following side effects:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings2, null)]</ul>"


		// Chemistry Recipe
		production_strings = list()
		for(var/react in SSchemistry.chemical_reactions_by_result[thing])

			var/datum/chemical_reaction/reaction = react

			if(reaction.hidden_from_codex)
				continue

			var/list/reactant_values = list()
			for(var/reactant_id in reaction.required_reagents)
				var/datum/reagent/reactant = reactant_id
				reactant_values += "[reaction.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"

			if(!reactant_values.len)
				continue

			var/list/catalysts = list()
			for(var/catalyst_id in reaction.catalysts)
				var/datum/reagent/catalyst = catalyst_id
				catalysts += "[reaction.catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"

			var/datum/reagent/result = reaction.result
			if(catalysts.len)
				production_strings += "<li>[jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")]): [reaction.result_amount]u [lowertext(initial(result.name))]</li>"
			else
				production_strings += "<li>[jointext(reactant_values, " + ")]: [reaction.result_amount]u [lowertext(initial(result.name))]</li>"

		if(production_strings.len)
			entry.mechanics_text += "<hr /><p>It can be produced as follows:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		// Reactions That Use This Chemical
		production_strings = list()
		for (var/react in SSchemistry.chemical_reactions_by_id[thing])
			var/datum/chemical_reaction/reaction = react
			if(reaction.hidden_from_codex)
				continue

			var/datum/reagent/result = reaction.result
			if (initial(result.hidden_from_codex))
				continue

			production_strings += "<li>[initial(result.name)]</li>"

		if (production_strings.len)
			entry.mechanics_text += "<hr /><p>It is used in recipes to produce the following known chemicals:</p>"
			entry.mechanics_text += "<ul>[jointext(production_strings, null)]</ul>"

		// Antag Notes
		if (initial(reagent.codex_antag))
			entry.antag_text += initial(reagent.codex_antag)

		if (initial(reagent.scannable))
			entry.antag_text += "<p>It appears on medical scans.</p>"
		else
			entry.antag_text += "<p>It is invisible to medical scans.</p>"

		entry.update_links()
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	..()
