/*
This file is for all the planes and layers contained in the equipment system.

These are to be used instead of numbers for all equipment usage instead of a magical or arbitrary numbering system.




*/


#define FLESH_EQP_PLANE				0 // For natural things like scales, fur, or chitin.
	#define SKIN_EQP_LAYER				0 // Natural stuff you can't take off. Set based on species.

#define CLOTHING_EQP_PLANE			1 // For most general clothing.
	#define UNDERWEAR_EQP_LAYER			1 // Just underwear.
	#define CLOTHES_EQP_LAYER			2 // This is the former /obj/item/clothing/under/ things like jumpsuits and pants.
	#define JACKET_EQP_LAYER			3 // For thin jackets that don't provite protection but could go under armour like a lab coat or a paramedic jacket.

#define ARMOUR_EQP_PLANE			2 // For all protective armour and armoured exosuits.
	#define SOFT_ARMOUR_EQP_LAYER		1 // For all armour with soft protections.
	#define HARD_ARMOUR_EQP_LAYER		2 // For all armour with hard protection or fitted plates

#define OVERWEAR_EQP_PLANE			3 // For jackets, softsuits, and other things that need to go over everything eles
	#define STORAGE_EQP_LAYER			1 // For holsters, webbing, bandoliers, and other storage things.
	#define OVERCOAT_EQP_LAYER			2 // For either big coats like heavy winter coats or coats that could go over armour like a lab coat or a trench coat.

// Some premade ones for each layer.
#define EQP_SKIN			"skin layer"
#define EQP_UNDERWEAR		"underwear layer"
#define EQP_CLOTHES			"clothing layer"
#define EQP_JACKET			"jacket layer"
#define EQP_SOFT_ARMOUR		"soft armour layer"
#define EQP_HARD_ARMOUR		"hard armour layer"
#define EQP_STORAGE			"storage layer"
#define EQP_OVERCOAT		"overcoat layer"

// This is where to put the combo ones for those that can take more than one layer in the same plane.
#define EQP_BOTH_ARMOUR		"all armour layers"