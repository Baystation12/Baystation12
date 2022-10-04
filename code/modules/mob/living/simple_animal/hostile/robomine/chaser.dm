/mob/living/simple_animal/hostile/robomine/chaser
	name = "seeker mine"
	base_icon = "seeker"
	movement_cooldown = 1
	can_pry = FALSE
	ai_holder = /datum/ai_holder/robomine/chaser


/datum/ai_holder/robomine/chaser
	vision_range = 5
	returns_home = TRUE
	use_astar = TRUE
	no_move = FALSE
	max_home_distance = 0
