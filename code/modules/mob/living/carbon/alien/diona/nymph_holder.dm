/obj/item/weapon/holder/diona
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING | SLOT_HOLSTER
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)

// Yes, you can wear a nymph on your head instead of a radiation mask.
/obj/item/weapon/holder/diona/equipped(var/mob/living/user, var/slot)
	if(slot == slot_l_hand || slot == slot_r_hand)
		body_parts_covered = ARMS
	else if(slot == slot_head)
		body_parts_covered = HEAD
	else if(slot == slot_wear_suit)
		body_parts_covered = UPPER_TORSO
	. = ..()