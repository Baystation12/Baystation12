/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'
	worth_multiplier = 1.1

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	w_class = ITEM_SIZE_TINY
	thrown_force_multiplier = 1
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("attacked", "stabbed", "poked")
	max_force = 5
	force_multiplier = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_multiplier = 0.25 // 5 when thrown with weight 20 (steel)
	default_material = MATERIAL_ALUMINIUM

	var/loaded      //Descriptive string for currently loaded food object.
	var/scoop_food = 1

/obj/item/material/kitchen/utensil/New()
	..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)
	return

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_HEAD || user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()

	if (reagents.total_volume > 0)
		if(M == user)
			if(!M.can_eat(loaded))
				return
			switch(M.get_fullness())
				if (0 to 50)
					to_chat(M, SPAN_DANGER("You ravenously stick \the [src] into your mouth and gobble the food!"))
				if (50 to 150)
					to_chat(M, SPAN_NOTICE("You hungrily chew the food on \the [src]."))
				if (150 to 350)
					to_chat(M, SPAN_NOTICE("You chew the food on \the [src]."))
				if (350 to 550)
					to_chat(M, SPAN_NOTICE("You unwillingly chew the food on \the [src]."))
				if (550 to INFINITY)
					to_chat(M, SPAN_WARNING("You cannot take one more bite from \the [src]!"))
					return

		else
			user.visible_message("<span class='warning'>\The [user] begins to feed \the [M]!</span>")
			if(!M.can_force_feed(user, loaded) || !do_after(user, 5 SECONDS, M))
				return

			if (user.get_active_hand() != src)
				return
			M.visible_message("<span class='notice'>\The [user] feeds some [loaded] to \the [M] with \the [src].</span>")
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), 1)
		overlays.Cut()
		return
	else
		to_chat(user, "<span class='warning'>You don't have anything on \the [src].</span>")//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"

/obj/item/material/kitchen/utensil/fork/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	force_multiplier = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/spork
	name = "spork"
	desc = "It's a spork. It's much like a fork, but much blunter."
	icon_state = "spork"

/obj/item/material/kitchen/utensil/spork/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/material/kitchen/utensil/foon
	name = "foon"
	desc = "It's a foon. It's much like a spoon, but much sharper."
	icon_state = "foon"

/obj/item/material/kitchen/utensil/foon/plastic
	default_material = MATERIAL_PLASTIC

 /*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = MATERIAL_WOOD
	max_force = 15
	force_multiplier = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_force_multiplier = 1 // as above

/obj/item/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50) && user.unEquip(src))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10, 0)
		user.Paralyse(2)
		return
	return ..()
