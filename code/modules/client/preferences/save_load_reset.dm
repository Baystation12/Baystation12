/datum/preferences/proc/load_char(var/savefile/S)
	S["real_name"]				>> real_name
	S["char_lock"]				>> char_lock
	S["gender"]					>> gender
	S["age"]					>> age
	S["spawnpoint"]				>> spawnpoint
	S["OOC_Notes"]				>> metadata
	S["species"]				>> species
	S["hair_red"]				>> r_hair
	S["hair_green"]				>> g_hair
	S["hair_blue"]				>> b_hair
	S["facial_red"]				>> r_facial
	S["facial_green"]			>> g_facial
	S["facial_blue"]			>> b_facial
	S["skin_tone"]				>> s_tone
	S["skin_red"]				>> r_skin
	S["skin_green"]				>> g_skin
	S["skin_blue"]				>> b_skin
	S["hair_style_name"]		>> h_style
	S["facial_style_name"]		>> f_style
	S["eyes_red"]				>> r_eyes
	S["eyes_green"]				>> g_eyes
	S["eyes_blue"]				>> b_eyes
	S["b_type"]					>> b_type
	S["disabilities"]			>> disabilities
	S["organ_data"]				>> organ_data
	S["rlimb_data"]				>> rlimb_data
	S["has_cortical_stack"] 	>> has_cortical_stack
	S["language"]				>> alternate_languages
	S["all_underwear"]          >> all_underwear
	S["all_underwear_metadata"] >> all_underwear_metadata
	S["backbag"]                >> backbag
	S["med_record"]				>> med_record
	S["sec_record"]				>> sec_record
	S["gen_record"]				>> gen_record
	S["home_system"]			>> home_system
	S["citizenship"]			>> citizenship
	S["faction"]				>> faction
	S["religion"]				>> religion
	S["nanotrasen_relation"]	>> nanotrasen_relation
	S["flavor_texts_general"]	>> flavor_texts["general"]
	S["flavor_texts_head"]		>> flavor_texts["head"]
	S["flavor_texts_face"]		>> flavor_texts["face"]
	S["flavor_texts_eyes"]		>> flavor_texts["eyes"]
	S["flavor_texts_torso"]		>> flavor_texts["torso"]
	S["flavor_texts_arms"]		>> flavor_texts["arms"]
	S["flavor_texts_hands"]		>> flavor_texts["hands"]
	S["flavor_texts_legs"]		>> flavor_texts["legs"]
	S["flavor_texts_feet"]		>> flavor_texts["feet"]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> flavour_texts_robot["Default"]
	for(var/module in GLOB.robot_module_types)
		S["flavour_texts_robot_[module]"] >> flavour_texts_robot[module]

	preview_icon = null

	from_file(S["be_special"],           be_special_role)
	from_file(S["sometimes_be_special"], sometimes_be_special_role)
	from_file(S["never_be_special"],     never_be_special_role)
	S["uplinklocation"] >> uplinklocation
	S["exploit_record"] >> exploit_record

	from_file(S["gear_list"], gear_list)
	from_file(S["gear_slot"], gear_slot)
	if(gear_list!=null && gear_slot!=null)
		gear = gear_list["[gear_slot]"]
	else
		from_file(S["gear"], gear)

	S["alternate_option"]	>> alternate_option
	S["job_high"]	>> job_high
	S["job_medium"]	>> job_medium
	S["job_low"]	>> job_low
	if(!job_medium)
		job_medium = list()
	if(!job_low)
		job_low = list()
	S["player_alt_titles"]	>> player_alt_titles
	S["char_branch"] 			>> char_branch
	S["char_rank"] 				>> char_rank
	S["relations"]	>> relations
	S["relations_info"]	>> relations_info

/datum/preferences/proc/save_char(var/savefile/S)
	S["real_name"]				<< real_name
	S["char_lock"]				<< char_lock
	S["gender"]					<< gender
	S["age"]					<< age
	S["spawnpoint"]				<< spawnpoint
	S["OOC_Notes"]				<< metadata
	S["language"]				<< alternate_languages
	S["species"]				<< species
	S["hair_red"]				<< r_hair
	S["hair_green"]				<< g_hair
	S["hair_blue"]				<< b_hair
	S["facial_red"]				<< r_facial
	S["facial_green"]			<< g_facial
	S["facial_blue"]			<< b_facial
	S["skin_tone"]				<< s_tone
	S["skin_red"]				<< r_skin
	S["skin_green"]				<< g_skin
	S["skin_blue"]				<< b_skin
	S["hair_style_name"]		<< h_style
	S["facial_style_name"]		<< f_style
	S["eyes_red"]				<< r_eyes
	S["eyes_green"]				<< g_eyes
	S["eyes_blue"]				<< b_eyes
	S["b_type"]					<< b_type
	S["disabilities"]			<< disabilities
	S["organ_data"]				<< organ_data
	S["rlimb_data"]				<< rlimb_data
	S["has_cortical_stack"] 	<< has_cortical_stack
	S["all_underwear"]          << all_underwear
	S["all_underwear_metadata"] << all_underwear_metadata
	S["backbag"]                << backbag
	S["med_record"]				<< med_record
	S["sec_record"]				<< sec_record
	S["gen_record"]				<< gen_record
	S["home_system"]			<< home_system
	S["citizenship"]			<< citizenship
	S["faction"]				<< faction
	S["religion"]				<< religion
	S["nanotrasen_relation"]	<< nanotrasen_relation
	S["flavor_texts_general"]	<< flavor_texts["general"]
	S["flavor_texts_head"]		<< flavor_texts["head"]
	S["flavor_texts_face"]		<< flavor_texts["face"]
	S["flavor_texts_eyes"]		<< flavor_texts["eyes"]
	S["flavor_texts_torso"]		<< flavor_texts["torso"]
	S["flavor_texts_arms"]		<< flavor_texts["arms"]
	S["flavor_texts_hands"]		<< flavor_texts["hands"]
	S["flavor_texts_legs"]		<< flavor_texts["legs"]
	S["flavor_texts_feet"]		<< flavor_texts["feet"]

	S["flavour_texts_robot_Default"] << flavour_texts_robot["Default"]
	for(var/module in GLOB.robot_module_types)
		S["flavour_texts_robot_[module]"] << flavour_texts_robot[module]

	to_file(S["be_special"],             be_special_role)
	to_file(S["sometimes_be_special"],   sometimes_be_special_role)
	to_file(S["never_be_special"],       never_be_special_role)

	S["uplinklocation"] << uplinklocation
	S["exploit_record"] << exploit_record

	gear_list["[gear_slot]"] = gear
	to_file(S["gear_list"], gear_list)
	to_file(S["gear_slot"], gear_slot)

	S["alternate_option"]	<< alternate_option
	S["job_high"]	<< job_high
	S["job_medium"]	<< job_medium
	S["job_low"]	<< job_low
	S["player_alt_titles"]	<< player_alt_titles
	S["char_branch"] 			<< char_branch
	S["char_rank"] 				<< char_rank
	S["relations"]	<< relations
	S["relations_info"]	<< relations_info

/datum/preferences/proc/sanitize_char()
	var/datum/species/S = all_species[species ? species : SPECIES_HUMAN]
	if(!S) S = all_species[SPECIES_HUMAN]
	age                = sanitize_integer(age, S.min_age, S.max_age, initial(age))
	gender             = sanitize_inlist(gender, S.genders, pick(S.genders))
	real_name          = sanitize_name(real_name, species)
	if(!real_name)
		real_name      = random_name(gender, species)
	spawnpoint         = sanitize_inlist(spawnpoint, spawntypes, initial(spawnpoint))
	if(!species || !(species in playable_species))
		species = SPECIES_HUMAN
	r_hair			= sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair			= sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair			= sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial		= sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial		= sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial		= sanitize_integer(b_facial, 0, 255, initial(b_facial))
	s_tone			= sanitize_integer(s_tone, -185, 34, initial(s_tone))
	r_skin			= sanitize_integer(r_skin, 0, 255, initial(r_skin))
	g_skin			= sanitize_integer(g_skin, 0, 255, initial(g_skin))
	b_skin			= sanitize_integer(b_skin, 0, 255, initial(b_skin))
	h_style		= sanitize_inlist(h_style, hair_styles_list, initial(h_style))
	f_style		= sanitize_inlist(f_style, facial_hair_styles_list, initial(f_style))
	r_eyes			= sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes			= sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes			= sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	b_type			= sanitize_text(b_type, initial(b_type))
	has_cortical_stack = sanitize_bool(has_cortical_stack, initial(has_cortical_stack))

	disabilities	= sanitize_integer(disabilities, 0, 65535, initial(disabilities))
	if(!organ_data) organ_data = list()
	if(!rlimb_data) rlimb_data = list()

	if(organ_data[BP_CHEST] != "cyborg")
		organ_data[BP_HEAD] = null
		organ_data[BP_GROIN] = null
		organ_data[BP_BRAIN] = null

	if(!islist(alternate_languages))	alternate_languages = list()
	sanitize_alt_languages()

	if(!istype(all_underwear))
		all_underwear = list()

		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(gender ? gender : MALE))
					all_underwear[WRC.name] = WRI.name
					break

	if(!istype(all_underwear_metadata))
		all_underwear_metadata = list()

	for(var/underwear_category in all_underwear)
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[all_underwear[underwear_category]]
			if(!UWI)
				all_underwear -= underwear_category

	for(var/underwear_metadata in all_underwear_metadata)
		if(!(underwear_metadata in all_underwear))
			all_underwear_metadata -= underwear_metadata

	backbag = sanitize_integer(backbag, 1, backbaglist.len, initial(backbag))

	if(!home_system) home_system = "Unset"
	if(!citizenship) citizenship = "None"
	if(!faction)     faction =     "None"
	if(!religion)    religion =    "None"

	nanotrasen_relation = sanitize_inlist(nanotrasen_relation, COMPANY_ALIGNMENTS, initial(nanotrasen_relation))

	if(!istype(be_special_role))
		be_special_role = list()
	if(!istype(sometimes_be_special_role))
		sometimes_be_special_role = list()
	if(!istype(never_be_special_role))
		never_be_special_role = list()

	var/special_roles = valid_special_roles()
	for(var/role in be_special_role)
		if(!(role in special_roles))
			be_special_role -= role
	for(var/role in sometimes_be_special_role)
		if(!(role in special_roles))
			sometimes_be_special_role -= role
	for(var/role in never_be_special_role)
		if(!(role in special_roles))
			never_be_special_role -= role

	uplinklocation	= sanitize_inlist(uplinklocation, uplink_locations, initial(uplinklocation))

	if(!islist(gear))
		gear = list()
	if(!islist(gear_list))
		gear_list = list()

	for(var/gear_name in gear)
		if(!(gear_name in gear_datums))
			gear -= gear_name

	var/total_cost = 0
	for(var/gear_name in gear)
		if(!gear_datums[gear_name])
			gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				gear -= gear_name
			else
				total_cost += G.cost


	alternate_option	= sanitize_integer(alternate_option, 0, 2, initial(alternate_option))
	job_high	        = sanitize(job_high, null)
	if(job_medium && job_medium.len)
		for(var/i in 1 to job_medium.len)
			job_medium[i]  = sanitize(job_medium[i])
	if(job_low && job_low.len)
		for(var/i in 1 to job_low.len)
			job_low[i]  = sanitize(job_low[i])
	if(!player_alt_titles) player_alt_titles = new()

	if((GLOB.using_map.flags & MAP_HAS_BRANCH)\
	   && (!char_branch || !mil_branches.is_spawn_branch(char_branch)))
		char_branch = "None"

	if((GLOB.using_map.flags & MAP_HAS_RANK)\
	   && (!char_rank || !mil_branches.is_spawn_rank(char_branch, char_rank)))
		char_rank = "None"

	// We could have something like Captain set to high while on a non-rank map,
	// so we prune here to make sure we don't spawn as a PFC captain
	prune_job_prefs_for_rank()

	if(!job_master)
		return

	for(var/datum/job/job in job_master.occupations)
		var/alt_title = player_alt_titles[job.title]
		if(alt_title && !(alt_title in job.alt_titles))
			player_alt_titles -= job.title
	if(!relations)
		relations = list()
	if(!relations_info)
		relations_info = list()
	gear_slot = sanitize_integer(gear_slot, 1, 3, 1)

