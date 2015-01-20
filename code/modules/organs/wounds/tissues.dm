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
/datum/tissue/proc/can_cut_with(var/sharpness)
	if(istype(sharpness,/obj))
		var/obj/tool = sharpness
		sharpness = tool.sharp
	if(sharpness >= hardness)
		return 1
	return 0