/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/

/obj/item/projectile
	name = "projectile"
	icon = 'projectiles.dmi'
	icon_state = "bullet"
	density = 1
	unacidable = 1
	anchored = 1 //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	mouse_opacity = 0
	var
		bumped = 0		//Prevents it from hitting more than one guy at once
		def_zone = ""	//Aiming at
		mob/firer = null//Who shot it
		silenced = 0	//Attack message
		yo = null
		xo = null
		current = null
		turf/original = null

		damage = 10
		damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
		nodamage = 0 //Determines if the projectile will skip any damage inflictions
		flag = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb
		projectile_type = "/obj/item/projectile"
		//Effects
		stun = 0
		weaken = 0
		paralyze = 0
		irradiate = 0
		stutter = 0
		eyeblur = 0
		drowsy = 0


	proc/on_hit(var/atom/target, var/blocked = 0)
		if(blocked >= 2)	return 0//Full block
		if(!isliving(target))	return 0
		var/mob/living/L = target
		L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, blocked)
		return 1


	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return //cannot shoot yourself

		if(bumped)	return

		bumped = 1
		if(firer && istype(A, /mob))
			var/mob/M = A
			if(!istype(A, /mob/living))
				loc = A.loc
				return // nope.avi

			if(!silenced)
				visible_message("\red [A.name] has been shot by the [src.name]!")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter
			else
				M << "\red You've been shot!"
			if(istype(firer, /mob))
				M.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
				firer.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
			else
				M.attack_log += text("\[[]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), M, M.ckey, src)

		spawn(0)
			if(A)
				A.bullet_act(src, def_zone)
				if(istype(A,/turf))
					for(var/obj/O in A)
						O.bullet_act(src)
					for(var/mob/M in A)
						M.bullet_act(src, def_zone)

				density = 0
				invisibility = 101
				del(src)
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1

		if(istype(mover, /obj/item/projectile))
			return prob(95)
		else
			return 1


	process()
		spawn while(src)
			if((!( current ) || loc == current))
				current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
			if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
				del(src)
				return
			step_towards(src, current)
			sleep(1)
			if(!bumped)
				if(loc == original)
					for(var/mob/living/M in original)
						Bump(M)
						sleep(1)
		return
