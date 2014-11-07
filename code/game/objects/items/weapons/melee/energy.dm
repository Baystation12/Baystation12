/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	sharp = 0
	edge = 0
	flags = FPRINT | TABLEPASS | NOBLOODY

/obj/item/weapon/melee/energy/proc/activate()
	active = 1
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)

/obj/item/weapon/melee/energy/proc/deactivate()
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("\red [user] accidentally cuts \himself with \the [src].", "\red You accidentally cut yourself with \the [src].")
			user.take_organ_damage(5,5)
		deactivate()
	else
		activate()

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/suicide_act(mob/user)
	if (active)
		viewers(user) << pick("\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>", \
							"\red <b>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS|FIRELOSS)

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 35
	active_w_class = 5
	//force = 40
	//throwforce = 25
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = 3
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS | NOBLOODY
	origin_tech = "magnets=3;combat=4"
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/weapon/melee/energy/axe/activate()
	..()
	icon_state = "axe1"
	user << "\blue \The [src] is now energised."

/obj/item/weapon/melee/energy/axe/deactivate()
	..()
	icon_state = initial(icon_state)
	user << "\blue \The [src] is de-energised. It's just a regular axe now."

/obj/item/weapon/melee/energy/axe/suicide_act(mob/user)
	viewers(user) << "\red <b>[user] swings the [src.name] towards /his head! It looks like \he's trying to commit suicide.</b>"
	return (BRUTELOSS|FIRELOSS)

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
	active_force = 30
	active_throwforce = 20
	active_w_class = 4
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = 2
	flags = FPRINT | TABLEPASS | NOSHIELD | NOBLOODY
	origin_tech = "magnets=3;syndicate=4"
	var/attack_verb_active = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/melee/energy/sword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/weapon/melee/energy/sword/green/New()
	item_color = "green"

/obj/item/weapon/melee/energy/sword/red/New()
	item_color = "red"

/obj/item/weapon/melee/energy/sword/blue/New()
	item_color = "blue"

/obj/item/weapon/melee/energy/sword/purple/New()
	item_color = "purple"

/obj/item/weapon/melee/energy/sword/activate()
	..()
	attack_verb = attack_verb_active
	icon_state = "sword[item_color]"
	user << "\blue \The [src] is now energised."

/obj/item/weapon/melee/energy/sword/deactivate()
	..()
	attack_verb = initial(attack_verb)
	icon_state = initial(icon_state)
	user << "\blue It can now be concealed."

/obj/item/weapon/melee/energy/sword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/sword/pirate/activate()
	..()
	icon_state = "cutlass1"

/*
 *Energy Blade
 */

//Can't be activated or deactivated, so not actually a subtype of energy
/obj/item/weapon/melee/energy_blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	sharp = 1
	edge = 1
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = 4.0//So you can't hide it in your pocket or some such.
	flags = FPRINT | TABLEPASS | NOSHIELD | NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/melee/energy_blade/New()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/melee/energy_blade/dropped()
	del(src)

/obj/item/weapon/melee/energy_blade/proc/throw()
	del(src)
