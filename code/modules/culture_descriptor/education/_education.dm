/decl/cultural_info/education
	desc_type =          "Education"
	category =            TAG_EDUCATION
	economic_power =      null
	language =            null

	var/education_tier =  EDUCATION_TIER_NONE
	var/education_prefix
	var/education_suffix
	var/list/qualifications

/decl/cultural_info/education/get_education_tier()
	return education_tier

/decl/cultural_info/education/format_formal_name(var/character_name)
	if(education_prefix)
		character_name = "[education_prefix][character_name]"
	if(education_suffix)
		character_name = "[character_name][education_suffix]"
	return character_name

/decl/cultural_info/education/get_qualifications()
	return qualifications
