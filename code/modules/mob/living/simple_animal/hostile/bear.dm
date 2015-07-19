//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 60
	health = 60
	melee_damage_lower = 20
	melee_damage_upper = 30

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "russian"

//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple_animal/hostile/bear/Life()
	. =..()
	if(!.)
		return

	update_icons()

/mob/living/simple_animal/hostile/bear/update_icons()
	if(loc && istype(loc,/turf/space))
		icon_state = "bear"
	else
		icon_state = "bearfloor"

/mob/living/simple_animal/hostile/bear/Process_Spacemove(var/check_drift = 0)
	return	//No drifting in space for space bears!
