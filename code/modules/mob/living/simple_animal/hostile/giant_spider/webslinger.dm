// Webslingers do what their name implies, shoot web at enemies to slow them down.
/mob/living/simple_animal/hostile/giant_spider/webslinger
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes, and a cloak of web."

	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"
	maxHealth = 90
	health = 90

	projectile_dispersion = 1
	projectile_accuracy = -2

	projectilesound = 'sound/weapons/thudswoosh.ogg'
	projectiletype = /obj/item/projectile/webball
	base_attack_cooldown = 3 SECONDS

	natural_weapon = /obj/item/natural_weapon/bite/spider/webslinger

	poison_per_bite = 2
	poison_type = /datum/reagent/psilocybin
	ai_holder = /datum/ai_holder/simple_animal/ranged

// Check if we should bola, or just shoot the pain ball
/mob/living/simple_animal/hostile/giant_spider/webslinger/should_special_attack(atom/A)

	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		if (!H.incapacitated())
			return TRUE
	return FALSE

// Now we've got a running human in sight, time to throw the bola
/mob/living/simple_animal/hostile/giant_spider/webslinger/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	var/obj/item/projectile/bola/B = new /obj/item/projectile/bola(src.loc)
	playsound(src, 'sound/weapons/thudswoosh.ogg', 100, 1)
	if (!B)
		return
	set_AI_busy(FALSE)

/obj/item/natural_weapon/bite/spider/webslinger
	force = 8

/obj/aura/web
	name = "Webbing"
	icon = 'icons/mob/mob.dmi'
	icon_state = "web_1"
	layer = MOB_LAYER
	var/stacks = 1
	var/max_stacks = 5
	var/datum/action/remove_web/remove_webs

/obj/aura/web/New()
	. = ..()
	remove_webs = new()
	remove_webs.web = src
	remove_webs.Grant(user)

/obj/aura/web/Destroy()
	if (remove_webs)
		remove_webs.Remove(user)
		remove_webs = null

	. = ..()

/obj/aura/web/on_update_icon()
	. = ..()

	icon_state = "web_[clamp(stacks, 1, 4)]"
	user.update_icon()

/obj/aura/web/proc/add_stack()
	stacks = stacks + 1
	stacks = clamp(stacks, 1, max_stacks)

	if (stacks >= max_stacks && istype(user.loc, /turf))

		var/obj/effect/spider/cocoon/C = new(user.loc)
		user.forceMove(C)
		C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")


		user.visible_message(user,
			SPAN_WARNING("\The [user] is cocooned by all the webbing!"),
			SPAN_WARNING("You are cocooned by all the webbing!"),
			)

		for (var/mob/living/simple_animal/A in oview(user))
			if (A.ai_holder)
				var/datum/ai_holder/AI = A.ai_holder
				if (AI.target == user)
					AI.lose_target()

		return

	update_icon()

	var/mob/living/carbon/human/H = user
	if (ishuman(H))
		H.Weaken(1)

		if (prob(log(stacks)))
			H.slip("", 2)

	return TRUE

/obj/aura/web/proc/remove_stack()
	stacks = stacks - 1
	update_icon()

	if (stacks <= 0)
		Destroy()


/obj/aura/web/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if (istype(P, /obj/item/projectile/webball))
		add_stack()

/obj/aura/web/hitby(obj/O, mob/living/M)
	. = ..()
	remove_webbing(M)

/obj/aura/web/proc/remove_webbing(mob/living/M)
	if (!M)
		return

	var/body_type = "[M.isSynthetic() ? "chassis" : "body"]"
	if (istype(M) && M.a_intent == I_HELP)
		if (M == user)
			user.visible_message(
			SPAN_WARNING("\The [M] starts tearing at the webbing on their [body_type]!"),
			SPAN_WARNING("You start tearing at the webbing on your [body_type]!"),
			SPAN_WARNING("You hear the sound of something being torn up.")
			)
		else
			user.visible_message(
			SPAN_WARNING("\The [M] starts tearing at the webbing on \the [user]'s [body_type]!"),
			SPAN_WARNING("\The [M] starts tearing off the webbing on you!"),
			SPAN_WARNING("You hear the sound of something being torn up.")
			)

		if (do_after(M, 2 SECONDS, user))
			if (stacks <= 1)
				user.visible_message(
					SPAN_WARNING("\The [user] is freed from the webs!"),
					SPAN_WARNING("You are freed from the webs!"),
					SPAN_WARNING("You hear the sound of something being torn free.")
				)
			else
				user.visible_message(
					SPAN_WARNING("\The [M] tears some of the webbing off of [M == user ? "themselves" : "\the [user]"]!"),
					SPAN_WARNING("You feel some of the webbing get torn away, but you aren't free yet!"),
					SPAN_WARNING("You hear the sound of something being torn up.")
				)
			remove_stack()

/datum/action/remove_web
	name = "Remove Webs"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "stickyweb2"
	action_type = AB_INNATE
	var/obj/aura/web/web

/datum/action/remove_web/Activate()
	. = ..()

	if (web)
		web.remove_webbing(owner)

/mob/living/movement_delay()
	. = ..()

	if (!auras)
		return .

	for (var/obj/aura/web/W in auras)
		var/tally = W.stacks * 2
		return . + tally

/mob/living/attackby(obj/item/I, mob/user)
	for (var/obj/aura/web/W in auras)
		W.remove_webbing(user)
		return

	return ..()
