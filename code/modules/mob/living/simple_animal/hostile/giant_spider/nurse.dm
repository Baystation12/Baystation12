// Nurses, they create webs and eggs.
// They're fragile but their attacks can cause horrifying consequences.


/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "Furry and beige, it makes you shudder to look at it. This one has brilliant green eyes."

	icon_state = "nurse"
	icon_living = "nurse"
	icon_dead = "nurse_dead"

	maxHealth = 40
	health = 40

	movement_cooldown = 5	// A bit faster so that they can inject the eggs easier.

	poison_per_bite = 5
	poison_type = /datum/reagent/soporific

	natural_weapon = /obj/item/natural_weapon/bite/spider/nurse

	ai_holder_type = /datum/ai_holder/simple_animal/melee/nurse_spider

	var/fed = 0 // Counter for how many egg laying 'charges' the spider has.
	var/laying_eggs = FALSE	// Only allow one set of eggs to be laid at once.
	var/egg_inject_chance = 25 // One in four chance to get eggs.
	var/egg_type = /obj/effect/spider/eggcluster
	var/web_type = /obj/effect/spider/stickyweb/dark

	var/mob/living/simple_animal/hostile/giant_spider/guard/paired_guard

/obj/item/natural_weapon/bite/spider/nurse
	force = 10

/datum/ai_holder/simple_animal/melee/nurse_spider
	mauling = TRUE		// The nurse puts mobs into webs by attacking, so it needs to attack in crit
	handle_corpse = TRUE	// Lets the nurse wrap dead things

/mob/living/simple_animal/hostile/giant_spider/nurse/inject_poison(mob/living/L, target_zone)
	..() // Inject the stoxin here.
	if(ishuman(L) && prob(egg_inject_chance))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/external/O = H.get_organ(target_zone)
		if(O)
			var/eggcount = 0
			for(var/obj/effect/spider/eggcluster/E in O.implants)
				eggcount++
			if(!eggcount)
				var/eggs = new egg_type(O, src)
				O.implants += eggs
				to_chat(H, "<span class='critical'>\The [src] injects something into your [O.name]!</span>") // Oh god its laying eggs in me!

// Webs target in a web if able to.
/mob/living/simple_animal/hostile/giant_spider/nurse/attack_target(atom/A)
	if(isturf(A))
		if(fed)
			if(!laying_eggs)
				return lay_eggs(A)
		return web_tile(A)

	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			return ..()

	if(!istype(A, /atom/movable))
		return
	var/atom/movable/AM = A

	if(AM.anchored)
		return ..()


	return spin_cocoon(AM)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/spin_cocoon(atom/movable/AM)
	if(!istype(AM) || istype(AM, /obj/item))
		return FALSE // We can't cocoon walls sadly.

	if (AM in contents)
		return

	visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance around \the [AM].") )

	// Get our AI to stay still.
	set_AI_busy(TRUE)

	if(!do_after(src, 5 SECONDS, AM))
		set_AI_busy(FALSE)
		return FALSE

	set_AI_busy(FALSE)

	if(!AM || !isturf(AM.loc) || !Adjacent(AM))
		return FALSE

	// Finally done with the checks.
	var/obj/effect/spider/cocoon/C = new(AM.loc)
	var/large_cocoon = FALSE
	for(var/mob/living/L in C.loc)
		if(istype(L, /mob/living/simple_animal/hostile/giant_spider)) // Cannibalism is bad.
			continue
		fed++
		visible_message(SPAN_WARNING("\The [src] sticks a proboscis into \the [L], and sucks a viscous substance out."))
		L.forceMove(C)
		large_cocoon = TRUE
		break

	// This part's pretty stupid.
	for(var/obj/O in C.loc)
		if(!O.anchored)
			O.forceMove(C)

	if(large_cocoon)
		C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")

	ai_holder.target = null

	return TRUE

/mob/living/simple_animal/hostile/giant_spider/nurse/handle_special()
	set waitfor = FALSE
	if(get_AI_stance() == STANCE_IDLE && !is_AI_busy() && isturf(loc))
		if(fed)
			lay_eggs(loc)
		else
			web_tile(loc)

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/web_tile(turf/T)
	if(!istype(T))
		return FALSE

	var/obj/effect/spider/stickyweb/W = locate() in T
	if(W)
		return FALSE // Already got webs here.

	visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance."))
	// Get our AI to stay still.
	set_AI_busy(TRUE)

	if(!do_after(src, 5 SECONDS, T))
		set_AI_busy(FALSE)
		return FALSE

	W = locate() in T
	if(W)
		return FALSE // Spamclick protection.

	set_AI_busy(FALSE)
	new web_type(T)
	return TRUE


/mob/living/simple_animal/hostile/giant_spider/nurse/proc/lay_eggs(turf/T)
	if(!istype(T))
		return FALSE

	if(!fed)
		return FALSE

	var/obj/effect/spider/eggcluster/E = locate() in T
	if(E)
		return FALSE // Already got eggs here.

	visible_message(SPAN_NOTICE("\The [src] begins to lay a cluster of eggs."))
	// Get our AI to stay still.
	set_AI_busy(TRUE)
	// Stop players from spamming eggs.
	laying_eggs = TRUE

	if(!do_after(src, 5 SECONDS, T))
		set_AI_busy(FALSE)
		return FALSE

	E = locate() in T
	if(E)
		return FALSE // Spamclick protection.

	set_AI_busy(FALSE)
	new egg_type(T)
	fed--
	laying_eggs = FALSE
	return TRUE

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/divorce()
	if(paired_guard)
		if(paired_guard.paired_nurse)
			paired_guard.paired_nurse = null
	paired_guard = null

// Variant that 'blocks' light (by being a negative light source).
// This is done to make webbed rooms scary and allow for spiders on the other side of webs to see prey.
/obj/effect/spider/stickyweb/dark
	name = "dense web"
	desc = "It's sticky, and blocks a lot of light."

/obj/effect/spider/stickyweb/dark/Initialize()
	. = ..()
	set_light(-1, 0.5, 1, 1, l_color = "#ffffff")

// The AI for nurse spiders. Wraps things in webs by 'attacking' them.
/datum/ai_holder/simple_animal/melee/nurse_spider
	wander = TRUE
	base_wander_delay = 8
	cooperative = FALSE // So we don't ask our spider friends to attack things we're webbing. This might also make them stay at the base if their friends find tasty explorers.
	returns_home = TRUE

// Get us unachored objects as an option as well.
/datum/ai_holder/simple_animal/melee/nurse_spider/list_targets()
	. = ..()

	var/static/alternative_targets = typecacheof(list(/obj/structure))

	for(var/AT in typecache_filter_list(range(vision_range, holder), alternative_targets))
		var/obj/O = AT
		if(can_see(holder, O, vision_range) && !O.anchored)
			. += O

// Select an obj if no mobs are around.
/datum/ai_holder/simple_animal/melee/nurse_spider/pick_target(list/targets)
	var/mobs_only = locate(/mob/living) in targets // If a mob is in the list of targets, then ignore objects.
	if(mobs_only)
		for(var/A in targets)
			if(!isliving(A))
				targets -= A

	return ..(targets)

/datum/ai_holder/simple_animal/melee/nurse_spider/can_attack(atom/movable/the_target, vision_required = TRUE)
	. = ..()
	if (!.) // Parent returned FALSE.
		if (istype(the_target, /obj))
			var/obj/O = the_target
			if (!O.anchored)
				return TRUE
