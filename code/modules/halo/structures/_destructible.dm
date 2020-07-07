
#define REPAIR_AMOUNT 100

/obj/structure/destructible
	name = "destructible"
	icon = 'code/modules/halo/structures/structures.dmi'
	anchored = 1
	density = 1
	var/health = 200
	var/maxHealth = 200
	var/closerange_freefire = 1 //mobs within 1 tile are allowed to shoot through if set to 1
	var/list/maneuvring_mobs = list()
	var/repair_material_name
	var/cover_rating = 10
	var/deconstruct_tools = list(/obj/item/weapon/weldingtool)
	var/list/loot_types = list(/obj/item/stack/material/steel)
	var/list/scrap_types = list(/obj/item/salvage/metal)
	var/dead_type
	var/climbable = 1

/obj/structure/destructible/New()
	. = ..()
	if(health != maxHealth)
		health = maxHealth

	if(climbable)
		verbs += /obj/structure/destructible/proc/verb_climb

	update_icon()

/obj/structure/destructible/update_icon()
	. = ..()
	if(flags & ON_BORDER)
		throwpass = 1
		if(dir & SOUTH)
			plane = ABOVE_HUMAN_PLANE
			layer = ABOVE_HUMAN_LAYER
		else
			plane = OBJ_PLANE
			layer = BELOW_TABLE_LAYER

/obj/structure/destructible/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack))
		if(repair_material_name)
			if(W.get_material_name() == repair_material_name && istype(W, /obj/item/stack))
				var/obj/item/stack/D = W
				if (D.get_amount() > 0)
					if (health < maxHealth - REPAIR_AMOUNT)
						visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
						if(do_after(user,20,src) && D.use(1))
							repair_damage(REPAIR_AMOUNT)
							to_chat(user, "\icon[src] <span class='info'>You repair \the [src]. It is now \
								[round(100*health/maxHealth)]% repaired (+[round(100*REPAIR_AMOUNT/maxHealth)]%).</span>")
					else
						to_chat(user, "<span class='notice'>You cannot repair [src] any more.</span>")
				else
					to_chat(user, "<span class='warning'>You need at least 1 sheet of [D] \
						to repair \the [src] (+[round(100*REPAIR_AMOUNT/maxHealth)]%).</span>")
			else
				to_chat(user, "<span class='warning'>You need a stack of [repair_material_name] to repair \the [src] \
					(+[round(100*REPAIR_AMOUNT/maxHealth)]%).</span>")
		else
			to_chat(user, "<span class='warning'>[src] cannot be repaired.</span>")

	else if(attempt_deconstruct(W, user))
		if(do_after(user,20,src))
			dismantle()

	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(W.damtype == "brute")
			take_damage(W.force)
		..()

/obj/structure/destructible/proc/attempt_deconstruct(obj/item/W as obj, mob/user as mob)
	. = 0

	if (!(W in deconstruct_tools))
		return 0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			return 1
		else
			to_chat(user, "<span class='warning'>You need more fuel.</span>")

/obj/structure/destructible/attack_generic(var/mob/user, var/damage, var/attacktext)
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")
	take_damage(damage)

/obj/structure/destructible/bullet_act(var/obj/item/projectile/Proj)
	. = ..()
	take_damage(Proj.damage)
	playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)

/obj/structure/destructible/proc/dismantle()
	for(var/spawn_type in loot_types)
		new spawn_type(src.loc)
	for(var/obj/I in parts)
		I.loc = src
	qdel(src)
	return

/obj/structure/destructible/CanPass(atom/movable/mover, turf/start, height=0, air_group=0)//So bullets will fly over and stuff.

	//this proc is called when something is trying to enter our turf
	//set a return value now in case of runtimes (this is the default result for full tile things)
	. = !density

	//air and virtual entities
	if(air_group || height==0)
		return 1

	//flying
	if(mover.elevation != elevation)
		return 1

	//we're not blocking anything so skip the processing later
	if(!density)
		return 1

	//by default, assume we will bump
	var/is_bumping = 1

	//are we only blocking the edge of the tile?
	if(src.flags & ON_BORDER)
		//check if we are trying to cross that edge
		is_bumping = edge_bump_check(mover, get_turf(src))

	if(is_bumping)

		//bullets have special handling
		if(istype(mover, /obj/item/projectile))
			if(projectile_block_check(mover))
				return 0
			return 1

		//let thrown objects enter our turf if we arent entirely blocked off
		//eg grenades, supplies
		if(mover.throwing)
			return climbable

		return 0

	else
		//something is trying to enter the turf via a different edge to us
		return 1

/obj/structure/destructible/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)

	//something is trying to leave our turf
	//by default, always allow it to leave regardless of density
	. = 1

	//flying
	if(mover.elevation != elevation)
		return 1

	//we're not blocking anything so skip the processing later
	if(!density)
		return 1

	var/is_bumping = 0

	//are we only blocking the edge of the tile?
	if(src.flags & ON_BORDER)
		//check if we are trying to cross that edge
		is_bumping = edge_bump_check(mover, target)

	if(is_bumping)

		//bullets have special handling
		if(istype(mover, /obj/item/projectile))
			if(projectile_block_check(mover))
				return 0
			return 1

		//let thrown objects exit our turf if we arent entirely blocked off
		//eg grenades, supplies
		if(mover.throwing)
			return climbable

		return 0

	return 1

/obj/structure/destructible/proc/edge_bump_check(var/atom/movable/mover, var/turf/target_turf)
	//this proc assumes that src is on a tile edge. return 1 if the mover will bump with that edge

	var/turf/start_turf = get_turf(mover)
	var/turf/our_turf = get_turf(src)
	var/move_dir = get_dir(start_turf, target_turf)

	//trying to exit our turf
	if(start_turf == our_turf)

		//trying to exit our turf via the edge we cover
		if(move_dir & src.dir)
			return 1

	//sanity check: are we trying to enter the turf?
	if(target_turf != our_turf)
		//then we arent going to bump
		return 0

	//mover must be trying to enter our turf
	var/check_dir = get_dir(our_turf, start_turf)

	//it's a little easier to work in reverse here
	var/list/block_dirs = list(src.dir)
	block_dirs.Add(turn(src.dir, 45))
	block_dirs.Add(turn(src.dir, -45))

	//mover is trying to cross our tile edge
	if(check_dir in block_dirs)
		return 1

/obj/structure/destructible/proc/projectile_block_check(var/obj/item/projectile/P)
	var/modified_cover_rating = cover_rating
	if(P.starting)
		//get_dist() will return 0 for on top of, 1 for adjacent and surrounds
		var/dist = get_dist(get_turf(src), P.starting)

		if(closerange_freefire && dist <= 1)
			//never block bullets fired from an adjacent turf
			modified_cover_rating = 0

		else if(dist < 3)
			//reduced block chance
			modified_cover_rating *= 0.5

	//percent chance to block the bullet
	var/blocked = prob(modified_cover_rating)
	return blocked


/*
/obj/structure/destructible/Bumped(atom/movable/AM)
	if(isliving(AM) && AM:a_intent == I_HELP)
		if(istype(AM, /mob/living/simple_animal/))
			return
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob)
				return
		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvring past [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips past [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			var/mob/moving = AM
			moving.show_message("<span class='warning'>Something is blocking you from maneuvering past [src].</span>")
	. = ..()
*/
/obj/structure/destructible/ex_act(severity)
	//explosions do extra damage
	take_damage(severity * 50)

/obj/structure/destructible/proc/take_damage(var/amount)
	health -= amount
	if(health <= 0)
		place_scraps()
		qdel(src)
	else
		update_icon()

/obj/structure/destructible/proc/repair_damage(var/amount)
	health = min(health + amount, maxHealth)
	update_icon()

/obj/structure/destructible/proc/place_scraps()
	if(scrap_types.len && prob(33))
		var/spawn_type = pick(scrap_types)
		new spawn_type(src.loc)
	else if(loot_types.len && prob(50))
		var/spawn_type = pick(loot_types)
		new spawn_type (src.loc)
		for(var/obj/I in parts)
			I.Move(src.loc)
	if(dead_type)
		var/atom/movable/A = new dead_type(src.loc)
		A.dir = src.dir

/obj/structure/destructible/examine(var/mob/user)
	. = ..()
	var/out_text = ""
	if(flags & ON_BORDER)
		out_text += "It is oriented [dir2text(src.dir)]."

	if(health >= maxHealth)
		out_text += " <span class='info'>It is at maximum repair.</span>"
	else if(health > maxHealth * 0.66)
		out_text += " <span class='info'>It is slightly damaged.</span>"
	else if(health > maxHealth * 0.33)
		out_text += " <span class='notice'>It is moderately damaged.</span>"
	else
		out_text += " <span class='danger'>It is heavily damaged.</span>"

	if(repair_material_name)
		out_text += " It can be repaired with [repair_material_name]."

	if(length(out_text))
		to_chat(user,out_text)

/obj/structure/destructible/proc/structure_climb(var/mob/living/user)

	if(istype(user))
		var/climb_dir = get_dir(user, src)
		if(user.loc == src.loc)
			climb_dir = src.dir
		var/turf/T = get_step(user, climb_dir)
		if(T.CanPass(user, T))
			user.dir = climb_dir
			to_chat(user, "<span class='notice'>You start climbing over [src]...</span>")
			if(do_after(user, 30))
				src.visible_message("<span class='info'>[user] climbs over [src].</span>")
				user.loc = T
		else
			to_chat(user,"<span class='warning'>You cannot climb over [src] as it is being blocked.</span>")

/obj/structure/destructible/proc/verb_climb()
	set name = "Climb over structure"
	set category = "Object"
	set src = view(1)

	structure_climb(usr)

/obj/structure/destructible/MouseDrop_T(atom/movable/target, mob/user)
	if(climbable && istype(target))
		if(target == user)
			structure_climb(user)
		else
			var/target_turf
			if(get_turf(target) != src.loc)
				var/target_dir = get_dir(get_turf(target), src)
				target_turf = get_step(get_turf(target), target_dir)
			else
				target_turf = get_step(get_turf(target), user.dir)
			if(do_after(user, 30))
				src.visible_message("<span class='info'>[user] moves the [target] past [src].</span>")
				target.loc = target_turf
	else
		to_chat(user,"<span class='notice'>You cannot fit that past [src]!</span>")



/* SS13 STRUCTURE PROCS */
/*
	These proc overrides are to enable simple mobs to destroy them, necessary for Firefight gamemodes.
*/

/obj/structure/barricade/attack_generic(var/mob/living/attacker, var/damage, var/attacktext)
	src.visible_message("<span class='danger'>[attacker] has [attacktext] [src]!</span>")
	health -= damage
	if (src.health <= 0)
		visible_message("<span class='danger'>[src] is smashed apart!</span>")
		dismantle()
		qdel(src)

/obj/structure/table/attack_generic(var/mob/living/attacker, var/damage, var/attacktext)
	src.visible_message("<span class='danger'>[attacker] has [attacktext] [src]!</span>")
	health -= damage
	if (src.health <= 0)
		visible_message("<span class='danger'>[src] is smashed apart!</span>")
		break_to_parts()
		qdel(src)

/obj/structure/closet/attack_generic(var/mob/living/attacker, var/damage, var/attacktext)
	src.visible_message("<span class='danger'>[attacker] has [attacktext] [src]!</span>")
	health -= damage
	if (src.health <= 0)
		visible_message("<span class='danger'>[src] is smashed apart!</span>")
		dump_contents()
		qdel(src)

/obj/structure/tree/attack_generic(var/mob/living/attacker, var/damage, var/attacktext)
	visible_message("<span class='danger'>[src] is smashed apart!</span>")
	if(prob(50))
		new /obj/item/stack/material/wood(src.loc)
	qdel(src)
