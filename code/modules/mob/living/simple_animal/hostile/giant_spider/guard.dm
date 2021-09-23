/mob/living/simple_animal/hostile/giant_spider/guard
	desc = "A monstrously huge brown spider. This one has terrible red eyes."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	meat_amount = 4
	maxHealth = 200
	health = 200
	natural_weapon = /obj/item/natural_weapon/bite/spider/strong
	poison_per_bite = 5
	speed = 2
	move_to_delay = 4
	break_stuff_probability = 15
	pry_time = 6 SECONDS

	var/vengance
	var/berserking
	var/mob/living/simple_animal/hostile/giant_spider/nurse/paired_nurse

/obj/item/natural_weapon/bite/spider/strong

/datum/ai_holder/simple_animal/melee/spider/guard
	var/datum/ai_holder/simple_animal/melee/spider/nurse/paired_nurse

/datum/ai_holder/simple_animal/melee/spider/guard/find_target(list/possible_targets, has_targets_list)
	. = ..()
	var/mob/living/simple_animal/hostile/giant_spider/guard/G = holder
	G.find_nurse(possible_targets)

/mob/living/simple_animal/hostile/giant_spider/guard/Life()
	. = ..()
	if(!.)
		return FALSE
	if(berserking)
		return FALSE
	if(!paired_nurse)
		find_nurse()

/mob/living/simple_animal/hostile/giant_spider/guard/death()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/proc/divorce()
	if(paired_nurse)
		if(paired_nurse.paired_guard)
			paired_nurse.paired_guard = null
		paired_nurse = null

/mob/living/simple_animal/hostile/giant_spider/guard/proc/find_nurse()
	for(var/mob/living/simple_animal/hostile/giant_spider/nurse/N in hearers(src, 10))
		if(N.stat || N.paired_guard)
			continue
		paired_nurse = N
		paired_nurse.paired_guard = src
		ai_holder.set_follow(paired_nurse)
		return 1

/mob/living/simple_animal/hostile/giant_spider/guard/proc/go_berserk()
	audible_message(SPAN_DANGER("\The [src] chitters wildly!"))
	var/obj/item/W = get_natural_weapon()
	if(W)
		W.force = initial(W.force) + 5
	move_to_delay--
	break_stuff_probability = 45
	addtimer(CALLBACK(src, .proc/calm_down), 3 MINUTES)

/mob/living/simple_animal/hostile/giant_spider/guard/proc/calm_down()
	berserking = FALSE
	visible_message(SPAN_NOTICE("\The [src] calms down and surveys the area."))
	var/obj/item/W = get_natural_weapon()
	if(W)
		W.force = initial(W.force)
	move_to_delay++
	break_stuff_probability = 10
