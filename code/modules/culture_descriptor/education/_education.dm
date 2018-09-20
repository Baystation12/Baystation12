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

/decl/cultural_info/education/get_formal_name_suffix()
	return education_suffix

/decl/cultural_info/education/get_formal_name_prefix()
	return education_prefix

/decl/cultural_info/education/get_qualifications()
	return qualifications
