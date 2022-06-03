/mob/living/simple_animal/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone_dead"
	ranged = TRUE
	turns_per_move = 3
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	health = 300
	maxHealth = 300
	speed = 8
	base_attack_cooldown = 2 SECONDS
	move_to_delay = 6
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = 0
	meat_type = null
	meat_amount = 0
	bone_material = null
	bone_amount = 0
	skin_material = null
	skin_amount = 0
	ai_holder = /datum/ai_holder/simple_animal/ranged/pointblank/malf_drone
	say_list_type = /datum/say_list/malf_drone
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "malf_drone"

	var/datum/effect/effect/system/trail = /datum/effect/effect/system/trail/ion
	var/malfunctioning = TRUE
	var/hostile = FALSE
	var/hostile_drone = FALSE
	var/hostile_range = 10
	var/explode_chance = 1
	var/exploding = FALSE
	var/disabled = 0
	var/has_loot = TRUE


/mob/living/simple_animal/hostile/retaliate/malf_drone/Destroy()
	QDEL_NULL(trail)
	return ..()


/mob/living/simple_animal/hostile/retaliate/malf_drone/Initialize()
	. = ..()
	if (prob(50))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	if (ispath(trail))
		trail = new trail
		trail.set_up(src)
		trail.start()


/mob/living/simple_animal/hostile/retaliate/malf_drone/Allow_Spacemove(check_drift)
	return TRUE


/mob/living/simple_animal/hostile/retaliate/malf_drone/Life()
	. = ..()
	if (!.)
		return
	if(disabled > 0)
		set_stat(UNCONSCIOUS)
		icon_state = "[initial(icon_state)]_dead"
		disabled--
		set_wander (FALSE)
		ai_holder.speak_chance = 0
		if(disabled <= 0)
			set_stat(CONSCIOUS)
			icon_state = "[initial(icon_state)]0"
			set_wander (TRUE)
			ai_holder.speak_chance = 5
	var/sparked = FALSE
	if (prob(1))
		sparked = TRUE
		visible_message(SPAN_WARNING("\The [src] shudders and shakes."))
		var/datum/effect/effect/system/spark_spread/sparks = new
		sparks.set_up(3, 1, src)
		sparks.start()
		health += rand(25, 50)
	if (!sparked && prob(5))
		sparked = TRUE
		var/datum/effect/effect/system/spark_spread/sparks = new
		sparks.set_up(3, 1, src)
		sparks.start()
	if (malfunctioning && prob(disabled ? 0 : 1))
		hostile_drone = !hostile_drone
		if (hostile_drone)
			visible_message(SPAN_WARNING("\The [src] suddenly lights up with activity, searching for targets."))
		else
			visible_message(SPAN_WARNING("\The [src] dulls its running lights, becoming passive."))
	if (health / maxHealth > 0.9)
		icon_state = "[initial(icon_state)]"
		explode_chance = 0
	else if (health / maxHealth > 0.7)
		icon_state = "[initial(icon_state)]2"
		explode_chance = 0
	else if (health / maxHealth > 0.5)
		icon_state = "[initial(icon_state)]1"
		explode_chance = 0.5
	else if (health / maxHealth > 0.3)
		icon_state = "[initial(icon_state)]0"
		explode_chance = 5
	else if (health > 0)
		icon_state = "[initial(icon_state)]_dead"
		exploding = FALSE
		if (!disabled)
			visible_message(SPAN_WARNING("\The [src] suddenly goes still and quiet."))
			disabled = rand(150, 600)
			walk(src, 0)
	if (exploding && prob(20))
		visible_message(SPAN_WARNING("\The [src] begins to spark and shake violently!"))
		if (!sparked)
			var/datum/effect/effect/system/spark_spread/sparks = new
			sparks.set_up(3, 1, src)
			sparks.start()
	if (!exploding && !disabled && prob(explode_chance))
		exploding = TRUE
		set_stat(UNCONSCIOUS)
		set_wander(TRUE)
		walk(src, 0)
		if (!disabled && exploding)
			explosion(get_turf(src), 0, 1, 4, 7)
			death()


/mob/living/simple_animal/hostile/retaliate/malf_drone/emp_act(severity)
	if (status_flags & GODMODE)
		return
	health -= rand(3, 15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = FALSE
	walk(src, 0)
	..()


/mob/living/simple_animal/hostile/retaliate/malf_drone/death()
	..(FALSE, "suddenly breaks apart.", "You have been destroyed.")
	if (has_loot)
		var/turf/origin = get_turf(src)
		if (origin)
			var/datum/effect/effect/system/spark_spread/sparks = new
			sparks.set_up(3, 1, origin)
			sparks.start()
			var/list/loot = list()
			for (var/i = rand(1, 2) to 1 step -1)
				loot += new /obj/item/material/shard/shrapnel/steel (origin)
			for (var/i = rand(1, 2) to 1 step -1)
				loot += new /obj/item/material/shard/shrapnel/aluminium (origin)
			if (prob(50))
				loot += new /obj/item/material/shard/shrapnel/titanium (origin)
			if (prob(50))
				loot += new /obj/item/material/shard/shrapnel/copper (origin)
			for (var/i = rand(1, 3) to 1 step -1)
				loot += new /obj/item/drone_loot_board (origin)
			var/strength = exploding ? 1 : 0.5
			for (var/obj/item/item as anything in loot)
				item.throw_at(CircularRandomTurfAround(origin, Frand(2, 6) * strength), 5, 5 * strength)
	qdel(src)




/obj/item/drone_loot_board/name = "circuit board (drone systems)"

/obj/item/drone_loot_board/desc = "A damaged piece of circuitry that was once part of a combat drone."

/obj/item/drone_loot_board/icon = 'icons/obj/module.dmi'

/obj/item/drone_loot_board/icon_state = "id_mod"

/obj/item/drone_loot_board/item_state = "electronic"

/obj/item/drone_loot_board/w_class = ITEM_SIZE_SMALL

/obj/item/drone_loot_board/obj_flags = OBJ_FLAG_CONDUCTIBLE


/obj/item/drone_loot_board/Initialize()
	. = ..()
	if (prob(33))
		LAZYSET(origin_tech, TECH_DATA, rand(2, 4))
	if (prob(33))
		LAZYSET(origin_tech, TECH_POWER, rand(2, 4))
	if (prob(33))
		LAZYSET(origin_tech, TECH_ENGINEERING, rand(2, 4))
	if (prob(33))
		LAZYSET(origin_tech, TECH_COMBAT, rand(2, 4))




/obj/item/projectile/beam/drone/damage = 15




/obj/item/projectile/beam/pulse/drone/damage = 10




/datum/ai_holder/simple_animal/ranged/pointblank/malf_drone/speak_chance = 5


/datum/ai_holder/simple_animal/ranged/pointblank/malf_drone/list_targets()
	var/mob/living/simple_animal/hostile/retaliate/malf_drone/D = holder
	if (!D.hostile_drone)
		return ..()
	var/list/targets = list()
	for (var/mob/living/M in oview(D.hostile_range, D))
		if (M.stat == DEAD)
			continue
		if (M.type == D.type)
			continue
		targets += M
	return targets




/datum/say_list/malf_drone/speak = list(
	"ALERT.",
	"Hostile-ile-ile entities dee-twhoooo-wected.",
	"Threat parameterszzzz- szzet.",
	"Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a."
)

/datum/say_list/malf_drone/emote_see = list(
	"beeps menacingly",
	"whirrs threateningly",
	"scans its immediate vicinity"
)

/datum/say_list/malf_drone/say_understood = list(
	"Affirmative.",
	"Positive."
)

/datum/say_list/malf_drone/say_cannot = list(
	"Denied.",
	"Negative."
)

/datum/say_list/malf_drone/say_maybe_target = list(
	"Possible threat detected. Investigating.",
	"Motion detected.",
	"Investigating."
)

/datum/say_list/malf_drone/say_got_target = list(
	"Threat detected.",
	"New task: Remove threat.",
	"Threat removal engaged.",
	"Engaging target."
)

/datum/say_list/malf_drone/threaten_sound = 'sound/effects/turret/move1.wav'

/datum/say_list/malf_drone/say_threaten = list(
	"Motion detected, judging target..."
)

/datum/say_list/malf_drone/stand_down_sound = 'sound/effects/turret/move2.wav'

/datum/say_list/malf_drone/say_stand_down = list(
	"Visual lost.",
	"Error: Target not found."
)

/datum/say_list/malf_drone/say_escalate = list(
	"Viable target found. Removing.",
	"Engaging target.",
	"Target judgement complete. Removal required."
)
