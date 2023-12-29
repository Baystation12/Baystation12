
/proc/donation_tier_to_css_class(tier)
	switch(tier)
		if(DONATION_TIER_ONE)   return "dt_1"
		if(DONATION_TIER_TWO)   return "dt_2"
		if(DONATION_TIER_THREE) return "dt_3"
		if(DONATION_TIER_FOUR)  return "dt_4"
		if(DONATION_TIER_ADMIN) return "dt_a"

/proc/donation_tier_decorated(tier)
	if(tier == DONATION_TIER_NONE)
		return null

	switch(tier)
		if(DONATION_TIER_ONE)   . = "Tier I"
		if(DONATION_TIER_TWO)   . = "Tier II"
		if(DONATION_TIER_THREE) . = "Tier III"
		if(DONATION_TIER_FOUR)  . = "Tier IV"
		if(DONATION_TIER_ADMIN) . = "Admin"

	return SPAN_CLASS(donation_tier_to_css_class(tier), .)

/client
	var/datum/donator_info/donator_info = new

/client/New()
	. = ..()
	var/singleton/modpack/don_loadout/donations = GET_SINGLETON(/singleton/modpack/don_loadout)
	donations.update_donator(src)

/client/verb/donations_info()
	set name = "Donations Info"
	set desc = "View information about donations."
	set hidden = 1

	var/singleton/modpack/don_loadout/donations = GET_SINGLETON(/singleton/modpack/don_loadout)
	donations.show_donations_info(mob)

/datum/donator_info
	var/donator = FALSE
	var/donation_type = DONATION_TIER_NONE

/datum/donator_info/proc/on_donation_tier_loaded(client/C)
	return

/datum/donator_info/proc/get_decorated_message(client/C, message)
	if(!SScharacter_setup.initialized || isnull(donation_type))
		return message
	if (C.get_preference_value(/datum/client_preference/ooc_donation_color) != GLOB.PREF_SHOW)
		return message
	return "<span class='[donation_tier_to_css_class(donation_type)]'>[message]</span>"

/datum/donator_info/proc/get_full_donation_tier()
	return donation_tier_decorated(donation_type)

/datum/donator_info/proc/donation_tier_available(required)
	ASSERT(required in DONATION_TIER_ALL_TIERS)

	if(!(donation_type in DONATION_TIER_ALL_TIERS))
		return FALSE

	for(var/type in DONATION_TIER_ALL_TIERS)
		if(type == required)
			return TRUE
		if(type == donation_type)
			return FALSE

	CRASH("This code should not be accessible")
