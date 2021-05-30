
// Clothing armour values.
/obj/item/clothing
	var/global/list/armour_to_descriptive_term = list(
		"melee" = "blunt force",
		"bullet" = "ballistics",
		"laser" = "lasers",
		"energy" = "energy",
		"bomb" = "explosions",
		"bio" = "biohazards",
		"rad" = "radiation"
		)

/obj/item/clothing/get_lore_info()
	return desc

/obj/item/clothing/get_mechanics_info()
	var/list/armor_strings = list()
	for(var/armor_type in armour_to_descriptive_term)
		if(LAZYACCESS(armor, armor_type))
			switch(armor[armor_type])
				if(1 to 20)
					armor_strings += "It barely protects against [armour_to_descriptive_term[armor_type]]."
				if(21 to 30)
					armor_strings += "It provides a very small defense against [armour_to_descriptive_term[armor_type]]."
				if(31 to 40)
					armor_strings += "It offers a small amount of protection against [armour_to_descriptive_term[armor_type]]."
				if(41 to 50)
					armor_strings += "It offers a moderate defense against [armour_to_descriptive_term[armor_type]]."
				if(51 to 60)
					armor_strings += "It provides a strong defense against [armour_to_descriptive_term[armor_type]]."
				if(61 to 70)
					armor_strings += "It is very strong against [armour_to_descriptive_term[armor_type]]."
				if(71 to 80)
					armor_strings += "This gives a very robust defense against [armour_to_descriptive_term[armor_type]]."
				if(81 to 100)
					armor_strings += "Wearing this would make you nigh-invulerable against [armour_to_descriptive_term[armor_type]]."

	if(item_flags & ITEM_FLAG_AIRTIGHT)
		armor_strings += "It is airtight."

	if(min_pressure_protection == 0)
		armor_strings += "Wearing this will protect you from the vacuum of space."
	else if(min_pressure_protection != null)
		armor_strings += "Wearing this will protect you from low pressures, but not the vacuum of space."

	if(max_pressure_protection != null)
		armor_strings += "This suit is rated for pressures up to [max_pressure_protection] kPa."

	if(item_flags & ITEM_FLAG_THICKMATERIAL)
		armor_strings += "The material is exceptionally thick."

	if(max_heat_protection_temperature >= FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		armor_strings += "You could probably safely skydive into the Sun wearing this."
	else if(max_heat_protection_temperature >= SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		armor_strings += "It provides good protection against fire and heat."

	if(!isnull(min_cold_protection_temperature) && min_cold_protection_temperature <= SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE)
		armor_strings += "It provides very good protection against very cold temperatures."

	var/list/covers = list()
	var/list/slots = list()
	for(var/name in string_part_flags)
		if(body_parts_covered & string_part_flags[name])
			covers += name
	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name

	if(covers.len)
		armor_strings += "It covers the [english_list(covers)]."

	if(slots.len)
		armor_strings += "It can be worn on your [english_list(slots)]."

	return jointext(armor_strings, "<br>")

/obj/item/clothing/suit/armor/pcarrier/get_mechanics_info()
	. = ..()
	. += "<br>Its protection is provided by the plate inside, examine it for details on armor.<br>"
