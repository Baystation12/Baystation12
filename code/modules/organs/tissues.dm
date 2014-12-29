// Tissue macros.
// Tool values
#define HARDNESS_SCALPEL 1
#define HARDNESS_SAW 2
#define HARDNESS_TORCH 3

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
	var/brute_soak = 0              // Amount of damage removed from brute damage to the limb. TODO: blunt_soak and edge_soak.
	var/burn_soak = 0               // As above, for burn.

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
	switch(hardness)
		if(HARDNESS_SCALPEL)
			if(istype(tool,/obj/item/weapon/scalpel))
				return 1
		if(HARDNESS_SAW)
			if(istype(tool,/obj/item/weapon/circular_saw))
				return 1
		if(HARDNESS_TORCH)
			if(istype(tool,/obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/W = tool
				if(W.isOn())
					return 1
		else
			return 1
	return 0

// This datum is distinct from the previous in that it is just a holder/reference for
// tissue layer status. Actual tissue data is defined in a global list (see top of file).
/datum/tissue_layer
	var/damage = 0
	var/retracted = 0
	var/necrotic = 0
	var/datum/tissue/tissue

/datum/tissue_layer/New(var/newloc,var/tissue_type)
	..()
	if(!tissue_type || !tissues || !tissues[tissue_type])
		del(src)
	tissue = tissues[tissue_type]

/datum/tissue_layer/proc/heal_damage(var/healing_damage)
	// Tissue layer is undamaged or beyond natural recovery.
	if(damage == 0 || damage > tissue.regen_threshold)
		return healing_damage

	// Get the amount we will need to subtract to heal all of our damage.
	var/need_healing = min(healing_damage,damage/tissue.growth_factor)
	if(!necrotic) // Necrosis consumes health but doesn't actually heal.
		damage = max(0,damage-(need_healing*tissue.growth_factor))
	healing_damage -= need_healing
	return healing_damage

/datum/tissue_layer/proc/set_damage(var/new_damage)
	damage = max(new_damage, tissue.split_threshold)

/datum/tissue_layer/proc/take_damage(var/dealt_damage, var/damage_type)
	// If the tissue is open (damage at or past threshold) we just pass right through.
	if(damage >= tissue.split_threshold)
		return dealt_damage
	// Work out how much is soaked and how much remains for lower tissues.
	var/remaining_damage = dealt_damage
	var/damage_soaked = 0
	switch(damage_type)
		if(BRUTE)
			damage_soaked = tissue.brute_soak
		if(BURN)
			damage_soaked = tissue.burn_soak
	damage_soaked = remaining_damage * damage_soaked
	remaining_damage = remaining_damage - damage_soaked
	damage += damage_soaked
	// Overflow damage is returned.
	if(damage > tissue.split_threshold)
		remaining_damage += damage - tissue.split_threshold
	return remaining_damage

/datum/tissue_layer/proc/is_open()
	return retracted

/datum/tissue_layer/proc/is_split()
	return damage >= tissue.split_threshold

/datum/tissue_layer/proc/is_bleeding()
	return is_split() && (tissue.flags & TISSUE_BLEEDS)