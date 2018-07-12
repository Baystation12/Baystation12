/datum/species/human/orion
	name = "Orion"
	name_plural = "Orion Subjects"
	spawn_flags = SPECIES_IS_RESTRICTED
	pain_mod = 0.9 //Slight reduction in pain recieved
	total_health = 220 //Slightly more health then a normal human
	metabolism_mod = 1.15 //Slightly faster metabolism
	darksight = 3 //Slightly better night vision!
	slowdown = -1.5 //Increased move speed

	//Spartan 1's have a bit better temperature tolerance
	siemens_coefficient = 0.9 //Better insulated against temp changes
	heat_discomfort_level = 355 //Normal human is 315
	cold_discomfort_level = 255 // Normal human is 285
	//Buff to temperature damage levels (5% per level)
	heat_level_1 = 380 //~107C
	heat_level_2 = 420 //147C
	heat_level_3 = 1050 //777C
	cold_level_1 = 247 //-26C
	cold_level_2 = 190 //-83C
	cold_level_3 = 114 //-159C
	blood_volume = 600 // Normal Human has 560
	//Custom Defines for the race as follows
	unarmed_types = list(/datum/unarmed_attack/orionpunch, /datum/unarmed_attack/orionkick)

//Orion Attack Datums
/datum/unarmed_attack/orionpunch
	attack_verb = list("attacked, punched, assaulted, struck, slammed")	// Empty hand hurt intent verb.
	attack_noun = list("fist")
	damage = 8						// Extra empty hand attack damage.
	delay = 1
	sparring_variant_type = /datum/unarmed_attack/light_strike
	eye_attack_text = "gouges"
	eye_attack_text_victim = "digits"

/datum/unarmed_attack/orionkick
	attack_verb = list("spun and kicked, roundhouse kicked")	// Empty hand hurt intent verb.
	attack_noun = list("heel, foot")
	attack_sound = "swing_hit"
	delay = 2
	sparring_variant_type = /datum/unarmed_attack/light_strike
	eye_attack_text = "slammed"
	eye_attack_text_victim = "slammed"

//Should check to make sure that the user has both their legs. Or it will cancel the attack.
/datum/unarmed_attack/orionkick/is_usable(var/mob/living/carbon/human/user)
	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
	if(E && !E.is_stump())
		return 1

	E = user.organs_by_name[BP_R_FOOT]
	if(E && !E.is_stump())
		return 1

	return 0

/datum/unarmed_attack/orionkick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/kick_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	kick_damage = Clamp(kick_damage, 6, 12)
	damage = kick_damage 						// Extra empty hand attack damage.
	switch(kick_damage)

		if(6 to 7)	user.visible_message("<span class='danger'>[user] glanced [target] with their [pick(attack_noun)] in the [organ]!</span>")

		if(8 to 10)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")

		if(11 to 12)		user.visible_message("<span class='danger'>[user] landed a heavy blow with their [pick(attack_noun)] against [target]'s [organ]!</span>")
