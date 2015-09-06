/obj/item/clothing/proc/describe_armor(var/armor_type, var/descriptive_attack_type)
	if(armor[armor_type])
		switch(armor[armor_type])
			if(1 to 20)
				return "It barely protects against [descriptive_attack_type]."
			if(21 to 30)
				return "It provides a very small defense against [descriptive_attack_type]."
			if(31 to 40)
				return "It offers a small amount of protection against [descriptive_attack_type]."
			if(41 to 50)
				return "It offers a moderate defense against [descriptive_attack_type]."
			if(51 to 60)
				return "It provides a strong defense against [descriptive_attack_type]."
			if(61 to 70)
				return "It is very strong against [descriptive_attack_type]."
			if(71 to 80)
				return "This gives a very robust defense against [descriptive_attack_type]."
			if(81 to 99)
				return "Wearing this would make you nigh-invulerable against [descriptive_attack_type]."
			if(100)
				return "You would be immune to [descriptive_attack_type] if you wore this."



/obj/item/clothing/get_description_info()
	var/armor_stats = description_info + "\
	<br>"

	if(armor["melee"])
		armor_stats += "[describe_armor("melee","blunt force")] \n"
	if(armor["bullet"])
		armor_stats += "[describe_armor("bullet","ballistics")] \n"
	if(armor["laser"])
		armor_stats += "[describe_armor("laser","lasers")] \n"
	if(armor["energy"])
		armor_stats += "[describe_armor("energy","energy")] \n"
	if(armor["bomb"])
		armor_stats += "[describe_armor("bomb","explosions")] \n"
	if(armor["bio"])
		armor_stats += "[describe_armor("bio","biohazards")] \n"
	if(armor["rad"])
		armor_stats += "[describe_armor("rad","radiation")] \n"

	armor_stats += "\n"

	if(flags & AIRTIGHT)
		armor_stats += "It is airtight. \n"

	if(flags & STOPPRESSUREDAMAGE)
		armor_stats += "Wearing this will protect you from the vacuum of space. \n"

	if(max_heat_protection_temperature == FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against fire and heat. \n"

	if(min_cold_protection_temperature == SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against very cold temperatures. \n"

	return armor_stats