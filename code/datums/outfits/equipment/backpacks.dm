#define BACKPACK_HAS_TYPE_SELECTION 1
#define BACKPACK_HAS_SUBTYPE_SELECTION 2

/*******************
* Outfit Backpacks *
*******************/

/* Setup new backpacks here */
/decl/backpack_outfit/nothing
	name = "Nothing"

/decl/backpack_outfit/nothing/spawn_backpack(var/location, var/metadata, var/desired_type)
	return

/decl/backpack_outfit/backpack
	name = "Backpack"
	path = /obj/item/weapon/storage/backpack
	is_default = TRUE

/decl/backpack_outfit/rucksack
	name = "Rucksack"
	path = /obj/item/weapon/storage/backpack/rucksack
	flags = BACKPACK_HAS_TYPE_SELECTION

/decl/backpack_outfit/satchel
	name = "Satchel"
	path = /obj/item/weapon/storage/backpack/satchel

/decl/backpack_outfit/satchel/New()
	..()
	tweaks += new/datum/backpack_tweak/selection/specified_types_as_list(typesof(/obj/item/weapon/storage/backpack/satchel/leather) + /obj/item/weapon/storage/backpack/satchel/grey)

/decl/backpack_outfit/messenger_bag
	name = "Messenger bag"
	path = /obj/item/weapon/storage/backpack/messenger

/decl/backpack_outfit/pocketbook
	name = "Pocketbook"
	path = /obj/item/weapon/storage/backpack/satchel/pocketbook
	flags = BACKPACK_HAS_TYPE_SELECTION

/* Code */
/decl/backpack_outfit
	var/flags
	var/name
	var/path
	var/is_default = FALSE
	var/list/tweaks

/decl/backpack_outfit/New()
	tweaks = tweaks || list()

	if(FLAGS_EQUALS(flags, BACKPACK_HAS_TYPE_SELECTION|BACKPACK_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")

	if(flags & BACKPACK_HAS_TYPE_SELECTION)
		tweaks += new/datum/backpack_tweak/selection/types(path)
	if(flags & BACKPACK_HAS_SUBTYPE_SELECTION)
		tweaks += new/datum/backpack_tweak/selection/subtypes(path)

/decl/backpack_outfit/proc/spawn_backpack(var/location, var/metadata, var/desired_type)
	metadata = metadata || list()
	desired_type = desired_type || path
	for(var/t in tweaks)
		var/datum/backpack_tweak/bt = t
		var/tweak_metadata = metadata["[bt]"] || bt.get_default_metadata()
		desired_type = bt.get_backpack_type(desired_type, tweak_metadata)

	. = new desired_type(location)

	for(var/t in tweaks)
		var/datum/backpack_tweak/bt = t
		var/tweak_metadata = metadata["[bt]"]
		bt.tweak_backpack(., tweak_metadata)

/******************
* Backpack Tweaks *
******************/
/datum/backpack_tweak/proc/get_ui_content(var/metadata)
	return ""

/datum/backpack_tweak/proc/get_default_metadata()
	return

/datum/backpack_tweak/proc/get_metadata(var/user, var/metadata, var/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	return

/datum/backpack_tweak/proc/validate_metadata(var/metadata)
	return get_default_metadata()

/datum/backpack_tweak/proc/get_backpack_type(var/given_backpack_type)
	return given_backpack_type

/datum/backpack_tweak/proc/tweak_backpack(var/obj/item/weapon/storage/backpack/backpack, var/metadata)
	return


/* Selection Tweak */
/datum/backpack_tweak/selection
	var/const/RETURN_GIVEN_BACKPACK = "default"
	var/const/RETURN_RANDOM_BACKPACK = "random"
	var/list/selections

/datum/backpack_tweak/selection/New(var/list/selections)
	if(!selections.len)
		CRASH("No selections offered")
	if(RETURN_GIVEN_BACKPACK in selections)
		CRASH("May not use the keyword '[RETURN_GIVEN_BACKPACK]'")
	if(RETURN_RANDOM_BACKPACK in selections)
		CRASH("May not use the keyword '[RETURN_RANDOM_BACKPACK]'")
	var/list/duplicate_keys = duplicates(selections)
	if(duplicate_keys.len)
		CRASH("Duplicate names found: [english_list(duplicate_keys)]")
	var/list/duplicate_values = duplicates(list_values(selections))
	if(duplicate_values.len)
		CRASH("Duplicate types found: [english_list(duplicate_values)]")
	for(var/selection_key in selections)
		if(!istext(selection_key))
			CRASH("Expected a valid selection key, was [log_info_line(selection_key)]")
		var/selection_type = selections[selection_key]
		if(!ispath(selection_type, /obj/item/weapon/storage/backpack))
			CRASH("Expected a valid selection value, was [log_info_line(selection_type)]")

	src.selections = selections
	selections += RETURN_GIVEN_BACKPACK
	selections += RETURN_RANDOM_BACKPACK

/datum/backpack_tweak/selection/get_ui_content(var/metadata)
	return "Type: [metadata]"

/datum/backpack_tweak/selection/get_default_metadata()
	return RETURN_GIVEN_BACKPACK

/datum/backpack_tweak/selection/validate_metadata(var/metadata)
	return (metadata in selections) ? metadata : ..()

/datum/backpack_tweak/selection/get_metadata(var/user, var/metadata, var/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	return input(user, "Choose a type.", title, metadata) as null|anything in selections

/datum/backpack_tweak/selection/get_backpack_type(var/given_backpack_type, var/metadata)
	switch(metadata)
		if(RETURN_GIVEN_BACKPACK)
			return given_backpack_type
		if(RETURN_RANDOM_BACKPACK)
			var/random_choice = pick(selections - RETURN_RANDOM_BACKPACK)
			return get_backpack_type(given_backpack_type, random_choice)
		else
			return selections[metadata]

/datum/backpack_tweak/selection/types/New(var/selection_type)
	..(atomtype2nameassoclist(selection_type))

/datum/backpack_tweak/selection/subtypes/New(var/selection_type)
	..(atomtypes2nameassoclist(subtypesof(selection_type)))

/datum/backpack_tweak/selection/specified_types_as_list/New(var/selection_list)
	..(atomtypes2nameassoclist(selection_list))

/datum/backpack_tweak/selection/specified_types_as_args/New()
	..(atomtypes2nameassoclist(args))

/******************
* Character setup *
*******************/
/datum/backpack_setup
	var/decl/backpack_outfit/backpack
	var/metadata

/datum/backpack_setup/New(var/backpack, var/metadata)
	src.backpack = backpack
	src.metadata = metadata

/**********
* Helpers *
**********/
/proc/get_default_outfit_backpack()
	var backpacks = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	for(var/backpack in backpacks)
		var/decl/backpack_outfit/bo = backpacks[backpack]
		if(bo.is_default)
			return bo

#undef BACKPACK_HAS_TYPE_SELECTION
#undef BACKPACK_HAS_SUBTYPE_SELECTION
