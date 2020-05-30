/mob/living/chorus/Life()
	. = ..()
	if(. && health <= 0)
		death()

/mob/living/chorus/death()
	..()
	playsound(src, 'sound/hallucinations/wail.ogg', 100, 1)
	icon_state = "chorus_death"