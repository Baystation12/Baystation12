
//Organ Defines + misc//

/obj/item/organ/internal/heart_secondary
	name = "Secondary Heart"
	parent_organ = "chest"
	organ_tag = "second heart"
	icon_state = "heart-on"
	min_broken_damage = 30
	var/useheart = 0

/obj/item/organ/internal/heart_secondary/process()
	if(is_broken())
		return
	var/obj/item/organ/internal/heart = owner.internal_organs_by_name["heart"]
	if(heart && heart.is_broken())
		if(useheart == 0)
			useheart = world.time + 50
		if((useheart != 0) && world.time >= useheart) //They still feel the effect.
			damage = heart.damage
			heart.damage = 0
			useheart = 0
		return
	for(var/obj/item/organ/external/e in owner.bad_external_organs)
		if(!e.clamped() && prob(SANGHEILI_BLEEDBLOCK_CHANCE))
			e.clamp_organ() //Clamping, not bandaging ensures that no passive healing is gained from the wounds being bandaged
