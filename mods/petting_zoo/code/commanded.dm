/mob/living/simple_animal/hostile/commanded/rex
	var/list/possible_natural_weapon // Rex can attack with random natural weapon
	name = "Rex"
	desc = "A large.... dog?"

	icon_state = "lavadog"
	icon_living = "lavadog"
	icon_dead = "lavadog_dead"


	health = 45
	maxHealth = 45
	speed = 8

	density = TRUE

	natural_weapon = /obj/item/natural_weapon/bite
	possible_natural_weapon = list(/obj/item/natural_weapon/bite, /obj/item/natural_weapon/claws)
	can_escape = TRUE

	max_gas = list(GAS_PHORON = 10, GAS_CO2 = 10)

	response_help = "pets"
	response_harm = "bites"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow", "guard", "forget master", "obey", "forget target")
	ai_holder = /datum/ai_holder/simple_animal/melee/commanded

/mob/living/simple_animal/hostile/commanded/rex/get_natural_weapon()
	if(natural_weapon)
		qdel(natural_weapon)
	natural_weapon = pick(possible_natural_weapon)
	return ..()

/mob/living/simple_animal/hostile/commanded/rex/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)

	if(!master && istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/S = speaker
		if ("ACCESS_HEAD_OF_SECURITY" in S.GetAccess())
			master = S
			ai_holder.leader = S
			friends |= weakref(S)
			allowed_targets -= S
			S.guards += src
	..()

/mob/living/simple_animal/hostile/commanded/rex/can_use_item(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/meat) && stat != DEAD)
		if(user != master)
			visible_message(SPAN_WARNING("\The [src] started to growl"))
		else
			visible_message(SPAN_NOTICE("\The [user] start feeding the [src] [O]"))
			if(do_after(user, 30, src))
				var/prev_AI_busy = ai_holder.busy
				set_AI_busy(FALSE)
				heal_overall_damage(10, 10)
				qdel(O)
				visible_message(SPAN_NOTICE("\The [src] ate [O]"))
				set_AI_busy(prev_AI_busy)

	else
		..()

/mob/living/simple_animal/hostile/commanded/rex/attack_hand(mob/living/carbon/human/target)
	if(target.a_intent != I_HELP && retribution) //assume he wants to hurt us.
		var/dealt_damage = harm_intent_damage
		var/harm_verb = response_harm
		if(ishuman(target) && target.species)
			var/datum/unarmed_attack/attack = target.get_unarmed_attack(src)
			dealt_damage = max(dealt_damage, attack.damage)
			harm_verb = pick(attack.attack_verb)
			if(attack.sharp || attack.edge)
				adjustBleedTicks(dealt_damage)

		adjustBruteLoss(dealt_damage)
		target.visible_message(SPAN_WARNING("[target] [harm_verb] \the [src]!"))
		target.do_attack_animation(src)

		if((target == master) && prob(80))
			visible_message(SPAN_WARNING("The [src]  whines"))
			return TRUE

		target_mob = target
		allowed_targets |= target
		stance = STANCE_ATTACK
		friends |= weakref(target)
		set_AI_busy(FALSE)
		ai_holder.react_to_attack(target)
		return TRUE


	else if(target.a_intent == I_HELP)
		if((target == master) || (weakref(target) in friends))
			visible_message("<span class='notice'>The [src] wags its tail</span>")
			if(prob(20))
				say("Wuff!")
			return TRUE

		visible_message(SPAN_WARNING("\The [src] started to growl"))
		if(prob(10))
			attack_target(target)

	. = ..()

/mob/living/simple_animal/hostile/commanded/dog
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

	ai_holder = /datum/ai_holder/simple_animal/melee/commanded
	say_list_type = /datum/say_list/dog

/datum/say_list/dog
	emote_see = list("wiggles its tail warily", "scratches itself")
	emote_hear = list("woofs", "barks")
	speak = list("Bark!", "Woof!")

/mob/living/simple_animal/hostile/commanded/dog/german
	name = "german shepherd"
	real_name = "german shepherd"
	desc = "That very type of a dog that appears in everybody's mind in the first place."
	icon_state = "german_shepherd"
	icon_living = "german_shepherd"
	icon_dead = "german_shepherd_dead"

/mob/living/simple_animal/hostile/commanded/dog/german/black
	icon_state = "german_shepherd_black"
	icon_living = "german_shepherd_black"
	icon_dead = "german_shepherd_black_dead"

/mob/living/simple_animal/hostile/commanded/dog/golden_retriever
	name = "golden retriever"
	real_name = "golden retriever"
	desc = "Your perfect companion."
	icon_state = "golden_retriever"
	icon_living = "golden_retriever"
	icon_dead = "golden_retriever_dead"

/mob/living/simple_animal/hostile/commanded/dog/bullterrier
	name = "bullterrier"
	real_name = "bullterrier"
	desc = "Don't tempt this perky guy."
	icon_state = "bullterrier"
	icon_living = "bullterrier"
	icon_dead = "bullterrier_dead"
