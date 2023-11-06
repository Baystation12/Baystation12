/datum/artifact_trigger/chemical
	name = "presence of a chemical"
	var/list/required_chemicals	//Need any of these

/datum/artifact_trigger/chemical/New()
	if(isnull(required_chemicals))
		name = "presence of either an acid, toxin, or water"
		required_chemicals = typesof(pick(/datum/reagent/acid, /datum/reagent/toxin, /datum/reagent/water))

/datum/artifact_trigger/chemical/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/reagent_containers))
		if(O.reagents.has_any_reagent(required_chemicals))
			return TRUE

/datum/artifact_trigger/chemical/water
	name = "presence of water"

/datum/artifact_trigger/chemical/water/New()
	required_chemicals = typesof(/datum/reagent/water)

/datum/artifact_trigger/chemical/water/on_water_act(depth)
	if(depth > FLUID_EVAPORATION_POINT)
		return TRUE

/datum/artifact_trigger/chemical/acid
	name = "presence of acid"
	required_chemicals = list(
		/datum/reagent/acid,
		/datum/reagent/acid/polyacid,
		/datum/reagent/diethylamine
	)
	trigger_type = TRIGGER_COMPLEX

/datum/artifact_trigger/chemical/acid/New()
	required_chemicals = typesof(/datum/reagent/acid)
/datum/artifact_trigger/chemical/volatile
	name = "presence of volatile chemicals"
	required_chemicals = list(
		/datum/reagent/toxin/phoron,
		/datum/reagent/thermite,
		/datum/reagent/fuel,
		/datum/reagent/toxin/pyrotoxin,
		/datum/reagent/potassium,
		/datum/reagent/napalm,
		/datum/reagent/napalm/b,
		/datum/reagent/nitroglycerin,
		/datum/reagent/toxin/phoron/oxygen,
		/datum/reagent/gunpowder
	)
	trigger_type = TRIGGER_COMPLEX

/datum/artifact_trigger/chemical/toxic
	name = "presence of toxins"

/datum/artifact_trigger/chemical/toxic/New()
	required_chemicals = typesof(/datum/reagent/toxin)
