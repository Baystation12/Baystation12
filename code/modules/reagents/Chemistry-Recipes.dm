/datum/chemical_reaction
	var/name = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0
	var/hidden_from_codex
	var/maximum_temperature = INFINITY
	var/minimum_temperature = 0
	var/thermal_product
	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'
	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	var/temperature = holder.my_atom ? holder.my_atom.temperature : T20C
	if(temperature < minimum_temperature || temperature > maximum_temperature)
		return 0

	return 1

/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	if(thermal_product && ATOM_IS_TEMPERATURE_SENSITIVE(holder.my_atom))
		ADJUST_ATOM_TEMPERATURE(holder.my_atom, thermal_product)

// This proc returns a list of all reagents it wants to use; if the holder has several reactions that use the same reagent, it will split the reagent evenly between them
/datum/chemical_reaction/proc/get_used_reagents()
	. = list()
	for(var/reagent in required_reagents)
		. += reagent

/datum/chemical_reaction/proc/get_reaction_flags(var/datum/reagents/holder)
	return 0

/datum/chemical_reaction/proc/process(var/datum/reagents/holder, var/limit)
	var/data = send_data(holder)

	var/reaction_volume = holder.maximum_volume
	for(var/reactant in required_reagents)
		var/A = holder.get_reagent_amount(reactant) / required_reagents[reactant] / limit // How much of this reagent we are allowed to use
		if(reaction_volume > A)
			reaction_volume = A

	var/reaction_flags = get_reaction_flags(holder)

	for(var/reactant in required_reagents)
		holder.remove_reagent(reactant, reaction_volume * required_reagents[reactant], safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_volume
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced, reaction_flags)

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		container.visible_message("<span class='notice'>\icon[container] [mix_message]</span>")
		playsound(container, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Common reactions */
/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/carbon = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	result = /datum/reagent/dylovene
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/potassium = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	result = /datum/reagent/tramadol
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/ethanol = 1, /datum/reagent/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	result = /datum/reagent/paracetamol
	required_reagents = list(/datum/reagent/tramadol = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	result = /datum/reagent/tramadol/oxycodone
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/tramadol = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/dylovene = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/mutagen
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/phosphorus = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/thermite
	name = "Thermite"
	result = /datum/reagent/thermite
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/acetone = 1)
	result_amount = 3
	mix_message = "The solution thickens into a coarse metallic paste."

/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	result = /datum/reagent/space_drugs
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/sugar = 1, /datum/reagent/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Space Lube"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/acid/polyacid
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/acid/hydrochloric = 1, /datum/reagent/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)
	result_amount = 3
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = list(/datum/reagent/hyronalin = 1, /datum/reagent/hydrazine = 1)
	result_amount = 2

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	result = /datum/reagent/kelotane
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = list(/datum/reagent/bicaridine = 2, /datum/reagent/clonexadone = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	result = /datum/reagent/leporazine
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 2

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	result = /datum/reagent/cryptobiolin
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/acetone = 1, /datum/reagent/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	result = /datum/reagent/alkysine
	required_reagents = list(/datum/reagent/acid/hydrochloric = 1, /datum/reagent/ammonia = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	result = /datum/reagent/dexalin
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/toxin/phoron = 0.1)
	inhibitors = list(/datum/reagent/water = 1) // Messes with cryox
	result_amount = 1

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	result = /datum/reagent/dermaline
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1, /datum/reagent/kelotane = 1)
	result_amount = 3
	minimum_temperature = (-50 CELSIUS) - 100
	maximum_temperature = -50 CELSIUS

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	result = /datum/reagent/dexalinp
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/carbon = 1, /datum/reagent/iron = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/carbon = 1)
	inhibitors = list(/datum/reagent/sugar = 1) // Messes up with inaprovaline
	result_amount = 2

/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1, /datum/reagent/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = list(/datum/reagent/arithrazine = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = list(/datum/reagent/dexalin = 1, /datum/reagent/drink/ice = 1, /datum/reagent/acetone = 1)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes sludge-like."

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /datum/reagent/nanitefluid
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/aluminium = 1, /datum/reagent/lube = 1)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/venaxilin
	name = "Venaxilin"
	result = /datum/reagent/dylovene/venaxilin
	required_reagents = list(/datum/reagent/dylovene = 1, /datum/reagent/spaceacillin = 1, /datum/reagent/toxin/venom = 1)
	result_amount = 1
	minimum_temperature = 50 CELSIUS
	maximum_temperature = 100 CELSIUS
	mix_message = "The solution steams and becomes cloudy."


/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = list(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1)
	result_amount = 2
	minimum_temperature = -100 CELSIUS
	maximum_temperature = -75 CELSIUS
	mix_message = "The solution thickens into translucent slime."

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	result = /datum/reagent/spaceacillin
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "Imidazoline"
	result = /datum/reagent/imidazoline
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/dylovene = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/soporific
	name = "Soporific"
	result = /datum/reagent/soporific
	required_reagents = list(/datum/reagent/chloralhydrate = 1, /datum/reagent/sugar = 4)
	inhibitors = list(/datum/reagent/phosphorus) // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	result = /datum/reagent/chloralhydrate
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/acid/hydrochloric = 3, /datum/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/vecuronium_bromide
	name = "Vecuronium Bromide"
	result = /datum/reagent/vecuronium_bromide
	required_reagents = list(/datum/reagent/ethanol = 1, /datum/reagent/mercury = 2, /datum/reagent/hydrazine = 2)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/potassium = 1)
	minimum_temperature = 60 CELSIUS
	maximum_temperature = (60 CELSIUS) + 100
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = list(/datum/reagent/toxin/potassium_chloride = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/chloralhydrate = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/soporific = 5, /datum/reagent/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/mindbreaker
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/hydrazine = 1, /datum/reagent/dylovene = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/lipozine
	name = "Lipozine"
	result = /datum/reagent/lipozine
	required_reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/ethanol = 1, /datum/reagent/radium = 1)
	result_amount = 3

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /datum/reagent/surfactant
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/ethanol = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /datum/reagent/space_cleaner
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/nutriment/cornoil = 3, /datum/reagent/acid = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /datum/reagent/sodiumchloride
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /datum/reagent/capsaicin/condensed
	required_reagents = list(/datum/reagent/capsaicin = 2)
	catalysts = list(/datum/reagent/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	result = /datum/reagent/coolant
	required_reagents = list(/datum/reagent/tungsten = 1, /datum/reagent/acetone = 1, /datum/reagent/water = 1)
	result_amount = 3
	log_is_important = 1
	mix_message = "The solution becomes thick and slightly slimy."

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	result = /datum/reagent/rezadone
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/cryptobiolin = 1, /datum/reagent/copper = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	result = /datum/reagent/lexorin
	required_reagents = list(/datum/reagent/toxin/phoron = 1, /datum/reagent/hydrazine = 1, /datum/reagent/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	result = /datum/reagent/methylphenidate
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	result = /datum/reagent/citalopram
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	result = /datum/reagent/paroxetine
	required_reagents = list(/datum/reagent/mindbreaker = 1, /datum/reagent/acetone = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /datum/reagent/toxin/hair_remover
	required_reagents = list(/datum/reagent/radium = 1, /datum/reagent/potassium = 1, /datum/reagent/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/noexcutite
	name = "Noexcutite"
	result = /datum/reagent/noexcutite
	required_reagents = list(/datum/reagent/tramadol/oxycodone = 1, /datum/reagent/dylovene = 1)
	result_amount = 2

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/datum/reagent/toxin/bromide = 1, /datum/reagent/ethanol = 1, /datum/reagent/hydrazine = 1)
	result_amount = 3
	result = /datum/reagent/toxin/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /datum/reagent/adrenaline
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/hyperzine = 1, /datum/reagent/dexalinp = 1)
	result_amount = 3

/* Solidification */
/datum/chemical_reaction/phoronsolidification
	name = "Solid Phoron"
	result = null
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/toxin/phoron = 20)
	result_amount = 1
	minimum_temperature = (-80 CELSIUS) - 100
	maximum_temperature = -80 CELSIUS
	mix_message = "The solution hardens and begins to crystallize."

/datum/chemical_reaction/phoronsolidification/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/stack/material/phoron(get_turf(holder.my_atom), created_volume)

/datum/chemical_reaction/plastication
	name = "Plastic"
	result = null
	required_reagents = list(/datum/reagent/acid/polyacid = 1, /datum/reagent/toxin/plasticide = 2)
	result_amount = 1
	mix_message = "The solution solidifies into a grey-white mass."

/datum/chemical_reaction/plastication/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/stack/material/plastic(get_turf(holder.my_atom), created_volume)

/* Grenade reactions */

/datum/chemical_reaction/explosion_potassium
	name = "Explosion"
	result = null
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	result_amount = 2
	mix_message = null
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/explosion_potassium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat != DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	result = null
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )
	result_amount = null
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/flash_powder/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/M in viewers(world.view, location))
		switch(get_dist(M, location))
			if(0 to 3)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Weaken(15)

			if(4 to 5)
				if(hasvar(M, "glasses"))
					if(istype(M:glasses, /obj/item/clothing/glasses/sunglasses))
						continue

				M.flash_eyes()
				M.Stun(5)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	result = null
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/emp_pulse/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/datum/chemical_reaction/nitroglycerin
	name = "Nitroglycerin"
	result = /datum/reagent/nitroglycerin
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/acid/polyacid = 1, /datum/reagent/acid = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/nitroglycerin/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/datum/effect/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)
	if(isliving(holder.my_atom))
		e.amount *= 0.5
		var/mob/living/L = holder.my_atom
		if(L.stat!=DEAD)
			e.amount *= 0.5
	e.start()
	holder.clear_reagents()

/datum/chemical_reaction/phlogiston
	name = "Phlogiston"
	result = null
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/toxin/phoron = 1, /datum/reagent/acid = 1 )
	result_amount = 1
	mix_message = "The solution thickens and begins to bubble."

/datum/chemical_reaction/phlogiston/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas(/datum/reagent/toxin/phoron, created_volume, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)

/datum/chemical_reaction/napalm
	name = "Napalm"
	result = /datum/reagent/napalm
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/acid = 1, /datum/reagent/glycerol = 1 ) //because bananas grow on palms and palm oil is used to make napalm. =/= logic
	result_amount = 2
	mix_message = "The solution thickens and takes on a slimy sheen."

/datum/chemical_reaction/napalmb
	name = "Napalm B"
	result = /datum/reagent/napalm/b
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/fuel = 1 )
	result_amount = 2
	mix_message = "The solution thickens and takes on a slimy sheen."

/datum/chemical_reaction/chemsmoke
	name = "Chemsmoke"
	result = null
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/sugar = 1, /datum/reagent/phosphorus = 1)
	result_amount = 0.4
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/chemsmoke/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
	S.attach(location)
	S.set_up(holder, created_volume, 0, location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()
	holder.clear_reagents()

/datum/chemical_reaction/foam
	name = "Foam"
	result = null
	required_reagents = list(/datum/reagent/surfactant = 1, /datum/reagent/water = 1)
	result_amount = 2
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/foam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	result = null
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/metalfoam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 1)
	s.start()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	result = null
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/acid/polyacid = 1)
	result_amount = 5
	mix_message = "The solution bubbles vigorously!"

/datum/chemical_reaction/ironfoam/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		to_chat(M, "<span class='warning'>The solution spews out a metalic foam!</span>")

	var/datum/effect/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 2)
	s.start()

/* Paint */

/datum/chemical_reaction/red_paint
	name = "Red paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/red = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/datum/chemical_reaction/red_paint/send_data()
	return "#fe191a"

/datum/chemical_reaction/orange_paint
	name = "Orange paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/orange = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/datum/chemical_reaction/orange_paint/send_data()
	return "#ffbe4f"

/datum/chemical_reaction/yellow_paint
	name = "Yellow paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/yellow = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/datum/chemical_reaction/yellow_paint/send_data()
	return "#fdfe7d"

/datum/chemical_reaction/green_paint
	name = "Green paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/green = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy green sheen."

/datum/chemical_reaction/green_paint/send_data()
	return "#18a31a"

/datum/chemical_reaction/blue_paint
	name = "Blue paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/blue = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy blue sheen."

/datum/chemical_reaction/blue_paint/send_data()
	return "#247cff"

/datum/chemical_reaction/purple_paint
	name = "Purple paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/purple = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/datum/chemical_reaction/purple_paint/send_data()
	return "#cc0099"

/datum/chemical_reaction/grey_paint //mime
	name = "Grey paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/grey = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy grey sheen."

/datum/chemical_reaction/grey_paint/send_data()
	return "#808080"

/datum/chemical_reaction/brown_paint
	name = "Brown paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/crayon_dust/brown = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy brown sheen."

/datum/chemical_reaction/brown_paint/send_data()
	return "#846f35"

/datum/chemical_reaction/blood_paint
	name = "Blood paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/blood = 2)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/datum/chemical_reaction/blood_paint/send_data(var/datum/reagents/T)
	var/t = T.get_data("blood")
	if(t && t["blood_colour"])
		return t["blood_colour"]
	return "#fe191a" // Probably red

/datum/chemical_reaction/milk_paint
	name = "Milk paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/milk = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy white sheen."

/datum/chemical_reaction/milk_paint/send_data()
	return "#f0f8ff"

/datum/chemical_reaction/orange_juice_paint
	name = "Orange juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/orange = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/datum/chemical_reaction/orange_juice_paint/send_data()
	return "#e78108"

/datum/chemical_reaction/tomato_juice_paint
	name = "Tomato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/tomato = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/datum/chemical_reaction/tomato_juice_paint/send_data()
	return "#731008"

/datum/chemical_reaction/lime_juice_paint
	name = "Lime juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lime = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy green sheen."

/datum/chemical_reaction/lime_juice_paint/send_data()
	return "#365e30"

/datum/chemical_reaction/carrot_juice_paint
	name = "Carrot juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/carrot = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy orange sheen."

/datum/chemical_reaction/carrot_juice_paint/send_data()
	return "#973800"

/datum/chemical_reaction/berry_juice_paint
	name = "Berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/berry = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/datum/chemical_reaction/berry_juice_paint/send_data()
	return "#990066"

/datum/chemical_reaction/grape_juice_paint
	name = "Grape juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/grape = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/datum/chemical_reaction/grape_juice_paint/send_data()
	return "#863333"

/datum/chemical_reaction/poisonberry_juice_paint
	name = "Poison berry juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/toxin/poisonberryjuice = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy purple sheen."

/datum/chemical_reaction/poisonberry_juice_paint/send_data()
	return "#863353"

/datum/chemical_reaction/watermelon_juice_paint
	name = "Watermelon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/watermelon = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy red sheen."

/datum/chemical_reaction/watermelon_juice_paint/send_data()
	return "#b83333"

/datum/chemical_reaction/lemon_juice_paint
	name = "Lemon juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/lemon = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/datum/chemical_reaction/lemon_juice_paint/send_data()
	return "#afaf00"

/datum/chemical_reaction/banana_juice_paint
	name = "Banana juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/drink/juice/banana = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy yellow sheen."

/datum/chemical_reaction/banana_juice_paint/send_data()
	return "#c3af00"

/datum/chemical_reaction/potato_juice_paint
	name = "Potato juice paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, "potatojuice" = 5)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy brown sheen."

/datum/chemical_reaction/potato_juice_paint/send_data()
	return "#302000"

/datum/chemical_reaction/carbon_paint
	name = "Carbon paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/carbon = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy black sheen."

/datum/chemical_reaction/carbon_paint/send_data()
	return "#333333"

/datum/chemical_reaction/aluminium_paint
	name = "Aluminium paint"
	result = /datum/reagent/paint
	required_reagents = list(/datum/reagent/toxin/plasticide = 1, /datum/reagent/water = 3, /datum/reagent/aluminium = 1)
	result_amount = 5
	mix_message = "The solution thickens and takes on a glossy white sheen."

/datum/chemical_reaction/aluminium_paint/send_data()
	return "#f0f8ff"

/* Slime cores */

/datum/chemical_reaction/slime
	hidden_from_codex = TRUE
	mix_message = "The slime core twitches sharply."
	var/required = null

/datum/chemical_reaction/slime/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, required))
		var/obj/item/slime_extract/T = holder.my_atom
		if(T.Uses > 0)
			return ..()
	return 0

/datum/chemical_reaction/slime/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/slime_extract/T = holder.my_atom
	T.Uses--
	if(T.Uses <= 0)
		T.visible_message("\icon[T]<span class='notice'>\The [T]'s power is consumed in the reaction.</span>")
		T.SetName("used slime extract")
		T.desc = "This extract has been used up."

//Grey
/datum/chemical_reaction/slime/spawn
	name = "Slime Spawn"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/spawn/on_reaction(var/datum/reagents/holder)
	..()
	holder.my_atom.visible_message("<span class='warning'>Infused with phoron, the core begins to quiver and grow, and soon a new baby slime emerges from it!</span>")
	new /mob/living/carbon/slime(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/monkey
	name = "Slime Monkey"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/grey

/datum/chemical_reaction/slime/monkey/on_reaction(var/datum/reagents/holder)
	..()
	for(var/i = 1, i <= 3, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube(get_turf(holder.my_atom))

//Green
/datum/chemical_reaction/slime/mutate
	name = "Mutation Toxin"
	result = /datum/reagent/slimetoxin
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/green

//Metal
/datum/chemical_reaction/slime/metal
	name = "Slime Metal"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/metal

/datum/chemical_reaction/slime/metal/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/stack/material/steel/M = new (get_turf(holder.my_atom))
	M.amount = 15
	var/obj/item/stack/material/plasteel/P = new (get_turf(holder.my_atom))
	P.amount = 5

//Gold
/datum/chemical_reaction/slime/crit
	name = "Slime Crit"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/gold
	var/list/possible_mobs = list(
							/mob/living/simple_animal/cat,
							/mob/living/simple_animal/cat/kitten,
							/mob/living/simple_animal/corgi,
							/mob/living/simple_animal/corgi/puppy,
							/mob/living/simple_animal/cow,
							/mob/living/simple_animal/chick,
							/mob/living/simple_animal/chicken
							)

/datum/chemical_reaction/slime/crit/on_reaction(var/datum/reagents/holder)
	..()
	var/type = pick(possible_mobs)
	new type(get_turf(holder.my_atom))

//Silver
/datum/chemical_reaction/slime/bork
	name = "Slime Bork"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/silver

/datum/chemical_reaction/slime/bork/on_reaction(var/datum/reagents/holder)
	..()
	var/list/borks = typesof(/obj/item/weapon/reagent_containers/food/snacks) - /obj/item/weapon/reagent_containers/food/snacks
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(get_turf(holder.my_atom), null))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.flash_eyes()

	for(var/i = 1, i <= 4 + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen(get_turf(holder.my_atom))
		if(B)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))

//Blue
/datum/chemical_reaction/slime/frost
	name = "Slime Frost Oil"
	result = /datum/reagent/frostoil
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 10
	required = /obj/item/slime_extract/blue

//Dark Blue
/datum/chemical_reaction/slime/freeze
	name = "Slime Freeze"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkblue
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/freeze/on_reaction(var/datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
		M.bodytemperature -= 140
		to_chat(M, "<span class='warning'>You feel a chill!</span>")

//Orange
/datum/chemical_reaction/slime/casp
	name = "Slime Capsaicin Oil"
	result = /datum/reagent/capsaicin
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 10
	required = /obj/item/slime_extract/orange

/datum/chemical_reaction/slime/fire
	name = "Slime fire"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/orange
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/fire/on_reaction(var/datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	if(!(holder.my_atom && holder.my_atom.loc))
		return

	var/turf/location = get_turf(holder.my_atom)
	location.assume_gas(GAS_PHORON, 250, 1400)
	location.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slime/overload
	name = "Slime EMP"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/overload/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	empulse(get_turf(holder.my_atom), 3, 7)

/datum/chemical_reaction/slime/cell
	name = "Slime Powercell"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow

/datum/chemical_reaction/slime/cell/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/weapon/cell/slime(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/glow
	name = "Slime Glow"
	result = null
	required_reagents = list(/datum/reagent/water = 1)
	result_amount = 1
	required = /obj/item/slime_extract/yellow
	mix_message = "The contents of the slime core harden and begin to emit a warm, bright light."

/datum/chemical_reaction/slime/glow/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/device/flashlight/slime(get_turf(holder.my_atom))

//Purple
/datum/chemical_reaction/slime/psteroid
	name = "Slime Steroid"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/purple

/datum/chemical_reaction/slime/psteroid/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	new /obj/item/weapon/slimesteroid(get_turf(holder.my_atom))

/datum/chemical_reaction/slime/jam
	name = "Slime Jam"
	result = /datum/reagent/slimejelly
	required_reagents = list(/datum/reagent/sugar = 1)
	result_amount = 10
	required = /obj/item/slime_extract/purple

//Dark Purple
/datum/chemical_reaction/slime/plasma
	name = "Slime Plasma"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/darkpurple

/datum/chemical_reaction/slime/plasma/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/item/stack/material/phoron/P = new (get_turf(holder.my_atom))
	P.amount = 10

//Red
/datum/chemical_reaction/slime/glycerol
	name = "Slime Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 8
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust
	name = "Bloodlust"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 1
	required = /obj/item/slime_extract/red

/datum/chemical_reaction/slime/bloodlust/on_reaction(var/datum/reagents/holder)
	..()
	for(var/mob/living/carbon/slime/slime in viewers(get_turf(holder.my_atom), null))
		slime.rabid = 1
		slime.visible_message("<span class='warning'>The [slime] is driven into a frenzy!</span>")

//Pink
/datum/chemical_reaction/slime/ppotion
	name = "Slime Potion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/pink

/datum/chemical_reaction/slime/ppotion/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/weapon/slimepotion(get_turf(holder.my_atom))

//Black
/datum/chemical_reaction/slime/mutate2
	name = "Advanced Mutation Toxin"
	result = /datum/reagent/aslimetoxin
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slime/explosion
	name = "Slime Explosion"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/oil
	mix_message = "The slime extract begins to vibrate violently!"

/datum/chemical_reaction/slime/explosion/on_reaction(var/datum/reagents/holder)
	set waitfor = 0
	..()
	sleep(50)
	explosion(get_turf(holder.my_atom), 1, 3, 6)

//Light Pink
/datum/chemical_reaction/slime/potion2
	name = "Slime Potion 2"
	result = null
	result_amount = 1
	required = /obj/item/slime_extract/lightpink
	required_reagents = list(/datum/reagent/toxin/phoron = 1)

/datum/chemical_reaction/slime/potion2/on_reaction(var/datum/reagents/holder)
	..()
	new /obj/item/weapon/slimepotion2(get_turf(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slime/golem
	name = "Slime Golem"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/adamantine

/datum/chemical_reaction/slime/golem/on_reaction(var/datum/reagents/holder)
	..()
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune(get_turf(holder.my_atom))
	Z.announce_to_ghosts()

//Sepia
/datum/chemical_reaction/slime/film
	name = "Slime Film"
	result = null
	required_reagents = list(/datum/reagent/blood = 1)
	result_amount = 2
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/film/on_reaction(var/datum/reagents/holder)
	for(var/i in 1 to result_amount)
		new /obj/item/device/camera_film(get_turf(holder.my_atom))
	..()

/datum/chemical_reaction/slime/camera
	name = "Slime Camera"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	result_amount = 1
	required = /obj/item/slime_extract/sepia

/datum/chemical_reaction/slime/camera/on_reaction(var/datum/reagents/holder)
	new /obj/item/device/camera(get_turf(holder.my_atom))
	..()

//Bluespace
/datum/chemical_reaction/slime/teleport
	name = "Slime Teleport"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/bluespace
	reaction_sound = 'sound/effects/teleport.ogg'

/datum/chemical_reaction/slime/teleport/on_reaction(var/datum/reagents/holder)
	var/list/turfs = list()
	for(var/turf/T in orange(holder.my_atom,6))
		turfs += T
	for(var/atom/movable/a in viewers(holder.my_atom,2))
		if(!a.simulated)
			continue
		a.forceMove(pick(turfs))
	..()

//pyrite
/datum/chemical_reaction/slime/paint
	name = "Slime Paint"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/pyrite

/datum/chemical_reaction/slime/paint/on_reaction(var/datum/reagents/holder)
	new /obj/item/weapon/reagent_containers/glass/paint/random(get_turf(holder.my_atom))
	..()

//cerulean
/datum/chemical_reaction/slime/extract_enhance
	name = "Extract Enhancer"
	result = null
	required_reagents = list(/datum/reagent/toxin/phoron = 1)
	required = /obj/item/slime_extract/cerulean

/datum/chemical_reaction/slime/extract_enhance/on_reaction(var/datum/reagents/holder)
	new /obj/item/weapon/slimesteroid2(get_turf(holder.my_atom))
	..()

/datum/chemical_reaction/soap_key
	name = "Soap Key"
	result = null
	required_reagents = list(/datum/reagent/frostoil = 2, /datum/reagent/space_cleaner = 5)
	var/strength = 3

/datum/chemical_reaction/soap_key/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/weapon/soap))
		return ..()
	return 0

/datum/chemical_reaction/soap_key/on_reaction(var/datum/reagents/holder)
	var/obj/item/weapon/soap/S = holder.my_atom
	if(S.key_data)
		var/obj/item/weapon/key/soap/key = new(get_turf(holder.my_atom), S.key_data)
		key.uses = strength
	..()

/* Food */

/datum/chemical_reaction/tofu
	name = "Tofu"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1
	mix_message = "The solution thickens and clumps into a yellow-white substance."

/datum/chemical_reaction/tofu/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/tofu(location)

/datum/chemical_reaction/chocolate_bar
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1
	mix_message = "The solution thickens and hardens into a glossy brown substance."

/datum/chemical_reaction/chocolate_bar/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)

/datum/chemical_reaction/chocolate_bar2
	name = "Chocolate Bar"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/nutriment/coco = 2, /datum/reagent/sugar = 2)
	result_amount = 1
	mix_message = "The solution thickens and hardens into a glossy brown substance."

/datum/chemical_reaction/chocolate_bar2/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(location)

/datum/chemical_reaction/chocolate_milk
	name = "Chocolate Milk"
	result = /datum/reagent/drink/milk/chocolate
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."

/datum/chemical_reaction/coffee
	name = "Coffee"
	result = /datum/reagent/drink/coffee
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming dark brown beverage."

/datum/chemical_reaction/coffee/instant
	name = "Instant Coffee"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coffee/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into dark brown beverage."

/datum/chemical_reaction/tea
	name = "Black tea"
	result = /datum/reagent/drink/tea
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming black beverage."

/datum/chemical_reaction/tea/instant
	name = "Instant Black tea"
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/tea/instant = 1)
	maximum_temperature = INFINITY
	minimum_temperature = 0
	mix_message = "The solution thickens into black beverage."

/datum/chemical_reaction/hot_coco
	name = "Hot Coco"
	result = /datum/reagent/drink/hot_coco
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The solution thickens into a steaming brown beverage."

/datum/chemical_reaction/grapejuice
	name = "Grape Juice"
	result = /datum/reagent/drink/juice/grape
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/grape = 1)
	result_amount = 3
	mix_message = "The solution settles into a purplish-red beverage."

/datum/chemical_reaction/orangejuice
	name = "Orange Juice"
	result = /datum/reagent/drink/juice/orange
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/orange = 1)
	result_amount = 3
	mix_message = "The solution settles into an orange beverage."

/datum/chemical_reaction/watermelonjuice
	name = "Watermelon Juice"
	result = /datum/reagent/drink/juice/watermelon
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/watermelon = 1)
	result_amount = 3
	mix_message = "The solution settles into a red beverage."

/datum/chemical_reaction/applejuice
	name = "Apple Juice"
	result = /datum/reagent/drink/juice/apple
	required_reagents = list(/datum/reagent/water = 3, /datum/reagent/nutriment/instantjuice/apple = 1)
	result_amount = 3
	mix_message = "The solution settles into a clear brown beverage."

/datum/chemical_reaction/soysauce
	name = "Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 5, /datum/reagent/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/soysauce_acid
	name = "Bitey Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/ketchup
	name = "Ketchup"
	result = /datum/reagent/nutriment/ketchup
	required_reagents = list(/datum/reagent/drink/juice/tomato = 2, /datum/reagent/water = 1, /datum/reagent/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/datum/chemical_reaction/barbecue
	name = "Barbecue Sauce"
	result = /datum/reagent/nutriment/barbecue
	required_reagents = list(/datum/reagent/nutriment/ketchup = 2, /datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/datum/chemical_reaction/garlicsauce
	name = "Garlic Sauce"
	result = /datum/reagent/nutriment/garlicsauce
	required_reagents = list(/datum/reagent/drink/juice/garlic = 1, /datum/reagent/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

/datum/chemical_reaction/cheesewheel
	name = "Cheesewheel"
	result = null
	required_reagents = list(/datum/reagent/drink/milk = 40)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 1
	mix_message = "The solution thickens and curdles into a rich yellow substance."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100

/datum/chemical_reaction/cheesewheel/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel(location)

/datum/chemical_reaction/rawmeatball
	name = "Raw Meatball"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein = 3, /datum/reagent/nutriment/flour = 5)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."

/datum/chemical_reaction/rawmeatball/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/rawmeatball(location)

/datum/chemical_reaction/dough
	name = "Dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/datum/chemical_reaction/dough/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)

/datum/chemical_reaction/soydough
	name = "Soy dough"
	result = null
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result_amount = 1
	mix_message = "The solution folds and thickens into a large ball of dough."

/datum/chemical_reaction/soydough/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(location)

//batter reaction as food precursor, for things that don't use pliable dough precursor.

/datum/chemical_reaction/batter
	name = "Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/cakebatter
	name = "Cake Batter"
	result = /datum/reagent/nutriment/batter/cakebatter
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/datum/chemical_reaction/soybatter
	name = "Vegan Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/softtofu = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/syntiflesh
	name = "Syntiflesh"
	result = null
	required_reagents = list(/datum/reagent/blood = 5, /datum/reagent/clonexadone = 1)
	result_amount = 1
	mix_message = "The solution thickens disturbingly, taking on a meaty appearance."

/datum/chemical_reaction/syntiflesh/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh(location)

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	result = /datum/reagent/drink/hot_ramen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	result = /datum/reagent/drink/hell_ramen
	required_reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."

/* Alcohol */

/datum/chemical_reaction/goldschlager
	name = "Goldschlager"
	result = /datum/reagent/ethanol/goldschlager
	required_reagents = list(/datum/reagent/ethanol/vodka = 10, /datum/reagent/gold = 1)
	result_amount = 10
	mix_message = "The gold flakes and settles in the vodka."

/datum/chemical_reaction/patron
	name = "Patron"
	result = /datum/reagent/ethanol/patron
	required_reagents = list(/datum/reagent/ethanol/tequilla = 10, /datum/reagent/silver = 1)
	result_amount = 10
	mix_message = "The silver flakes and settles in the tequila."

/datum/chemical_reaction/bilk
	name = "Bilk"
	result = /datum/reagent/ethanol/bilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/ethanol/beer = 1)
	result_amount = 2
	mix_message = "The solution takes on an unpleasant, thick, brown appearance."

/datum/chemical_reaction/icecoffee
	name = "Iced Coffee"
	result = /datum/reagent/drink/coffee/icecoffee
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled coffee."

/datum/chemical_reaction/icesoylatte
	name = "Iced Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy latte."

/datum/chemical_reaction/icecafelatte
	name = "Iced Cafe Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled cafe latte."

/datum/chemical_reaction/nuka_cola
	name = "Nuka Cola"
	result = /datum/reagent/drink/nuka_cola
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/drink/space_cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	result = /datum/reagent/ethanol/moonshine
	required_reagents = list(/datum/reagent/nutriment = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = list(/datum/reagent/drink/juice/berry = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	result = /datum/reagent/ethanol/wine
	required_reagents = list(/datum/reagent/drink/juice/grape = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	result = /datum/reagent/ethanol/pwine
	required_reagents = list(/datum/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	result = /datum/reagent/ethanol/melonliquor
	required_reagents = list(/datum/reagent/drink/juice/watermelon = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	result = /datum/reagent/ethanol/bluecuracao
	required_reagents = list(/datum/reagent/drink/juice/orange = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	result = /datum/reagent/ethanol/beer
	required_reagents = list(/datum/reagent/nutriment/cornoil = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/vodka
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/potato = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/vodka2
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/turnip = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/sake
	name = "Sake"
	result = /datum/reagent/ethanol/sake
	required_reagents = list(/datum/reagent/nutriment/rice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	result = /datum/reagent/ethanol/coffee/kahlua
	required_reagents = list(/datum/reagent/drink/coffee = 5, /datum/reagent/sugar = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/datum/chemical_reaction/gin_tonic
	name = "Gin and Tonic"
	result = /datum/reagent/ethanol/gintonic
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/cuba_libre
	name = "Cuba Libre"
	result = /datum/reagent/ethanol/cuba_libre
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/martini
	name = "Classic Martini"
	result = /datum/reagent/ethanol/martini
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/vodkamartini
	name = "Vodka Martini"
	result = /datum/reagent/ethanol/vodkamartini
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/black_russian = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/whiskey_cola
	name = "Whiskey Cola"
	result = /datum/reagent/ethanol/whiskey_cola
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/screwdriver
	name = "Screwdriver"
	result = /datum/reagent/ethanol/screwdrivercocktail
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/battuta
	name = "Ibn Battuta"
	result = /datum/reagent/ethanol/battuta
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/drink/juice/orange = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/magellan
	name = "Magellan"
	result = /datum/reagent/ethanol/magellan
	required_reagents = list(/datum/reagent/ethanol/wine = 1, /datum/reagent/ethanol/specialwhiskey = 1)
	catalysts = list(/datum/reagent/sugar)
	result_amount = 2

/datum/chemical_reaction/zhenghe
	name = "Zheng He"
	result = /datum/reagent/ethanol/zhenghe
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/armstrong
	name = "Armstrong"
	result = /datum/reagent/ethanol/armstrong
	required_reagents = list(/datum/reagent/ethanol/beer = 2, /datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4

/datum/chemical_reaction/bloody_mary
	name = "Bloody Mary"
	result = /datum/reagent/ethanol/bloody_mary
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/tomato = 3, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	result = /datum/reagent/ethanol/gargle_blaster
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/brave_bull
	name = "Brave Bull"
	result = /datum/reagent/ethanol/coffee/brave_bull
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /datum/reagent/ethanol/tequilla_sunrise
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/phoron_special
	name = "Toxins Special"
	result = /datum/reagent/ethanol/toxins_special
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/vermouth = 2, /datum/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/beepsky_smash
	name = "Beepksy Smash"
	result = /datum/reagent/ethanol/beepsky_smash
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/drink/doctor_delight
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/milk/cream = 2, /datum/reagent/tricordrazine = 1)
	result_amount = 6

/datum/chemical_reaction/irish_cream
	name = "Irish Cream"
	result = /datum/reagent/ethanol/irish_cream
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/manly_dorf
	name = "The Manly Dorf"
	result = /datum/reagent/ethanol/manly_dorf
	required_reagents = list (/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/hooch
	name = "Hooch"
	result = /datum/reagent/ethanol/hooch
	required_reagents = list (/datum/reagent/sugar = 1, /datum/reagent/ethanol = 2, /datum/reagent/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/irish_coffee
	name = "Irish Coffee"
	result = /datum/reagent/ethanol/coffee/irishcoffee
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/b52
	name = "B-52"
	result = /datum/reagent/ethanol/coffee/b52
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/atomicbomb
	name = "Atomic Bomb"
	result = /datum/reagent/ethanol/atomicbomb
	required_reagents = list(/datum/reagent/ethanol/coffee/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/margarita
	name = "Margarita"
	result = /datum/reagent/ethanol/margarita
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/longislandicedtea
	name = "Long Island Iced Tea"
	result = /datum/reagent/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/tequilla = 1, /datum/reagent/ethanol/cuba_libre = 3)
	result_amount = 6

/datum/chemical_reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /datum/reagent/ethanol/threemileisland
	required_reagents = list(/datum/reagent/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/whiskeysoda
	name = "Whiskey Soda"
	result = /datum/reagent/ethanol/whiskeysoda
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/black_russian
	name = "Black Russian"
	result = /datum/reagent/ethanol/black_russian
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan
	name = "Manhattan"
	result = /datum/reagent/ethanol/manhattan
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan_proj
	name = "Manhattan Project"
	result = /datum/reagent/ethanol/manhattan_proj
	required_reagents = list(/datum/reagent/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/vodka_tonic
	name = "Vodka and Tonic"
	result = /datum/reagent/ethanol/vodkatonic
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/gin_fizz
	name = "Gin Fizz"
	result = /datum/reagent/ethanol/ginfizz
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/bahama_mama
	name = "Bahama Mama"
	result = /datum/reagent/ethanol/bahama_mama
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/singulo
	name = "Singulo"
	result = /datum/reagent/ethanol/singulo
	required_reagents = list(/datum/reagent/ethanol/vodka = 5, /datum/reagent/radium = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/alliescocktail
	name = "Allies Cocktail"
	result = /datum/reagent/ethanol/alliescocktail
	required_reagents = list(/datum/reagent/ethanol/vodkamartini = 1, /datum/reagent/ethanol/martini = 1)
	result_amount = 2

/datum/chemical_reaction/demonsblood
	name = "Demon's Blood"
	result = /datum/reagent/ethanol/demonsblood
	required_reagents = list(/datum/reagent/ethanol/rum = 3, /datum/reagent/drink/spacemountainwind = 1, /datum/reagent/blood = 1, /datum/reagent/drink/dr_gibb = 1)
	result_amount = 6

/datum/chemical_reaction/booger
	name = "Booger"
	result = /datum/reagent/ethanol/booger
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/juice/banana = 1, /datum/reagent/ethanol/rum = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 5
	mix_message = "The solution thickens unpleasantly."

/datum/chemical_reaction/antifreeze
	name = "Anti-freeze"
	result = /datum/reagent/ethanol/antifreeze
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	result_amount = 3
	mix_message = "The solution thickens sluggishly."

/datum/chemical_reaction/barefoot
	name = "Barefoot"
	result = /datum/reagent/ethanol/barefoot
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/juice/grape = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/sbiten
	name = "Sbiten"
	result = /datum/reagent/ethanol/sbiten
	required_reagents = list(/datum/reagent/ethanol/mead = 10, /datum/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/red_mead
	name = "Red Mead"
	result = /datum/reagent/ethanol/red_mead
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/mead
	name = "Mead"
	result = /datum/reagent/ethanol/mead
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/iced_beer
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10
	mix_message = "The solution chills rapidly, frost forming on its surface."

/datum/chemical_reaction/iced_beer2
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 5, /datum/reagent/drink/ice = 1)
	result_amount = 6
	mix_message = "The ice clinks together in the beer."

/datum/chemical_reaction/grog
	name = "Grog"
	result = /datum/reagent/ethanol/grog
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/soy_latte
	name = "Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 2
	mix_message = "The soy milk suffuses the coffee with pale shades."

/datum/chemical_reaction/cafe_latte
	name = "Cafe Latte"
	result = /datum/reagent/drink/coffee/cafe_latte
	required_reagents = list(/datum/reagent/drink/coffee = 1, /datum/reagent/drink/milk = 1)
	result_amount = 2
	mix_message = "The milk suffuses the coffee with pale shades."

/datum/chemical_reaction/mocha_latte
	name = "Mocha Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 3
	mix_message = "The chocolate swirls into the latte."

/datum/chemical_reaction/soy_mocha_latte
	name = "Mocha Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_chocolate = 1)
	result_amount = 4
	mix_message = "The chocolate swirls into the latte."

/datum/chemical_reaction/ice_mocha_latte
	name = "Iced Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled mocha latte."

/datum/chemical_reaction/ice_soy_mocha_latte
	name = "Iced Soy Mocha Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/mocha
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/mocha = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy mocha latte."

/datum/chemical_reaction/pumpkin_latte
	name = "Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/cafe_latte = 2, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 3
	mix_message = "The pumpkin spice swirls into the latte."

/datum/chemical_reaction/soy_pumpkin_latte
	name = "Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/coffee/soy_latte = 3, /datum/reagent/drink/syrup_pumpkin = 1)
	result_amount = 4
	mix_message = "The pumpkin spice swirls into the latte."

/datum/chemical_reaction/ice_pumpkin_latte
	name = "Iced Pumpkin Spice Latte"
	result = /datum/reagent/drink/coffee/icecoffee/cafe_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/cafe_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice latte."

/datum/chemical_reaction/ice_soy_pumpkin_latte
	name = "Iced Pumpkin Spice Soy Latte"
	result = /datum/reagent/drink/coffee/icecoffee/soy_latte/pumpkin
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/coffee/soy_latte/pumpkin = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled pumpkin spice soy latte."

/datum/chemical_reaction/acidspit
	name = "Acid Spit"
	result = /datum/reagent/ethanol/acid_spit
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 6
	mix_message = "The solution curdles into an unpleasant, slimy liquid."

/datum/chemical_reaction/amasec
	name = "Amasec"
	result = /datum/reagent/ethanol/amasec
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/ethanol/wine = 5, /datum/reagent/ethanol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/changelingsting
	name = "Changeling Sting"
	result = /datum/reagent/ethanol/changelingsting
	required_reagents = list(/datum/reagent/ethanol/screwdrivercocktail = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3
	mix_message = "The solution begins to shift and change colour."

/datum/chemical_reaction/aloe
	name = "Aloe"
	result = /datum/reagent/ethanol/aloe
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 3

/datum/chemical_reaction/andalusia
	name = "Andalusia"
	result = /datum/reagent/ethanol/andalusia
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	result = /datum/reagent/ethanol/neurotoxin
	required_reagents = list(/datum/reagent/ethanol/gargle_blaster = 1, /datum/reagent/soporific = 1)
	result_amount = 2

/datum/chemical_reaction/snowwhite
	name = "Snow White"
	result = /datum/reagent/ethanol/snowwhite
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/irishslammer
	name = "Irish Slammer"
	result = /datum/reagent/ethanol/irishslammer
	required_reagents = list(/datum/reagent/ethanol/ale = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/syndicatebomb
	name = "Syndicate Bomb"
	result = /datum/reagent/ethanol/syndicatebomb
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/erikasurprise
	name = "Erika Surprise"
	result = /datum/reagent/ethanol/erikasurprise
	required_reagents = list(/datum/reagent/ethanol/ale = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/devilskiss
	name = "Devils Kiss"
	result = /datum/reagent/ethanol/devilskiss
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/hippiesdelight
	name = "Hippies Delight"
	result = /datum/reagent/ethanol/hippies_delight
	required_reagents = list(/datum/reagent/psilocybin = 1, /datum/reagent/ethanol/gargle_blaster = 1)
	result_amount = 2

/datum/chemical_reaction/bananahonk
	name = "Banana Honk"
	result = /datum/reagent/ethanol/bananahonk
	required_reagents = list(/datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/silencer
	name = "Silencer"
	result = /datum/reagent/ethanol/silencer
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/driestmartini
	name = "Driest Martini"
	result = /datum/reagent/ethanol/driestmartini
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/juice/lemon = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/kiraspecial
	name = "Kira Special"
	result = /datum/reagent/drink/kiraspecial
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/brownstar
	name = "Brown Star"
	result = /datum/reagent/drink/brownstar
	required_reagents = list(/datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/space_cola = 1)
	result_amount = 3

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/spacemountainwind = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/suidream
	name = "Sui Dream"
	result = /datum/reagent/ethanol/suidream
	required_reagents = list(/datum/reagent/drink/space_up = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/ethanol/melonliquor = 1)
	result_amount = 3

/datum/chemical_reaction/rum
	name = "Rum"
	result = /datum/reagent/ethanol/rum
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/ships_surgeon
	name = "Ship's Surgeon"
	result = /datum/reagent/ethanol/ships_surgeon
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/drink/dr_gibb = 2, /datum/reagent/drink/ice = 1)
	result_amount = 4

/datum/chemical_reaction/luminol
	name = "Luminol"
	result = /datum/reagent/luminol
	required_reagents = list(/datum/reagent/hydrazine = 2, /datum/reagent/carbon = 2, /datum/reagent/ammonia = 2)
	result_amount = 6
	mix_message = "The solution begins to gleam with a fey inner light."

/datum/chemical_reaction/oxyphoron
	name = "Oxyphoron"
	result = /datum/reagent/toxin/phoron/oxygen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/toxin/phoron = 1)
	result_amount = 2
	mix_message = "The solution boils violently, shedding wisps of vapor."

/datum/chemical_reaction/deuterium
	name = "Deuterium"
	result = null
	required_reagents = list(/datum/reagent/water = 10)
	catalysts = list(/datum/reagent/toxin/phoron/oxygen = 5)
	result_amount = 1
	mix_message = "The solution makes a loud cracking sound as it crystalizes."

/datum/chemical_reaction/deuterium/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T)) new /obj/item/stack/material/deuterium(T, created_volume)
	return

/datum/chemical_reaction/antidexafen
	name = "Antidexafen"
	result = /datum/reagent/antidexafen
	required_reagents = list(/datum/reagent/paracetamol = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/nanoblood
	name = "Nanoblood"
	result = /datum/reagent/nanoblood
	required_reagents = list(/datum/reagent/dexalinp = 1, /datum/reagent/iron = 1, /datum/reagent/blood = 1)
	result_amount = 3
	mix_message = "The solution thickens slowly into a glossy liquid."

/datum/chemical_reaction/vinegar
	name = "Apple Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/drink/juice/apple = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/vinegar2
	name = "Clear Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/ethanol = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/mayo
	name = "Vinegar Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/nutriment/vinegar = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/mayo2
	name = "Lemon Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/drink/juice/lemon = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/anfo
	name = "EZ-ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/eznutrient=20, /datum/reagent/fuel=10)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo2
	name = "Left 4 ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/left4zed=10, /datum/reagent/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo3
	name = "Robust ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/toxin/fertilizer/robustharvest=15, /datum/reagent/fuel=5)
	result_amount = 10
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo4
	name = "Chemlab ANFO"
	result = /datum/reagent/anfo
	required_reagents = list(/datum/reagent/ammonia=10, /datum/reagent/fuel=5)
	result_amount = 15
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

/datum/chemical_reaction/anfo_plus
	name = "ANFO+"
	result = /datum/reagent/anfo/plus
	required_reagents = list(/datum/reagent/anfo=15, /datum/reagent/aluminium=5)
	result_amount = 20
	mix_message = "The solution gives off the eye-watering reek of spilled fertilizer and petroleum."

// psi-altering drug
/datum/chemical_reaction/three_eye
	name = "Three Eye"
	result = /datum/reagent/three_eye
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	hidden_from_codex = TRUE

	catalysts = list(
		/datum/reagent/toxin/carpotoxin = 1,
		/datum/reagent/enzyme = 1
	)

	required_reagents = list(
		/datum/reagent/mindbreaker = 2,
		/datum/reagent/toxin/phoron = 1,
		/datum/reagent/blood = 1
	)

// tea expansion pack content - black tea drinks
/datum/chemical_reaction/icetea
	name = "Iced Tea"
	result = /datum/reagent/drink/tea/icetea
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/sweettea
	name = "Sweet Tea"
	result = /datum/reagent/drink/tea/icetea/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/barongrey
	name = "Baron Grey Tea"
	result = /datum/reagent/drink/tea/barongrey
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3
	mix_message = "The juice swirls into the tea."

/datum/chemical_reaction/latte_barongrey
	name = "London Fog"
	result = /datum/reagent/drink/tea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the tea."

/datum/chemical_reaction/soy_latte_barongrey
	name = "Soy London Fog"
	result = /datum/reagent/drink/tea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/barongrey = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The soy swirls into the tea."

/datum/chemical_reaction/ice_latte_barongrey
	name = "Iced London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled london fog."

/datum/chemical_reaction/ice_soy_latte_barongrey
	name = "Iced Soy London Fog"
	result = /datum/reagent/drink/tea/icetea/barongrey/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/barongrey/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled soy london fog."

//green tea drinks
/datum/chemical_reaction/icetea_green
	name = "Iced Green Tea"
	result = /datum/reagent/drink/tea/icetea/green
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/green = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/sweettea_green
	name = "Sweet Green Tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/green = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/maghreb_tea
	name = "Maghrebi tea"
	result = /datum/reagent/drink/tea/icetea/green/sweet/mint
	required_reagents = list(/datum/reagent/drink/tea/icetea/green/sweet = 3)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3
	mix_message = "The mint swirls into the drink."

/datum/chemical_reaction/icetea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/sweettea_chai
	name = "Iced Chai Tea"
	result = /datum/reagent/drink/tea/icetea/chai/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/chai = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/latte_chai
	name = "Chai Latte"
	result = /datum/reagent/drink/tea/chai/latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/datum/chemical_reaction/soy_latte_chai
	name = "Chai Soy Latte"
	result = /datum/reagent/drink/tea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/tea/chai = 2, /datum/reagent/drink/milk/soymilk = 1)
	result_amount = 3
	mix_message = "The milk swirls into the drink."

/datum/chemical_reaction/ice_latte_chai
	name = "Iced Chai Latte"
	result = /datum/reagent/drink/tea/icetea/chai/latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai latte."

/datum/chemical_reaction/ice_soy_latte_chai
	name = "Iced Chai Soy Latte"
	result = /datum/reagent/drink/tea/icetea/chai/soy_latte
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/chai/soy_latte = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the chilled chai soy latte."

/datum/chemical_reaction/icetea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red
	required_reagents = list(/datum/reagent/drink/ice = 1, /datum/reagent/drink/tea/red = 2)
	result_amount = 3
	mix_message = "The ice clinks together in the tea."

/datum/chemical_reaction/sweettea_red
	name = "Iced Rooibos tea"
	result = /datum/reagent/drink/tea/icetea/red/sweet
	required_reagents = list(/datum/reagent/drink/tea/icetea/red = 2, /datum/reagent/sugar = 1)
	result_amount = 3
	mix_message = "The ice clinks together in the sweet tea."

/datum/chemical_reaction/chazuke
	name = "Chazuke"
	result = /datum/reagent/nutriment/rice/chazuke
	required_reagents = list(/datum/reagent/nutriment/rice = 10, /datum/reagent/drink/tea/green = 1)
	result_amount = 10
	mix_message = "The tea mingles with the rice."

/datum/chemical_reaction/resin_pack
	name = "Resin Globule"
	result = null
	required_reagents = list(
		/datum/reagent/crystal = 1,
		/datum/reagent/silicon = 2
	)
	catalysts = list(
		/datum/reagent/toxin/phoron = 1
	)
	result_amount = 3
	mix_message = "The solution hardens and begins to crystallize."

/datum/chemical_reaction/resin_pack/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/turf/T = get_turf(holder.my_atom)
	if(istype(T))
		var/create_stacks = Floor(created_volume)
		if(create_stacks > 0)
			new /obj/item/stack/medical/resin/handmade(T, create_stacks)

/datum/chemical_reaction/crystal_agent
	result = /datum/reagent/crystal
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/tungsten = 1, /datum/reagent/acid/polyacid = 1)
	minimum_temperature = 150 CELSIUS
	maximum_temperature = 200 CELSIUS
	result_amount = 3

/datum/chemical_reaction/immunobooster
	result = /datum/reagent/immunobooster
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/dylovene = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2

// Alcohol Expansion

//Alcohol
/datum/chemical_reaction/applecider
	name = "Apple Cider"
	result = /datum/reagent/ethanol/applecider
	required_reagents = list(/datum/reagent/drink/juice/apple = 2, /datum/reagent/sugar = 1)
	catalysts = list(/datum/reagent/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/lunabrandy
	name = "Lunar Brandy"
	result = /datum/reagent/ethanol/lunabrandy
	required_reagents = list(/datum/reagent/drink/juice/grape = 1, /datum/reagent/ethanol/wine = 2)
	catalysts = list(/datum/reagent/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/hellshenpa
	name = "Hellshen Pale Ale"
	result = /datum/reagent/ethanol/hellshenpa
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/vodkacola
	name = "Vodka Cola"
	result = /datum/reagent/ethanol/vodkacola
	required_reagents = list(/datum/reagent/drink/space_cola = 1, /datum/reagent/ethanol/vodka = 2)
	result_amount = 3

/datum/chemical_reaction/red_whiskey
	name = "Red Whiskey"
	result = /datum/reagent/ethanol/red_whiskey
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/ethanol/specialwhiskey = 1)
	result_amount = 4

/datum/chemical_reaction/nevadan_gold
	name = "Nevadan Gold Whiskey"
	result = /datum/reagent/ethanol/nevadan_gold
	required_reagents = list(/datum/reagent/ethanol/specialwhiskey = 1, /datum/reagent/ethanol/goldschlager = 1, /datum/reagent/ethanol/coffee/irishcoffee = 1,)
	result_amount = 3

/datum/chemical_reaction/arak
	name = "Arak"
	result = /datum/reagent/ethanol/arak
	required_reagents = list(/datum/reagent/ethanol/absinthe = 2, /datum/reagent/drink/juice/grape = 1)
	catalysts = list(/datum/reagent/nutriment)
	result_amount = 3
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The aniseed ferments into a translucent white mixture"

/datum/chemical_reaction/blackstrap
	name = "Blackstrap"
	result = /datum/reagent/ethanol/blackstrap
	required_reagents = list(/datum/reagent/ethanol/whiskey = 1, /datum/reagent/ethanol/rum = 2)
	result_amount = 3

/datum/chemical_reaction/stag
	name = "Stag"
	result = /datum/reagent/ethanol/stag
	required_reagents = list(/datum/reagent/drink/tea = 2, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/lordaniawine
	name = "Lordanian Wine"
	result = /datum/reagent/ethanol/lordaniawine
	required_reagents = list(/datum/reagent/ethanol/wine = 2, /datum/reagent/drink/grenadine = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/jagerbomb
	name = "Jagerbomb"
	result = /datum/reagent/ethanol/jagerbomb
	required_reagents = list(/datum/reagent/drink/beastenergy = 1, /datum/reagent/ethanol/jagermeister = 2)
	result_amount = 3

/datum/chemical_reaction/jagermeister
	name = "Jagermeister"
	result = /datum/reagent/ethanol/jagermeister
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/lonestarmule
	name = "Lonestar Mule"
	result = /datum/reagent/ethanol/lonestarmule
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/gingerbeer = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4

/datum/chemical_reaction/llanbrydewhiskey
	name = "Llanbryde Whiskey"
	result = /datum/reagent/ethanol/llanbrydewhiskey
	required_reagents = list(/datum/reagent/ethanol/specialwhiskey= 2, /datum/reagent/ethanol/gin = 1)
	catalysts = list(/datum/reagent/sugar)
	result_amount = 3

/datum/chemical_reaction/kvass
	name = "Kvass"
	result = /datum/reagent/ethanol/kvass
	required_reagents = list(/datum/reagent/sugar = 1, /datum/reagent/ethanol/beer = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 3

/datum/chemical_reaction/gargled
	name = "Gargled"
	result = /datum/reagent/ethanol/coffee/gargled
	required_reagents = list(/datum/reagent/ethanol/blackstrap = 1, /datum/reagent/drink/coffee = 2)
	result_amount = 3

/datum/chemical_reaction/bogus
	name = "Bogus"
	result = /datum/reagent/ethanol/bogus
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/blackstrap = 2)
	result_amount = 3

/datum/chemical_reaction/moscowmule
	name = "Moscow Mule"
	result = /datum/reagent/ethanol/moscowmule
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/gingerbeer = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 4

/datum/chemical_reaction/springpunch
	name = "Gilgamesh Spring Punch"
	result = /datum/reagent/ethanol/springpunch
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/lemon = 1,  /datum/reagent/sugar = 1)
	result_amount = 4

/datum/chemical_reaction/jimmygideon
	name = "Jimmy Gideon"
	result = /datum/reagent/ethanol/jimmygideon
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/hot_coco = 1)
	result_amount = 3


// Non-Alcoholic Drinks

/datum/chemical_reaction/nothing
	name = "Nothing"
	result = /datum/reagent/drink/nothing
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/sugar = 1, /datum/reagent/water= 1)
	result_amount = 3

/datum/chemical_reaction/fools_gold
	name = "Fools Gold"
	result = /datum/reagent/drink/fools_gold
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/snowball
	name = "Snowball"
	result = /datum/reagent/drink/snowball
	required_reagents = list(/datum/reagent/drink/ice = 2, /datum/reagent/drink/coffee/icecoffee = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution turns pure white."

/datum/chemical_reaction/browndwarf
	name = "Brown Dwarf"
	result = /datum/reagent/drink/browndwarf
	required_reagents = list(/datum/reagent/drink/hot_coco = 2, /datum/reagent/drink/spacemountainwind = 1)
	result_amount = 3
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The chocolate puffs up into a semi-solid state"

/datum/chemical_reaction/kefir
	name = "Kefir"
	result = /datum/reagent/drink/kefir
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/datum/reagent/nutriment)
	mix_message = "The milk ferments into kefir"

// Alien Drinks

/datum/chemical_reaction/skrianhi
	name = "Skrianhi Tea"
	result = /datum/reagent/drink/alien/skrianhi
	required_reagents = list(/datum/reagent/drink/alien/unathijuice = 2, /datum/reagent/water = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The tea turns a bitter black"

/datum/chemical_reaction/mumbaksting
	name = "Mumbak Sting"
	result = /datum/reagent/drink/alien/mumbaksting
	required_reagents = list(/datum/reagent/drink/alien/unathijuice = 2, /datum/reagent/toxin = 1)
	result_amount = 3
	mix_message = "The toxins mix with the juice to create a dark red substance"

/datum/chemical_reaction/wasgaelhi
	name = "Wasgaelhi"
	result = /datum/reagent/ethanol/alien/wasgaelhi
	required_reagents = list(/datum/reagent/drink/alien/unathijuice = 2, /datum/reagent/ethanol/wine = 1)
	result_amount = 3
	mix_message = "The mixture turns a dark green"

/datum/chemical_reaction/kzkzaa
	name = "Kzkzaa"
	result = /datum/reagent/drink/alien/kzkzaa
	required_reagents = list(/datum/reagent/drink/alien/unathijuice = 2, /datum/reagent/nutriment/protein = 1)
	result_amount = 3
	mix_message = "The mixture turns a dark green"

//Fruit Expansion

/datum/chemical_reaction/qokkhrona
	name = "Qokk'Hrona"
	result = /datum/reagent/ethanol/alien/qokkhrona
	required_reagents = list(/datum/reagent/ethanol/alien/qokkloa = 2, /datum/reagent/ethanol/wine = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 3
	mix_message = "The mixture turns a soft red, bubbling faintly"

/datum/chemical_reaction/coconutmilk
	name = "Coconut Milk"
	result = /datum/reagent/drink/coconut/milk
	required_reagents = list(/datum/reagent/drink/coconut = 2, /datum/reagent/nutriment = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100
	catalysts = list(/datum/reagent/enzyme = 5)
	mix_message = "The water dilutes into delicious looking milk"

/datum/chemical_reaction/pinacolada
	name = "Pino Colada"
	result = /datum/reagent/ethanol/pinacolada
	required_reagents = list(/datum/reagent/drink/coconut/milk = 1, /datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/pineapple = 1)
	result_amount = 4
	mix_message = "The cocktail turns a vibrant orange"

/datum/chemical_reaction/horchata
	name = "Horchata"
	result = /datum/reagent/ethanol/horchata
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/milk/cream = 1, /datum/reagent/cinnamon = 1, /datum/reagent/drink/syrup_vanilla = 1)
	result_amount = 5
	mix_message = "The liquid froths up into a rich, cool mixture"