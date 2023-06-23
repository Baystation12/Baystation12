/datum/reagent/nutriment/condensedmilk
	name = "condensed milk"
	description = "The miracle of Terra's food industry — super-saturated compressed milk."
	taste_description = "extraordinary sweetness"
	nutriment_factor = 5
	taste_mult = 2
	reagent_state = LIQUID
	color = "#F4CBA8"

/datum/reagent/nutriment/condensedmilkboiled
	name = "boiled condensed milk"
	description = "The miracle of Terra's food industry — super-saturated compressed milk that's been boiled."
	taste_description = "extraordinary thicc sweetness"
	nutriment_factor = 6
	taste_mult = 2
	reagent_state = LIQUID
	color = "#AC6527"



// Recipes
/datum/chemical_reaction/condensedmilk
	name = "condensedmilk"
	result = /datum/reagent/nutriment/condensedmilk
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/sugar = 5)
	result_amount = 5
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 120 CELSIUS
	mix_message = "The solution thickens."

/datum/chemical_reaction/varenka
	name = "Varenka"
	result = /datum/reagent/nutriment/condensedmilkboiled
	required_reagents = list(/datum/reagent/nutriment/condensedmilk = 1)
	result_amount = 1
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 120 CELSIUS
	mix_message = "The solution thickens."

// reagent_containers/food/snacks

/obj/item/reagent_containers/food/snacks/canned/sgushenka
	name = "sgushenka"
	icon_state = "sgushenka"
	desc = "A can of condensed milk originating from the ICCG."
	trash = /obj/item/trash/sgushenka
	filling_color = "#F4CBA8"
	volume = 40
	center_of_mass = "x=15;y=9"
	eat_sound = 'sound/items/drink.ogg'
	bitesize = 8

/obj/item/reagent_containers/food/snacks/canned/sgushenka/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/condensedmilk, 28)
	reagents.add_reagent(/datum/reagent/sugar, 8)
	reagents.add_reagent(/datum/reagent/iron, 4)

/obj/item/reagent_containers/food/snacks/canned/sgushenka/attack_self(var/mob/user)
	if(sealed)
		to_chat(user, "<span class='notice'>You can't open \the [src] with a bare hands.</span>")
		return

/obj/item/reagent_containers/food/snacks/canned/sgushenka/attackby(obj/item/W, mob/user)
	if(!is_sharp(W) || !sealed)
		return
	playsound(loc,'sound/effects/sound_effects_canopenlong.ogg', 32)
	if(do_after(user, 3 SECONDS, src))
		to_chat(user, "<span class='notice'>You unseal \the [src] with a crack of metal.</span>")
		unseal()
	else
		var/mob/living/carbon/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_L_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_R_HAND]

		temp.take_general_damage(rand(8,24))
		H.visible_message(
			"<span class='danger'>\The [user] cuts himself with \the [W]!</span>",
			"<span class='notice'>You cut yourself with \the [W]!</span>"
			)

/obj/item/reagent_containers/food/snacks/canned/varenka
	name = "varenka"
	icon_state = "varenka"
	desc = "A can of boiled condensed milk originating from the ICCG."
	trash = /obj/item/trash/varenka
	filling_color = "#AC6527"
	volume = 40
	center_of_mass = "x=15;y=9"
	bitesize = 8

/obj/item/reagent_containers/food/snacks/canned/varenka/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/condensedmilkboiled, 28)
	reagents.add_reagent(/datum/reagent/sugar, 8)
	reagents.add_reagent(/datum/reagent/iron, 4)

/obj/item/reagent_containers/food/snacks/canned/varenka/attack_self(var/mob/user)
	if(sealed)
		to_chat(user, "<span class='notice'>You can't open \the [src] with a bare hands.</span>")
		return

/obj/item/reagent_containers/food/snacks/canned/varenka/attackby(obj/item/W, mob/user)
	if(!is_sharp(W) || !sealed)
		return
	playsound(loc,'sound/effects/sound_effects_canopenlong.ogg', 32)
	if(do_after(user, 3 SECONDS, src))
		to_chat(user, "<span class='notice'>You unseal \the [src] with a crack of metal.</span>")
		unseal()
	else
		var/mob/living/carbon/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_L_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_R_HAND]

		temp.take_general_damage(rand(8,24))
		H.visible_message(
			"<span class='danger'>\The [user] cuts off himself with \the [W]!</span>",
			"<span class='notice'>You cut yourself with \the [W]!</span>"
			)
