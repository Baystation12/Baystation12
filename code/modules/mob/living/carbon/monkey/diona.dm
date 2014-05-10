/*
  Tiny babby plant critter plus procs.
*/

//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."

/obj/item/weapon/holder/diona

	name = "diona nymph"
	desc = "It's a tiny plant critter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	slot_flags = SLOT_HEAD
	origin_tech = "magnets=3;biotech=5"

/obj/item/weapon/holder/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Del()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		del(src)

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob defines.
/mob/living/carbon/monkey/diona
	name = "diona nymph"
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
	icon_state = "nymph1"
	var/list/donors = list()
	var/ready_evolve = 0

/mob/living/carbon/monkey/diona/attack_hand(mob/living/carbon/human/M as mob)

	//Let people pick the little buggers up.
	if(M.a_intent == "help")
		if(M.species && M.species.name == "Diona")
			M << "You feel your being twine with that of [src] as it merges with your biomass."
			src << "You feel your being twine with that of [M] as you merge with its biomass."
			src.verbs += /mob/living/carbon/monkey/diona/proc/split
			src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
			src.loc = M
		else
			var/obj/item/weapon/holder/diona/D = new(loc)
			src.loc = D
			D.name = loc.name
			D.attack_hand(M)
			M << "You scoop up [src]."
			src << "[M] scoops you up."
		return

	..()

/mob/living/carbon/monkey/diona/New()

	..()
	gender = NEUTER
	dna.mutantrace = "plant"
	greaterform = "Diona"
	add_language("Rootspeak")
	src.verbs += /mob/living/carbon/monkey/diona/proc/merge

//Verbs after this point.

/mob/living/carbon/monkey/diona/proc/merge()

	set category = "Diona"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(istype(src.loc,/mob/living/carbon))
		src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))

		if(!(src.Adjacent(C)) || !(C.client)) continue

		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/D = C
			if(D.species && D.species.name == "Diona")
				choices += C

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M || !src || !(src.Adjacent(M))) return

	if(istype(M,/mob/living/carbon/human))
		M << "You feel your being twine with that of [src] as it merges with your biomass."
		src << "You feel your being twine with that of [M] as you merge with its biomass."
		src.loc = M
		src.verbs += /mob/living/carbon/monkey/diona/proc/split
		src.verbs -= /mob/living/carbon/monkey/diona/proc/merge
	else
		return

/mob/living/carbon/monkey/diona/proc/split()

	set category = "Diona"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(!(istype(src.loc,/mob/living/carbon)))
		src.verbs -= /mob/living/carbon/monkey/diona/proc/split
		return

	src.loc << "You feel a pang of loss as [src] splits away from your biomass."
	src << "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground."
	src.loc = get_turf(src)
	src.verbs -= /mob/living/carbon/monkey/diona/proc/split
	src.verbs += /mob/living/carbon/monkey/diona/proc/merge

/mob/living/carbon/monkey/diona/verb/fertilize_plant()

	set category = "Diona"
	set name = "Fertilize plant"
	set desc = "Turn your food into nutrients for plants."

	var/list/trays = list()
	for(var/obj/machinery/hydroponics/tray in range(1))
		if(tray.nutrilevel < 10)
			trays += tray

	var/obj/machinery/hydroponics/target = input("Select a tray:") as null|anything in trays

	if(!src || !target || target.nutrilevel == 10) return //Sanity check.

	src.nutrition -= ((10-target.nutrilevel)*5)
	target.nutrilevel = 10
	src.visible_message("\red [src] secretes a trickle of green liquid from its tail, refilling [target]'s nutrient tray.","\red You secrete a trickle of green liquid from your tail, refilling [target]'s nutrient tray.")

/mob/living/carbon/monkey/diona/verb/eat_weeds()

	set category = "Diona"
	set name = "Eat Weeds"
	set desc = "Clean the weeds out of soil or a hydroponics tray."

	var/list/trays = list()
	for(var/obj/machinery/hydroponics/tray in range(1))
		if(tray.weedlevel > 0)
			trays += tray

	var/obj/machinery/hydroponics/target = input("Select a tray:") as null|anything in trays

	if(!src || !target || target.weedlevel == 0) return //Sanity check.

	src.reagents.add_reagent("nutriment", target.weedlevel)
	target.weedlevel = 0
	src.visible_message("\red [src] begins rooting through [target], ripping out weeds and eating them noisily.","\red You begin rooting through [target], ripping out weeds and eating them noisily.")

/mob/living/carbon/monkey/diona/verb/evolve()

	set category = "Diona"
	set name = "Evolve"
	set desc = "Grow to a more complex form."

	if(!is_alien_whitelisted(src, "Diona") && config.usealienwhitelist)
		src << alert("You are currently not whitelisted to play as a full diona.")
		return 0

	if(donors.len < 5)
		src << "You are not yet ready for your growth..."
		return

	if(nutrition < 400)
		src << "You have not yet consumed enough to grow..."
		return

	src.split()
	src.visible_message("\red [src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.","\red You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.")

	var/mob/living/carbon/human/adult = new(get_turf(src.loc))
	adult.set_species("Diona")

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.loc = L.loc
		del(L)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)
	adult.regenerate_icons()

	adult.name = "diona ([rand(100,999)])"
	adult.real_name = adult.name
	adult.ckey = src.ckey

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)
	del(src)

/mob/living/carbon/monkey/diona/verb/steal_blood()
	set category = "Diona"
	set name = "Steal Blood"
	set desc = "Take a blood sample from a suitable donor."

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in oview(1,src))
		choices += H

	var/mob/living/carbon/human/M = input(src,"Who do you wish to take a sample from?") in null|choices

	if(!M || !src) return

	if(M.species.flags & NO_BLOOD)
		src << "\red That donor has no blood to take."
		return

	if(donors.Find(M.real_name))
		src << "\red That donor offers you nothing new."
		return

	src.visible_message("\red [src] flicks out a feeler and neatly steals a sample of [M]'s blood.","\red You flick out a feeler and neatly steal a sample of [M]'s blood.")
	donors += M.real_name
	for(var/datum/language/L in M.languages)
		languages += L

	spawn(25)
		update_progression()

/mob/living/carbon/monkey/diona/proc/update_progression()

	if(!donors.len)
		return

	if(donors.len == 5)
		ready_evolve = 1
		src << "\green You feel ready to move on to your next stage of growth."
	else if(donors.len == 3)
		universal_understand = 1
		src << "\green You feel your awareness expand, and realize you know how to understand the creatures around you."
	else
		src << "\green The blood seeps into your small form, and you draw out the echoes of memories and personality from it, working them into your budding mind."


/mob/living/carbon/monkey/diona/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (istype(other, /mob/living/carbon/human) && !speaking)
		if(languages.len >= 2) // They have sucked down some blood.
			return 1
	return ..()

/mob/living/carbon/monkey/diona/say(var/message)
	var/verb = "says"
	var/message_range = world.view

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (Muted)."
			return
	
	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	

	if(stat == 2)
		return say_dead(message)

	var/datum/language/speaking = null

	

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		if(languages.len)
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == ":[L.key]")
					verb = L.speech_verb
					speaking = L
					break

	if(speaking)
		message = trim(copytext(message,3))

	message = capitalize(trim_left(message))	

	if(!message || stat)
		return



	..(message, speaking, verb, null, null, message_range, null)
