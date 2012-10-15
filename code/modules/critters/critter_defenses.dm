/*
Contains the procs that control attacking critters
*/
/obj/effect/critter

	attackby(obj/item/weapon/W as obj, mob/living/user as mob)
		..()
		if(!src.alive)
			Harvest(W,user)
			return
		var/damage = 0
		switch(W.damtype)
			if("fire") damage = W.force * firevuln
			if("brute") damage = W.force * brutevuln
		TakeDamage(damage)
		if(src.defensive && alive)	Target_Attacker(user)
		return


	attack_hand(var/mob/user as mob)
		if (!src.alive)	..()
		if (user.a_intent == "hurt")
			TakeDamage(rand(1,2) * brutevuln)

			if(istype(user, /mob/living/carbon/human))
				if(user.get_species() == "Tajaran")
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <B>[user] has slashed at [src]!</B>", 1)
					playsound(src.loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				else
					for(var/mob/O in viewers(src, null))
						O.show_message("\red <B>[user] has punched [src]!</B>", 1)
					playsound(src.loc, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'), 100, 1)

			else if(istype(user, /mob/living/carbon/alien/humanoid))
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[user] has slashed at [src]!</B>", 1)
				playsound(src.loc, 'sound/weapons/slice.ogg', 25, 1, -1)



			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[user] has bit [src]!</B>", 1)

			if(src.defensive)	Target_Attacker(user)
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\blue [user] touches [src]!", 1)


	proc/Target_Attacker(var/target)
		if(!target)	return
		src.target = target
		src.oldtarget_name = target:name
		if(task != "chasing" && task != "attacking")
			if(angertext && angertext != "")
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <b>[src]</b> [src.angertext] at [target:name]!", 1)
			src.task = "chasing"
		return


	proc/TakeDamage(var/damage = 0)
		var/tempdamage = (damage-armor)
		if(tempdamage > 0)
			src.health -= tempdamage
		else
			src.health--
		if(src.health <= 0)
			src.Die()


	proc/Die()
		if (!src.alive) return
		src.icon_state += "_dead"
		src.alive = 0
		src.anchored = 0
		src.density = 0
		walk_to(src,0)
		src.visible_message("<b>[src]</b> [deathtext]")


	proc/Harvest(var/obj/item/weapon/W, var/mob/living/user)
		if((!W) || (!user))	return 0
		if(src.alive)	return 0
		return 1


	bullet_act(var/obj/item/projectile/Proj)
		TakeDamage(Proj.damage)
		..()


	ex_act(severity)
		switch(severity)
			if(1.0)
				src.Die()
				return
			if(2.0)
				TakeDamage(20)
				return
		return


	emp_act(serverity)
		switch(serverity)
			if(1.0)
				src.Die()
				return
			if(2.0)
				TakeDamage(20)
				return
		return


	meteorhit()
		src.Die()
		return


	blob_act()
		if(prob(25))
			src.Die()
		return

	attack_animal(mob/living/simple_animal/M as mob)
		if(M.melee_damage_upper == 0)
			M.emote("[M.friendly] [src]")
		else
			for(var/mob/O in viewers(src, null))
				O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
			TakeDamage(damage)
		return