/mob/living/carbon/human/verb/give(var/mob/living/target in view(1)-usr)
	set category = "IC"
	set name = "Give"

	if(incapacitated())
		return
	if(!istype(target) || target.incapacitated() || target.client == null)
		return

	var/obj/item/I = src.get_active_hand()
	if(!I)
		I = src.get_inactive_hand()
	if(!I)
		src << "<span class='warning'>You don't have anything in your hands to give to \the [target].</span>"
		return

	if(alert(target,"[src] wants to give you \a [I]. Will you accept it?",,"No","Yes") == "No")
		target.visible_message("<span class='notice'>\The [src] tried to hand \the [I] to \the [target], \
		but \the [target] didn't want it.</span>")
		return

	if(!I) return

	if(!Adjacent(target))
		src << "<span class='warning'>You need to stay in reaching distance while giving an object.</span>"
		target << "<span class='warning'>\The [src] moved too far away.</span>"
		return

	if(I.loc != src || !src.item_is_in_hands(I))
		src << "<span class='warning'>You need to keep the item in your hands.</span>"
		target << "<span class='warning'>\The [src] seems to have given up on passing \the [I] to you.</span>"
		return

	if(target.hands_are_full())
		target << "<span class='warning'>Your hands are full.</span>"
		src << "<span class='warning'>Their hands are full.</span>"
		return

	if(src.unEquip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message("<span class='notice'>\The [src] handed \the [I] to \the [target].</span>")
