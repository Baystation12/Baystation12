
/obj/item/sentinel_kit
	name = "Unknown Device"
	desc = "The shape of this device suggests it is made to be placed against the head of... A human being? Looks like other species are supported however."
	icon = 'code/modules/halo/Forerunner/sentinel_kit.dmi'
	icon_state = "sentinel_kit"

/obj/item/sentinel_kit/proc/convert_person(var/mob/living/carbon/M,var/mob/user)
	if(!M.client || !M.ckey)
		to_chat(user,"<span class = 'notice'>[src] seems to do nothing, Perhaps it needs a target with a consciousness?</span>")
		return
	user.visible_message("<span class = 'notice'>[user] places [src] against [M]'s head.\n[src] starts to glow...</span>")
	if(do_after(user, 10 SECONDS, M, 1, 1,INCAPACITATION_DEFAULT,1))
		M.visible_message("<span class = 'danger'>[M] falls limp, their body falling into a catatonic state.</span>")
		var/mob/living/simple_animal/hostile/sentinel/player_sentinel = new /mob/living/simple_animal/hostile/sentinel/player_sentinel(M.loc)
		player_sentinel.visible_message("<span class = 'warning'>[src] glows as it reassembles itself into a functional sentinel</span>")
		player_sentinel.ckey = M.ckey
		player_sentinel.faction = M.faction
		to_chat(player_sentinel,"<span class = 'warning'>Your mind is ripped from the form it once occupied, then placed in an unfamiliar chassis. A moment of uncertainty passes, then a rush of information fills your mind. The secrets of the Forerunners revealed, the nature of the Flood... (You are expected to maintain allegiance with your previous faction, however, it is recommended that your character and personality be somewhat modified by this experience.)</span>")
		M.drop_from_inventory(src)
		qdel(src)

/obj/item/sentinel_kit/attack(var/mob/living/carbon/M, var/mob/user)
	if(user.a_intent == "help")
		convert_person(M,user)
	else
		. = ..()