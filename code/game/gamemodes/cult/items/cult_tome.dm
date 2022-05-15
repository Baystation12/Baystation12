/obj/item/book/tome
	name = "arcane tome"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = 2
	unique = 1
	carved = 2 // Don't carve it

/obj/item/book/tome/attack_self(mob/living/user)
	if(!iscultist(user))
		to_chat(user, SPAN_NOTICE("\The [src] seems full of illegible scribbles. Is this a joke?"))
	else
		to_chat(user, "Hold \the [src] in your hand while drawing a rune to use it.")

/obj/item/book/tome/examine(mob/user)
	. = ..()
	if(!iscultist(user))
		to_chat(user, "An old, dusty tome with frayed edges and a sinister looking cover.")
	else
		to_chat(user, "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual his followers could think of. Most of these are useless, though.")

/obj/item/book/tome/attack(mob/living/M, mob/living/user)
	if (user.a_intent != I_HELP || user.zone_sel.selecting != BP_EYES)
		return ..()
	user.visible_message(
		SPAN_NOTICE("\The [user] shows \the [src] to \the [M]."),
		SPAN_NOTICE("You open up \the [src] and show it to \the [M].")
	)
	if (iscultist(M))
		if (user != M)
			to_chat(user, SPAN_NOTICE("But they already know all there is to know."))
		to_chat(M, SPAN_NOTICE("But you already know all there is to know."))
	else
		to_chat(M, SPAN_NOTICE("\The [src] seems full of illegible scribbles. Is this a joke?"))
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

/obj/item/book/tome/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || !iscultist(user))
		return
	if(A.reagents && A.reagents.has_reagent(/datum/reagent/water/holywater))
		to_chat(user, SPAN_NOTICE("You unbless \the [A]."))
		var/holy2water = A.reagents.get_reagent_amount(/datum/reagent/water/holywater)
		A.reagents.del_reagent(/datum/reagent/water/holywater)
		A.reagents.add_reagent(/datum/reagent/water, holy2water)