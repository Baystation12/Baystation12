////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	flags = OPENCONTAINER
	var/gulp_size = 5 //This is now officially broken ... need to think of a nice way to fix it.
	possible_transfer_amounts = list(5,10,25)
	volume = 50

	on_reagent_change()
		if (gulp_size < 5) gulp_size = 5
		else gulp_size = max(round(reagents.total_volume / 5), 5)

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents
		var/fillevel = gulp_size

		if(!R.total_volume || !R)
			user << "\red The [src.name] is empty!"
			return 0

		if(M == user)

			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.species.flags & IS_SYNTHETIC)
					H << "\red You have a monitor for a head, where do you think you're going to put that?"
					return

			M << "\blue You swallow a gulp from \the [src]."
			if(reagents.total_volume)
				reagents.trans_to_ingest(M, gulp_size)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "\red They have a monitor for a head, where do you think you're going to put that?"
				return

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.trans_to_ingest(M, gulp_size)

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				bro.cell.use(30)
				var/refill = R.get_master_reagent_id()
				spawn(600)
					R.add_reagent(refill, fillevel)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1

		return 0


	afterattack(obj/target, mob/user, proximity)
		if(!proximity) return

		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.is_open_container()) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return



			var/datum/reagent/refill
			var/datum/reagent/refillName
			if(isrobot(user))
				refill = reagents.get_master_reagent_id()
				refillName = reagents.get_master_reagent_name()

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/bro = user
				var/chargeAmount = max(30,4*trans)
				bro.cell.use(chargeAmount)
				user << "Now synthesizing [trans] units of [refillName]..."


				spawn(300)
					reagents.add_reagent(refill, trans)
					user << "Cyborg [src] refilled."

		return ..()

	examine(mob/user)
		if(!..(user, 1))
			return
		if(!reagents || reagents.total_volume==0)
			user << "\blue \The [src] is empty!"
		else if (reagents.total_volume<=src.volume/4)
			user << "\blue \The [src] is almost empty!"
		else if (reagents.total_volume<=src.volume*0.66)
			user << "\blue \The [src] is half full!"
		else if (reagents.total_volume<=src.volume*0.90)
			user << "\blue \The [src] is almost full!"
		else
			user << "\blue \The [src] is full!"


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = 4
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT | OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/golden_cup/tournament_26_06_2011
	desc = "A golden cup. It will be presented to a winner of tournament 26 june and name of the winner will be graved on it."


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	New()
		..()
		reagents.add_reagent("milk", 50)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	New()
		..()
		reagents.add_reagent("soymilk", 50)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
	New()
		..()
		reagents.add_reagent("coffee", 30)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "teacup"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	New()
		..()
		reagents.add_reagent("tea", 30)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
	New()
		..()
		reagents.add_reagent("ice", 30)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = list("x"=15, "y"=13)
	New()
		..()
		reagents.add_reagent("hot_coco", 30)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = list("x"=16, "y"=11)
	New()
		..()
		reagents.add_reagent("dry_ramen", 30)


/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "Paper Cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)
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
	name = "Shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "Captain's Flask"
	desc = "A metal flask belonging to the captain"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/weapon/reagent_containers/food/drinks/flask/detflask
	name = "Detective's Flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)

/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
