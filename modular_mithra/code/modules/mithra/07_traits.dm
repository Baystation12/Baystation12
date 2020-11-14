#define NEUTRAL_MODE 1

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#f5e400"

	// What traits they've selected for their custom species
	var/list/neu_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = STARTING_SPECIES_POINTS
	var/max_traits = MAX_SPECIES_TRAITS

/datum/category_item/player_setup_item/vore/traits
	name = "Traits"
	sort_order = 2

/datum/category_item/player_setup_item/vore/traits/load_character(var/savefile/S)
	from_file(S["custom_species"], pref.custom_species)
	from_file(S["custom_base"], pref.custom_base)
	from_file(S["neu_traits"], pref.neu_traits)
	from_file(S["blood_color"], pref.blood_color)

	from_file(S["traits_cheating"], pref.traits_cheating)
	from_file(S["max_traits"], pref.max_traits)
	from_file(S["trait_points"], pref.starting_trait_points)

/datum/category_item/player_setup_item/vore/traits/save_character(var/savefile/S)
	to_file(S["custom_species"], pref.custom_species)
	to_file(S["custom_base"], pref.custom_base)
	to_file(S["neu_traits"], pref.neu_traits)
	to_file(S["blood_color"], pref.blood_color)

	to_file(S["traits_cheating"], pref.traits_cheating)
	to_file(S["max_traits"], pref.max_traits)
	to_file(S["trait_points"], pref.starting_trait_points)

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.neu_traits) pref.neu_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, default="#f5e400")

	if(!pref.traits_cheating)
		pref.starting_trait_points = STARTING_SPECIES_POINTS
		pref.max_traits = MAX_SPECIES_TRAITS

	if(pref.species != SPECIES_CUSTOM)
		pref.neu_traits.Cut()
	else
		//Neutral traits
		for(var/path in pref.neu_traits)
			if(!(path in neutral_traits))
				pref.neu_traits -= path

	var/datum/species/selected_species = all_species[pref.species]
	if(selected_species.selects_bodytype)
		// Allowed!
	else if(!pref.custom_base || !(pref.custom_base in custom_species_bases))
		pref.custom_base = SPECIES_HUMAN2

obj/item/organ/external
	var/custom_species_override

datum/preferences/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	..()

	character.custom_species	= custom_species

	var/datum/species/selected_species = all_species[species]
	if(selected_species.selects_bodytype)
		var/datum/species/custom/CS = character.species
		var/S = custom_base ? custom_base : "Human"
		var/datum/species/custom/new_CS = CS.produceCopy(S, neu_traits, character)

		//Any additional non-trait settings can be applied here
		new_CS.blood_color = blood_color

	for(var/obj/item/organ/external/E in character.organs)	//Forces the base species stuff onto the limbs
		E.custom_species_override = character.species.base_species	//Kludge to make the icon cache key proper
		E.species = character.species	//Secondary kludge
		if(!BP_IS_ROBOTIC(E))	//Check if the limb is robotic
			E.force_icon = character.species.get_icobase()	//If not, force the species limb icons onto the limb because update_icons won't actually use the icon cache key stuff

	character.force_update_limbs()
	character.update_sight()
	character.update_body(0)
	character.update_hair()
	character.update_icons()

/datum/category_item/player_setup_item/vore/traits/content(var/mob/user)
	. += "<b>Custom Species</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"

	var/datum/species/selected_species = all_species[pref.species]
	if(selected_species.selects_bodytype)
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : "Custom Human"]</a><br>"

		. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neu_traits)
			var/datum/trait/trait = neutral_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name]</a></li>"
		. += "</ul>"

	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"

/datum/category_item/player_setup_item/vore/traits/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["custom_species"])
		/*if(pref.species != "Custom Species")
			alert("You cannot set a custom species name unless you set your character to use the 'Custom Species' \
			species on the 'General' tab. If you have this set to something, it's because you had it set before the \
			Trait system was implemented. If you wish to change it, set your species to 'Custom Species' and configure \
			the species completely.")
			return TOPIC_REFRESH*/ //There was no reason to have this.
		var/raw_choice = sanitize(input(user, "Input your custom species name:",
			"Character Preference", pref.custom_species) as null|text, MAX_NAME_LEN)
		if (CanUseTopic(user))
			pref.custom_species = raw_choice
		return TOPIC_REFRESH

	else if(href_list["custom_base"])
		var/list/choices = custom_species_bases
		if(pref.species != SPECIES_CUSTOM)
			choices = (choices | pref.species)
		var/text_choice = input("Pick an icon set for your species:","Icon Base") in choices
		if(text_choice in choices)
			pref.custom_base = text_choice
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_color"])
		var/color_choice = input("Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color) as color
		if(color_choice)
			pref.blood_color = sanitize_hexcolor(color_choice, default="#f5e400")
		return TOPIC_REFRESH

	else if(href_list["blood_reset"])
		var/choice = alert("Reset blood color to human default (#A10808)?","Reset Blood Color","Reset","Cancel")
		if(choice == "Reset")
			pref.blood_color = "#f5e400"
		return TOPIC_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		var/choice = alert("Remove [initial(trait.name)]?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.neu_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["add_trait"])
		var/mode = text2num(href_list["add_trait"])
		var/list/picklist
		var/list/mylist
		if(mode == NEUTRAL_MODE)
			picklist = neutral_traits.Copy() - pref.neu_traits
			mylist = pref.neu_traits

		if(isnull(picklist))
			return TOPIC_REFRESH

		if(isnull(mylist))
			return TOPIC_REFRESH

		var/list/nicelist = list()
		for(var/P in picklist)
			var/datum/trait/T = picklist[P]
			nicelist[T.name] = P

		var/trait_choice
		var/done = FALSE
		while(!done)
			var/message = "Select a trait to read the description."
			trait_choice = input(message,"Trait List") as null|anything in nicelist
			if(!trait_choice)
				done = TRUE
			if(trait_choice in nicelist)
				var/datum/trait/path = nicelist[trait_choice]
				var/choice = alert("\ [initial(path.desc)]","[initial(path.name)]","Take Trait","Cancel","Go Back")
				if(choice == "Cancel")
					trait_choice = null
				if(choice != "Go Back")
					done = TRUE

		if(!trait_choice)
			return TOPIC_REFRESH
		else if(trait_choice in nicelist)
			var/datum/trait/path = nicelist[trait_choice]
			var/datum/trait/instance = all_traits[path]

			var/conflict = FALSE

			if(trait_choice in pref.neu_traits)
				conflict = instance.name

			varconflict:
				for(var/P in pref.neu_traits)
					var/datum/trait/instance_test = all_traits[P]
					if(path in instance_test.excludes)
						conflict = instance_test.name
						break varconflict

					for(var/V in instance.var_changes)
						if(V in instance_test.var_changes)
							conflict = instance_test.name
							break varconflict

			if(conflict)
				alert("You cannot take this trait and [conflict] at the same time. \
				Please remove that trait, or pick another trait to add.","Error")
				return TOPIC_REFRESH

			mylist += path
			return TOPIC_REFRESH

	return ..()

#undef NEUTRAL_MODE
