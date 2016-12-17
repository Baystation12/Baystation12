/datum/technomancer/equipment/gloves_of_regen
	name = "Gloves of Regeneration"
	desc = "It's a pair of black gloves, with a hypodermic needle on the insides, and a small storage of a secret blend of chemicals \
	designed to be slowly fed into a living person's system, increasing their metabolism greatly, resulting in accelerated healing.  \
	A side effect of this healing is that the wearer will generally get hungry a lot faster.  Sliding the gloves on and off also \
	hurts a lot.  As a bonus, the gloves are more resistant to the elements than most.  It should be noted that synthetics will have \
	little use for these."
	cost = 50
	obj_path = /obj/item/clothing/gloves/regen

/obj/item/clothing/gloves/regen
	name = "gloves of regeneration"
	desc = "A pair of gloves with a small storage of green liquid on the outside.  On the inside, a a hypodermic needle can be seen \
	on each glove."
	icon_state = "regen"
	item_state = "graygloves"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	var/mob/living/carbon/human/wearer = null

/obj/item/clothing/gloves/regen/equipped(var/mob/living/carbon/human/H)
	if(H && H.gloves == src)
		wearer = H
		if(wearer.can_feel_pain())
			to_chat(H,"<span class='danger'>You feel a stabbing sensation in your hands as you slide \the [src] on!</span>")
			wearer.custom_pain("You feel a sharp pain in your hands!",1)
	..()

/obj/item/clothing/gloves/regen/dropped(var/mob/living/carbon/human/H)
	..()
	if(wearer)
		if(wearer.can_feel_pain())
			to_chat(wearer,"<span class='danger'>You feel the hypodermic needles as you slide \the [src] off!</span>")
			wearer.custom_pain("Your hands hurt like hell!",1)
		wearer = null

/obj/item/clothing/gloves/regen/New()
	processing_objects |= src
	..()

/obj/item/clothing/gloves/regen/Destroy()
	wearer = null
	processing_objects -= src
	return ..()

/obj/item/clothing/gloves/regen/process()
	if(!wearer || wearer.isSynthetic() || wearer.stat == DEAD || wearer.nutrition >= 10)
		return // Robots and dead people don't have a metabolism.

	if(wearer.getBruteLoss())
		wearer.adjustBruteLoss(-0.1)
		wearer.nutrition = max(wearer.nutrition - 10, 0)
	if(wearer.getFireLoss())
		wearer.adjustFireLoss(-0.1)
		wearer.nutrition = max(wearer.nutrition - 10, 0)
	if(wearer.getToxLoss())
		wearer.adjustToxLoss(-0.1)
		wearer.nutrition = max(wearer.nutrition - 10, 0)
	if(wearer.getOxyLoss())
		wearer.adjustOxyLoss(-0.1)
		wearer.nutrition = max(wearer.nutrition - 10, 0)
	if(wearer.getCloneLoss())
		wearer.adjustCloneLoss(-0.1)
		wearer.nutrition = max(wearer.nutrition - 20, 0)