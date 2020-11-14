/obj/aura/regenerating/human/hunger
	nutrition_damage_mult = 1
	grow_chance = -1
	grow_threshold = -1

/obj/aura/regenerating/human/hunger/life_tick()
	var/mob/living/carbon/human/H = user
	if(innate_heal && istype(H) && H.stat != DEAD && H.nutrition < 50)
		H.apply_damage(5, PAIN)
	if(innate_heal && istype(H) && H.stat != DEAD && H.nutrition < 1)
		H.adjustBrainLoss(rand(8, 12))
		return 1
	return ..()