
/mob/living/simple_animal/hostile/sentinel/defensedrone
	name = "Forerunner Defense Drone"
	health = 100

/mob/living/simple_animal/hostile/sentinel/defensedrone/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>It appears to be programmed to assist the [faction] faction.</span>")

/mob/living/simple_animal/hostile/sentinel/defensedrone/UNSC
	faction = "UNSC"

/mob/living/simple_animal/hostile/sentinel/defensedrone/Innie
	faction = "Insurrection"

/mob/living/simple_animal/hostile/sentinel/defensedrone/Covenant
	faction = "Covenant"