/datum/species/human/gravworlder
	name = "grav-adapted Human"
	name_plural = "grav-adapted Humans"
	blurb = "Heavier and stronger than a baseline human, gravity-adapted people have \
	thick radiation-resistant skin with a high lead content, denser bones, and recessed \
	eyes beneath a prominent brow in order to shield them from the glare of a dangerously \
	bright, alien sun. This comes at the cost of mobility, flexibility, and increased \
	oxygen requirements to support their robust metabolism."
	icobase = 'icons/mob/human_races/subspecies/r_gravworlder.dmi'

	flash_mod =     0.9
	oxy_mod =       1.1
	radiation_mod = 0.5
	brute_mod =     0.85
	slowdown =      1

/datum/species/human/spacer
	name = "space-adapted Human"
	name_plural = "space-adapted Humans"
	blurb = "Lithe and frail, these sickly folk were engineered for work in environments that \
	lack both light and atmosphere. As such, they're quite resistant to asphyxiation as well as \
	toxins, but they suffer from weakened bone structure and a marked vulnerability to bright lights."
	icobase = 'icons/mob/human_races/subspecies/r_spacer.dmi'

	oxy_mod =   0.8
	toxins_mod =   0.9
	flash_mod = 1.2
	brute_mod = 1.1
	burn_mod =  1.1

/datum/species/human/vatgrown
	name = "vat-grown Human"
	name_plural = "vat-grown Humans"
	blurb = "With cloning on the forefront of human scientific advancement, cheap mass production \
	of bodies is a very real and rather ethically grey industry. Vat-grown humans tend to be paler than \
	baseline, with no appendix and fewer inherited genetic disabilities, but a weakened metabolism."
	icobase = 'icons/mob/human_races/subspecies/r_vatgrown.dmi'

	toxins_mod =   1.1
	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes
		)

/*
// These guys are going to need full resprites of all the suits/etc so I'm going to
// define them and commit the sprites, but leave the clothing for another day.
/datum/species/human/chimpanzee
	name = "uplifted Chimpanzee"
	name_plural = "uplifted Chimpanzees"
	blurb = "Ook ook."
	icobase = 'icons/mob/human_races/subspecies/r_upliftedchimp.dmi'
*/
