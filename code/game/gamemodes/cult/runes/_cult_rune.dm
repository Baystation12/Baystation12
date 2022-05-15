//Cultic runes
/obj/effect/rune
	name = "cultic rune"
	desc = "A strange collage of symbols."

	icon = 'icons/effects/uristrunes.dmi'
	icon_state = "blank"
	layer = RUNE_LAYER
	var/strokes = 2 // IF YOU EVER SET THIS TO MORE THAN TEN, EVERYTHING WILL BREAK

	unacidable = TRUE
	anchored = TRUE

	var/blood_name
	var/rune_type = "mundane"

	var/list/mob/living/cultists //both acolytes and the caster

	var/cast_time = 0 SECONDS
	var/mob/living/caster //Who is leading the casting

	var/required_acolytes = 0 //How many assistants need to be surrounding the rune
	var/acolyte_range = 1 //How far can the acolytes be
	var/list/mob/living/acolytes
	var/acolytes_free = FALSE //Can acolytes freely move during the spell

	var/tome_written = FALSE //Does this need a tome to be made?
	var/tome_cast = FALSE //Does the caster need their tome to cast it
	var/acolytes_tome_cast = FALSE //Do all the accolytes need their tome to cast it

	var/infinite = FALSE //Can it be reused infinitely?
	var/activations = 1 //If the above is false, how many activations does it have?

	var/blood_written
	var/blood_cost = 0 //How much blood does it cost to use?

	var/active = FALSE //Determines whether people are reciting things right now
	var/list/active_chants = list(
		"By the will of the Dark One!",
		"Through the Dark One's power!",
		"Under the Geometer's truth!",
		"Yes, yes, yes!"
	)
	var/last_active_chant

	var/incantation_chant = "I cast such!" //The final chant

/obj/effect/rune/New(loc, mob/writer) //Override only for identifying species blood information
	if(writer && istype(writer, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = writer
		color = H.blood_color
		blood_name = H.get_blood_name()
	else
		color = COLOR_BLOOD_HUMAN
		blood_name = "blood"
	..()

/obj/effect/rune/Initialize()
	..()
	update_icon() //Updates color & pattern
	set_extension(src, /datum/extension/turf_hand, 10)

/obj/effect/rune/on_update_icon()
	overlays.Cut()
	if(GLOB.cult.rune_strokes[type])
		var/list/f = GLOB.cult.rune_strokes[type]
		for(var/i in f)
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[i]")
			overlays += t
	else
		var/list/q = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		var/list/f = list()
		for(var/i = 1 to strokes)
			var/j = pick(q)
			f += j
			q -= f
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[j]")
			overlays += t
		GLOB.cult.rune_strokes[type] = f.Copy()

/obj/effect/rune/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_WARNING("It's drawn in [blood_name]."))

	if(iscultist(user))
		to_chat(user, SPAN_INFO("This is <b>\a [rune_type] rune</b> of the Dark One's scripture. Using harm intent will erase the rune."))

/obj/effect/rune/Process()
	..()
	if(active)
		for(var/mob/living/M in acolytes)
			var/chant = pick(active_chants)
			speak_incantation(M, chant)
		last_active_chant = world.time

//Null rod effect
/obj/effect/rune/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/nullrod))
		user.visible_message(
			SPAN_NOTICE("[user] hits \the [src] with \the [I], and it disappears, fizzling."),
			SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [I]."),
			"You hear a fizzle."
		)
		qdel(src)
		return
	..()

//Casting or erasing
/obj/effect/rune/attack_hand(mob/living/user)
	if(iscultist(user))
		to_chat(user, SPAN_NOTICE("You begin to manipulate \the [src]."))

		if(user.a_intent == I_HURT) //Erase it by hand with a progress bar
			user.visible_message(
				SPAN_WARNING("<b>[user]</b> begins doing <b>something</b> with \the [src]."),
				SPAN_NOTICE("You begin slowly erasing \the [src] with your bare hands.")
			)

			if(do_after(user, 4 SECONDS, src, DO_DEFAULT))
				user.visible_message(
					SPAN_WARNING("[user] retraces \the [src] with \his fingertips, and it disappears quietly."),
					SPAN_NOTICE("You finish erasing \the [src] with your bare hands.")
				)

				qdel(src)
			return

		var/success = attempt_cast(user)
		if(!success)
			fizzle(user)

	else
		to_chat(user, SPAN_WARNING("You can't even begin to understand these symbols."))

/obj/effect/rune/proc/attempt_cast(mob/living/user) //THAT'S A LOT OF IF()
	if(user.silent) //No voice?
		to_chat(user, SPAN_WARNING("You try to recite the incantations, however you can't."))
		return FALSE

	if(istype(user, /mob/living/carbon/human)) //Prevent runtime with the theoretical impossiblity that a non-human mob attempted casting
		var/mob/living/carbon/human/H = user

		if(istype(H.wear_mask, /obj/item/clothing/mask/muzzle))
			to_chat(user, SPAN_WARNING("You try to recite the incantations, however your mouth is muzzled."))
			return FALSE

	if(tome_cast && !istype(user.get_active_hand(), /obj/item/book/tome) && !istype(user.get_inactive_hand(), /obj/item/book/tome))
		to_chat(user, SPAN_WARNING("You need your tome's knowledge to cast \the [src]."))

	caster = user
	acolytes = get_acolytes()

	if(length(acolytes) < required_acolytes)
		to_chat(user, SPAN_WARNING("It takes <b>[required_acolytes - length(acolytes)] more [acolytes_tome_cast ? "acolytes with tomes" : "acolytes"]</b> to recite the incantations."))
		return FALSE

	active = TRUE

	if(cast_time) //If there is cast time, force them to wait
		visible_message(
			SPAN_WARNING("<b>[caster]</b> begins doing <b>something</b> with \the [src]."),
			SPAN_NOTICE("You begin to activate \the [rune_type] rune with your bare hands."),
			"You hear chanting."
		)

		for(var/mob/living/cultist in cultists)
			if(!acolytes_free)
				if(do_after(cultist, cast_time, src, DO_DEFAULT))
					cast()
					return TRUE
				else
					to_chat(cultist, SPAN_WARNING("You and the other cultists must stand still to activate \the [src]!"))
					return FALSE
			else
				break

		if(do_after(user, cast_time, src, DO_DEFAULT))
			user.visible_message(
				SPAN_WARNING("<b>[caster]</b> chants and \the [src] activates!"),
				SPAN_NOTICE("You activate \the [rune_type] rune."),
				"You hear chanting stop."
			)
			cast()
			return TRUE
		else
			return FALSE

	cast()
	return TRUE


/obj/effect/rune/proc/cast()
	speak_incantation(caster, incantation_chant)
	caster = null
	acolytes = null
	cultists = null

/obj/effect/rune/proc/get_acolytes()
	. = list()
	for(var/mob/living/M in range(acolyte_range))
		if(iscultist(M) && M.stat != DEAD && !M == caster) //Must be an alive non-caster cultist
			if(acolytes_tome_cast && !istype(M.get_active_hand(), /obj/item/book/tome) && !istype(M.get_inactive_hand(), /obj/item/book/tome)) //Tome required and no tome?
				continue
			else
				. += M
/obj/effect/rune/proc/fizzle(mob/living/user)
	user.visible_message(
		SPAN_WARNING("\The [src] pulses and fizzles with a small burst of light."),
		SPAN_WARNING("\The [src] simply pulses and crackles with your failure."),
		"You hear a fizzle."
	)

//Makes the speech a proc so all verbal components can be easily manipulated as a whole, or individually easily
/obj/effect/rune/proc/speak_incantation(mob/living/user, incantation)
	var/datum/language/L = all_languages[LANGUAGE_CULT]
	if(incantation && (L in user.languages))
		user.say(incantation, L)

//Any rune that requires a target ON the rune
/obj/effect/rune/targeted
	var/targeted = FALSE
	var/mob/target

/obj/effect/rune/targeted/attempt_cast(mob/living/user)
	target = get_target()

	if(targeted && !target)
		to_chat(user, SPAN_WARNING("There is no victim on \the [src]."))
		return FALSE
	..()

/obj/effect/rune/targeted/proc/get_target()
	for(var/mob/living/carbon/human/H in loc) //Just get the first one
		target = H
		break