/mob/living/simple_animal/passive/meatbeast
	name = "meatbeast"
	desc = "A ponderous creature covered in glistening, skinless flesh, with a tiny sluglike head. It seems to be constantly extruding pointless slabs of muscle and flesh."
	icon_state = "meatbeast"
	icon_living = "meatbeast"
	icon_dead = "meatbeast_dead"
	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "kicks"
	health = 50
	maxHealth = 50 //they are beefy
	meat_amount = 10
	bone_amount = 10
	skin_amount = 0 //skinless chunk of crawling meat
	skin_material = null
	minbodytemp = 0
	cold_damage_per_tick = 0
	min_gas = null
	max_gas = list(GAS_PHORON = 1, GAS_OXYGEN = 5)
	bleed_colour = "#2299fc"
	natural_weapon = /obj/item/natural_weapon/bite
	ai_holder = /datum/ai_holder/simple_animal/passive
	var/num_meat = 5


/mob/living/simple_animal/passive/meatbeast/use_tool(obj/item/tool, mob/user, list/click_params)
	// Sharp item - Harvest meat
	if (is_sharp(tool))
		if (stat)
			USE_FEEDBACK_FAILURE("\The [src] is not conscious and not in a state to be harvested.")
			return TRUE
		if (num_meat <= 0)
			USE_FEEDBACK_FAILURE("\The [src]'s met protrusions are still growing.")
			return TRUE
		num_meat--
		var/obj/item/meat = new meat_type(loc)
		playsound(user, 'sound/weapons/bladeslice.ogg', 15, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] harvests some [meat.name] from \the [src] with \a [tool]."),
			SPAN_NOTICE("You harvest some [meat.name] from \the [src] with \the [tool]."),
			exclude_mobs = list(src)
		)
		to_chat(src, SPAN_NOTICE("\The [user] harvests some [meat.name] from you with \a [tool]."))
		return TRUE

	return ..()


/mob/living/simple_animal/passive/meatbeast/Life()
	. = ..()
	if(!.)
		return FALSE
	if((num_meat < 5) && prob(5))
		++num_meat
