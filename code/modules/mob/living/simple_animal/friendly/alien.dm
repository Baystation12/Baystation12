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

/mob/living/simple_animal/passive/meatbeast/attackby(obj/item/O, mob/living/user)
	if(stat == CONSCIOUS && is_sharp(O) && (user.a_intent == I_HELP))
		if(num_meat >= 1)
			user.visible_message(
				SPAN_NOTICE("\The [user] harvests meat from [src]"),
				SPAN_NOTICE("You harvest meat from [src]")
			)
			--num_meat
			new meat_type(get_turf(src))
			playsound(user, 'sound/weapons/bladeslice.ogg', 15, 1)
		else
			to_chat(user, SPAN_NOTICE("Meat protrusions on \the [src] are still growing."))
	else
		..()

/mob/living/simple_animal/passive/meatbeast/Life()
	. = ..()
	if(!.)
		return FALSE
	if((num_meat < 5) && prob(5))
		++num_meat