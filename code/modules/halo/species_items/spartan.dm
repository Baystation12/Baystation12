
/mob/living/carbon/human/spartan/New(var/new_loc)
	..(new_loc,"Spartan")
	if(gender == "male")
		name = pick(GLOB.first_names_male)
	else
		name = pick(GLOB.first_names_female)
	name += " "
	name += pick(GLOB.last_names)
	real_name = name



/obj/item/organ/external/chest/augmented
	min_broken_damage = 50

/obj/item/organ/external/groin/augmented
	min_broken_damage = 50

/obj/item/organ/external/head/augmented
	min_broken_damage = 50

/obj/item/organ/external/arm/augmented
	min_broken_damage = 50 //Needs 20 more damage to break

/obj/item/organ/external/arm/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/leg/augmented
	min_broken_damage = 50

/obj/item/organ/external/leg/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/hand/augmented
	min_broken_damage = 50

/obj/item/organ/external/hand/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/right/augmented
	min_broken_damage = 50