
//Cryo(Stasis)Bags

/obj/item/bodybag/cryobag/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	icon_state = "bodybag_folded"

/obj/item/bodybag/cryobag/covenant/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/covenant/R = new /obj/structure/closet/body_bag/cryobag/covenant(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/body_bag/cryobag/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
	item_path = /obj/item/bodybag/cryobag/covenant

/obj/structure/closet/body_bag/cryobag/covenant/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.in_stasis = 1
		src.used = 1
	..()

/obj/item/usedcryobag/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'
