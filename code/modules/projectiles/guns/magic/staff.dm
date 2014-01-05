obj/item/weapon/gun/magic/staff/
	slot_flags = SLOT_BACK
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	var/variable_charges = 1

/obj/item/weapon/gun/magic/staff/New()
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = Ceiling(max_charges / 3)
		else
			max_charges = Ceiling(max_charges / 2)
	..()

obj/item/weapon/gun/magic/staff/change
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	projectile_type = "/obj/item/projectile/magic/change"
	icon_state = "staffofchange"
	item_state = "staffofchange"
	max_charges = 8 //8, 4, 4, 3

obj/item/weapon/gun/magic/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = "/obj/item/projectile/magic/animate"
	icon_state = "staffofanimation"
	item_state = "staffofanimation"
	max_charges = 8 //8, 4, 4, 3

obj/item/weapon/gun/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead."
	projectile_type = "/obj/item/projectile/magic/resurrection"
	icon_state = "staffofhealing"
	item_state = "staffofhealing"
	max_charges = 8 //8, 4, 4, 3
