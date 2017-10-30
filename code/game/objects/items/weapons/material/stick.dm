/obj/item/weapon/material/stick
	name = "stick"
	desc = "You feel the urge to poke someone with this."
	icon_state = "stick"
	item_state = "stickmat"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	w_class = ITEM_SIZE_NORMAL
	default_material = "wood"
	attack_verb = list("poked", "jabbed")


/obj/item/weapon/material/stick/attack_self(mob/user as mob)
	user.visible_message("<span class='warning'>\The [user] snaps [src].</span>", "<span class='warning'>You snap [src].</span>")
	shatter(0)


/obj/item/weapon/material/stick/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.sharp && W.edge && !sharp)
		user.visible_message("<span class='warning'>[user] sharpens [src] with [W].</span>", "<span class='warning'>You sharpen [src] using [W].</span>")
		sharp = 1 //Sharpen stick
		name = "sharpened " + name
		update_force()
	return ..()


/obj/item/weapon/material/stick/attack(mob/M, mob/user)
	if(user != M && user.a_intent == I_HELP)
		//Playful poking is its own thing
		user.visible_message("<span class='notice'>[user] pokes [M] with [src].</span>", "<span class='notice'>You poke [M] with [src].</span>")
		//Consider adding a check to see if target is dead
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(M)
		return
	return ..()
