/obj/item/weapon/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/material/kitchen/utensil
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	flags = CONDUCT
	origin_tech = "materials=1"
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 0
	var/loaded      //Descriptive string for currently loaded food object.

/obj/item/weapon/material/kitchen/utensil/New()
	if (prob(60))
		src.pixel_y = rand(0, 4)

	create_reagents(5)
	return

/obj/item/weapon/material/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == "head" || user.zone_sel.selecting == "eyes")
			if((CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()

	if (reagents.total_volume > 0)
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] eats some [] from \the [].", user, loaded, src), 1)
				M.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\blue [] feeds [] some [] from \the []", user, M, loaded, src), 1)
				M.reagents.add_reagent("nutriment", 1)
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), 1)
		overlays.Cut()
		return
	else
		..()

/obj/item/weapon/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"

/obj/item/weapon/material/kitchen/utensil/fork/plastic
	default_material = "plastic"

/obj/item/weapon/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")

/obj/item/weapon/material/kitchen/utensil/spoon/plastic
	default_material = "plastic"

/*
 * Knives
 */
/obj/item/weapon/material/kitchen/utensil/knife
	name = "knife"
	desc = "Can cut through any food."
	icon_state = "knife"
	force = 10.0
	throwforce = 10.0
	sharp = 1
	edge = 1

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)

/obj/item/weapon/material/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You accidentally cut yourself with the [src]."
		user.take_organ_damage(20)
		return
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/material/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red You somehow managed to cut yourself with the [src]."
		user.take_organ_damage(20)
		return
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/material/kitchen/utensil/knife/plastic
	default_material = "plastic"

/*
 * Rolling Pins
 */

/obj/item/weapon/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	force = 8.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 7
	w_class = 3.0
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked") //I think the rollingpin attackby will end up ignoring this anyway.

/obj/item/weapon/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red The [src] slips out of your hand and hits your head."
		user.take_organ_damage(10)
		user.Paralyse(2)
		return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to attack [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	var/t = user:zone_sel.selecting
	if (t == "head")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.stat < 2 && H.health < 50 && prob(90))
				// ******* Check
				if (istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80))
					H << "\red The helmet protects you from being hit hard in the head!"
					return
				var/time = rand(2, 6)
				if (prob(75))
					H.Paralyse(time)
				else
					H.Stun(time)
				if(H.stat != 2)	H.stat = 1
				user.visible_message("\red <B>[H] has been knocked unconscious!</B>", "\red <B>You knock [H] unconscious!</B>")
				return
			else
				H.visible_message("\red [user] tried to knock [H] unconscious!", "\red [user] tried to knock you unconscious!")
				H.eye_blurry += 3
	return ..()

