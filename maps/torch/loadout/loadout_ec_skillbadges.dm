
/datum/gear/skill
	sort_category = "Skill Badges"
	category = /datum/gear/skill
	slot = slot_tie
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/skill/botany
	display_name = "Field Xenobotany Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/botany
	allowed_skills = list(
		SKILL_BOTANY = SKILL_ADEPT
	)

/datum/gear/skill/botany/stripe
	display_name = "Field Xenobotany Specialist voidsuit stripe"
	path = /obj/item/clothing/accessory/solgov/skillstripe/botany

/datum/gear/skill/netgun
	display_name = "Xenofauna Acquisition Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/netgun
	allowed_skills = list(
		SKILL_WEAPONS = SKILL_ADEPT
	)

/datum/gear/skill/netgun/stripe
	display_name = "Xenofauna Acquisition Specialist voidsuit stripe"
	path = /obj/item/clothing/accessory/solgov/skillstripe/netgun

/datum/gear/skill/eva
	display_name = "Void Mobility Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/eva
	allowed_skills = list(
		SKILL_EVA = SKILL_ADEPT
	)

/datum/gear/skill/eva/stripe
	display_name = "Void Mobility Specialist voidsuit stripe"
	path = /obj/item/clothing/accessory/solgov/skillstripe/eva

/datum/gear/skill/medical
	display_name = "Advanced First Aid Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/medical
	allowed_skills = list(
		SKILL_MEDICAL = SKILL_BASIC
	)

/datum/gear/skill/medical/stripe
	display_name = "Advanced First Aid Specialist voidsuit stripe"
	path = /obj/item/clothing/accessory/solgov/skillstripe/medical

/datum/gear/skill/mech
	display_name = "Exosuit Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/mech
	allowed_skills = list(
		SKILL_MECH = HAS_PERK
	)

/datum/gear/skill/electric
	display_name = "Electrical Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/electric
	allowed_skills = list(
		SKILL_ELECTRICAL = SKILL_ADEPT
	)

/datum/gear/skill/electric/stripe
	display_name = "Electrical Specialist voidsuit stripe"
	path = /obj/item/clothing/accessory/solgov/skillstripe/electric

/datum/gear/skill/science
	display_name = "Research Specialist badge"
	path = /obj/item/clothing/accessory/solgov/skillbadge/science
	allowed_skills = list(
		SKILL_SCIENCE = SKILL_ADEPT
	)
