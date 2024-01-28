/mob/living/simple_animal/butterfly
	name = "butterfly"
	desc = "A colorful butterfly, how'd it get up here?"
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "butterfly"
	icon_living = "butterfly"
	icon_dead = "butterfly_dead"
	turns_per_move = 1
	response_help = "shoos"
	response_disarm = "brushes aside"
	response_harm = "squashes"
	maxHealth = 2
	health = 2
	harm_intent_damage = 1
	friendly = "nudges"
	density = FALSE
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	mob_size = MOB_MINISCULE
	say_list_type = /datum/say_list/butterfly
	ai_holder = /datum/ai_holder/simple_animal/passive

/mob/living/simple_animal/butterfly/New()
	..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))

/datum/say_list/butterfly
	emote_see = list("flutters")

// New big cats. And i'm don't allow you to copypaste whole parent code, Leroy. Not like this

/mob/living/simple_animal/friendly/cat/maine_coon
	name = "maine coon"
	desc = "What a hell of a cat!"
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "maine_coon"
	item_state = "maine_coon"
	icon_living = "maine_coon"
	icon_dead = "maine_coon_dead"
	gender = NEUTER

// What time is it? IT'S WAR CRIME TIME
/mob/living/simple_animal/friendly/cat/floppa
	name = "caracal"
	desc = "Well-known for distinctive tassels on its ears and a strong urge for dumplings."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "caracal"
	item_state = "caracal"
	icon_living = "caracal"
	icon_dead = "caracal_dead"
	default_pixel_x = -16
	pixel_x = -16
	gender = MALE
	say_list_type = /datum/say_list/cat/floppa
	ai_holder = /datum/ai_holder/simple_animal/passive/cat

/datum/say_list/cat/floppa
	emote_see = list("flaps its ears", "gnashes", "shakes its head")
	emote_hear = list("chirps", "hisses")
	speak = list("HSSSSS", "Maow!")

// Dogs. Some kind of happinies is measured out in miles. What makes you think you're something special when you smile?

/mob/living/simple_animal/friendly/dogs
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	speak_emote = list("barks", "woofs")
	turns_per_move = 10
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	mob_size = 15
	possession_candidate = 1
	pass_flags = PASS_FLAG_TABLE
	density = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/corgi
	meat_amount = 5
	skin_material = MATERIAL_SKIN_FUR_ORANGE

	var/obj/item/inventory_head
	var/obj/item/inventory_back

	ai_holder = /datum/ai_holder/simple_animal/passive/corgi
	say_list_type = /datum/say_list/dog

/datum/say_list/dog
	emote_see = list("wiggles its tail warily", "scratches itself")
	emote_hear = list("woofs", "barks")
	speak = list("Bark!", "Woof!")

/mob/living/simple_animal/friendly/dogs/pug // Some kind of solitude is measured out in you
	name = "pug"
	real_name = "pug"
	desc = "It's a pug."
	icon_state = "pug"
	icon_living = "pug"
	icon_dead = "pug_dead"
	mob_size = 8

	meat_amount = 2

	ai_holder = /datum/ai_holder/simple_animal/passive/corgi
	say_list_type = /datum/say_list/corgi 							//we don't need repeat main say list here, aren't we?

/mob/living/simple_animal/friendly/dogs/shiba_inu
	name = "shiba inu"
	real_name = "shiba inu"
	desc = "This good boy demonstrates noticeably high intelligence."
	icon_state = "shiba_inu"
	icon_living = "shiba_inu"
	icon_dead = "shiba_inu_dead"

// Big Mon'keigh, ahem, just a normal gorilla

/mob/living/simple_animal/hostile/gorilla
	name = "gorilla"
	desc = "A ground-dwelling, predominantly herbivorous ape that inhabits the tropic forests."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "gorilla"
	icon_living = "gorilla"
	icon_dead = "gorilla_dead"
	maxHealth = 220
	health = 220
	speed = 0.2
	mob_size = MOB_LARGE
	natural_weapon = /obj/item/natural_weapon/giant
	break_stuff_probability = 80
	melee_attack_delay = 5 SECOND
	attacktext = list("smashed", "whacked", "smacked")
	attack_sound = list('sound/weapons/genhit1.ogg',
						'sound/weapons/punch1.ogg')
	possession_candidate = 1
	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list_type = /datum/say_list/gorilla


/datum/say_list/gorilla
	emote_see = list("stares menacingly", "scratches its chest")
	emote_hear = list("growls menacingly")

/datum/ai_holder/simple_animal/melee/gorilla/engage_target()
	. = ..()

	var/mob/living/L = .
	if(istype(L))
		if(prob(90))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

// It's Wednesday, my dudes
/mob/living/simple_animal/friendly/frog
	name = "frog"
	desc = "They seem a little sad."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "frog"
	icon_living = "frog"
	icon_dead = "frog_dead"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	turns_per_move = 5
	maxHealth = 15
	health = 15
	harm_intent_damage = 10
	density = FALSE
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	say_list_type = /datum/say_list/frog
	ai_holder = /datum/ai_holder/simple_animal/passive

/mob/living/simple_animal/friendly/frog/venomous
	name = "rare frog"
	desc = "They seem a little smug."
	icon_state = "frog_venomous"
	icon_living = "frog_venomous"
	icon_dead = "frog_venomous_dead"
	natural_weapon = /obj/item/natural_weapon/bite/weak
	///How much of a reagent the mob injects on attack
	var/poison_per_bite = 3
	///What reagent the mob injects targets with
	var/poison_type = /datum/reagent/toxin/cyanide

/datum/say_list/frog
	speak = list("ribbit","croak")
	emote_see = list("hops in a circle.", "shakes.")

/mob/living/simple_animal/friendly/rabbit
	name = "\improper rabbit"
	desc = "He do be hoppin doe"
	gender = PLURAL
	health = 15
	maxHealth = 15
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "rabbit"
	icon_living = "rabbit"
	icon_dead = "rabbit_dead"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	density = FALSE
	turns_per_move = 3
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	say_list_type = /datum/say_list/rabbit
	ai_holder = /datum/ai_holder/simple_animal/passive

	var/body_color

/datum/say_list/rabbit
	speak = list("sniffles","twitches")
	emote_hear = list("hops.")
	emote_see = list("hops around","bounces up and down")

/mob/living/simple_animal/friendly/rabbit/New()
	..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "rabbit_[body_color]"
	icon_living = "rabbit_[body_color]"
	icon_dead = "rabbit_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

// A ya seen dis?
/mob/living/simple_animal/hostile/retaliate/kangaroo
	name = "kangaroo"
	real_name = "kangaroo"
	desc = "A large marsupial herbivore. It has powerful hind legs, with nails that resemble long claws."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "kangaroo" // Credit: FoS
	icon_living = "kangaroo"
	icon_dead = "kangaroo_dead"
	turns_per_move = 8
	response_help = "pets the"
	response_disarm = "gently pushes aside"
	response_harm = "hits the"
	maxHealth = 150
	health = 150
	harm_intent_damage = 10
	natural_weapon = /obj/item/natural_weapon/claws/strong
	attacktext = list("kicks", "leaps onto")
	attack_sound = 'sound/weapons/bladeslice.ogg' // they have nails that work like claws, so, slashing sound
	melee_attack_delay = 2 SECOND
	move_to_delay = 4 // at 20ticks/sec, this is 5 tile/sec movespeed, about the same as a 'fast human'.
	speed = -1 // '-1' converts to 1.5 total move delay, or 6.6 tiles/sec movespeed
	can_escape = TRUE
	ai_holder = /datum/ai_holder/simple_animal/retaliate

// Hey, pink guy from local pond, you better have this dependencies working clear, because you far from your parent type
/mob/living/simple_animal/friendly/lizard/axolotl
	name = "axolotl"
	desc = "A cute tiny axolotl. And it's just like you - has no brain as well!"
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "axolotl"
	icon_living = "axolotl"
	icon_dead = "axolotl_dead"

// TG breached contaiment, call MTF
/mob/living/simple_animal/friendly/megamoth
	name = "big moff"
	desc = "Keep it away from fire."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "megamoth"
	icon_living = "megamoth"
	icon_dead = "megamoth_dead"
	turns_per_move = 5
	see_in_dark = 6
	health = 5
	maxHealth = 5
	natural_weapon = /obj/item/natural_weapon/bite/weak
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	density = FALSE
	ai_holder = /datum/ai_holder/simple_animal/passive
	say_list_type = /datum/say_list/megamoth

/datum/say_list/megamoth
	emote_see = list("taps its paws", "ruffles its fur", "flaps its wings")
	emote_hear = list("sizzles softly")

// Big cats. This one don't like you
/mob/living/simple_animal/hostile/panther
	name = "panther"
	desc = "A long sleek, black cat with sharp teeth and claws."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther_dead"
	icon_rest = "panther_rest"
	icon_gib = "panther_dead"
	speed = 2.5
	turns_per_move = 3
	default_pixel_x = -16
	pixel_x = -16
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 3
	bone_amount = 5
	skin_amount = 10
	skin_material = MATERIAL_SKIN_FUR_HEAVY
	response_help = "pets the"
	response_disarm = "gently pushes aside"
	response_harm = "hits the"
	maxHealth = 80
	health = 80
	natural_weapon = /obj/item/natural_weapon/claws/strong
	can_escape = TRUE
	melee_attack_delay = 0.5 SECOND
	attacktext = list("clawed", "chomped")
	harm_intent_damage = 5
	attack_sound = 'sound/weapons/bite.ogg'
	possession_candidate = 1

	see_in_dark = 8

	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list_type = /datum/say_list/panther

/datum/say_list/panther
	emote_see = list("grooms its fur", "stretches", "wiggles its tail warily")
	emote_hear = list("meows gruntly", "yawns", "hisses", "gnashes")

/datum/ai_holder/simple_animal/melee/panther/engage_target()
	. = ..()

	var/mob/living/L = .
	if(istype(L))
		if(prob(25))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/panther/on_update_icon()
	. = ..()
	return

/mob/living/simple_animal/hostile/panther/get_natural_weapon()
	if(natural_weapon)
		qdel(natural_weapon)
	natural_weapon = /obj/item/natural_weapon/claws/strong
	return ..()

/mob/living/simple_animal/hostile/panther/lion
	name = "lion"
	desc = "The proud bearer of his majestic mane."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "lion"
	icon_living = "lion"
	icon_dead = "lion_dead"
	icon_gib = "lion_dead"
	default_pixel_x = -16
	pixel_x = -16
	gender = MALE

// Kovalski, analysis
/mob/living/simple_animal/penguin
	name = "penguin"
	real_name = "penguin"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	faction = list("penguin")
	see_in_dark = 5
	turns_per_move = 10
	density = FALSE
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	ai_holder = /datum/ai_holder/simple_animal/passive

/mob/living/simple_animal/penguin/emperor
	name = "emperor penguin"
	real_name = "penguin"
	desc = "Emperor of all he surveys."

	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	say_list_type = /datum/say_list/penguin
	maxHealth = 15
	health = 15
	harm_intent_damage = 3

/datum/say_list/penguin
	speak = list("Gah Gah!", "NOOT NOOT!", "NOOT!", "Noot", "noot", "Prah!", "Grah!")
	emote_hear = list("squawk!", "gakkers!", "noots.","NOOTS!")
	emote_see = list("shakes its beak.", "flaps it's wings.","preens itself.")

/mob/living/simple_animal/penguin/baby
	name = "penguin chick"
	real_name = "penguin"
	desc = "Can't fly and barely waddles, but is the prince of all chicks."
	icon_state = "penguin_baby"
	icon_living = "penguin_baby"
	icon_dead = "penguin_baby_dead"
	mob_size = MOB_MINISCULE
	say_list_type = /datum/say_list/penguin/baby
	maxHealth = 5
	health = 5
	harm_intent_damage = 2

/datum/say_list/penguin/baby
	speak = list("gah", "noot noot", "noot!", "noot", "squeee!", "noo!")
	emote_see = list("shakes its beak.", "flaps it's wings.","preens itself.")

/mob/living/simple_animal/penguin/baby/pet
	name = "Major Willy"
	desc = "The talisman and example of productivity for all cargo workers."
	say_list_type = /datum/say_list/penguin/baby/pet

/datum/say_list/penguin/baby/pet
	speak = list("gah", "noot noot", "noot!", "noot", "squeee!", "noo!", "GET TO WORK THIS FUCKING INSTANT YOU DARN SLEEPY MAGGOTS!")
	emote_see = list("shakes its beak.", "flaps it's wings.","preens itself.")

// I think i little late for X-mas with this code. But anyway, this comments made for easier splitting different types of beasts, isn't it?
/mob/living/simple_animal/hostile/retaliate/reindeer
	name = "reindeer"
	desc = "The king of tundra, extremely endurant beast."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "reindeer"
	icon_living = "reindeer"
	icon_dead = "reindeer_dead"
	maxHealth = 80
	health = 80
	harm_intent_damage = 5
	speed = 2.5
	turns_per_move = 3
	default_pixel_x = -16
	pixel_x = -16
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 3
	bone_amount = 5
	skin_amount = 10
	skin_material = MATERIAL_SKIN_FUR_HEAVY
	response_help = "pets the"
	response_disarm = "gently pushes aside"
	response_harm = "hits the"
	natural_weapon = /obj/item/natural_weapon/large

	ai_holder = /datum/ai_holder/simple_animal/retaliate

/datum/ai_holder/simple_animal/melee/reindeer/engage_target()
	. = ..()

	var/mob/living/L = .
	if(istype(L))
		if(prob(25))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/panther/on_update_icon()
	. = ..()
	return

/mob/living/simple_animal/hostile/panther/get_natural_weapon()
	if(natural_weapon)
		qdel(natural_weapon)
	natural_weapon = /obj/item/natural_weapon/claws/strong
	return ..()

// And worker from HR NT Department
/mob/living/simple_animal/pet/sloth
	name = "sloth"
	desc = "An adorable, sleepy creature. Still twice more productive than most of the crewmembers."
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x32.dmi'
	icon_state = "sloth"
	icon_living = "sloth"
	icon_dead = "sloth_dead"
	gender = MALE
	turns_per_move = 5
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	health = 25
	maxHealth = 25
	speed = 0.2
	say_list_type = /datum/say_list/sloth
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	density = TRUE
	ai_holder = /datum/ai_holder/simple_animal/passive

/datum/say_list/sloth
	speak = list("Ahhhh...")
	emote_hear = list("snores.","yawns.")
	emote_see = list("dozes off.", "looks around sleepily.")


// Override of legacy space bear
/mob/living/simple_animal/hostile/bear
	icon = 'mods/petting_zoo/icons/leroy_beasts_32x64.dmi'
	icon_state = "brown_bear"
	icon_living = "brown_bear"
	icon_dead = "brown_bear_dead"
	icon_gib = "bear_gib"
	default_pixel_x = -16
	pixel_x = -16
