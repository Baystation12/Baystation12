/obj/item/weapon/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/material/kitchen/utensil
	w_class = 1
	thrown_force_divisor = 1
	origin_tech = "materials=1"
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 1
	edge = 1
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/loaded      //Descriptive string for currently loaded food object.

/obj/item/weapon/material/kitchen/utensil/New()
	..()
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
			M.visible_message("<span class='notice'>\The [user] eats some [loaded] from \the [src].</span>")
		else
			M.visible_message("<span class='notice'>\The [user] feeds some [loaded] to \the [M] with \the [src].</span>")
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), 1)
		overlays.Cut()
		return
	else
		user << "<span class='warning'>You don't have anything on \the [src].</span>"	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK GODDAMNIT
		return

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
	edge = 0
	sharp = 0
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/weapon/material/kitchen/utensil/spoon/plastic
	default_material = "plastic"

/*
 * Knives
 */
/obj/item/weapon/material/kitchen/utensil/knife
	name = "knife"
	desc = "A knife for eating with. Can cut through any food."
	icon_state = "knife"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)

/obj/item/weapon/material/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>You accidentally cut yourself with \the [src].</span>"
		user.take_organ_damage(20)
		return
	return ..()

/obj/item/weapon/material/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>You somehow managed to cut yourself with \the [src].</span>"
		user.take_organ_damage(20)
		return
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
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = "wood"
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_force_divisor = 1 // as above

/obj/item/weapon/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'>\The [src] slips out of your hand and hits your head.</span>"
		user.take_organ_damage(10)
		user.Paralyse(2)
		return
	return ..()