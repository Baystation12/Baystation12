// Frost spiders inject cryotoxin, slowing people down (which is very bad if trying to run from spiders).

/mob/living/simple_animal/hostile/giant_spider/frost
	desc = "Icy and blue, it makes you shudder to look at it. This one has brilliant blue eyes."

	icon_state = "frost"
	icon_living = "frost"
	icon_dead = "frost_dead"

	maxHealth = 175
	health = 175

	poison_per_bite = 5
	poison_type = /datum/reagent/toxin/cryotoxin

	special_attack_min_range = 2
	special_attack_max_range = 5
	special_attack_cooldown = 15 SECONDS

	natural_weapon = /obj/item/natural_weapon/bite/spider/frost
	ai_holder = /datum/ai_holder/simple_animal/spider/frost

	minbodytemp = 0

/datum/ai_holder/simple_animal/spider/frost/special_attack(atom/movable/AM)
	. = ..()
	holder.visible_message(SPAN_DANGER("\The [holder] shakes rapidly as it releases freezing particles into the air!"))
	holder.shake_animation(1.5)
	set_busy(TRUE)
	addtimer(CALLBACK(src, .proc/finish_special), 2 SECONDS)

	for (var/turf/T in trange(2, get_turf(holder)))
		var/datum/gas_mixture/env = T.return_air()

		if (!env)
			return

		if (env.temperature <= 160)
			return

		env.temperature -= rand(1, 4)


/datum/ai_holder/simple_animal/spider/frost/proc/finish_special()
	set_busy(FALSE)
	holder.shake_animation(0)

/obj/item/natural_weapon/bite/spider/frost
	force = 15
