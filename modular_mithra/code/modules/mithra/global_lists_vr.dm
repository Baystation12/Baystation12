/**
 * MITHRAstation global lists
*/

var/global/list/ear_styles_list = list()	// Stores /datum/sprite_accessory/ears indexed by type
var/global/list/tail_styles_list = list()	// Stores /datum/sprite_accessory/tail indexed by type
var/global/list/wing_styles_list = list()	// Stores /datum/sprite_accessory/wing indexed by type
var/global/list/negative_traits = list()	// Negative custom species traits, indexed by path
var/global/list/neutral_traits = list()		// Neutral custom species traits, indexed by path
var/global/list/positive_traits = list()	// Positive custom species traits, indexed by path
var/global/list/traits_costs = list()		// Just path = cost list, saves time in char setup
var/global/list/all_traits = list() // All of 'em at once (same instances)
var/global/list/custom_species_bases = list() // Species that can be used for a Custom Species icon base

/hook/startup/proc/init_vore_datum_ref_lists() //TODO: Restructure this to remove 'vore' if possible
	var/paths

	// Custom Ears
	paths = typesof(/datum/sprite_accessory/ears) - /datum/sprite_accessory/ears
	for(var/path in paths)
		var/obj/item/clothing/head/instance = new path()
		ear_styles_list[path] = instance

	// Custom Tails
	paths = typesof(/datum/sprite_accessory/tail) - /datum/sprite_accessory/tail
	for(var/path in paths)
		var/datum/sprite_accessory/tail/instance = new path()
		tail_styles_list[path] = instance

	// Custom Wings
	paths = typesof(/datum/sprite_accessory/wing) - /datum/sprite_accessory/wing
	for(var/path in paths)
		var/datum/sprite_accessory/wing/instance = new path()
		wing_styles_list[path] = instance

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
		all_traits[path] = instance
		neutral_traits[path] = instance

	// Custom species icon bases
	var/list/blacklisted_icons = list(SPECIES_CUSTOM,SPECIES_PROMETHEAN,SPECIES_HUMAN) //Just ones that won't work well, and Humans, as Custom Humans will be used instead.
	for(var/species_name in all_species)
		if(species_name in blacklisted_icons)
			continue
		var/datum/species/S = all_species[species_name]
		if(!(S.spawn_flags & SPECIES_IS_ICONBASE))
			continue
		custom_species_bases += species_name


	for(var/species_name in playable_species)
		if(species_name in blacklisted_icons)
			continue
		var/datum/species/S = all_species[species_name]
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			continue
		custom_species_bases += species_name

	return 1 // Hooks must return 1
