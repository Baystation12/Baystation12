/mob/living/simple_animal/hostile/retaliate/clown
	name = "clown"
	desc = "A denizen of clown planet"
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	maxHealth = 75
	health = 75
	speed = -1
	harm_intent_damage = 8
	can_escape = TRUE
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 10	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	unsuitable_atmos_damage = 10
	natural_weapon = /obj/item/natural_weapon/clown

	ai_holder_type = /datum/ai_holder/simple_animal/retaliate/clown
	say_list = /datum/say_list/clown

/obj/item/natural_weapon/clown
	name = "bike horn"
	force = 10
	hitsound = 'sound/items/bikehorn.ogg'

/datum/ai_holder/simple_animal/retaliate/clown
	speak_chance = 1

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")
