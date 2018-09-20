/decl/cultural_info/education/none
	name = EDUCATION_NONE
	description = "You never attended any kind of formal schooling, and are likely illiterate."
	education_tier = EDUCATION_TIER_NONE

/decl/cultural_info/education/dropout
	name = EDUCATION_DROPOUT
	description = "You did not complete highschool. You are unlikely to have more than a basic understanding of academics."
	education_tier = EDUCATION_TIER_DROPOUT

/decl/cultural_info/education/basic
	name = EDUCATION_HIGH_SCHOOL
	description = "You completed high school and likely have good literacy and numeracy, as well as a good grasp of a number of wider subjects like society, computing or higher mathematics."
	education_tier = EDUCATION_TIER_BASIC
	qualifications = list("High school diploma.")

/decl/cultural_info/education/trade
	name = EDUCATION_TRADE_SCHOOL
	description = "You attended vocational training in a technical or trade school. You likely have highly specialized practical and theoretical knowledge of a hands-on field like engineering, cooking or network administration."
	education_tier = EDUCATION_TIER_TRADE
	qualifications = list("Trade school certificate.")

/decl/cultural_info/education/undergrad
	name = EDUCATION_UNDERGRAD
	description = "You have attained a bachelor's degree in a field of your choice. You likely have excellent theoretical knowledge of an academic field like computer science, physics or psychology."
	education_tier = EDUCATION_TIER_BACHELOR
	qualifications = list("Bachelor's degree.")

/decl/cultural_info/education/masters
	name = EDUCATION_MASTERS
	description = "You have attained a master's degree in a field of your choice. This is a step up from a bachelor's degree, requiring a thorough understanding of your field and a solid work ethic, and represents a longer period spent studying."
	education_tier = EDUCATION_TIER_MASTERS
	qualifications = list("Master's degree.")

/decl/cultural_info/education/doctorate
	name = EDUCATION_DOCTORATE
	description = "You have attained a doctorate in a field of your choice other than medicine. You are identified as 'Doctor' and are considered to be an extremely highly educated individual in your area of expertise."
	education_tier = EDUCATION_TIER_DOCTORATE
	education_prefix = "Dr. "
	education_suffix = ", PhD"
	qualifications = list("Doctorate.")

/decl/cultural_info/education/medschool
	name = EDUCATION_MEDSCHOOL
	description = "You have attended medical school and received both the associated doctorate and a medical license, allowing you to work as an accredited medical professional."
	education_tier = EDUCATION_TIER_MEDSCHOOL
	education_prefix = "Dr. "
	education_suffix = ", MD"
	qualifications = list("Medical degree.")
