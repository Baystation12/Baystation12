/mob/living/carbon/human/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"

	if(incapacitated())
		return
	if(!istype(target) || target.incapacitated() || target.client == null)
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		I = usr.get_inactive_hand()
	if(!I)
		to_chat(usr, SPAN_WARNING("You don't have anything in your hands to give to \the [target]."))
		return

	if(istype(I, /obj/item/grab))
		to_chat(usr, SPAN_WARNING("You can't give someone a grab."))
		return

	usr.visible_message(SPAN_NOTICE("\The [usr] holds out \the [I] to \the [target]."), SPAN_NOTICE("You hold out \the [I] to \the [target], waiting for them to accept it."))

	if(alert(target,"[usr] wants to give you \a [I]. Will you accept it?",,"Yes","No") == "No")
		target.visible_message(SPAN_NOTICE("\The [usr] tried to hand \the [I] to \the [target], but \the [target] didn't want it."))
		return

	if(!I) return

	if(!Adjacent(target))
		to_chat(usr, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
		to_chat(target, SPAN_WARNING("\The [usr] moved too far away."))
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		to_chat(usr, SPAN_WARNING("You need to keep the item in your hands."))
		to_chat(target, SPAN_WARNING("\The [usr] seems to have given up on passing \the [I] to you."))
		return

	if(target.r_hand != null && target.l_hand != null)
		to_chat(target, SPAN_WARNING("Your hands are full."))
		to_chat(usr, SPAN_WARNING("Their hands are full."))
		return

	if(usr.unEquip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		usr.visible_message(SPAN_NOTICE("\The [usr] handed \the [I] to \the [target]."), SPAN_NOTICE("You give \the [I] to \the [target]."))
