/obj/item/paper/talisman/emp/attack_self(mob/living/user)
	if(iscultist(user))
		to_chat(user, "This is an emp talisman.")
	..()


/obj/item/paper/talisman/emp/afterattack(atom/target, mob/user, proximity)
	if(!iscultist(user))
		return
	if(!proximity)
		return
	user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	user.visible_message(
		SPAN_DANGER("\The [user] invokes \the [src] at [target]."),
		SPAN_DANGER("You invoke \the [src] at [target].")
	)
	target.emp_act(1)
	user.unEquip(src)
	qdel(src)
