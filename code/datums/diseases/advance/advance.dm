/*

	Advance Disease is a system for Virologist to Engineer their own disease with symptoms that have effects and properties
	which add onto the overall disease.

	If you need help with creating new symptoms or expanding the advance disease, ask for Giacom on #coderbus.

*/

#define RANDOM_STARTING_LEVEL 2

var/list/archive_diseases = list()


/*

	PROPERTIES

 */

/datum/disease/advance

	name = "Unknown" // We will always let our Virologist name our disease.
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease" // Will let med-scanners know that this disease was engineered.
	agent = "advance microbes"
	max_stages = 5
	spread = "Unknown"
	affected_species = list("Human","Monkey")

	// NEW VARS

	var/list/symptoms = list() // The symptoms of the disease.

/*

	OLD PROCS

 */

/datum/disease/advance/New(var/process = 1, var/datum/disease/advance/D, var/copy = 0)

	// Setup our dictionary if it hasn't already.
	if(!dictionary_symptoms.len)
		for(var/symp in list_symptoms)
			var/datum/symptom/S = new symp
			dictionary_symptoms[S.id] = symp

	if(!istype(D))
		D = null
	// Generate symptoms if we weren't given any.

	if(!symptoms || !symptoms.len)

		if(!D || !D.symptoms || !D.symptoms.len)
			symptoms = GenerateSymptoms()
		else
			for(var/datum/symptom/S in D.symptoms)
				symptoms += new S.type
			name = D.name

	Refresh(!copy)
	..(process, D)
	return

// Randomly pick a symptom to activate.
/datum/disease/advance/stage_act()
	..()
	if(symptoms && symptoms.len)
		for(var/datum/symptom/S in symptoms)
			S.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")

// Compares type then ID.
/datum/disease/advance/IsSame(var/datum/disease/advance/D)
	if(!(istype(D, /datum/disease/advance)))
		//error("Returning 0 because not same type.")

		return 0
	//error("Comparing [src.GetDiseaseID()] [D.GetDiseaseID()]")
	if(src.GetDiseaseID() != D.GetDiseaseID())
		//error("Returing 0")
		return 0
	//error("Returning 1")
	return 1

// To add special resistances.
/datum/disease/advance/cure(var/resistance=1)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !(id in affected_mob.resistances))
			affected_mob.resistances[id] = id
		affected_mob.viruses -= src		//remove the datum from the list
	del(src)	//delete the datum to stop it processing
	return

// Returns the advance disease with a different reference memory.
/datum/disease/advance/Copy()
	return new /datum/disease/advance(0, src, 1)

/*

	NEW PROCS

 */

// Mix the symptoms of two diseases (the src and the argument)
/datum/disease/advance/proc/Mix(var/datum/disease/advance/D)
	if(!(src.IsSame(D)))
		var/list/possible_symptoms = shuffle(D.symptoms)
		for(var/datum/symptom/S in possible_symptoms)
			AddSymptom(new S.type)

/datum/disease/advance/proc/HasSymptom(var/datum/symptom/S)
	for(var/datum/symptom/symp in symptoms)
		if(symp.id == S.id)
			return 1
	return 0

// Will generate new unique symptoms, use this if there are none. Returns a list of symptoms that were generated.
/datum/disease/advance/proc/GenerateSymptoms(var/type_level_limit = RANDOM_STARTING_LEVEL, var/amount_get = 0)

	var/list/generated = list() // Symptoms we generated.

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in list_symptoms)
		var/datum/symptom/S = new symp
		if(S.level <= type_level_limit)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!possible_symptoms.len)
		return
		//error("Advance Disease - We weren't able to get any possible symptoms in GenerateSymptoms([type_level_limit], [amount_get])")

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i; i++)
		var/datum/symptom/S = pick(possible_symptoms)
		generated += S
		possible_symptoms -= S

	return generated

/datum/disease/advance/proc/Refresh(var/save = 1)
	//world << "[src.name] \ref[src] - REFRESH!"
	var/list/properties = GenerateProperties()
	AssignProperties(properties)
	if(save)
		archive_diseases[GetDiseaseID()] = new /datum/disease/advance(0, src, 1)

//Generate disease properties based on the effects. Returns an associated list.
/datum/disease/advance/proc/GenerateProperties()

	if(!symptoms || !symptoms.len)
		CRASH("We did not have any symptoms before generating properties.")
		return

	var/list/properties = list("resistance" = 1, "stealth" = 1, "stage_rate" = 1, "transmittable" = 1, "severity" = 1)

	for(var/datum/symptom/S in symptoms)

		properties["resistance"] += S.resistance
		properties["stealth"] += S.stealth
		properties["stage_rate"] += S.stage_speed
		properties["transmittable"] += S.transmittable
		properties["severity"] = max(properties["severity"], S.level) // severity is based on the highest level symptom

	return properties

// Assign the properties that are in the list.
/datum/disease/advance/proc/AssignProperties(var/list/properties = list())

	if(properties && properties.len)

		hidden = list( (properties["stealth"] > 2), (properties["stealth"] > 3) )
		// The more symptoms we have, the less transmittable it is but some symptoms can make up for it.
		SetSpread(max(BLOOD, min(properties["transmittable"] - symptoms.len, AIRBORNE)))
		permeability_mod = max(round(0.5 * properties["transmittable"]), 1)
		stage_prob = max(properties["stage_rate"], 1)
		SetSeverity(properties["severity"])
		GenerateCure(properties)
	else
		CRASH("Our properties were empty or null!")


// Assign the spread type and give it the correct description.
/datum/disease/advance/proc/SetSpread(var/spread_id)
	switch(spread_id)

		if(NON_CONTAGIOUS)
			spread = "None"
		if(SPECIAL)
			spread = "None"
		if(CONTACT_GENERAL, CONTACT_HANDS, CONTACT_FEET)
			spread = "On contact"
		if(AIRBORNE)
			spread = "Airborne"
		if(BLOOD)
			spread = "Blood"

	spread_type = spread_id
	//world << "Setting spread type to [spread_id]/[spread]"

/datum/disease/advance/proc/SetSeverity(var/level_sev)

	switch(level_sev)

		if(0)
			severity = "Non-Threat"
		if(1)
			severity = "Minor"
		if(2)
			severity = "Medium"
		if(3)
			severity = "Harmful"
		if(4)
			severity = "Dangerous!"
		if(5)
			severity = "BIOHAZARD THREAT!"
		else
			severity = "Unknown"


// Will generate a random cure, the less resistance the symptoms have, the harder the cure.
/datum/disease/advance/proc/GenerateCure(var/list/properties = list())
	if(properties && properties.len)
		var/res = max(properties["resistance"] - (symptoms.len / 2), 0)
		//world << "Res = [res]"
		switch(round(res))
			// Due to complications, I cannot randomly generate cures or randomly give cures.
			if(0)
				cure_id = "nutriment"

			if(1)
				cure_id = "sodiumchloride"

			if(2)
				cure_id = "orangejuice"

			if(3)
				cure_id = "spaceacillin"

			if(4)
				cure_id = "ethanol"

			if(5)
				cure_id = "ethylredoxrazine"

			if(6)
				cure_id = "synaptizine"

			if(7)
				cure_id = "silver"

			if(8)
				cure_id = "gold"

			if(9)
				cure_id = "mindbreaker"

			else
				cure_id = "plasma"

		// Get the cure name from the cure_id
		var/datum/reagent/D = chemical_reagents_list[cure_id]
		cure = D.name


	return

// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/Evolve(var/level = 2)
	var/s = safepick(GenerateSymptoms(level, 1))
	if(s)
		AddSymptom(s)
		Refresh()
	return

// Randomly remove a symptom.
/datum/disease/advance/proc/Devolve()
	if(symptoms.len > 1)
		var/s = safepick(symptoms)
		if(s)
			RemoveSymptom(s)
			Refresh()
	return

// Name the disease.
/datum/disease/advance/proc/AssignName(var/name = "Unknown")
	src.name = name
	return

// Return a unique ID of the disease.
/datum/disease/advance/proc/GetDiseaseID()
	var/list/L = list()
	for(var/datum/symptom/S in symptoms)
		L += S.id
	L = sortList(L) // Sort the list so it doesn't matter which order the symptoms are in.
	return dd_list2text(L, ":")

// Add a symptom, if it is over the limit (with a small chance to be able to go over)
// we take a random symptom away and add the new one.
/datum/disease/advance/proc/AddSymptom(var/datum/symptom/S)

	if(HasSymptom(S))
		return

	if(symptoms.len < 3 + rand(-1, 1))
		symptoms += S
	else
		RemoveSymptom(pick(symptoms))
		symptoms += S
	return

// Simply removes the symptom.
/datum/disease/advance/proc/RemoveSymptom(var/datum/symptom/S)
	symptoms -= S
	return

/*

	Static Procs

*/

// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(var/list/D_list)

	//world << "Mixing!!!!"

	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list.Copy())
		diseases += A.Copy()

	if(!diseases.len)
		return null
	if(diseases.len <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && diseases.len > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	 // Should be only 1 entry left, but if not let's only return a single entry
	//world << "END MIXING!!!!!"
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.Refresh()
	return to_return

/proc/SetViruses(var/datum/reagent/R, var/list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.Copy()
			R.data = data.Copy()
		else
			R.data = data
		if(preserve.len)
			R.data["viruses"] = preserve

#undef RANDOM_STARTING_LEVEL