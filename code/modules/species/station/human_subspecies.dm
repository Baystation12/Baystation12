/datum/species/human/gravworlder
	name = "Grav-Adapted Human"
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
	radiation_mod = 0.5
	brute_mod =     0.85
	slowdown =      1

	descriptors = list(
		/datum/mob_descriptor/height,
		/datum/mob_descriptor/build = 1
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_GRAV | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

/datum/species/human/spacer
	name = "Space-Adapted Human"
	name_plural = "Space-Adapted Humans"
	description = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."
	icobase =     'icons/mob/human_races/species/human/subspecies/spacer_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/spacer_preview.dmi'

	oxy_mod =   0.8
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

/datum/species/human/vatgrown
	name = "Vat-Grown Human"
	name_plural = "Vat-Grown Humans"
	description = "With cloning on the forefront of human scientific advancement, cheap mass production \
	of bodies is a very real and rather ethically grey industry. Vat-grown humans tend to be paler than \
	baseline, with no appendix and fewer inherited genetic disabilities, but a weakened metabolism."
	icobase =     'icons/mob/human_races/species/human/subspecies/vatgrown_body.dmi'
	preview_icon= 'icons/mob/human_races/species/human/subspecies/vatgrown_preview.dmi'

	toxins_mod =   1.1
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
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
	name = "Tritonian"
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
