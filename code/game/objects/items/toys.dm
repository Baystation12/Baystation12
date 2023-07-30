/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Toy bosun's whistle
 *      Toy mechs
 *		Snap pops
 *		Water flower
 *      Therapy dolls
 *      Inflatable duck
 *		Action figures
 *		Plushies
 *		Toy cult sword
 *		Marshalling wand
 *		Ring bell
 *
 *	desk toys
 */



/obj/item/toy
	icon = 'icons/obj/toy.dmi'
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0

/*
 * Balloons
 */
/obj/item/toy/water_balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon = 'icons/obj/toy.dmi'
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"

/obj/item/toy/water_balloon/New()
	create_reagents(10)
	..()

/obj/item/toy/water_balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/water_balloon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if (!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, 10)
		to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [A]."))
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/water_balloon/attackby(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/item/reagent_containers/glass))
		if (O.reagents)
			if (O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if (O.reagents.total_volume >= 1)
				if (O.reagents.has_reagent(/datum/reagent/acid/polyacid, 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, SPAN_NOTICE("You fill the balloon with the contents of [O]."))
					O.reagents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/water_balloon/throw_impact(atom/hit_atom)
	if (reagents && reagents.total_volume >= 1)
		src.visible_message(SPAN_WARNING("\The [src] bursts!"),"You hear a pop and a splash.")
		src.reagents.touch_turf(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.touch(A)
		src.icon_state = "burst"
		spawn(5)
			if (src)
				qdel(src)
	return

/obj/item/toy/water_balloon/on_update_icon()
	if (src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/balloon
	name = "\improper 'criminal' balloon"
	desc = "FUK CAPITALISM!11!"
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = ITEM_SIZE_HUGE

/obj/item/toy/balloon/New()
	..()
	desc = "Across the balloon is printed: \"[desc]\""

/obj/item/toy/balloon/nanotrasen
	name = "\improper 'motivational' balloon"
	desc = "Man, I love Profit soooo much. I use only Brand Name products. You have NO idea."
	icon_state = "ntballoon"
	item_state = "ntballoon"

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	item_icons = list(
		icon_l_hand = 'icons/mob/onmob/items/lefthand_guns.dmi',
		icon_r_hand = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 5

/obj/item/toy/crossbow/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/toy/ammo/crossbow))
		if (bullets <= 4)
			if (!user.unEquip(I))
				return
			qdel(I)
			bullets++
			to_chat(user, SPAN_NOTICE("You load the foam dart into the crossbow."))
		else
			to_chat(usr, SPAN_WARNING("It's already fully loaded."))


/obj/item/toy/crossbow/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (!isturf(target.loc) || target == user) return
	if (flag) return

	if (locate (/obj/structure/table, src.loc))
		return
	else if (bullets)
		var/turf/trg = get_turf(target)
		var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
		bullets--
		D.icon_state = "foamdart"
		D.SetName("foam dart")
		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

		for(var/i=0, i<6, i++)
			if (D)
				if (D.loc == trg) break
				step_towards(D,trg)

				for(var/mob/living/M in D.loc)
					if (!istype(M,/mob/living)) continue
					if (M == user) continue
					for(var/mob/O in viewers(world.view, D))
						O.show_message(SPAN_WARNING("\The [M] was hit by the foam dart!"), 1)
					new /obj/item/toy/ammo/crossbow(M.loc)
					qdel(D)
					return

				for(var/atom/A in D.loc)
					if (A == user) continue
					if (A.density)
						new /obj/item/toy/ammo/crossbow(A.loc)
						qdel(D)

			sleep(1)

		spawn(10)
			if (D)
				new /obj/item/toy/ammo/crossbow(D.loc)
				qdel(D)

		return
	else if (bullets == 0)
		user.Weaken(5)
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("\The [user] realized they were out of ammo and starting scrounging for some!"), 1)


/obj/item/toy/crossbow/attack(mob/M as mob, mob/user as mob)
	src.add_fingerprint(user)

// ******* Check

	if (src.bullets > 0 && M.lying)

		M.visible_message(
			SPAN_DANGER("\The [user] casually lines up a shot with \the [M]'s head and pulls the trigger!"),
			SPAN_WARNING("You hear the sound of foam against skull")
		)
		M.visible_message(SPAN_WARNING("\The [M] was hit in the head by the foam dart!"))

		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)
		new /obj/item/toy/ammo/crossbow(M.loc)
		src.bullets--
	else if (M.lying && src.bullets == 0)
		M.visible_message(SPAN_DANGER("\The [user] casually lines up a shot with \the [M]'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!"))
		user.Weaken(5)
	return

/obj/item/toy/crossbow/examine(mob/user, distance)
	. = ..()
	if (distance <= 2 && bullets)
		to_chat(user, SPAN_NOTICE("It is loaded with [bullets] foam darts!"))

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "null"
	anchored = TRUE
	density = FALSE


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons/melee_energy.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	var/active = 0.0
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")

/obj/item/toy/sword/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, SPAN_NOTICE("You extend the plastic blade with a quick flick of your wrist."))
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		src.icon_state = "swordblue"
		src.item_state = "swordblue"
		src.w_class = ITEM_SIZE_HUGE
	else
		to_chat(user, SPAN_NOTICE("You push the plastic blade back down into the handle."))
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		src.icon_state = "sword0"
		src.item_state = "sword0"
		src.w_class = initial(w_class)

	update_held_icon()

	src.add_fingerprint(user)
	return

/obj/item/toy/katana
	name = "katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "katana"
	item_state = "katana"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = ITEM_SIZE_TINY

/obj/item/toy/snappop/throw_impact(atom/hit_atom)
	..()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	new /obj/effect/decal/cleanable/ash(src.loc)
	src.visible_message(SPAN_WARNING("The [src.name] explodes!"),SPAN_WARNING("You hear a snap!"))
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if ((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if (!MOVING_DELIBERATELY(M))
			to_chat(M, SPAN_WARNING("You step on the snap pop!"))

			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(2, 0, src)
			s.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message(SPAN_WARNING("The [src.name] explodes!"),SPAN_WARNING("You hear a snap!"))
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A genuine Admiral Krush Bosun's Whistle, for the aspiring ship's captain! Suitable for ages 8 and up, do not swallow."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bosunwhistle"
	var/cooldown = 0
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

/obj/item/toy/bosunwhistle/attack_self(mob/user as mob)
	if (cooldown < world.time - 35)
		to_chat(user, SPAN_NOTICE("You blow on [src], creating an ear-splitting noise!"))
		playsound(user, 'sound/misc/boatswain.ogg', 20, 1)
		cooldown = world.time

/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	var/cooldown = 0
	w_class = ITEM_SIZE_TINY

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user as mob)
	if (cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with [src]."))
		playsound(user, 'sound/mecha/mechstep01.ogg', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user as mob)
	if (loc == user)
		if (cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with [src]."))
			playsound(user, 'sound/mecha/mechmove01.ogg', 20, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/powerloader
	name = "toy ripley"
	desc = "Mini-mech action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-mech action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-mech action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-mech action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"

/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-mech action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-mech action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-mech action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-mech action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-mech action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-mech action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-mech action figure! Collect them all! 11/11."
	icon_state = "phazonprize"

/*
 * Action figures
 */

/obj/item/toy/figure
	name = "Completely Glitched action figure"
	desc = "A \"Space Life\" brand... wait, what the hell is this thing? It seems to be requesting the sweet release of death."
	icon_state = "assistant"
	icon = 'icons/obj/toy.dmi'
	w_class = ITEM_SIZE_TINY

/obj/item/toy/figure/cmo
	name = "Chief Medical Officer action figure"
	desc = "A \"Space Life\" brand Chief Medical Officer action figure."
	icon_state = "cmo"

/obj/item/toy/figure/assistant
	name = "Assistant action figure"
	desc = "A \"Space Life\" brand Assistant action figure."
	icon_state = "assistant"

/obj/item/toy/figure/atmos
	name = "Atmospheric Technician action figure"
	desc = "A \"Space Life\" brand Atmospheric Technician action figure."
	icon_state = "atmos"

/obj/item/toy/figure/bartender
	name = "Bartender action figure"
	desc = "A \"Space Life\" brand Bartender action figure."
	icon_state = "bartender"

/obj/item/toy/figure/borg
	name = "Cyborg action figure"
	desc = "A \"Space Life\" brand Cyborg action figure."
	icon_state = "borg"

/obj/item/toy/figure/gardener
	name = "Gardener action figure"
	desc = "A \"Space Life\" brand Gardener action figure."
	icon_state = "gardener"

/obj/item/toy/figure/captain
	name = "Captain action figure"
	desc = "A \"Space Life\" brand Captain action figure."
	icon_state = "captain"

/obj/item/toy/figure/cargotech
	name = "Cargo Technician action figure"
	desc = "A \"Space Life\" brand Cargo Technician action figure."
	icon_state = "cargotech"

/obj/item/toy/figure/ce
	name = "Chief Engineer action figure"
	desc = "A \"Space Life\" brand Chief Engineer action figure."
	icon_state = "ce"

/obj/item/toy/figure/chaplain
	name = "Chaplain action figure"
	desc = "A \"Space Life\" brand Chaplain action figure."
	icon_state = "chaplain"

/obj/item/toy/figure/chef
	name = "Chef action figure"
	desc = "A \"Space Life\" brand Chef action figure."
	icon_state = "chef"

/obj/item/toy/figure/chemist
	name = "Pharmacist action figure"
	desc = "A \"Space Life\" brand Pharmacist action figure."
	icon_state = "chemist"

/obj/item/toy/figure/clown
	name = "Clown action figure"
	desc = "A \"Space Life\" brand Clown action figure."
	icon_state = "clown"

/obj/item/toy/figure/corgi
	name = "Corgi action figure"
	desc = "A \"Space Life\" brand Corgi action figure."
	icon_state = "ian"

/obj/item/toy/figure/detective
	name = "Detective action figure"
	desc = "A \"Space Life\" brand Detective action figure."
	icon_state = "detective"

/obj/item/toy/figure/dsquad
	name = "Space Commando action figure"
	desc = "A \"Space Life\" brand Space Commando action figure."
	icon_state = "dsquad"

/obj/item/toy/figure/engineer
	name = "Engineer action figure"
	desc = "A \"Space Life\" brand Engineer action figure."
	icon_state = "engineer"

/obj/item/toy/figure/geneticist
	name = "Geneticist action figure"
	desc = "A \"Space Life\" brand Geneticist action figure, which was recently dicontinued."
	icon_state = "geneticist"

/obj/item/toy/figure/hop
	name = "Head of Personel action figure"
	desc = "A \"Space Life\" brand Head of Personel action figure."
	icon_state = "hop"

/obj/item/toy/figure/hos
	name = "Head of Security action figure"
	desc = "A \"Space Life\" brand Head of Security action figure."
	icon_state = "hos"

/obj/item/toy/figure/qm
	name = "Quartermaster action figure"
	desc = "A \"Space Life\" brand Quartermaster action figure."
	icon_state = "qm"

/obj/item/toy/figure/janitor
	name = "Janitor action figure"
	desc = "A \"Space Life\" brand Janitor action figure."
	icon_state = "janitor"

/obj/item/toy/figure/agent
	name = "Internal Affairs Agent action figure"
	desc = "A \"Space Life\" brand Internal Affairs Agent action figure."
	icon_state = "agent"

/obj/item/toy/figure/librarian
	name = "Librarian action figure"
	desc = "A \"Space Life\" brand Librarian action figure."
	icon_state = "librarian"

/obj/item/toy/figure/md
	name = "Medical Doctor action figure"
	desc = "A \"Space Life\" brand Medical Doctor action figure."
	icon_state = "md"

/obj/item/toy/figure/mime
	name = "Mime action figure"
	desc = "A \"Space Life\" brand Mime action figure."
	icon_state = "mime"

/obj/item/toy/figure/miner
	name = "Shaft Miner action figure"
	desc = "A \"Space Life\" brand Shaft Miner action figure."
	icon_state = "miner"

/obj/item/toy/figure/ninja
	name = "Space Ninja action figure"
	desc = "A \"Space Life\" brand Space Ninja action figure."
	icon_state = "ninja"

/obj/item/toy/figure/wizard
	name = "Wizard action figure"
	desc = "A \"Space Life\" brand Wizard action figure."
	icon_state = "wizard"

/obj/item/toy/figure/rd
	name = "Chief Science Officer action figure"
	desc = "A \"Space Life\" brand Chief Science Officer action figure."
	icon_state = "rd"

/obj/item/toy/figure/roboticist
	name = "Roboticist action figure"
	desc = "A \"Space Life\" brand Roboticist action figure."
	icon_state = "roboticist"

/obj/item/toy/figure/scientist
	name = "Scientist action figure"
	desc = "A \"Space Life\" brand Scientist action figure."
	icon_state = "scientist"

/obj/item/toy/figure/syndie
	name = "Doom Operative action figure"
	desc = "A \"Space Life\" brand Doom Operative action figure."
	icon_state = "syndie"

/obj/item/toy/figure/secofficer
	name = "Security Officer action figure"
	desc = "A \"Space Life\" brand Security Officer action figure."
	icon_state = "secofficer"

/obj/item/toy/figure/warden
	name = "Warden action figure"
	desc = "A \"Space Life\" brand Warden action figure."
	icon_state = "warden"

/obj/item/toy/figure/psychologist
	name = "Psychologist action figure"
	desc = "A \"Space Life\" brand Psychologist action figure."
	icon_state = "psychologist"

/obj/item/toy/figure/paramedic
	name = "Paramedic action figure"
	desc = "A \"Space Life\" brand Paramedic action figure."
	icon_state = "paramedic"

/obj/item/toy/figure/ert
	name = "Emergency Response Team Commander action figure"
	desc = "A \"Space Life\" brand Emergency Response Team Commander action figure."
	icon_state = "ert"

/obj/item/toy/therapy_red
	name = "red therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is red."
	icon_state = "therapyred"
	item_state = "egg4" // It's the red egg in items_left/righthand
	w_class = ITEM_SIZE_TINY

/obj/item/toy/therapy_purple
	name = "purple therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is purple."
	icon_state = "therapypurple"
	item_state = "egg1" // It's the magenta egg in items_left/righthand
	w_class = ITEM_SIZE_TINY

/obj/item/toy/therapy_blue
	name = "blue therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is blue."
	icon_state = "therapyblue"
	item_state = "egg2" // It's the blue egg in items_left/righthand
	w_class = ITEM_SIZE_TINY

/obj/item/toy/therapy_yellow
	name = "yellow therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is yellow."
	icon_state = "therapyyellow"
	item_state = "egg5" // It's the yellow egg in items_left/righthand
	w_class = ITEM_SIZE_TINY

/obj/item/toy/therapy_orange
	name = "orange therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is orange."
	icon_state = "therapyorange"
	item_state = "egg4" // It's the red one again, lacking an orange item_state and making a new one is pointless
	w_class = ITEM_SIZE_TINY

/obj/item/toy/therapy_green
	name = "green therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is green."
	icon_state = "therapygreen"
	item_state = "egg3" // It's the green egg in items_left/righthand
	w_class = ITEM_SIZE_TINY


/*
 * Plushies
 */

/obj/structure/plushie
	abstract_type = /obj/structure/plushie
	name = "generic plush"
	desc = "A very generic plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ianplushie"
	atom_flags = ATOM_FLAG_CLIMBABLE
	anchored = FALSE
	density = TRUE
	var/phrase = "I don't want to exist anymore!"


/obj/structure/plushie/attack_hand(mob/living/user)
	var/action_word = "action"
	if (user.a_intent == I_HELP)
		action_word = "hug"
	else if (user.a_intent == I_DISARM)
		action_word = "poke"
	else if (user.a_intent == I_GRAB)
		action_word = "strangle"
	else if (user.a_intent == I_HURT)
		action_word = "bop"
	user.visible_message(
		SPAN_ITALIC("\The [user] [action_word]s \the [src]."),
		SPAN_ITALIC("You [action_word] \the [src].")
	)
	if (phrase)
		audible_message(phrase, hearing_distance = 3)
	playsound(src, 'sound/effects/rustle1.ogg', 100, 1)


/obj/structure/plushie/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon_state = "ianplushie"
	phrase = "Arf!"


/obj/structure/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smiling, and has a small tag which reads \"N.D.V. Icarus Gift Shop\"."
	icon_state = "droneplushie"
	phrase = "Beep boop!"


/obj/structure/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the Nyx frontier, now right here in your hands."
	icon_state = "carpplushie"
	phrase = "Glorf!"


/obj/structure/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleaning robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Ping!"


/obj/item/toy/plushie
	abstract_type = /obj/item/toy/plushie
	name = "generic small plush"
	desc = "A very generic small plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"
	w_class = ITEM_SIZE_SMALL


/obj/item/toy/plushie/attack_self(mob/living/user)
	var/action_word = "action"
	if (user.a_intent == I_HELP)
		action_word = "hug"
	else if (user.a_intent == I_DISARM)
		action_word = "poke"
	else if (user.a_intent == I_GRAB)
		action_word = "strangle"
	else if (user.a_intent == I_HURT)
		action_word = "bop"
	user.visible_message(
		SPAN_ITALIC("\The [user] [action_word]s \the [src]."),
		SPAN_ITALIC("You [action_word] \the [src].")
	)


/obj/item/toy/plushie/nymph
	name = "diona nymph plush"
	desc = "A plushie of an adorable diona nymph! While its level of self-awareness is still being debated, its level of cuteness is not."
	icon_state = "nymphplushie"


/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	icon_state = "mouseplushie"


/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs it's way right into your heart."
	icon_state = "kittenplushie"

/obj/item/toy/plushie/crow
	name = "crow plush"
	desc = "A plushie of an adorable crow! Caw caw."
	icon_state = "crowplushie"

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard! Very controversial, after being accused as \"racist\" by some Unathi."
	icon_state = "lizardplushie"


/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon_state = "spiderplushie"


/obj/item/toy/plushie/farwa
	name = "farwa plush"
	desc = "A farwa plush doll. It's soft and comforting!"
	icon_state = "farwaplushie"


/obj/item/toy/plushie/thoom
	name = "th'oom plush"
	desc = "A plush Th'oom with big, button eyes. It smells like mushrooms."
	icon_state = "thoomplushie"


/obj/item/toy/plushie/carp_gold
	name = "carp plush"
	desc = "A plush golden space carp. Less threatening than the real thing."
	icon_state = "carp-gold"


/obj/item/toy/plushie/carp_purple
	name = "carp plush"
	desc = "A plush purple space carp. Less threatening than the real thing."
	icon_state = "carp-purple"


/obj/item/toy/plushie/carp_pink
	name = "carp plush"
	desc = "A plush pink space carp. Less threatening than the real thing."
	icon_state = "carp-pink"


/obj/item/toy/plushie/corgi
	name = "corgi plush"
	desc = "A plush corgi. Being tiny makes it cuter."
	icon_state = "corgi"


/obj/item/toy/plushie/corgi_bow
	name = "corgi plush"
	desc = "A plush corgi with a little bow on its head. Being tiny makes it cuter."
	icon_state = "corgi-bow"


/obj/item/toy/plushie/deer
	name = "deer plush"
	desc = "A plush deer. Somehow still majestic."
	icon_state = "deer"


/obj/item/toy/plushie/squid_blue
	name = "squid plush"
	desc = "A plush blue squid. Tentacular."
	icon_state = "squid-blue"


/obj/item/toy/plushie/squid_orange
	name = "squid plush"
	desc = "A plush orange squid. Tentacular."
	icon_state = "squid-orange"


//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon (made of foam) wielded by the followers of the hit Saturday morning cartoon \"King Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = ITEM_SIZE_HUGE
	attack_verb = list("attacked", "slashed", "stabbed", "poked")

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/clothing/obj_belt.dmi'
	slot_flags = SLOT_BELT

/obj/item/marshalling_wand
	name = "marshalling wand"
	desc = "An illuminated, hand-held baton used by hangar personnel to visually signal shuttle pilots. The signal changes depending on your intent."
	icon_state = "marshallingwand"
	item_state = "marshallingwand"
	icon = 'icons/obj/toy.dmi'
	item_icons = list(
		icon_l_hand = 'icons/mob/onmob/items/lefthand.dmi',
		icon_r_hand = 'icons/mob/onmob/items/righthand.dmi',
		)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 1
	attack_verb = list("attacked", "whacked", "jabbed", "poked", "marshalled")

/obj/item/marshalling_wand/Initialize()
	set_light(0.6, 0.5, 2, 2, "#ff0000")
	return ..()

/obj/item/marshalling_wand/attack_self(mob/living/user as mob)
	playsound(src.loc, 'sound/effects/rustle1.ogg', 100, 1)
	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("[user] beckons with \the [src], signalling forward motion."),
							SPAN_NOTICE("You beckon with \the [src], signalling forward motion."))
	else if (user.a_intent == I_DISARM)
		user.visible_message(SPAN_NOTICE("[user] holds \the [src] above their head, signalling a stop."),
							SPAN_NOTICE("You hold \the [src] above your head, signalling a stop."))
	else if (user.a_intent == I_GRAB)
		var/WAND_TURN_DIRECTION
		if (user.l_hand == src) WAND_TURN_DIRECTION = "left"
		else if (user.r_hand == src) WAND_TURN_DIRECTION = "right"
		else return //how can you not be holding it in either hand?? black magic
		user.visible_message(SPAN_NOTICE("[user] waves \the [src] to the [WAND_TURN_DIRECTION], signalling a turn."),
							SPAN_NOTICE("You wave \the [src] to the [WAND_TURN_DIRECTION], signalling a turn."))
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("[user] frantically waves \the [src] above their head!"),
							SPAN_WARNING("You frantically wave \the [src] above your head!"))

/obj/item/toy/torchmodel
	name = "table-top SEV Torch model"
	desc = "This is a replica of the SEV Torch, in 1:250th scale, on a handsome wooden stand. Small lights blink on the hull and at the engine exhaust."
	icon = 'icons/obj/toy.dmi'
	icon_state = "torch_model_figure"

/obj/item/toy/ringbell
	name = "ringside bell"
	desc = "A bell used to signal the beginning and end of various ring sports."
	icon = 'icons/obj/toy.dmi'
	icon_state= "ringbell"
	anchored = TRUE

/obj/item/toy/ringbell/attack_hand(mob/user as mob)
	if (user.a_intent == I_HELP)
		user.visible_message(SPAN_NOTICE("[user] rings \the [src], signalling the beginning of the contest."))
		playsound(user.loc, 'sound/items/oneding.ogg', 60)
	else if (user.a_intent == I_DISARM)
		user.visible_message(SPAN_NOTICE("[user] rings \the [src] three times, signalling the end of the contest!"))
		playsound(user.loc, 'sound/items/threedings.ogg', 60)
	else if (user.a_intent == I_HURT)
		user.visible_message(SPAN_WARNING("[user] rings \the [src] repeatedly, signalling a disqualification!"))
		playsound(user.loc, 'sound/items/manydings.ogg', 60)

//Office Desk Toys

/obj/item/toy/desk
	name = "desk toy master"
	desc = "A object that does not exist. Parent Item"

	var/on = 0
	var/activation_sound = 'sound/effects/flashlight.ogg'

/obj/item/toy/desk/on_update_icon()
	if (on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/toy/desk/attack_self(mob/user)
	on = !on
	if (on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
	update_icon()
	return 1

/obj/item/toy/desk/newtoncradle
	name = "\improper Newton's cradle"
	desc = "An ancient 21th century super-weapon model demonstrating that Sir Isaac Newton is the deadliest sonuvabitch in space."
	icon_state = "newtoncradle"

/obj/item/toy/desk/fan
	name = "office fan"
	desc = "Your greatest fan."
	icon_state= "fan"

/obj/item/toy/desk/officetoy
	name = "office toy"
	desc = "A generic microfusion powered office desk toy. Only generates magnetism and ennui."
	icon_state= "desktoy"

/obj/item/toy/desk/dippingbird
	name = "dipping bird toy"
	desc = "An ancient human bird idol, worshipped by clerks and desk jockeys."
	icon_state= "dippybird"

// tg station ports

/obj/item/toy/eightball
	name = "magic eightball"
	desc = "A black ball with a stencilled number eight in white on the side. It seems full of dark liquid.\nThe instructions state that you should ask your question aloud, and then shake."
	icon_state = "eightball"
	w_class = ITEM_SIZE_TINY

	var/static/list/possible_answers = list(
		"It is certain",
		"It is decidedly so",
		"Without a doubt",
		"Yes, definitely",
		"You may rely on it",
		"As I see it, yes",
		"Most likely",
		"Outlook good",
		"Yes",
		"Signs point to yes",
		"Reply hazy, try again",
		"Ask again later",
		"Better not tell you now",
		"Cannot predict now",
		"Concentrate and ask again",
		"Don't count on it",
		"My reply is no",
		"My sources say no",
		"Outlook not so good",
		"Very doubtful")

/obj/item/toy/eightball/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] shakes \the [src] for a moment, and it says, \"[pick(possible_answers) ].\""))

/obj/item/toy/eightball/afterattack(obj/O, mob/user, proximity)
	. = ..()
	if (proximity)
		visible_message(SPAN_WARNING("\The [src] says, \"[pick(possible_answers) ]\" as it hits \the [O]!"))
