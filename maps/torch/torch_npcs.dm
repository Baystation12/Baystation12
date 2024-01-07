/obj/random_multi/single_item/punitelli
	name = "Multi Point - Warrant Officer Punitelli"
	id = "Punitelli"
	item_path = /mob/living/carbon/human/monkey/punitelli

/mob/living/carbon/human/monkey/punitelli
	name = "Warrant Officer Punitelli"
	gender = MALE
	faction = MOB_FACTION_CREW


/mob/living/carbon/human/monkey/punitelli/Initialize(mapload)
	. = ..()
	real_name = name
	return INITIALIZE_HINT_LATELOAD


/mob/living/carbon/human/monkey/punitelli/LateInitialize(mapload)
	equip_to_appropriate_slot(new /obj/item/clothing/under/solgov/utility/expeditionary/monkey, skip_timer = TRUE)
	put_in_hands(new /obj/item/reagent_containers/food/drinks/glass2/coffeecup/punitelli)
	equip_to_appropriate_slot(new /obj/item/clothing/mask/smokable/cigarette/jerichos, skip_timer = TRUE)
	if(prob(50))
		equip_to_appropriate_slot(new /obj/item/clothing/shoes/sandal, skip_timer = TRUE)

/obj/random_multi/single_item/runtime
	name = "Multi Point - Runtime"
	id = "Runtime"
	item_path = /mob/living/simple_animal/passive/cat/fluff/Runtime

/obj/random_multi/single_item/poppy
	name = "Multi Point - Poppy"
	id = "Poppy"
	item_path = /mob/living/simple_animal/passive/opossum/poppy
