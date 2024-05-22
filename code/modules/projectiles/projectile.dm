//Amount of time in deciseconds to wait before deleting all drawn segments of a projectile.
#define SEGMENT_DELETION_DELAY 5

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	unacidable = TRUE
	anchored = TRUE //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASS_FLAG_TABLE
	mouse_opacity = 0
	var/bumped = 0		//Prevents it from hitting more than one guy at once
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = FALSE	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/shot_from = "" // name of the object which shot us
	var/atom/original = null // the target clicked (not necessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/list/segments = list() //For hitscan projectiles with tracers.

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/hitchance_mod = 0
	var/dispersion = 0.0
	var/distance_falloff = 2  //multiplier, higher value means accuracy drops faster with distance
	var/damage_falloff = FALSE
	/// List(Distance, Multiplier), intended to represent short / medium / long ranges. Uses default of 1 for anything lower than the first value.
	var/damage_falloff_list = list(
		list(4, 0.9),
		list(6, 0.8),
		list(8, 0.7)
	)

	var/damage = 10
	/// String (One of `DAMAGE_*`).
	var/damage_type = DAMAGE_BRUTE
	var/nodamage = FALSE //Determines if the projectile will skip any damage inflictions
	var/damage_flags = DAMAGE_FLAG_BULLET
	var/projectile_type = /obj/item/projectile
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/life_span = 50 //This will de-increment every process(). When 0, it will delete the projectile.

	//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = FALSE // whether or not the projectile can embed itself in the mob
	var/penetration_modifier = 0.2 //How likely this projectile is to embed or rupture artery
	var/space_knockback = 0	//whether or not it will knock things back in space

	var/hitscan = FALSE		// whether the projectile should be hitscan
	var/step_delay = 1	// the delay between iterations if not a hitscan projectile

	// effect types to be used
	var/muzzle_type
	var/tracer_type
	var/impact_type

	var/fire_sound
	var/miss_sounds
	var/ricochet_sounds
	var/list/impact_sounds	//for different categories, IMPACT_MEAT etc
	var/shrapnel_type = /obj/item/material/shard/shrapnel/steel

	var/vacuum_traversal = 1 //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/datum/plot_vector/trajectory	// used to plot the path of the projectile
	var/datum/vector_loc/location		// current location of the projectile in pixel space
	var/matrix/effect_transform			// matrix to rotate and scale projectile effects - putting it here so it doesn't
										//  have to be recreated multiple times

/obj/item/projectile/Initialize()
	damtype = damage_type //TODO unify these vars properly
	if(!hitscan)
		animate_movement = SLIDE_STEPS
	else animate_movement = NO_STEPS
	. = ..()

/obj/item/projectile/damage_flags()
	return damage_flags

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(atom/target, blocked = 0, def_zone = null)
	if(blocked >= 100)		return 0//Full block
	if(!isliving(target))	return 0
	if(isanimal(target))	return 0

	var/mob/living/L = target

	L.apply_effects(0, weaken, paralyze, stutter, eyeblur, drowsy, 0, blocked)
	L.stun_effect_act(stun, (agony - blocked), def_zone, src)
	//radiation protection is handled separately from other armour types.
	L.apply_damage(irradiate, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

	return 1

//called when the projectile stops flying because it collided with something
/obj/item/projectile/proc/on_impact(atom/A)
	impact_effect()		// generate impact effect
	if (damage && damage_type == DAMAGE_BURN)
		var/turf/T = get_turf(A)
		if(T)
			T.hotspot_expose(700, 5)

	if(space_knockback && ismovable(A))
		var/atom/movable/AM = A
		if(!AM.anchored && !AM.has_gravity())
			if(ismob(AM))
				var/mob/M = AM
				if(M.check_space_footing())
					return
			var/old_dir = AM.dir
			step(AM,get_dir(firer,AM))
			AM.set_dir(old_dir)

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != DAMAGE_BRUTE)
		return 0
	return 1

/obj/item/projectile/proc/get_structure_damage()
	if (damage_type == DAMAGE_BRUTE || damage_type == DAMAGE_BURN)
		return damage
	return 0

//return 1 if the projectile should be allowed to pass through after all, 0 if not.
/obj/item/projectile/proc/check_penetrate(atom/A)
	return 1

/obj/item/projectile/proc/check_fire(atom/target as mob, mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, item_flags, obj_flags)

//sets the click point of the projectile using mouse input params
/obj/item/projectile/proc/set_clickpoint(params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])

	//randomize clickpoint a bit based on dispersion
	if(dispersion)
		var/radius = round((dispersion*0.443)*world.icon_size*0.8) //0.443 = sqrt(pi)/4 = 2a, where a is the side length of a square that shares the same area as a circle with diameter = dispersion
		p_x = clamp(p_x + rand(-radius, radius), 0, world.icon_size)
		p_y = clamp(p_y + rand(-radius, radius), 0, world.icon_size)

//called to launch a projectile
/obj/item/projectile/proc/launch(atom/target, target_zone, x_offset=0, y_offset=0, angle_offset=0)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return 1

	if(targloc == curloc) //Shooting something in the same turf
		target.bullet_act(src, target_zone)
		on_impact(target)
		qdel(src)
		return 0

	original = target
	def_zone = target_zone

	addtimer(new Callback(src, PROC_REF(finalize_launch), curloc, targloc, x_offset, y_offset, angle_offset),0)
	return 0

/obj/item/projectile/proc/launch_from_mob(atom/target, mob/user, target_zone, x_offset = 0, y_offset = 0, angle_offset = 0)
	if(user == target) //Shooting yourself
		user.bullet_act(src, target_zone)
		qdel(src)
		return 0

	firer = user

	return launch(target, target_zone, x_offset, y_offset)

/obj/item/projectile/proc/finalize_launch(turf/curloc, turf/targloc, x_offset, y_offset, angle_offset)
	setup_trajectory(curloc, targloc, x_offset, y_offset, angle_offset) //plot the initial trajectory
	Process()
	spawn(SEGMENT_DELETION_DELAY) //running this from a proc wasn't working.
		QDEL_NULL_LIST(segments)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, mob/user, obj/item/gun/launcher, target_zone, x_offset=0, y_offset=0)
	if(user == target) //Shooting yourself
		user.bullet_act(src, target_zone)
		qdel(src)
		return 0

	dropInto(user.loc) //move the projectile out into the world

	firer = user
	shot_from = launcher.name
	silenced = launcher.silenced

	return launch(target, target_zone, x_offset, y_offset)

//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(new_x, new_y, atom/starting_loc, mob/new_firer=null)
	var/turf/new_target = locate(new_x, new_y, src.z)

	original = new_target
	if(new_firer)
		firer = src

	setup_trajectory(starting_loc, new_target)

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(mob/living/target_mob, distance, special_miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	var/miss_modifier = max(distance_falloff*(distance)*(distance) - hitchance_mod + special_miss_modifier, -30)
	//makes moving targets harder to hit, and stationary easier to hit
	var/movment_mod = min(5, (world.time - target_mob.l_move_time) - 5)

	if (damage_falloff)
		var/damage_mod = 1
		for (var/list/entry as anything in damage_falloff_list)
			if (entry[1] > distance)
				break
			damage_mod = entry[2]
		damage = damage * damage_mod
		armor_penetration = armor_penetration * damage_mod
		agony = agony * damage_mod
	//running in a straight line isnt as helpful tho
	if(movment_mod < 0)
		if(target_mob.last_move == get_dir(firer, target_mob))
			movment_mod *= 0.25
		else if(target_mob.last_move == get_dir(target_mob,firer))
			movment_mod *= 0.5
	miss_modifier -= movment_mod
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1 || original != target_mob)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		if(!target_mob.aura_check(AURA_TYPE_BULLET, src,def_zone))
			return 1
		result = target_mob.bullet_act(src, def_zone)

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			target_mob.visible_message(SPAN_NOTICE("\The [src] misses [target_mob] narrowly!"))
			if(LAZYLEN(miss_sounds))
				playsound(target_mob.loc, pick(miss_sounds), 60, 1)
		return 0

	//hit messages
	if(silenced)
		to_chat(target_mob, SPAN_DANGER("You've been hit in the [parse_zone(def_zone)] by \the [src]!"))
	else
		target_mob.visible_message(SPAN_DANGER("\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!"))//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob))

			var/attacker_message = "shot with \a [src.type]"
			var/victim_message = "shot with \a [src.type]"
			var/admin_message = "shot (\a [src.type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			admin_victim_log(target_mob, "was shot by an <b>UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return 0

	return 1


/obj/item/projectile/Bump(atom/atom, forced)
	if (atom == src)
		return FALSE
	if (atom == firer)
		forceMove(atom.loc)
		return FALSE
	if (bumped && !forced || (atom in permutated))
		return FALSE
	bumped = TRUE
	var/passthrough
	var/distance = get_dist(starting, loc)
	if (ismob(atom))
		passthrough = TRUE
		if (istype(atom, /mob/living))
			var/obj/item/grab/grab = locate() in atom
			var/dirs = GLOB.reverse_dir[atom.dir & 0xF]
			dirs = list(dirs, GLOB.cw_dir_8[dirs], GLOB.ccw_dir_8[dirs])
			if (grab?.shield_assailant() && (dir in dirs))
				grab.affecting.visible_message(SPAN_DANGER("\The [atom] uses \the [grab.affecting] as a shield!"))
				if (Bump(grab.affecting, TRUE))
					return
			passthrough = !attack_mob(atom, distance)
	else
		passthrough = atom.bullet_act(src, def_zone) == PROJECTILE_CONTINUE
		if (isturf(atom))
			for (var/obj/obj in atom)
				obj.bullet_act(src)
			for (var/mob/living/mob in atom)
				attack_mob(mob, distance)
	if (!passthrough && penetrating > 3)
		if (check_penetrate(atom))
			passthrough = TRUE
		--penetrating
	if (passthrough && isturf(atom))
		forceMove(atom)
		permutated += atom
		bumped = FALSE
		return FALSE
	on_impact(atom)
	set_density(FALSE)
	set_invisibility(INVISIBILITY_ABSTRACT)
	qdel(src)
	return TRUE


/obj/item/projectile/ex_act()
	return //explosions probably shouldn't delete projectiles

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1

/obj/item/projectile/Process()
	var/first_step = 1

	spawn while(src && src.loc)
		if(life_span-- < 1)
			on_impact(src.loc) //for any final impact behaviours
			qdel(src)
			return
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
			qdel(src)
			return

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		if(!location)
			qdel(src)	// if it's left the world... kill it
			return

		if (is_below_sound_pressure(get_turf(src)) && !vacuum_traversal) //Deletes projectiles that aren't supposed to bein vacuum if they leave pressurised areas
			qdel(src)
			return

		before_move()
		Move(location.return_turf())

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					if(Bump(original))
						return

		if(first_step)
			muzzle_effect()
			first_step = 0
		else if(!bumped && life_span > 0)
			tracer_effect()
		if(!hitscan)
			sleep(step_delay)	//add delay between movement iterations if it's not a hitscan weapon

/obj/item/projectile/proc/before_move()
	return 0

/obj/item/projectile/proc/setup_trajectory(turf/startloc, turf/targloc, x_offset = 0, y_offset = 0)
	// setup projectile state
	starting = startloc
	current = startloc
	yo = round(targloc.y - startloc.y + y_offset, 1)
	xo = round(targloc.x - startloc.x + x_offset, 1)

	// trajectory dispersion
	var/offset = 0
	if(dispersion)
		var/radius = round(dispersion*9, 1)
		offset = rand(-radius, radius)

	// plot the initial trajectory
	trajectory = new
	trajectory.setup(starting, original, pixel_x, pixel_y, angle_offset=offset)
	effect_transform = matrix().Update(
		scale_x = round(trajectory.return_hypotenuse() + 0.005, 0.001),
		rotation = round(-trajectory.angle, 0.1)
	)
	SetTransform(rotation = -(trajectory.angle + 90))

/obj/item/projectile/proc/muzzle_effect()
	if(silenced)
		return

	if(ispath(muzzle_type))
		var/obj/projectile/M = new muzzle_type(get_turf(src))

		if(istype(M))
			M.SetTransform(others = effect_transform)
			M.pixel_x = round(location.pixel_x, 1)
			M.pixel_y = round(location.pixel_y, 1)
			if(!hitscan) //Bullets don't hit their target instantly, so we can't link the deletion of the muzzle flash to the bullet's Destroy()
				QDEL_IN(M,1)
			else
				segments += M

/obj/item/projectile/proc/tracer_effect()
	if(ispath(tracer_type))
		var/obj/projectile/P = new tracer_type(location.loc)

		if(istype(P))
			P.SetTransform(others = effect_transform)
			P.pixel_x = round(location.pixel_x, 1)
			P.pixel_y = round(location.pixel_y, 1)
			if(hitscan)
				segments += P

/obj/item/projectile/proc/impact_effect()
	if(ispath(impact_type))
		var/obj/projectile/P = new impact_type(location ? location.loc : get_turf(src))

		if(istype(P) && location)
			P.SetTransform(others = effect_transform)
			P.pixel_x = round(location.pixel_x, 1)
			P.pixel_y = round(location.pixel_y, 1)
			segments += P

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = INVISIBILITY_ABSTRACT //Nope!  Can't see me!
	yo = null
	xo = null
	var/result = 0 //To pass the message back to the gun.
	var/atom/hit_thing

/obj/item/projectile/test/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == firer)
		forceMove(A.loc)
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(istype(A, /mob/living))
		result = 2 //We hit someone, return 1!
		hit_thing = A
		return
	result = 1
	return

/obj/item/projectile/test/launch(atom/target)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return 0

	original = target

	//plot the initial trajectory
	setup_trajectory(curloc, targloc)
	return Process(targloc)

/obj/item/projectile/test/Process(turf/targloc)
	while(src) //Loop on through!
		if(result > 1)
			return hit_thing
		else if (result)
			return (result - 1)
		if((!( targloc ) || loc == targloc))
			targloc = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z) //Finding the target turf at map edge

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data
		if (!location)
			return 0

		Move(location.return_turf())

		var/mob/living/M = locate() in get_turf(src)
		if(istype(M)) //If there is someting living...
			return 1 //Return 1
		else
			M = locate() in get_step(src,targloc)
			if(istype(M))
				return 1

//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, pass_flags=PASS_FLAG_TABLE|PASS_FLAG_GLASS|PASS_FLAG_GRILLE, item_flags = null, obj_flags = null)
	if(!istype(target) || !istype(firer))
		return null

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(item_flags))
		trace.item_flags = item_flags
	if(!isnull(obj_flags))
		trace.obj_flags = obj_flags
	trace.pass_flags = pass_flags

	var/output = trace.launch(target) //Test it!
	var/hit_thing = trace.hit_thing
	qdel(trace) //No need for it anymore
	return output ? hit_thing : null //Send it back to the gun!

/obj/item/projectile/after_wounding(obj/item/organ/external/organ, datum/wound/wound)
	//Check if we even broke skin in first place
	if (!wound || !(wound.damage_type == INJURY_TYPE_CUT || wound.damage_type == INJURY_TYPE_PIERCE))
		return
	//Check if we can do nasty stuff inside
	if(!can_embed() || (organ.species.species_flags & SPECIES_FLAG_NO_EMBED))
		return
	//Embed or sever artery
	var/damage_prob = 0.5 * wound.damage * penetration_modifier
	if(prob(damage_prob))
		var/obj/item/shrapnel = get_shrapnel()
		if(shrapnel)
			shrapnel.forceMove(organ)
			organ.embed(shrapnel)
	else if(prob(2 * damage_prob))
		organ.sever_artery()

	organ.owner.projectile_hit_bloody(src, wound.damage*5, null, organ)

/obj/item/projectile/proc/get_shrapnel()
	if(shrapnel_type)
		var/obj/item/SP = new shrapnel_type()
		SP.SetName((name != "shrapnel")? "[name] shrapnel" : "shrapnel")
		SP.desc += " It looks like it was fired from [shot_from]."
		return SP

/obj/item/projectile/Process_Spacemove()
	return TRUE	//Bullets don't drift in space
