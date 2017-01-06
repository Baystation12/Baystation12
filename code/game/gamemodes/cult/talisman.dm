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

/obj/item/weapon/paper/talisman/stun/attack_self(var/mob/living/user)
	if(iscultist(user))
		to_chat(user, "This is a stun talisman.")
	..()

/obj/item/weapon/paper/talisman/stun/attack(var/mob/living/M, var/mob/living/user)
	if(!iscultist(user))
		return
	user.say("Dream sign ''Evil sealing talisman'[pick("'","`")]!")//TODO: change this shit
	var/obj/item/weapon/nullrod/N = locate() in M
	if(N)
		user.visible_message("<span class='danger'>\The [user] invokes \the [src] at [M], but they are unaffected.</span>", "<span class='danger'>You invoke \the [src] at [M], but they are unaffected.</span>")
		return
	else
		user.visible_message("<span class='danger'>\The [user] invokes \the [src] at [M].</span>", "<span class='danger'>You invoke \the [src] at [M].</span>")

	if(issilicon(M))
		M.Weaken(15)
	else if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!(HULK in C.mutations))
			C.silent += 15
		C.Weaken(25)
		C.Stun(25)
	admin_attack_log(user, M, "Used a stun talisman.", "Was victim of a stun talisman.", "used a stun talisman on")
	qdel(src)

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
	empulse(get_turf(target), 1, 1, 1)
	qdel(src)
