/obj/item/weapon/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"

	var/wrapped = 0
	var/monkey_type = "Monkey"

	New()
		..()
		reagents.add_reagent("protein", 10)

	afterattack(obj/O as obj, mob/user as mob, proximity)
		if(!proximity) return
		if(istype(O,/obj/structure/sink) && !wrapped)
			user << "You place \the [name] under a stream of water..."
			loc = get_turf(O)
			return Expand()
		..()

	attack_self(mob/user as mob)
		if(wrapped)
			Unwrap(user)

	/*
	On_Consume(var/mob/M)
		M << "<span class = 'warning'>Something inside of you suddently expands!</span>"

		if (istype(M, /mob/living/carbon/human))
			//Do not try to understand.
			var/obj/item/weapon/surprise = new/obj/item/weapon(M)
			var/mob/ook = monkey_type
			surprise.icon = initial(ook.icon)
			surprise.icon_state = initial(ook.icon_state)
			surprise.name = "malformed [initial(ook.name)]"
			surprise.desc = "Looks like \a very deformed [initial(ook.name)], a little small for its kind. It shows no signs of life."
			surprise.transform *= 0.6
			surprise.add_blood(M)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/E = H.get_organ("chest")
			E.fracture()
			for (var/obj/item/organ/I in E.internal_organs)
				I.take_damage(rand(I.min_bruised_damage, I.min_broken_damage+1))

			if (!E.hidden && prob(60)) //set it snuggly
				E.hidden = surprise
				E.cavity = 0
			else 		//someone is having a bad day
				E.createwound(CUT, 30)
				E.embed(surprise)
		else if (issmall(M))
			M.visible_message("<span class='danger'>[M] suddenly tears in half!</span>")
			var/mob/living/carbon/monkey/ook = new monkey_type(M.loc)
			ook.name = "malformed [ook.name]"
			ook.transform *= 0.6
			ook.add_blood(M)
			M.gib()
		..()
	*/

	proc/Expand()
		for(var/mob/M in viewers(src,7))
			M << "\red \The [src] expands!"
		var/mob/living/carbon/human/H = new (src)
		H.set_species(monkey_type)
		qdel(src)

	proc/Unwrap(mob/user as mob)
		icon_state = "monkeycube"
		desc = "Just add water!"
		user << "You unwrap the cube."
		wrapped = 0
		return

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	wrapped = 1

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "Neara"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "Neara"