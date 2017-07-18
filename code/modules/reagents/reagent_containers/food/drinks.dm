////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "Yummy!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	var/filling_states // List of percentages full that have icons

/obj/item/weapon/reagent_containers/food/drinks/on_reagent_change()
	if(filling_states)
		update_icon()
	return

/obj/item/weapon/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		open(user)

/obj/item/weapon/reagent_containers/food/drinks/proc/open(mob/user)
	playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You open \the [src] with an audible pop!</span>")
	flags |= OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/weapon/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src]!</span>")
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/weapon/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/weapon/reagent_containers/food/drinks/examine(mob/user)
	if(!..(user, 1))
		return
	if(!reagents || reagents.total_volume == 0)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
	else if (reagents.total_volume <= volume * 0.25)
		to_chat(user, "<span class='notice'>\The [src] is almost empty!</span>")
	else if (reagents.total_volume <= volume * 0.66)
		to_chat(user, "<span class='notice'>\The [src] is half full!</span>")
	else if (reagents.total_volume <= volume * 0.90)
		to_chat(user, "<span class='notice'>\The [src] is almost full!</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] is full!</span>")

/obj/item/weapon/reagent_containers/food/drinks/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/k in cached_number_list_decode(filling_states))
		if(percent <= k)
			return k

/obj/item/weapon/reagent_containers/food/drinks/update_icon()
	var/image/filling = image(icon, src, "[icon_state][get_filling_state()]")
	filling.color = reagents.get_color()
	overlays += filling


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup."
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEM_SIZE_HUGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT | OPENCONTAINER

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"
	New()
		..()
		reagents.add_reagent("milk", 50)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = "x=16;y=9"
	New()
		..()
		reagents.add_reagent("soymilk", 50)

/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton
	name = "small milk carton"
	volume = 30
	icon_state = "mini-milk"
/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/New()
	..()
	reagents.add_reagent("milk", 30)

/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/chocolate
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."

/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/chocolate/New()
	..()
	reagents.add_reagent("chocolate_milk", 30)


/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"
	New()
		..()
		reagents.add_reagent("coffee", 30)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "cup of Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "teacup"
	item_state = "coffee"
	center_of_mass = "x=16;y=14"
	New()
		..()
		reagents.add_reagent("tea", 30)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = "x=15;y=10"
	New()
		..()
		reagents.add_reagent("ice", 30)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "cup of Dutch hot coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = "x=15;y=13"
	New()
		..()
		reagents.add_reagent("hot_coco", 30)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "cup ramen"
	gender = PLURAL
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)


/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = "x=16;y=12"
	New()
		..()
	on_reagent_change()
		if(reagents.total_volume)
			icon_state = "water_cup"
		else
			icon_state = "water_cup_e"


//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = "x=17;y=10"

/obj/item/weapon/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = "x=17;y=7"

/obj/item/weapon/reagent_containers/food/drinks/pitcher
	name = "pitcher"
	desc = "Everyone's best friend in the morning."
	icon_state = "pitcher"
	volume = 120
	amount_per_transfer_from_this = 10
	center_of_mass = "x=16;y=9"
	filling_states = "20;40;60;100"

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "\improper Captain's flask"
	desc = "A metal flask belonging to the captain."
	icon_state = "flask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/weapon/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/weapon/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/weapon/reagent_containers/food/drinks/flask/detflask
	name = "\improper Detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = "x=17;y=8"

/obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = "x=17;y=7"

/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = "x=15;y=4"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup
	name = "coffee cup"
	desc = "A plain white coffee cup."
	icon_state = "coffeecup"
	volume = 30
	center_of_mass = "x=15;y=13"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/black
	name = "black coffee cup"
	desc = "A sleek black coffee cup."
	icon_state = "coffeecup_black"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/green
	name = "green coffee cup"
	desc = "A pale green and pink coffee cup."
	icon_state = "coffeecup_green"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/heart
	name = "heart coffee cup"
	desc = "A white coffee cup, it prominently features a red heart."
	icon_state = "coffeecup_heart"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/SCG
	name = "SCG coffee cup"
	desc = "A blue coffee cup emblazoned with the crest of the Sol Central Government."
	icon_state = "coffeecup_SCG"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/NT
	name = "NT coffee cup"
	desc = "A red NanoTrasen coffee cup. 90% Guaranteed to not be laced with mind-control drugs."
	icon_state = "coffeecup_NT"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/one
	name = "#1 coffee cup"
	desc = "A white coffee cup, prominently featuring a #1."
	icon_state = "coffeecup_one"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/rainbow
	name = "rainbow coffee cup"
	desc = "A rainbow coffee cup. The colors are almost as blinding as a welder."
	icon_state = "coffeecup_rainbow"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/metal
	name = "metal coffee cup"
	desc = "A metal coffee cup. You're not sure which metal."
	icon_state = "coffeecup_metal"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/STC
	name = "STC coffee cup"
	desc = "A coffee cup adorned with the flag of the Sovereign Terran Confederacy, for when you need some espionage charges to go with your morning coffee."
	icon_state = "coffeecup_STC"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/pawn
	name = "pawn coffee cup"
	desc = "A black coffee cup adorned with the image of a red chess pawn."
	icon_state = "coffeecup_pawn"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/diona
	name = "diona nymph coffee cup"
	desc = "A green coffee cup featuring the image of a diona nymph."
	icon_state = "coffeecup_diona"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/britcup
	name = "british coffee cup"
	desc = "A coffee cup with the British flag emblazoned on it."
	icon_state = "coffeecup_brit"

/obj/item/weapon/reagent_containers/food/drinks/coffeecup/tall
	name = "tall coffee cup"
	desc = "An unreasonably tall coffee cup, for when you really need to wake up in the morning."
	icon_state = "coffeecup_tall"
	volume = 120
	center_of_mass = "x=15;y=19"