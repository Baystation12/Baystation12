
/obj/structure/destructible
	name = "destructible"
	icon = 'code/modules/halo/structures/structures.dmi'
	anchored = 1
	density = 1
	var/health = 500
	var/maxHealth = 500
	var/list/maneuvring_mobs = list()
	var/repair_material
	var/cover_rating = 10
	var/deconstruct_tools = list(/obj/item/weapon/weldingtool)
	var/loot_type

/obj/structure/destructible/New()
	. = ..()
	if(health != maxHealth)
		health = maxHealth

	if(flags & ON_BORDER)
		throwpass = 1
		if(dir == 2)
			//might regret this but it looks cool
			layer = 5

/obj/structure/destructible/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != repair_material)
			to_chat(user, "<span class='warning'>You need [repair_material] to repair \the [src].</span>")
			return
		if (health < maxHealth)
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [repair_material] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20,src) && health < maxHealth)
				if (D.use(1))
					repair_damage(maxHealth/3)
					visible_message("<span class='notice'>[user] repairs \the [src]. It is now [round(100*health/maxHealth)]% repaired.</span>")
				return
		else
			to_chat(user, "<span class='info'>[src] is already at maximum repair.</span>")
		return

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
	if(loot_type)
		new loot_type(src.loc)
	for(var/obj/I in parts)
		I.loc = src
	qdel(src)
	return

/obj/structure/destructible/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.

	//default return value in case of runtimes
	. = !density

	//air and tiny little things
	if(air_group || height==0)
		return 1

	//flying
	if(mover.elevation != elevation)
		return 1

	//we're not blocking anything so skip the processing later
	//all the later processing assumes density = 1
	if(!density)
		return 1

	//we are a structure on the edge of the tile
	if(src.flags & ON_BORDER)
		if(mover.checkpass(PASSTABLE) || mover.throwing)
			//PASSTABLE is for low flying things like projectiles, bullets, meteors etc which move over low structures

			//check if we're coming from behind the structure
			var/list/block_dirs = list(src.dir)
			block_dirs.Add(turn(src.dir, 45))
			block_dirs.Add(turn(src.dir, -45))

			var/incoming_dir = get_dir(src, mover)

			if(incoming_dir in block_dirs)
				//provide physical cover based on how effective we are
				return !prob(cover_rating)
			else
				return 1

		else if(get_dir(src, mover) == src.dir)
			//mobs, vehicles etc
			return 0

	//we are a full tile structure
	if(mover.checkpass(PASSTABLE) || mover.throwing)
		return !prob(cover_rating)

/obj/structure/destructible/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	//by default, always able to leave despite density
	. = 1

	//directional blocking can sometimes prevent leaving this tile
	if(src.flags & ON_BORDER)

		//check if we're coming from behind the structure
		var/list/block_dirs = list(src.dir)
		block_dirs.Add(turn(src.dir, 45))
		block_dirs.Add(turn(src.dir, -45))

		var/exit_dir = get_dir(src, target)

		//there is a chance we could block exit here
		if(exit_dir in block_dirs)
			if(mover.throwing)
				//thrown things can always leave
				return 1

			if(mover.checkpass(PASSTABLE))
				//fired projectiles from the barricade can always leave
				var/obj/item/projectile/P = mover
				if(istype(P) && mover.checkpass(PASSTABLE))
					//but only if they were fired from this turf
					if(P.starting == src.loc)
						return 1
					else
						//standard % block chance
						return !prob(cover_rating)
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
	if(prob(33))
		new /obj/item/metalscraps(src.loc)
	else if(prob(50))
		new loot_type (src.loc)
		for(var/obj/I in parts)
			I.Move(src.loc)

/obj/structure/destructible/examine(var/mob/user)
	. = ..()
	var/out_text = ""
	if(flags & ON_BORDER)
		out_text += "It is oriented [dir2text(src.dir)]. "

	if(health >= maxHealth)
		out_text += "<span class='info'>It is at maximum repair.</span>"
	else if(health > maxHealth * 0.66)
		out_text += "<span class='info'>It is slightly damaged.</span>"
	else if(health > maxHealth * 0.33)
		out_text += "<span class='notice'>It is moderately damaged.</span>"
	else
		out_text += "<span class='danger'>It is heavily damaged.</span>"

	if(length(out_text))
		to_chat(user,out_text)

/obj/structure/destructible/proc/structure_climb(var/mob/living/user)

	if(istype(user))
		var/climb_dir = get_dir(user, src)
		if(user.loc == src.loc)
			climb_dir = src.dir
		var/turf/T = get_step(src, climb_dir)
		if(T.CanPass(user, T))
			user.dir = climb_dir
			to_chat(user, "<span class='notice'>You start climbing over [src]...</span>")
			spawn(0)
				if(do_after(user, 30))
					src.visible_message("<span class='info'>[user] climbs over [src].</span>")
					user.loc = T
		else
			to_chat(user,"<span class='warning'>You cannot climb over [src] as it is being blocked.</span>")
