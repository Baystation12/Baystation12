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
/mob/living/simple_animal/hostile/giant_spider/webslinger/should_special_attack(atom/atom)
	if (!ishuman(atom))
		return FALSE
	var/mob/living/carbon/human/human = atom
	return !human.incapacitated()


// Now we've got a running human in sight, time to throw the bola
/mob/living/simple_animal/hostile/giant_spider/webslinger/do_special_attack(atom/atom)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	var/obj/item/projectile/bola/bola = new /obj/item/projectile/bola (loc)
	playsound(src, 'sound/weapons/thudswoosh.ogg', 100, 1)
	if (!bola)
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
	remove_webs = new
	remove_webs.web = src
	remove_webs.Grant(user)


/obj/aura/web/Destroy()
	if (remove_webs)
		remove_webs.Remove(user)
		remove_webs = null
	return ..()


/obj/aura/web/on_update_icon()
	. = ..()
	icon_state = "web_[clamp(stacks, 1, 4)]"
	user.update_icon()


/obj/aura/web/proc/add_stack()
	stacks = stacks + 1
	stacks = clamp(stacks, 1, max_stacks)
	if (stacks >= max_stacks && istype(user.loc, /turf))
		user.visible_message(user,
			SPAN_WARNING("\The [user] is cocooned by all the webbing!"),
			SPAN_WARNING("You are cocooned by all the webbing!"),
		)
		if (user.mob_size > MOB_SMALL)
			new /obj/structure/spider_cocoon (user.loc, user)
		else
			new /obj/item/spider_cocoon (user.loc, user)
		for (var/mob/living/simple_animal/A in oview(user))
			if (A.ai_holder)
				var/datum/ai_holder/AI = A.ai_holder
				if (AI.target == user)
					AI.lose_target()
		return
	update_icon()
	if (ishuman(user))
		user.Weaken(1)
		if (prob(log(stacks)))
			user.slip("", 2)
	return TRUE


/obj/aura/web/proc/remove_stack()
	stacks = stacks - 1
	update_icon()
	if (stacks <= 0)
		qdel(src)


/obj/aura/web/bullet_act(obj/item/projectile/projectile, def_zone)
	if (istype(projectile, /obj/item/projectile/webball))
		add_stack()


/obj/aura/web/hitby(atom/movable/movable, mob/living/living)
	remove_webbing(living)


/obj/aura/web/proc/remove_webbing(mob/living/living)
	if (!istype(living) || living.a_intent != I_HELP)
		return
	var/body = "[living.isSynthetic() ? "chassis" : "body"]"
	var/self = user == living
	var/subject = "their"
	if (user != living)
		subject = "\the [user]'s"
	living.visible_message(
		SPAN_ITALIC("\The [living] starts tearing at the webbing on [self ? "their" : "\the [user]'s"] [body]!"),
		SPAN_ITALIC("You start tearing at the webbing on [self ? "your" : "\the [user]'s"] [body]!")
	)
	if (!do_after(living, 2 SECONDS, user, DO_PUBLIC_UNIQUE))
		return
	if (stacks > 0)
		living.visible_message(
			SPAN_WARNING("\The [living] tears some of the webbing from [self ? "their" : "\the [user]'s"] [body]!"),
			SPAN_WARNING("You tear some of the webbing from [self ? "your" : "\the [user]'s"] [body]!"),
			SPAN_WARNING("You hear the sound of something being torn up.")
		)
	else
		user.visible_message(
			SPAN_WARNING("\The [living] tears the last of the webbing from [self ? "their" : "\the [user]'s"] [body]!"),
			SPAN_WARNING("You tear the last of the webbing from [self ? "your" : "\the [user]'s"] [body]!"),
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
	for (var/obj/aura/web/web in auras)
		var/tally = web.stacks * 2
		return . + tally


/mob/living/attackby(obj/item/item, mob/user)
	for (var/obj/aura/web/web in auras)
		web.remove_webbing(user)
		return
	return ..()
