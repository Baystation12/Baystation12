/mob/living/simple_animal/hostile/retaliate/jelly
	name = "zeq"
	desc = "It looks like a floating jellyfish. How does it do that?"
	faction = "zeq"
	icon_state = "jelly"
	icon_living = "jelly"
	icon_dead = "jelly_dead"
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	melee_damage_lower = 3
	melee_damage_upper = 12
	attacktext = "stung"
	damtype = BURN
	speak_chance = 1
	emote_see = list("wobbles slightly","oozes something out of tentacles' ends")
	var/gets_random_color = TRUE

/mob/living/simple_animal/hostile/retaliate/jelly/Initialize()
	. = ..()
	if(gets_random_color)
		color = color_rotation(round(rand(0,360),20))

/mob/living/simple_animal/hostile/retaliate/jelly/alt
	icon_state = "jelly-alt"
	icon_living = "jelly-alt"
	icon_dead = "jelly-alt_dead"

//megajellyfish
/mob/living/simple_animal/hostile/retaliate/jelly/mega
	name = "zeq queen"
	desc = "A gigantic jellyfish-like creature. Its bell wobbles about almost as if it's ready to burst."
	maxHealth = 300
	health = 300
	melee_damage_lower = 18
	melee_damage_upper = 30
	gets_random_color = FALSE
	can_escape = TRUE

	var/jelly_scale = 3
	var/split_type = /mob/living/simple_animal/hostile/retaliate/jelly/mega/half
	var/static/megajelly_color

/mob/living/simple_animal/hostile/retaliate/jelly/mega/Initialize()
	. = ..()
	var/matrix/M = new
	M.Scale(jelly_scale)
	transform = M
	if(!megajelly_color)
		megajelly_color = color_rotation(round(rand(0,360),20))
	color = megajelly_color

/mob/living/simple_animal/hostile/retaliate/jelly/mega/death()
	if(split_type)
		jelly_split()
	else
		..()

/mob/living/simple_animal/hostile/retaliate/jelly/mega/proc/jelly_split()
	visible_message(SPAN_MFAUNA("\The [src] rumbles briefly before splitting into two!"))
	var/kidnum = 2
	for(var/i = 0 to kidnum)
		var/mob/living/simple_animal/child = new split_type(get_turf(src))
		child.min_gas = min_gas.Copy()
		child.max_gas = max_gas.Copy()
		child.minbodytemp = minbodytemp
		child.maxbodytemp = maxbodytemp
	QDEL_NULL(src)

/mob/living/simple_animal/hostile/retaliate/jelly/mega/half
	name = "zeq duchess"
	desc = "A huge jellyfish-like creature."
	maxHealth = 150
	health = 150
	melee_damage_lower = 9
	melee_damage_upper = 15
	can_escape = TRUE
	jelly_scale = 1.5
	split_type = /mob/living/simple_animal/hostile/retaliate/jelly/mega/quarter

/mob/living/simple_animal/hostile/retaliate/jelly/mega/quarter
	name = "zeqling"
	desc = "A jellyfish-like creature."
	health = 75
	maxHealth = 75
	melee_damage_lower = 4.5
	melee_damage_upper = 7.5
	jelly_scale = 0.75
	can_escape = FALSE
	split_type = /mob/living/simple_animal/hostile/retaliate/jelly/mega/fourth

/mob/living/simple_animal/hostile/retaliate/jelly/mega/fourth
	name = "zeqetta"
	desc = "A tiny jellyfish-like creature."
	health = 40
	maxHealth = 40
	melee_damage_lower = 3
	melee_damage_upper = 4
	jelly_scale = 0.375
	split_type = /mob/living/simple_animal/hostile/retaliate/jelly/mega/eighth

/mob/living/simple_animal/hostile/retaliate/jelly/mega/eighth
	name = "zeqttina"
	desc = "An absolutely tiny jellyfish-like creature."
	health = 20
	maxHealth = 20
	melee_damage_lower = 1.5
	melee_damage_upper = 2
	jelly_scale = 0.1875
	split_type = null
