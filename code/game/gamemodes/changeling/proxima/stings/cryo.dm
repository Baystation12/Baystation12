/obj/screen/movable/ability_master/changeling/sting/cryo
	name = "Cryogenic Sting"
	desc = "We silently sting a human with a cocktail of chemicals that freeze them."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing."
	sting_icon = "sting_cryo"
	chemical_cost = 15
	dna_cost = 2

/obj/screen/movable/ability_master/changeling/sting/cryo/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "cryo sting")
	if(target.reagents)
		target.reagents.add_reagent("frostoil", 30)
	return TRUE
