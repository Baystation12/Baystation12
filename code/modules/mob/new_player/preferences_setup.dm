#define ASSIGN_LIST_TO_COLORS(L, R, G, B) if(L) { R = L[1]; G = L[2]; B = L[3]; }

/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	var/datum/species/current_species = all_species[species]
	if(!current_species) current_species = all_species[SPECIES_HUMAN]
	gender = pick(current_species.genders)

	h_style = random_hair_style(gender, species)
	facial_hair_style = random_facial_hair_style(gender, species)
	if(current_species)
		if(current_species.appearance_flags & HAS_A_SKIN_TONE)
			s_tone = current_species.get_random_skin_tone() || s_tone
		if(current_species.appearance_flags & HAS_EYE_COLOR)
			ASSIGN_LIST_TO_COLORS(current_species.get_random_eye_color(), r_eyes, g_eyes, b_eyes)
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			ASSIGN_LIST_TO_COLORS(current_species.get_random_skin_color(), r_skin, g_skin, b_skin)
		if(current_species.appearance_flags & HAS_HAIR_COLOR)
			var/hair_colors = current_species.get_random_hair_color()
			if(hair_colors)
				ASSIGN_LIST_TO_COLORS(hair_colors, r_hair, g_hair, b_hair)

				if(prob(75))
					r_facial = r_hair
					g_facial = g_hair
					b_facial = b_hair
				else
					ASSIGN_LIST_TO_COLORS(current_species.get_random_facial_hair_color(), r_facial, g_facial, b_facial)

	if(current_species.appearance_flags & HAS_UNDERWEAR)
		if(all_underwear)
			all_underwear.Cut()
		for(var/datum/category_group/underwear/WRC in GLOB.underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name

	backpack = decls_repository.get_decl(pick(subtypesof(/decl/backpack_outfit)))
	age = rand(current_species.min_age, current_species.max_age)
	b_type = RANDOM_BLOOD_TYPE
	if(H)
		copy_to(H)

#undef ASSIGN_LIST_TO_COLORS
