/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = 1.0
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = "biotech=4"
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?
	flags = OPENCONTAINER

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/slimesteroid2))
			if(enhanced == 1)
				user << "<span class='warning'> This extract has already been enhanced!</span>"
				return ..()
			if(Uses == 0)
				user << "<span class='warning'> You can't enhance a used extract!</span>"
				return ..()
			user <<"You apply the enhancer. It now has triple the amount of uses."
			Uses = 3
			enhanced = 1
			qdel(O)

/obj/item/slime_extract/New()
	..()
	create_reagents(100)
	reagents.add_reagent("slimejelly", 30)

/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"

/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite slime extract"

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia slime extract"

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"

////Pet Slime Creation///

/obj/item/weapon/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			user << "<span class='warning'> The potion only works on baby slimes!</span>"
			return ..()
		if(M.is_adult) //Can't tame adults
			user << "<span class='warning'> Only baby slimes can be tamed!</span>"
			return..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.mind)
			user << "<span class='warning'> The slime resists!</span>"
			return ..()
		var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "[M.colour] baby slime"
		pet.icon_living = "[M.colour] baby slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		user <<"You feed the slime the potion, removing it's powers and calming it."
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)

/obj/item/weapon/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
			user << "<span class='warning'> The potion only works on slimes!</span>"
			return ..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.mind)
			user << "<span class='warning'> The slime resists!</span>"
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		user <<"You feed the slime the potion, removing it's powers and calming it."
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)


/obj/item/weapon/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			user << "<span class='warning'> The steroid only works on baby slimes!</span>"
			return ..()
		if(M.is_adult) //Can't tame adults
			user << "<span class='warning'> Only baby slimes can use the steroid!</span>"
			return..()
		if(M.stat)
			user << "<span class='warning'> The slime is dead!</span>"
			return..()
		if(M.cores == 3)
			user <<"<span class='warning'> The slime already has the maximum amount of extract!</span>"
			return..()

		user <<"You feed the slime the steroid. It now has triple the amount of extract."
		M.cores = 3
		qdel(src)

/obj/item/weapon/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	/*afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/item/slime_extract))
			if(target.enhanced == 1)
				user << "<span class='warning'> This extract has already been enhanced!</span>"
				return ..()
			if(target.Uses == 0)
				user << "<span class='warning'> You can't enhance a used extract!</span>"
				return ..()
			user <<"You apply the enhancer. It now has triple the amount of uses."
			target.Uses = 3
			target.enahnced = 1
			qdel(src)*/

/obj/effect/golemrune
	anchored = 1
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER

	New()
		..()
		processing_objects.Add(src)

	process()
		var/mob/dead/observer/ghost
		for(var/mob/dead/observer/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(ghost)
			icon_state = "golem2"
		else
			icon_state = "golem"

	attack_hand(mob/living/user as mob)
		var/mob/dead/observer/ghost
		for(var/mob/dead/observer/O in src.loc)
			if(!O.client)	continue
			if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
			ghost = O
			break
		if(!ghost)
			user << "The rune fizzles uselessly. There is no spirit nearby."
			return
		var/mob/living/carbon/human/G = new(src.loc)
		G.set_species("Golem")
		G.key = ghost.key
		G << "You are an adamantine golem. You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools. Serve [user], and assist them in completing their goals at any cost."
		qdel(src)


	proc/announce_to_ghosts()
		for(var/mob/dead/observer/G in player_list)
			if(G.client)
				var/area/A = get_area(src)
				if(A)
					G << "Golem rune created in [A.name]."

/mob/living/carbon/slime/has_eyes()
	return 0

//////////////////////////////Old shit from metroids/RoRos, and the old cores, would not take much work to re-add them////////////////////////

/*
// Basically this slime Core catalyzes reactions that normally wouldn't happen anywhere
/obj/item/slime_core
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "slime extract"
	force = 1.0
	w_class = 1.0
	throwforce = 1.0
	throw_speed = 2
	throw_range = 6
	origin_tech = "biotech=4"
	var/POWERFLAG = 0 // sshhhhhhh
	var/Flush = 30
	var/Uses = 5 // uses before it goes inert

/obj/item/slime_core/New()
		..()
		create_reagents(100)
		POWERFLAG = rand(1,10)
		Uses = rand(7, 25)
		//flags |= NOREACT
/*
		spawn()
			Life()

	proc/Life()
		while(src)
			sleep(25)
			Flush--
			if(Flush <= 0)
				reagents.clear_reagents()
				Flush = 30
*/



/obj/item/weapon/reagent_containers/food/snacks/egg/slime
	name = "slime egg"
	desc = "A small, gelatinous egg."
	icon = 'icons/mob/mob.dmi'
	icon_state = "slime egg-growing"
	bitesize = 12
	origin_tech = "biotech=4"
	var/grown = 0

/obj/item/weapon/reagent_containers/food/snacks/egg/slime/New()
	..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("slimejelly", 1)
	spawn(rand(1200,1500))//the egg takes a while to "ripen"
		Grow()

/obj/item/weapon/reagent_containers/food/snacks/egg/slime/proc/Grow()
	grown = 1
	icon_state = "slime egg-grown"
	processing_objects.Add(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/egg/slime/proc/Hatch()
	processing_objects.Remove(src)
	var/turf/T = get_turf(src)
	src.visible_message("<span class='warning'> The [name] pulsates and quivers!</span>")
	spawn(rand(50,100))
		src.visible_message("<span class='warning'> The [name] bursts open!</span>")
		new/mob/living/carbon/slime(T)
		qdel(src)


/obj/item/weapon/reagent_containers/food/snacks/egg/slime/process()
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	if (environment.phoron > MOLES_PHORON_VISIBLE)//phoron exposure causes the egg to hatch
		src.Hatch()

/obj/item/weapon/reagent_containers/food/snacks/egg/slime/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype( W, /obj/item/weapon/pen/crayon ))
		return
	else
		..()
*/
