var/global/list/tissues = list()
proc/populate_tissue_list()
	for(var/T in typesof(/datum/tissue)-/datum/tissue)
		var/datum/tissue/tissue = new T
		tissues[tissue.id] = tissue

/datum/tissue
	var/id = "tissue"               // Index for global list.
	var/descriptor = "tissue"       // Descriptive string shown for this layer.
	var/list/descriptors = list()   // Some tissues have specific strings for bodyparts.

	var/list/blunt_damage_strings = list("mangling","mashing","pulverizing")
	var/list/edge_damage_strings = list("ripping","tearing","lacerating")
	var/list/burn_damage_strings = list("scorching","melting","searing")

	var/hardness = HARDNESS_SCALPEL // Minimum tool needed to cut this layer open.

	var/regen_threshold = 50        // After this point, damage will not be regenerated without surgery (ie. bone)
	var/split_threshold = 50        // Point at which tissue is 'broken' or 'open'. Also serves as max damage for the layer.
	var/growth_factor = 1           // Multiplier applied to the config brute regen value for this layer.
	var/flags = TISSUE_BLEEDS | TISSUE_INFECTS // Various general status flags.

/datum/tissue/skin
	id = "skin"
	descriptor = "skin"

/datum/tissue/muscle
	id = "muscle"
	descriptor = "muscle"
	growth_factor = 0.5 // Slower to heal than skin.

/datum/tissue/bone
	id = "bone"
	descriptor = "bone"
	descriptors = list("head"="skull","chest"="ribcage","l_arm"="humerus","r_arm"="humerus","l_leg"="femur","r_leg"="femur")
	hardness = HARDNESS_SAW
	flags = TISSUE_INFECTS | TISSUE_ORGAN_LAYER | TISSUE_SUPPORTS
	regen_threshold = 0 // Cannot regen without surgery.
	blunt_damage_strings = list("cracking","shattering","fracturing")

/datum/tissue/scales
	id = "scales"
	descriptor = "scales"
	hardness = HARDNESS_SAW
	flags = 0

/datum/tissue/cartilage
	id = "cartilage"
	descriptor = "cartilage"
	descriptors = list("head"="brain caul","chest"="organ sheath")
	hardness = HARDNESS_SAW
	flags = TISSUE_INFECTS | TISSUE_ORGAN_LAYER | TISSUE_SUPPORTS

/datum/tissue/slime
	id = "slime"
	descriptor = "slime"
	flags = 0

/datum/tissue/slime/innards
	id = "slime_innards"
	descriptor = "silky innards"
	hardness = HARDNESS_SAW
	flags = TISSUE_INFECTS | TISSUE_BLEEDS | TISSUE_ORGAN_LAYER | TISSUE_SUPPORTS

/datum/tissue/metal
	id = "metal_skin"
	descriptor = "steel casing"
	hardness = HARDNESS_TORCH
	flags = 0

/datum/tissue/cables
	id = "robot_wiring"
	descriptor = "internal conduits"
	hardness = HARDNESS_SAW
	flags = 0

/datum/tissue/metal/adamantine
	id = "adamantine"
	descriptor = "adamantine casing"

/datum/tissue/diona_carapace
	id = "diona_carapace"
	descriptor = "carapace"
	hardness = HARDNESS_SAW
	flags = 0

/datum/tissue/diona_ligaments
	id = "diona_ligaments"
	descriptor = "structural ligaments"
	hardness = HARDNESS_SCALPEL
	flags = 0

/datum/tissue/diona_strata
	id = "diona_strata"
	descriptor = "neural strata"
	hardness = HARDNESS_SAW
	flags = TISSUE_INFECTS | TISSUE_ORGAN_LAYER

// Maybe generalize this out to a 'sharpness' var on items. Consider using sharp for it.
/datum/tissue/proc/can_cut_with(var/obj/item/tool)
	if(tool.sharp >= hardness)
		return 1
	return 0

// This datum is distinct from the previous in that it is just a holder/reference for
// tissue layer status. Actual tissue data is defined in a global list (see top of file).
/datum/tissue_layer
	var/area = 10      // Max available for wounds.
	var/wound_area = 0 // Space occupied by wounds.
	var/datum/tissue/tissue
	var/list/wounds = list() // Current wounds.

/datum/tissue_layer/New(var/newloc,var/tissue_type)
	..()
	if(!tissue_type || !tissues || !tissues[tissue_type])
		del(src)
	tissue = tissues[tissue_type]

/datum/tissue_layer/proc/create_wound(var/wound_type = WOUND_CUT, var/wound_depth = 1)
	var/remainder = 0

	if(wound_area == area)
		return wound_depth

	if(wound_depth > wound_area)
		wound_depth = wound_area
		remainder = wound_depth - wound_area
		wound_area = 0
	wounds += new /datum/wound (src, wound_type, wound_depth)
	update()
	return remainder

/datum/tissue_layer/proc/update()
	wound_area = 0
	for(var/datum/wound/wound in wounds)
		wound_area += wound.severity

/datum/tissue_layer/proc/handle_healing(var/heal)
	if(wound_area < tissue.regen_threshold) // Make sure this isn't too broken to heal (fractured)
		var/list/healed_wounds = list()
		heal *= tissue.growth_factor
		for(var/datum/wound/wound in wounds)
			// Can't heal a stretched-open wound.
			if(!heal)
				break
			if(wound.status == WOUND_RETRACTED)
				continue
			if(heal > wound.severity)
				heal -= wound.severity
				wound.heal(wound.severity)
			else
				wound.heal(heal)
				heal = 0
			if(wound.severity <= 0)
				healed_wounds |= wound
			return
		if(healed_wounds.len)
			wounds -= healed_wounds
	update()
	return heal

/datum/tissue_layer/proc/is_open()
	for(var/datum/wound/wound in wounds)
		if(wound.status == WOUND_RETRACTED)
			return 1
	return 0

/datum/tissue_layer/proc/is_wounded()
	return wound_area > 0

/datum/tissue_layer/proc/is_cut()
	for(var/datum/wound/wound in wounds)
		if(wound.status == WOUND_OPEN || wound.status == WOUND_RETRACTED)
			return 1

/datum/tissue_layer/proc/is_bleeding()
	return (tissue.flags & TISSUE_BLEEDS) && is_wounded()