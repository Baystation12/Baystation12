
//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	volume = 60

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_hand()
		..()
		update_icon()

	New()
		..()
		if(!icon_state)
			icon_state = "bottle-[rand(1.4)]"

	update_icon()
		overlays.Cut()

		if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]--10"
				if(10 to 24) 	filling.icon_state = "[icon_state]-10"
				if(25 to 49)	filling.icon_state = "[icon_state]-25"
				if(50 to 74)	filling.icon_state = "[icon_state]-50"
				if(75 to 79)	filling.icon_state = "[icon_state]-75"
				if(80 to 90)	filling.icon_state = "[icon_state]-80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]-100"

			filling.icon += mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

		if (!is_open_container())
			var/image/lid = image(icon, src, "lid_bottle")
			overlays += lid

/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	New()
		..()
		reagents.add_reagent("inaprovaline", 60)

/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent("toxin", 60)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent("cyanide", 60)

/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("stoxin", 60)

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("chloralhydrate", 30)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent("anti_toxin", 60)

/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("mutagen", 60)

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent("ammonia", 60)

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent("diethylamine", 60)

/obj/item/weapon/reagent_containers/glass/bottle/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/flu(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion
	name = "Epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/voice_change(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion
	name = "Liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/heal(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion
	name = "Hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/advance/hullucigen(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/cold
	name = "Rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/advance/F = new /datum/disease/advance/cold(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/random
	name = "Random culture bottle"
	desc = "A small bottle. Contains a random disease."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/advance/F = new(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/retrovirus
	name = "Retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/dna_retrovirus(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/gbs
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/fake_gbs(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)
/*
/obj/item/weapon/reagent_containers/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)
*/

/obj/item/weapon/reagent_containers/glass/bottle/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/brainrot(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/magnitis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)


/obj/item/weapon/reagent_containers/glass/bottle/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		var/datum/disease/F = new /datum/disease/wizarditis(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)

/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent("pacid", 60)

/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	New()
		..()
		reagents.add_reagent("adminordrazine", 60)

/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	New()
		..()
		reagents.add_reagent("capsaicin", 60)

/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent("frostoil", 60)