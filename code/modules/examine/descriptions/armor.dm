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

	if(flags & THICKMATERIAL)
		armor_stats += "The material is exceptionally thick. \n"

	if(max_heat_protection_temperature == FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against fire and heat. \n"

	if(min_cold_protection_temperature == SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against very cold temperatures. \n"

	var/list/covers_these = list()

	//This is superugly :(
	if(body_parts_covered & HEAD)
		covers_these.Add("head")
	if(body_parts_covered & FACE)
		covers_these.Add("face")
	if(body_parts_covered & EYES)
		covers_these.Add("eyes")
	if(body_parts_covered & UPPER_TORSO)
		covers_these.Add("upper body")
	if(body_parts_covered & LOWER_TORSO)
		covers_these.Add("lower body")
	if(body_parts_covered & LEGS)
		covers_these.Add("legs")
	if(body_parts_covered & FEET)
		covers_these.Add("feet")
	if(body_parts_covered & ARMS)
		covers_these.Add("arms")
	if(body_parts_covered & HANDS)
		covers_these.Add("hands")

	if(covers_these.len)
		armor_stats += "It covers the [english_list(covers_these)]. \n"

	var/list/goes_on = list()

	if(slot_flags & SLOT_BACK)
		goes_on.Add("back")
	if(slot_flags & SLOT_MASK)
		goes_on.Add("face")
	if(slot_flags & SLOT_BELT)
		goes_on.Add("waist")
	if(slot_flags & SLOT_ID)
		goes_on.Add("uniform's ID slot")
	if(slot_flags & SLOT_EARS)
		goes_on.Add("ears")
	if(slot_flags & SLOT_EYES)
		goes_on.Add("eyes")
	if(slot_flags & SLOT_GLOVES)
		goes_on.Add("hands")
	if(slot_flags & SLOT_HEAD)
		goes_on.Add("head")
	if(slot_flags & SLOT_FEET)
		goes_on.Add("feet")
	if(slot_flags & SLOT_OCLOTHING)
		goes_on.Add("exo slot")
	if(slot_flags & SLOT_ICLOTHING)
		goes_on.Add("body")
	if(slot_flags & SLOT_TIE)
		goes_on.Add("uniform")
	if(slot_flags & SLOT_HOLSTER)
		goes_on.Add("holster")

	if(goes_on.len)
		armor_stats += "It can be worn on your [english_list(goes_on)]. \n"

	return armor_stats