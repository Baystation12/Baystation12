
/obj/item/organ/liver/quorum
	name = "waste filter"
	icon_state = "kidneys"
	organ_tag = "kidneys"
	parent_organ = "groin"

/obj/item/organ/liver/quorum/process()
		//quorom have dual purpose bladder/kidney. assumingly this means that their bladder-kidney processing what a liver would as well. so its a liver now! yay!
	..()

	if(!owner)
		return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/heart/quorum
	name = "blood oxidizer"
	icon_state = "heart"
	organ_tag = "heart"
	parent_organ = "chest"

/obj/item/organ/heart/quorum/process()
	//same deal for heart-lungs.
	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15