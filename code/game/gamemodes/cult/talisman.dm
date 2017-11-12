/obj/item/weapon/paper/talisman
	icon_state = "paper_talisman"
	var/imbue = null
	info = "<center><img src='talisman.png'></center><br/><br/>"

/obj/item/weapon/paper/talisman/attack_self(var/mob/living/user)
	if(iscultist(user))
		to_chat(user, "Attack your target to use this talisman.")
	else
		to_chat(user, "You see strange symbols on the paper. Are they supposed to mean something?")

/obj/item/weapon/paper/talisman/attack(var/mob/living/M, var/mob/living/user)
	return

/obj/item/weapon/paper/talisman/emp/attack_self(var/mob/living/user)
	if(iscultist(user))
		to_chat(user, "This is an emp talisman.")
	..()

/obj/item/weapon/paper/talisman/emp/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!iscultist(user))
		return
	if(!proximity)
		return
	user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	user.visible_message("<span class='danger'>\The [user] invokes \the [src] at [target].</span>", "<span class='danger'>You invoke \the [src] at [target].</span>")
	target.emp_act(1)
	qdel(src)
