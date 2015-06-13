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
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = 1
	unacidable = 1
	anchored = 1 //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE
	mouse_opacity = 0
	var/bumped = 0		//Prevents it from hitting more than one guy at once
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = 0	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/obj/shot_from = null // the object which shot us
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/projectile_type = /obj/item/projectile
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/kill_count = 50 //This will de-increment every process(). When 0, it will delete the projectile.
		//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked >= 2)		return 0//Full block
	if(!isliving(target))	return 0
	if(isanimal(target))	return 0
	var/mob/living/L = target
	L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked) // add in AGONY!
	return 1

//called when the projectile stops flying because it collided with something
/obj/item/projectile/proc/on_impact(var/atom/A)
	return

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != BRUTE)
		return 0
	return 1

//return 1 if the projectile should be allowed to pass through after all, 0 if not.
/obj/item/projectile/proc/check_penetrate(var/atom/A)
	return 1

/obj/item/projectile/proc/check_fire(atom/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, flags)

//sets the click point of the projectile using mouse input params
/obj/item/projectile/proc/set_clickpoint(var/params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)
	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return 1

	firer = user
	def_zone = user.zone_sel.selecting

	if(user == target) //Shooting yourself
		user.bullet_act(src, target_zone)
		on_impact(user)
		del(src)
		return 0
	if(targloc == curloc) //Shooting something in the same turf
		target.bullet_act(src, target_zone)
		on_impact(target)
		del(src)
		return 0

	original = target
	loc = curloc
	starting = curloc
	current = curloc
	yo = targloc.y - curloc.y + y_offset
	xo = targloc.x - curloc.x + x_offset

	shot_from = launcher
	silenced = launcher.silenced

	spawn()
		process()

	return 0

//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(var/new_x, var/new_y, var/atom/starting_loc, var/mob/new_firer=null)
	original = locate(new_x, new_y, src.z)
	starting = starting_loc
	current = starting_loc
	if(new_firer)
		firer = src

	yo = new_y - starting_loc.y
	xo = new_x - starting_loc.x

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(!istype(target_mob))
		return
	//accuracy bonus from aiming
	if (istype(shot_from, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/daddy = shot_from
		miss_modifier -= round(15*daddy.accuracy)

		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		if (daddy.aim_targets && original in daddy.aim_targets)
			miss_modifier += -30

	//roll to-hit
	miss_modifier = max(miss_modifier + 15*(distance-2), 0)
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1))
	if(!hit_zone)
		visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
		return 0

	//set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
	def_zone = hit_zone

	//hit messages
	if(silenced)
		target_mob << "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>"
	else
		visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob))

			var/attacker_message = "shot with \a [src.type]"
			var/victim_message = "shot with \a [src.type]"
			var/admin_message = "shot (\a [src.type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			target_mob.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[target_mob]/[target_mob.ckey]</b> with <b>\a [src]</b>"
			msg_admin_attack("UNKNOWN shot [target_mob] ([target_mob.ckey]) with \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target_mob.x];Y=[target_mob.y];Z=[target_mob.z]'>JMP</a>)")

	//sometimes bullet_act() will want the projectile to continue flying
	if (target_mob.bullet_act(src, def_zone) == -1)
		return 0

	return 1

/obj/item/projectile/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == src)
		return 0 //no

	if(A == firer)
		loc = A.loc
		return 0 //cannot shoot yourself

	if((bumped && !forced) || (A in permutated))
		return 0

	var/passthrough = 0 //if the projectile should continue flying
	var/distance = get_dist(starting,loc)

	bumped = 1
	if(ismob(A))
		var/mob/M = A
		if(istype(A, /mob/living))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/weapon/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
				if(Bump(G.affecting, forced=1))
					return //If Bump() returns 0 (keep going) then we continue on to attack M.

			passthrough = !attack_mob(M, distance)
		else
			passthrough = 1 //so ghosts don't stop bullets
	else
		passthrough = (A.bullet_act(src, def_zone) == -1) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = 1
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough)
		//move ourselves onto A so we can continue on our way.
		if(A)
			if(istype(A, /turf))
				loc = A
			else
				loc = A.loc
			permutated.Add(A)
		bumped = 0 //reset bumped variable!
		return 0

	//stop flying
	on_impact(A)

	density = 0
	invisibility = 101
	del(src)
	return 1

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover, /obj/item/projectile))
		return prob(95) //ha
	else
		return 1

/obj/item/projectile/process()
	spawn while(src)
		if(kill_count-- < 1)
			on_impact(src.loc) //for any final impact behaviours
			del(src)
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
			del(src)
			return
		step_towards(src, current)
		sleep(1)
		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					Bump(original)
					sleep(1)

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	yo = null
	xo = null
	var/target = null
	var/result = 0 //To pass the message back to the gun.

/obj/item/projectile/test/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(istype(A, /mob/living))
		result = 2 //We hit someone, return 1!
		return
	result = 1
	return

/obj/item/projectile/test/process()
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return 0
	yo = targloc.y - curloc.y
	xo = targloc.x - curloc.x
	target = targloc
	while(src) //Loop on through!
		if(result)
			return (result - 1)
		if((!( target ) || loc == target))
			target = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z) //Finding the target turf at map edge
		step_towards(src, target)
		var/mob/living/M = locate() in get_turf(src)
		if(istype(M)) //If there is someting living...
			return 1 //Return 1
		else
			M = locate() in get_step(src,target)
			if(istype(M))
				return 1

/proc/check_trajectory(atom/target as mob, var/mob/living/user as mob, var/pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE, flags=null)  //Checks if you can hit them or not.
	if(!istype(target) || !istype(user))
		return 0
	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_step_to(user,target)) //Making the test....
	trace.target = target
	if(!isnull(flags))
		trace.flags = flags //Set the flags...
	trace.pass_flags = pass_flags //And the pass flags to that of the real projectile...
	trace.firer = user
	var/output = trace.process() //Test it!
	del(trace) //No need for it anymore
	return output //Send it back to the gun!
