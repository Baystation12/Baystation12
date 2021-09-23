/datum/species/human/gravworlder
	name = SPECIES_GRAVWORLDER
	name_plural = "Grav-Adapted Humans"
	description = "Heavier and stronger than a baseline human, gravity-adapted people have \
	thick radiation-resistant skin with a high lead content, denser bones, and recessed \
	eyes beneath a prominent brow in order to shield them from the glare of a dangerously \
	bright, alien sun. This comes at the cost of mobility, flexibility, and increased \
	oxygen requirements to support their robust metabolism."
	icobase =     'icons/mob/human_races/species/human/subspecies/gravworlder_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/gravworlder_preview.dmi'
	health_hud_intensity = 3

	flash_mod =     0.9
	oxy_mod =       1.1
	breath_pressure = 18
	radiation_mod = 0.5
	brute_mod =     0.85
	slowdown =      1
	strength = STR_HIGH

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/build = 1
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_GRAV | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

/datum/species/human/gravworlder/can_float(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return H.skill_check(SKILL_HAULING, SKILL_EXPERT) //Hard for them to swim
	
/datum/species/human/spacer
	name = SPECIES_SPACER
	name_plural = "Space-Adapted Humans"
	description = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."
	icobase =     'icons/mob/human_races/species/human/subspecies/spacer_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/spacer_preview.dmi'

	oxy_mod =   0.8
	breath_pressure = 14
	toxins_mod =   0.9
	flash_mod = 1.2
	brute_mod = 1.1
	burn_mod =  1.1
	darksight_range = 6
	darksight_tint = DARKTINT_MODERATE

	descriptors = list(
		/datum/mob_descriptor/height,
		/datum/mob_descriptor/build = -1
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_SPCR | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	species_flags = SPECIES_FLAG_LOW_GRAV_ADAPTED

	hazard_high_pressure = HAZARD_HIGH_PRESSURE * 0.8            // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE * 0.8          // High pressure warning.
	warning_low_pressure = WARNING_LOW_PRESSURE * 0.8            // Low pressure warning.
	hazard_low_pressure = HAZARD_LOW_PRESSURE * 0.8              // Dangerously low pressure.

/datum/species/human/vatgrown
	name = SPECIES_VATGROWN
	name_plural = "Vat-Grown Humans"
	description = "With cloning on the forefront of human scientific advancement, mass production \
	of bodies is a very real and rather ethically grey industry. Although slavery, indentured servitude \
	and flash-cloning are all illegal in SCG space, there still exists a margin for those legitimate \
	corporations able to take up contracts for growing and raising vat-grown humans to populate new \
	colonies or installations. Many vat-grown humans come from one of these projects, making up the \
	majority of those referred to as the nonborn - those with singular names and an identifier, such as \
	ID-John, BQ1-Bob or Thomas-582 - while others, bearing more human-sounding names, are created for \
	and raised as members of regular human families. Still others are the lab-created designer progeny \
	of the SCG's rich elite.<br/><br/>Vat-grown humans tend to be paler than baseline, though those \
	with darker skin better display the dull, greenish hue resulting from their artificial growth. \
	Vat-grown humans have no appendix and fewer inherited genetic disabilities but have a weakened \
	metabolism."
	icobase =     'icons/mob/human_races/species/human/subspecies/vatgrown_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/vatgrown_preview.dmi'

	toxins_mod =   1.1
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes
		)

	additional_available_cultural_info = list(
		TAG_CULTURE = list(CULTURE_HUMAN_VATGROWN)
	)
	default_cultural_info = list(
		TAG_CULTURE = CULTURE_HUMAN_VATGROWN
	)

/datum/species/human/tritonian
	name = SPECIES_TRITONIAN
	name_plural = "Tritonians"
	description = "Of all human gene-adapts, the Tritonian genotype is probably the most wildly divergent from \
	baseline humanity. Conceived alongside dolphin and octopus genetic engineering projects, this genotype \
	is adapted for amphibious life on flooded ocean moons like Triton, but is equally comfortable in a range \
	of aquatic and non-aquatic environments. Their heavy, seal-like bodies have sharp teeth, recessed eyes, \
	and thick blue-grey skin with a layer of dense blubber for insulation and protection, but they find \
	it difficult to move quickly on land due to their bulk."
	icobase =     'icons/mob/human_races/species/human/subspecies/tritonian_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/tritonian_preview.dmi'
	slowdown = 1

	oxy_mod =             0.5
	brute_mod =           0.8
	toxins_mod =          1.15
	radiation_mod =       1.15
	body_temperature =    302
	water_soothe_amount = 5

	heat_level_1 = 350
	heat_level_2 = 380
	heat_level_3 = 900

	cold_level_1 = 220
	cold_level_2 = 160
	cold_level_3 = 100

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite/sharp
	)

	descriptors = list(
		/datum/mob_descriptor/height,
		/datum/mob_descriptor/build = 1
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_TRITON | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

/datum/species/human/tritonian/can_float(mob/living/carbon/human/H)
	if(!H.is_physically_disabled())
		if(H.encumbrance() < 2)
			return TRUE
	return FALSE

/datum/species/human/mule
	name = SPECIES_MULE
	name_plural = "Mules"
	description = "There are a huge number of 'uncurated' genetic lines in human space, many of which fall under the \
	general header of baseline humanity. One recently discovered genotype is remarkable for both being deeply feral, \
	in the sense that it still has many of the inherited diseases and weaknesses that plagued pre-expansion humanity, \
	and for a strange affinity for psionic operancy. The Mules, as they are called, are born on the very edges of \
	civilization, and are physically diminutive and unimposing, with scrawny, often deformed bodies. Their physiology \
	rejects prosthetics and synthetic organs, and their lifespans are short, but their raw psionic potential is unmatched."

	spawn_flags =   SPECIES_CAN_JOIN | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN | SPECIES_NO_ROBOTIC_INTERNAL_ORGANS
	brute_mod =     1.25
	burn_mod =      1.25
	oxy_mod =       1.25
	toxins_mod =    1.25
	radiation_mod = 1.25
	flash_mod =     1.25
	blood_volume =  SPECIES_BLOOD_DEFAULT * 0.85
	min_age =       18
	max_age =       45

/datum/species/human/mule/handle_post_spawn(var/mob/living/carbon/human/H)
	if(!H.psi)
		H.psi = new(H)
		var/list/faculties = list("[PSI_COERCION]", "[PSI_REDACTION]", "[PSI_ENERGISTICS]", "[PSI_PSYCHOKINESIS]")
		for(var/i = 1 to rand(2,3))
			H.set_psi_rank(pick_n_take(faculties), 1)
	H.psi.max_stamina = 70
	var/obj/item/organ/external/E = pick(H.organs)
	if(!BP_IS_ROBOTIC(E))
		E.mutate()
		E.limb_flags |= ORGAN_FLAG_DEFORMED
		E.status |= ORGAN_DISFIGURED
		E.status |= ORGAN_MUTATED
