/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/simple_animal/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = ITEM_SIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/slimesteroid2))
			if(enhanced == 1)
				to_chat(user, "<span class='warning'> This extract has already been enhanced!</span>")
				return ..()
			if(Uses == 0)
				to_chat(user, "<span class='warning'> You can't enhance a used extract!</span>")
				return ..()
			to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
			Uses = 3
			enhanced = 1
			qdel(O)

/obj/item/slime_extract/New()
	SSstatistics.extracted_slime_cores_amount++
	create_reagents(100)
	reagents.add_reagent(/datum/reagent/slimejelly, 30)
	..()

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

/obj/item/slime_extract/adamantine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/crystal, 10)

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
			to_chat(user, "<span class='warning'> The potion only works on baby slimes!</span>")
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, "<span class='warning'> Only baby slimes can be tamed!</span>")
			return..()
		if(M.stat)
			to_chat(user, "<span class='warning'> The slime is dead!</span>")
			return..()
		if(M.mind)
			to_chat(user, "<span class='warning'> The slime resists!</span>")
			return ..()
		var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "[M.colour] baby slime"
		pet.icon_living = "[M.colour] baby slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.SetName(newname)
		pet.real_name = newname
		qdel(src)

/obj/item/weapon/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
			to_chat(user, "<span class='warning'> The potion only works on slimes!</span>")
			return ..()
		if(M.stat)
			to_chat(user, "<span class='warning'> The slime is dead!</span>")
			return..()
		if(M.mind)
			to_chat(user, "<span class='warning'> The slime resists!</span>")
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.SetName(newname)
		pet.real_name = newname
		qdel(src)


/obj/item/weapon/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			to_chat(user, "<span class='warning'> The steroid only works on baby slimes!</span>")
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, "<span class='warning'> Only baby slimes can use the steroid!</span>")
			return..()
		if(M.stat)
			to_chat(user, "<span class='warning'> The slime is dead!</span>")
			return..()
		if(M.cores == 3)
			to_chat(user, "<span class='warning'> The slime already has the maximum amount of extract!</span>")
			return..()

		to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
		M.cores = 3
		qdel(src)

/obj/item/weapon/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

/obj/item/weapon/slimesteroid2/afterattack(obj/target, mob/user , flag)
	if(istype(target, /obj/item/slime_extract))
		var/obj/item/slime_extract/extract = target
		if(extract.enhanced == 1)
			to_chat(user, "<span class='warning'> This extract has already been enhanced!</span>")
			return ..()
		if(extract.Uses == 0)
			to_chat(user, "<span class='warning'> You can't enhance a used extract!</span>")
			return ..()
		to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
		extract.Uses = 3
		extract.enhanced = 1
		qdel(src)

/obj/effect/golemrune
	anchored = 1
	desc = "a strange rune used to create golems. It glows when it can be activated."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = RUNE_LAYER

/obj/effect/golemrune/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/golemrune/Process()
	var/mob/observer/ghost/ghost
	for(var/mob/observer/ghost/O in src.loc)
		if(!O.client)	continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
		ghost = O
		break
	if(ghost)
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/attack_hand(mob/living/user as mob)
	var/mob/observer/ghost/ghost
	for(var/mob/observer/ghost/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, SPAN_WARNING("The rune fizzles uselessly."))
		return
	visible_message(SPAN_WARNING("A craggy humanoid figure coalesces into being!"))

	var/mob/living/carbon/human/G = new(src.loc)
	G.set_species("Golem")
	G.key = ghost.key

	var/obj/item/weapon/implant/translator/natural/I = new()
	I.implant_in_mob(G, BP_HEAD)
	if (user.languages.len)
		var/datum/language/lang = user.languages[1]
		G.add_language(lang.name)
		G.set_default_language(lang)
		I.languages[lang.name] = 1

	to_chat(G, FONT_LARGE(SPAN_BOLD("You are a golem. Serve [user] and assist them at any cost.")))
	to_chat(G, SPAN_ITALIC("You move slowly and are vulnerable to trauma, but are resistant to heat and cold."))
	qdel(src)


/obj/effect/golemrune/proc/announce_to_ghosts()
	for(var/mob/observer/ghost/G in GLOB.player_list)
		if(G.client)
			var/area/A = get_area(src)
			if(A)
				to_chat(G, "Golem rune created in [A.name].")

