/mob/living/carbon/human/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"

	// TODO :  Change to incapacitated() on merge.
	if(usr.stat || usr.lying || usr.resting || usr.buckled)
		return
	if(!istype(target) || target.stat || target.lying || target.resting || target.buckled || target.client == null)
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		I = usr.get_inactive_hand()
	if(!I)
		usr << "<span class='warning'>You don't have anything in your hands to give to \the [target].</span>"
		return

	if(alert(target,"[usr] wants to give you \a [I]. Will you accept it?",,"No","Yes") == "No")
		target.visible_message("<span class='notice'>\The [usr] tried to hand \the [I] to \the [target], \
		but \the [target] didn't want it.</span>")
		return

	if(!I) return

	if(!Adjacent(target))
		usr << "<span class='warning'>You need to stay in reaching distance while giving an object.</span>"
		target << "<span class='warning'>\The [usr] moved too far away.</span>"
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		usr << "<span class='warning'>You need to keep the item in your hands.</span>"
		target << "<span class='warning'>\The [usr] seems to have given up on passing \the [I] to you.</span>"
		return

	if(target.r_hand != null && target.l_hand != null)
		target << "<span class='warning'>Your hands are full.</span>"
		usr << "<span class='warning'>Their hands are full.</span>"
		return

	if(usr.unEquip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message("<span class='notice'>\The [usr] handed \the [I] to \the [target].</span>")
