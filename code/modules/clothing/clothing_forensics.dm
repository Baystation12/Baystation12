/**
	clothing_forensics
	Behaviors related to detecting crime based on clothing items
*/


/// Alternative name for fibers to allow for more vagueness
/obj/item/clothing/var/fiber_name


/// Build a string for contact forensic evidence
/obj/item/clothing/proc/get_fibers()
	if (~clothing_flags & CLOTHING_HAS_FIBERS)
		return
	var/list/others = list()
	for (var/obj/item/clothing/accessory/A as anything in accessories)
		if ((A.clothing_flags & CLOTHING_HAS_FIBERS) && prob(50))
			others += A.get_fibers()
	return "material from \a [fiber_name || name][others.len ? " and [english_list(others)]" : ""]"


/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [fiber_name || name]."


/obj/item/clothing/shoes/get_fibers()
	return "material from a pair of [fiber_name || name]."


/// Clothing can have prints and be made wrinkly by grabs, etc
/obj/item/clothing/proc/leave_evidence(mob/source)
	add_fingerprint(source)
	if (prob(10))
		ironed_state = WRINKLES_WRINKLY


// Setting fiber_name for common uniform bits to make them less stand-outish. Probably not exhaustive.

/obj/item/clothing/under/solgov/utility/expeditionary/fiber_name = "expeditionary uniform"
/obj/item/clothing/under/solgov/utility/expeditionary_skirt/fiber_name = "expeditionary uniform"
/obj/item/clothing/under/solgov/dress/expeditionary/fiber_name = "expeditionary dress uniform"
/obj/item/clothing/suit/storage/solgov/service/expeditionary/fiber_name = "expeditionary jacket"
/obj/item/clothing/suit/storage/solgov/dress/expedition/fiber_name = "expeditionary dress coat"

/obj/item/clothing/under/solgov/utility/fleet/fiber_name = "fleet coveralls"
/obj/item/clothing/under/solgov/utility/fleet/polopants/fiber_name = "fleet polo and pants"
/obj/item/clothing/under/solgov/utility/fleet/combat/fiber_name = "fleet fatigues"
/obj/item/clothing/under/solgov/service/fleet/fiber_name = "fleet service uniform"
/obj/item/clothing/suit/storage/jacket/solgov/fleet/fiber_name = "fleet jacket"
/obj/item/clothing/suit/storage/solgov/service/fleet/fiber_name = "fleet service jacket"
/obj/item/clothing/suit/storage/solgov/dress/fleet/fiber_name = "fleet dress jacket"

/obj/item/clothing/under/solgov/utility/army/fiber_name = "army fatigues"
/obj/item/clothing/under/solgov/service/army/fiber_name = "army service uniform"
/obj/item/clothing/under/solgov/mildress/army/fiber_name = "army dress uniform"
/obj/item/clothing/suit/storage/solgov/utility/army/fiber_name = "green army jacket"
/obj/item/clothing/suit/storage/solgov/utility/army/navy/fiber_name = "navy army jacket"
/obj/item/clothing/suit/dress/solgov/army/fiber_name = "army dress jacket"


// Removing the has_fibers flag from things that should not leave forensic traces. Probably not exhaustive.

/obj/item/clothing/gloves/insulated/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/gloves/latex/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS

/obj/item/clothing/shoes/galoshes/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS

/obj/item/clothing/suit/space/void/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/space/rig/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/radiation/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/bio_suit/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/rubber/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/chameleon/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/armor/clothing_flags = CLOTHING_FLAGS_DEFAULT_FIBERLESS
/obj/item/clothing/suit/armor/pcarrier/clothing_flags = CLOTHING_FLAGS_DEFAULT //re-adding fibers to plate carriers

/obj/item/clothing/accessory/chameleon/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/storage/holster/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/storage/pouches/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/storage/knifeharness/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/storage/bandolier/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/medal/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/stethoscope/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/pride_pin/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/pronouns/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/arm_guards/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/leg_guards/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/badge/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/armor_plate/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/locket/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/armor_tag/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/necklace/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/kneepads/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/bracelet/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/buddy_tag/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/chaplain/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/ftu_pin/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/wristwatches/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/skillbadge/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/skillstripe/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/torch_patch/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/ec_patch/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/cultex_patch/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/fleet_patch/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/specialty/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/department/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/rank/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/solgov/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/ribbon/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
/obj/item/clothing/accessory/terran/clothing_flags = CLOTHING_FLAGS_ACCESSORY_DEFAULT_FIBERLESS
