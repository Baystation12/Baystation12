var/global/datum/gear_tweak/color/gear_tweak_free_color_choice_
/proc/gear_tweak_free_color_choice()
	if(!gear_tweak_free_color_choice_) gear_tweak_free_color_choice_ = new()
	return gear_tweak_free_color_choice_

//var/datum/gear_tweak/color/gear_tweak_free_color_choice_
//#define gear_tweak_free_color_choice (gear_tweak_free_color_choice_ ? gear_tweak_free_color_choice_ : (gear_tweak_free_color_choice_ = new()))
// Might work in 511 assuming x=y=5 gets implemented.

var/global/datum/gear_tweak/custom_name/gear_tweak_free_name_

/proc/gear_tweak_free_name()
	if(!gear_tweak_free_name_) gear_tweak_free_name_ = new()
	return gear_tweak_free_name_

var/global/datum/gear_tweak/custom_desc/gear_tweak_free_desc_

/proc/gear_tweak_free_desc()
	if(!gear_tweak_free_desc_) gear_tweak_free_desc_ = new()
	return gear_tweak_free_desc_
