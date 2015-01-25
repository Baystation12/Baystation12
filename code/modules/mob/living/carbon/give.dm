mob/living/carbon/verb/give(var/mob/living/carbon/target in view(1)-usr)
	set category = "IC"
	set name = "Give"
	if(target.stat == 2 || usr.stat == 2|| target.client == null)
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		usr << "\red You don't have anything in your right hand to give to [target.name]"
		return
	if(usr.hand && usr.l_hand == null)
		usr << "\red You don't have anything in your left hand to give to [target.name]"
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!I)
		return
	if(target.r_hand == null || target.l_hand == null)
		switch(alert(target,"[usr] wants to give you \a [I]?",,"Yes","No"))
			if("Yes")
				if(!I)
					return
				if(!Adjacent(usr))
					usr << "\red You need to stay in reaching distance while giving an object."
					target << "\red [usr.name] moved too far away."
					return
				if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
					usr << "\red You need to keep the item in your active hand."
					target << "\red [usr.name] seem to have given up on giving \the [I.name] to you."
					return
				if(src.r_hand != null && src.l_hand != null)
					target << "\red Your hands are full."
					usr << "\red Their hands are full."
					return
				else
					usr.drop_item()
					if(target.r_hand == null)
						target.r_hand = I
					else
						target.l_hand = I
				I.loc = target
				I.layer = 20
				I.add_fingerprint(target)
				target.update_inv_l_hand()
				target.update_inv_r_hand()
				usr.update_inv_l_hand()
				usr.update_inv_r_hand()
				target.visible_message("\blue [usr.name] handed \the [I.name] to [target.name].")
			if("No")
				target.visible_message("\red [usr.name] tried to hand [I.name] to [target.name] but [target.name] didn't want it.")
	else
		usr << "\red [target.name]'s hands are full."
