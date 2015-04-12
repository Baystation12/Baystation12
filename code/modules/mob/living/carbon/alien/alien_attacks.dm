//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message(text("\red [] has been hit by []", src, O), 1)
	if (health > 0)
		adjustBruteLoss((istype(O, /obj/effect/meteor/small) ? 10 : 25))
		adjustFireLoss(30)

		updatehealth()
	return

/mob/living/carbon/alien/attack_hand(mob/living/carbon/M as mob)

	..()

	switch(M.a_intent)

		if ("help")
			help_shake_act(M)

		if ("grab")
			if (M == src)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M, M, src )

			M.put_in_active_hand(G)

			grabbed_by += G
			G.affecting = src
			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)

		else
			var/damage = rand(1, 9)
			if (prob(90))
				if (HULK in M.mutations)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)
				playsound(loc, "punch", 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has punched []!</B>", M, src), 1)
				if (damage > 4.9)
					Weaken(rand(10,15))
					for(var/mob/O in viewers(M, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has weakened []!</B>", M, src), 1, "\red You hear someone fall.", 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to punch []!</B>", M, src), 1)
	return