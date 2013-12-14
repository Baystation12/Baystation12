/mob/living/carbon/hitby(atom/movable/AM)
//	if(!skip)  //ugly, but easy
//		message_admins("Skip Check Passed")
	if(in_throw_mode && !get_active_hand())  //empty active hand and we're in throw mode
//		message_admins("In Throw Mode and active hand check passed")
		if(canmove && !restrained())
//			message_admins("Restrained/moving check passed")
			if(istype(AM, /obj/item))
//				message_admins("Item check passed")
				var/obj/item/I = AM
				if(isturf(I.loc))
//					message_admins("Turf check passed")
					put_in_active_hand(I)
					visible_message("<span class='warning'>[src] catches [I]!</span>")
					throw_mode_off()
					return
	..()