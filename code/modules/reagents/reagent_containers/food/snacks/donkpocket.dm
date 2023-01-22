/**
* Donk Pockets are a food item that is a reference to a mass market
* brand of turnovers. They come with various "fillings" and can be
* cooked (or self-heat in some cases) to cause them to temporarily
* become more useful.
*/

/obj/item/reagent_containers/food/snacks/donkpocket
	abstract_type = /obj/item/reagent_containers/food/snacks/donkpocket
	name = "donk-pocket"
	icon_state = "donkpocket"
	filling_color = "#dedeab"
	center_of_mass = "x=16;y=10"
	bitesize = 3
	nutriment_amt = 2
	nutriment_desc = list(
		"heartiness" = 1,
		"dough" = 2
	)

	/// Whether the donk pocket is currently hot. Hot donk pockets have additional reagents
	var/is_hot = FALSE

	/// Whether the donk pocket is able to be made hot without a microwave by using it in-hand
	var/can_self_heat = FALSE

	/// Whether the donk pocket was heated up already. Reheating does not re-add the extra reagents.
	var/was_heated = FALSE

	/// The reagents to be added to the donk pocket when it is made hot (and removed when made cold)
	var/list/hot_reagents = list(
		/datum/reagent/tricordrazine = 5
	)

	/// The reagents to be added to the donk pocket when it is initialized
	var/list/filling_options


/obj/item/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	if (filling_options)
		SetInitialReagents(filling_options)


/obj/item/reagent_containers/food/snacks/donkpocket/OnConsume(mob/living/consumer)
	if (can_self_heat)
		to_chat(consumer, SPAN_ITALIC("You tear open \the [src], destroying the self-heating packaging."))
		can_self_heat = FALSE
	..()


/obj/item/reagent_containers/food/snacks/donkpocket/examine(mob/user, distance)
	. = ..()
	if (distance > 1)
		return
	if (!initial(can_self_heat))
		return
	to_chat(user, "This one can self-heat[can_self_heat ? "." : " but the heaters are used up."]")


/obj/item/reagent_containers/food/snacks/donkpocket/attack_self(mob/living/user)
	if (!initial(can_self_heat))
		return
	SetHot(user, TRUE)


/obj/item/reagent_containers/food/snacks/donkpocket/proc/SetHot(mob/living/user, attempt_self_heat)
	if (is_hot)
		to_chat(user, SPAN_NOTICE("\The [src] is already hot!"))
		return
	if (attempt_self_heat)
		if (!can_self_heat)
			if (!initial(can_self_heat))
				return
			to_chat(user, SPAN_WARNING("\The [src]'s heaters are used up. Use a microwave."))
			return
		can_self_heat = FALSE
	is_hot = TRUE
	if (attempt_self_heat)
		to_chat(user, SPAN_NOTICE("A comforting warmth spreads through \the [src]. It's ready to eat!"))
	if (!was_heated)
		for(var/reagent in hot_reagents)
			reagents.add_reagent(reagent, hot_reagents[reagent])
		was_heated = TRUE
	SetName("hot " + name)
	addtimer(CALLBACK(src, .proc/UnsetHot), 7 MINUTES)


/obj/item/reagent_containers/food/snacks/donkpocket/proc/UnsetHot()
	if (!is_hot)
		return
	is_hot = FALSE
	SetName(initial(name))
	visible_message(SPAN_ITALIC("\The [src] cools down."), range = 1)
	for (var/reagent in hot_reagents)
		reagents.del_reagent(reagent)


/obj/item/reagent_containers/food/snacks/donkpocket/proc/SetInitialReagents(list/options, amount = 3)
	var/list/entry = pick(options)
	if (!islist(entry))
		reagents.add_reagent(entry, amount)
		return
	var/sub_amount = amount / length(entry)
	for (var/reagent in entry)
		reagents.add_reagent(reagent, sub_amount)




/obj/item/reagent_containers/food/snacks/donkpocket/protein
	name = "protein donk-pocket"
	desc = "A mass produced shelf-stable turnover. Allegedly contains mixed meat product."
	filling_options = list(
		/datum/reagent/nutriment/protein,
		/datum/reagent/drink/porksoda
	)


/obj/item/reagent_containers/food/snacks/donkpocket/vegetable
	name = "vegetable donk-pocket"
	desc = "A mass produced shelf-stable turnover. Allegedly contains plant based nutrients."
	filling_options = list(
		list(
			/datum/reagent/drink/juice/potato,
			/datum/reagent/drink/juice/onion,
			/datum/reagent/drink/juice/tomato
		),
		/datum/reagent/drink/juice/potato,
		/datum/reagent/drink/juice/turnip,
		/datum/reagent/drink/juice/cabbage,
		/datum/reagent/drink/milk/soymilk
	)


/obj/item/reagent_containers/food/snacks/donkpocket/fruit
	name = "fruit donk-pocket"
	desc = "A mass produced shelf-stable turnover. Allegedly contains fruit derivatives."
	filling_options = list(
		/datum/reagent/drink/juice/apple,
		/datum/reagent/drink/juice/berry,
		/datum/reagent/drink/juice/melon,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/coconut
	)


/obj/item/reagent_containers/food/snacks/donkpocket/dessert
	name = "dessert donk-pocket"
	desc = "A mass produced shelf-stable turnover. Allegedly contains unnatural delights."
	filling_options = list(
		/datum/reagent/drink/milk/chocolate,
		/datum/reagent/drink/milk/cream,
		/datum/reagent/drink/coffee/soy_latte/mocha,
		/datum/reagent/drink/coffee/soy_latte/pumpkin,
		/datum/reagent/drink/milkshake,
		/datum/reagent/drink/maplesyrup,
		/datum/reagent/drink/kiraspecial,
		/datum/reagent/cinnamon,
		/datum/reagent/drink/kefir
	)


/obj/item/reagent_containers/food/snacks/donkpocket/premium
	name = "premium donk-pocket"
	desc = "A \"premium\" shelf-stable turnover. Possibly contains \"real\" fruit paste. Crush the packaging to cook it on the go!"
	filling_color = "#6d6d00"
	can_self_heat = TRUE
	nutriment_amt = 4
	nutriment_desc = list(
		"nutritious goodness" = 1,
		"flaky pastry" = 2
	)
	hot_reagents = list(
		/datum/reagent/drink/doctor_delight = 4,
		/datum/reagent/hyperzine = 0.5,
		/datum/reagent/synaptizine = 0.1
	)




/obj/random/donkpocket
	name = "random donk-pocket"
	desc = "This is a random donk-pocket."
	icon = 'icons/obj/food.dmi'
	icon_state = "donkpocket"


/obj/random/donkpocket/spawn_choices()
	return list(
		/obj/item/reagent_containers/food/snacks/donkpocket/protein = 10,
		/obj/item/reagent_containers/food/snacks/donkpocket/vegetable = 10,
		/obj/item/reagent_containers/food/snacks/donkpocket/fruit = 5,
		/obj/item/reagent_containers/food/snacks/donkpocket/dessert = 5,
		/obj/item/reagent_containers/food/snacks/donkpocket/premium = 1
	)




/obj/item/storage/box/donkpocket_protein
	name = "box of protein donk-pockets"
	desc = "Heat in microwave. Product will cool if not eaten within seven minutes. Contains meat."
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/protein = 4
	)


/obj/item/storage/box/donkpocket_vegetable
	name = "box of vegetable donk-pockets"
	desc = "Heat in microwave. Product will cool if not eaten within seven minutes. Suitable for vegetarians."
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/vegetable = 4
	)


/obj/item/storage/box/donkpocket_fruit
	name = "box of fruit donk-pockets"
	desc = "Heat in microwave. Product will cool if not eaten within seven minutes. Contains plant sugars."
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/fruit = 4
	)


/obj/item/storage/box/donkpocket_dessert
	name = "box of dessert donk-pockets"
	desc = "Heat in microwave. Product will cool if not eaten within seven minutes. Contains animal products."
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/dessert = 4
	)


/obj/item/storage/box/donkpocket_premium
	name = "box of premium donk-pockets"
	desc = "Heat in microwave or crush packaging in hand. Product will cool if not eaten within seven minutes. Suitable for vegetarians. Contains plant sugars."
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/reagent_containers/food/snacks/donkpocket/premium = 4
	)


// Mixed donk pocket boxes gives you a couple of extras for taking a chance
/obj/item/storage/box/donkpocket_mixed
	name = "box of mixed donk-pockets"
	desc = "Heat in microwave or crush packaging in hand. Product will cool if not eaten within seven minutes. Check packaged products for individual safety."
	icon_state = "donk_kit"
	startswith = list(
		/obj/random/donkpocket = 6
	)




/obj/random/donkpocket_box
	name = "random box of donk-pockets"
	desc = "This is a random box of donk-pockets."
	icon = 'icons/obj/storage.dmi'
	icon_state = "donk_kit"


/obj/random/donkpocket_box/spawn_choices()
	return list(
		/obj/item/storage/box/donkpocket_mixed = 10,
		/obj/item/storage/box/donkpocket_protein = 10,
		/obj/item/storage/box/donkpocket_vegetable = 10,
		/obj/item/storage/box/donkpocket_fruit = 5,
		/obj/item/storage/box/donkpocket_dessert = 5,
		/obj/item/storage/box/donkpocket_premium = 1
	)
