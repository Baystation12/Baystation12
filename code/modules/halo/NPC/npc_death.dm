
/mob/living/simple_animal/npc/death(gibbed, deathmessage = "dies!", show_dead_message)
	. = ..()

	//fall over
	src.dir = 2
	var/matrix/M = src.transform
	M.Turn(90)
	M.Translate(1,-6)
	src.transform = M
