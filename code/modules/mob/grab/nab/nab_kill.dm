/datum/grab/nab/kill
	state_name = NAB_KILL

	downgrab_name = NAB_AGGRESSIVE

	shift = -10

	icon_state = "kill1"

	downgrade_on_action = 1
	downgrade_on_move = 1

	breakability = 0

	break_chance_table = list(3, 10, 20, 100)

/datum/grab/nab/kill/process(var/obj/item/grab/G)
	var/mob/living/carbon/human/assailant = G.assailant

	switch(assailant.a_intent)
		if(I_GRAB)
			on_hit_grab(G)
		if(I_HURT)
			on_hit_harm(G)
