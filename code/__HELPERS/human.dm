//mob - who is being feed
//user - who is feeding
//food - whai is feeded
//eatverb - take/drink/eat method

proc/CanEat(user, mob, food, eatverb = "consume")
	if(ishuman(mob))
		var/mob/living/carbon/human/Feeded = mob
		if(Feeded.head)
			var/obj/item/Head = Feeded.head
			if(Head.flags & HEADCOVERSMOUTH)
				if (Feeded == user)
					user<<"You can't [eatverb] [food] through [Head]"
				else
					user<<"You can't feed [Feeded] with [food] through [Head]"
				return 0
		if(Feeded.wear_mask)
			var/obj/item/Mask = Feeded.wear_mask
			if(Mask.flags & MASKCOVERSMOUTH)
				if (Feeded == user)
					user<<"You can't [eatverb] [food] through [Mask]"
				else
					user<<"You can't feed [Feeded] with [food] through [Mask]"
				return 0
		return 1
