//Fired from the ripper, a sawblade deals constant damage to things it touches


//Totals for damaging objects.An ex_act call at the appropriate strength will be triggered every time the blade deals this much total damage to a dense object
#define EX3_TOTAL 45
#define EX2_TOTAL 90
#define EX1_TOTAL 170

#define SOUND_GRIND	'sound/weapons/sawblade_grind.ogg'
#define SOUND_NORMAL 'sound/weapons/sawblade_normal.ogg'

//These are defined here to prevent duplication
#define SAWBLADE_HEALTH 400
#define DIAMONDBLADE_HEALTH 1200


//When dropped unbroken the blade takes a bit of damage from the fall
#define DROP_DAMAGE 25

//Applied when a non-remotecontrolled blade hits a wall or other solid object
#define IMPACT_DAMAGE 60

/obj/item/projectile/sawblade
	name = "sawblade"
	desc = "Oh god, run, RUN!"
	damage_type = BRUTE
	//The compile time damage var is only used for blade launch mode. It will be replaced with a calculated value in remote control mode
	damage = 30

	//How much Damage Per Second is dealt to targets the blade hits in remote control mode. This is broken up into many small hits based on tick interval
	var/dps	=	30
	check_armour = "melee" //Its a cutting blade, melee armor helps most
	dispersion = 0
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "sawblade_projectile"
	mouse_opacity = 1
	pass_flags = PASS_FLAG_TABLE
	sharp = 1
	edge = 1
	step_delay = 2.5 //Lower air velocity than bullets
	penetrating = 1 //Allows check_penetrate to be called on this projectle when it fails to pass through something.
	//We will override that to make sure it always passes through mobs

	var/mob/user

	//If true we have dropped a remnant
	var/dropped = FALSE

	//The gun that launched us. Why the heck don't other projectiles track this?
	var/obj/item/weapon/gun/projectile/ripper/launcher

	//If true, we are being controlled by gravity tether
	//If false, it was launched as a normal projectile
	var/remote_controlled = FALSE

	//The sawblade has three states
	//STATE_STABLE: The blade is exactly on the user's cursor and is remaining still
	//STATE_MOVING: The blade isnt on the cursor and is moving towards it
	//STATE_GRINDING: The blade ran into a solid object while moving and is now grinding up against it, unable to complete movement
	var/status = STATE_MOVING

	//When the sawblade runs out of health, it breaks
	health = SAWBLADE_HEALTH

	//The turf we are currently attacking. This may be the same one we're in, or an adjacent one.
	//The sawblade will only damage things in the damage tile
	var/turf/damage_tile	= 	null

	//How quickly the blade moves towards the user's cursor. This is measured in pixels per second.
	var/tracking_speed	=	64
	var/tracking_per_tick //Calculated at runtime



	//Time in seconds between ticks of damage and movement. The lower this is, the smoother and more granular things are
	var/tick_interval	=	0.2

	//These variables cache where the user's cursor is, and thusly where we are trying to get to.
	var/turf/target_turf	=	null

	//Our X/Y location expressed as pixels from world 0. Useful for interpolation
	var/vector2/global_pixel_loc = new /vector2(0,0)

	var/timer_handle //Used for tick timer

	//A list of atoms we are grinding against and their damage counters. Entries in this list are in the format:
	//list(atom, ex3counter, ex2counter, ex1counter)
	var/list/grind_atoms = list()

	//Used to handle the looping sawblade audio
	var/datum/sound_token/saw_sound
	var/current_loop //Which looped sound is currently playing

	//The ammo item to drop when we are released but not quite broken
	var/ammo_type = /obj/item/ammo_casing/sawblade

	//The broken sawblade item to drop when we run out of health
	var/trash_type = /obj/item/trash/broken_sawblade

	//This bizarrely named variable is actually projectile lifetime
	kill_count = 1000

//The advanced version. A bit more damage, a LOT more durability
/obj/item/projectile/sawblade/diamond
	damage = 40
	dps = 40
	health = DIAMONDBLADE_HEALTH
	name = "diamond blade"
	desc = "glittering death approaches"
	icon_state = "diamond_projectile"
	ammo_type = /obj/item/ammo_casing/sawblade/diamond
	trash_type = /obj/item/trash/broken_sawblade/diamond

//Ammo version for picking up and loading
/obj/item/ammo_casing/sawblade
	name = "sawblade"
	desc = "a steel toothed blade with hardened plasteel tips, designed as ammunition for the RC-DS Remote Control Disc Ripper"
	icon_state = "sawblade"
	caliber = "saw"
	projectile_type = /obj/item/projectile/sawblade
	health = SAWBLADE_HEALTH //The ammo versions have a health value which is carried over from the projectile if an unbroken blade is dropped
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "plasteel" = 125)

	//An uninserted sawblade is also a modestly good weapon to swing around
	w_class = ITEM_SIZE_NORMAL
	force = 12
	throwforce = 15
	sharp = TRUE
	edge = TRUE

/obj/item/ammo_casing/sawblade/examine(var/mob/user)
	.=..()
	//Show damage on inspection
	if (health < initial(health))
		var/hp = health / initial(health)
		switch (hp)
			if (0.8 to 1.0)
				user << "It has a few minor scuffs and scratches"
			if (0.5 to 0.8)
				user << SPAN_WARNING("It is worn and shows significant stress fractures")
			if (0.3 to 0.5)
				user << SPAN_WARNING("It is blunted and chipped, has clearly seen heavy use")
			else
				user << SPAN_DANGER("It is cracked and bent, likely to shatter if used again")

//Damaged blades are worth less to recyle. Every 1% health lost reduces matter by 0.5%
/obj/item/ammo_casing/sawblade/get_matter()
	var/hp = health / initial(health)
	var/matmult = (0.5 * hp) + 0.5 //This will give a value in the range 0.5..1.0
	var/list/returnmat = list()
	for (var/m in matter)
		returnmat[m] = matter[m] * matmult

	return returnmat

/obj/item/ammo_casing/sawblade/diamond
	name = "sawblade"
	desc = "a glittering blade with a diamond-coated plasteel edge. Extremely durable and designed for grinding through the toughest materials."
	icon_state = "diamondblade"
	projectile_type = /obj/item/projectile/sawblade/diamond
	health = DIAMONDBLADE_HEALTH
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "plasteel" = 250, "diamond" = 125)


//Dropped when a blade breaks. These are trash subtype for easy categorising and pickup
/obj/item/trash/broken_sawblade
	name = "fragmented sawblade"
	layer = BELOW_TABLE_LAYER //Trash falls under objects
	//icon = 'icons/obj/trash.dmi' //Just putting this here for reference, no need to duplicate it
	icon_state = "sawblade"
	desc = "This was once a precisely machined cutting tool. Now it is just scrap metal for recycling"
	matter = list(DEFAULT_WALL_MATERIAL = 300, "plasteel" = 40) //The broken versions contain roughly a third of the original matter when recycled


/obj/item/trash/broken_sawblade/diamond
	name = "shattered diamond blade"
	icon_state = "diamondblade"
	desc = "This glittering blade was once a durable cutting edge, it must have seen heavy use to end up like this. May still contain some valueable materials to recycle"
	matter = list(DEFAULT_WALL_MATERIAL = 300, "plasteel" = 80, "diamond" = 40) //The broken versions contain roughly a third of the original matter when recycled

//We don't need to stop the looping audio here, it will do that itself
/obj/item/projectile/sawblade/Destroy()
	.=..()
	//If the blade is suddenly deleted for any reason, we want the launcher to stop controlling it
	if (launcher && launcher.blade == src) //Make sure its actually controlling us, dont mess with other blades
		launcher.blade = null //Unset ourself first to prevent recursion. It's assumed we've already handled dropping by now
		launcher.stop_firing() //And tell it to stop. This will remove the tether beam and allow the launcher to fire again

	if (!dropped)
		drop()


/obj/item/projectile/sawblade/Initialize()
	.=..()
	//When created, lets populate some initial variables


	tracking_per_tick = tracking_speed * tick_interval


//Called when a sawblade is launched in remote control mode
/obj/item/projectile/sawblade/proc/control_launched(var/obj/item/weapon/gun/projectile/ripper/gun)
	launcher = gun //Register the ripper
	if (launcher)
		pixel_click = launcher.last_clickpoint //Grab an initial clickpoint so that we don't fly towards world zero
	remote_controlled = TRUE //Set this flag
	damage = dps * tick_interval //Overwrite the compiletime damage with the calculated value
	animate_movement = 0 //Disable this to prevent byond's built in sliding, we do our own animate calls
	density = FALSE //Prevent it from colliding with things, we simulate our own colliusions
	damage_tile = get_turf(src) //Damage tile starts off as wherever we are
	set_sound(SOUND_NORMAL) //Set up the quiet whirring noise of a sawblade in empty air
	tick() //And do the first tick, this will start daisy chaining tick calls

/obj/item/projectile/sawblade/proc/tick()
	timer_handle = null //This has been successfully called, that handle is no use now
	if (!loc || QDELETED(src))
		return

	track_cursor()
	damage_turf()

	//Set the next timer handle
	timer_handle = addtimer(CALLBACK(src, .proc/tick, TRUE), tick_interval, TIMER_STOPPABLE)


//Move towards the cursor
/obj/item/projectile/sawblade/proc/track_cursor()

	global_pixel_loc = get_global_pixel_loc()




	//Ok now we're going to decide how much we can move towards the target point
	var/vector2/diff = pixel_click - global_pixel_loc //Get a vec2 that represents the difference between our current location and the target

	//If its farther than we can go in one tick...
	if (diff.Magnitude() > tracking_per_tick)
		diff = diff.ToMagnitude(tracking_per_tick)//We rescale the magnitude of the diff


	//Now before we do animating, lets check if this movement is going to put us into a different tile
	var/vector2/newpix = new /vector2((pixel_x + diff.x), (pixel_y + diff.y))
	if (is_outside_cell(newpix))
		//Yes it will, lets find that tile
		var/turf/newtile = get_turf_at_pixel_offset(newpix)

		//There's no tile there? We must be at the edge of the map, abort!
		if (!newtile)
			return

		damage_tile = newtile //Even if we don't get in, the tile we're about to enter becomes the new place we damage

		//Before going any farther, we must check if we're able to enter that new tile.
		//This function tests that and, if blocked, will return the first solid thing we would bump into
		var/atom/blocker = newtile.can_enter(src)



		//Something blocked us!
		if (blocker)
			status = STATE_GRINDING

			add_grind_atom(blocker)//We will start grinding against it

			//We can still animate a little towards it, up to 8 pixels into its tile
			if (is_far_outside_cell(newpix))
				//If we get here, we would intrude too far into that tile, so we cutoff this tracking and don't move towards it anymore
				return

			//If we get here, then we can still move a little closer, so proceed with animation as normal
		else
			//If nothing blocks us, then we're clear to just swooce right into that tile.
			//We want the animation to finish first though so lets spawn it
			spawn(tick_interval SECONDS)
				set_global_pixel_loc(get_global_pixel_loc()) //This will move us into the tile while maintaining our global pixel coords

	animate(src, pixel_x = newpix.x, pixel_y = newpix.y)


/obj/item/projectile/sawblade/proc/damage_turf()
	//Solid objects will block the blade first
	if (status == STATE_GRINDING)
		//We iterate through the grind atoms and see if we can hit any of them
		for (var/list/l in grind_atoms)
			var/atom/A = l[1]
			//If the atom is gone, remove from this list
			if (QDELETED(A))
				grind_atoms.Remove(l)
				continue

			//The atom must be in the damage tile
			//Or BE the damage tile
			if (A.loc == damage_tile || A == damage_tile)

				//A destroyed wall turns into a floor with no density, but its still the same memory address.
				//We want to detect that and stop cutting into a floor
				if (A == damage_tile && !A.density)
					grind_atoms.Remove(l)
					continue

				//Sometimes bullet_act modifies a projectile's damage. To workaround that, we'll cache it here and restore it afterwards
				var/cache_damage = damage

				//We call bullet act, maybe the object has a built in reaction to this. But we'll also build towards our fallback method
				A.bullet_act(src)
				damage = cache_damage

				health -= damage

				A.pixel_x += rand(-1,1)
				A.pixel_y += rand(-1,1)
				//Explosion counters for a blocker decrease by the damage amount each tick.
				//The ripper can cut through almost anything if the blade lasts long enough. Low quality blades generally won't though
				l[2] -= damage
				if (l[2] <= 0)
					l[2] = EX3_TOTAL
					A.shake_animation(2)
					A.ex_act(3)


				l[3] -= damage
				if (l[3] <= 0)
					l[3] = EX2_TOTAL
					A.shake_animation(4)
					A.ex_act(2)

				l[4] -= damage
				if (l[4] <= 0)
					l[4] = EX1_TOTAL
					A.shake_animation(8)
					A.ex_act(1)

				updatehealth()
				set_sound(SOUND_GRIND)//We're grinding, play the grind sound
				return //After dealing damage to a single hard target, we return. It prevents us from damaging anything else this tick.
				//Mobs hiding behind something sturdy are safe, temporarily at least


	//If we manage to get here, we aren't grinding on anything, play the normal non-grind sound
	set_sound(SOUND_NORMAL)

	//Deals damage to mobs in the damage tile
	for (var/mob/living/L in damage_tile)
		var/cache_damage = damage
		attack_mob(L, 0, 0)
		damage = cache_damage
		health -= damage
		updatehealth()


/obj/item/projectile/sawblade/proc/add_grind_atom(var/atom/A)
	//Adds an atom to our list of grind items. this is stored indefinitely (until this sawblade is deleted)
	if (!QDELETED(A))
		grind_atoms += list(list(A, EX3_TOTAL, EX2_TOTAL, EX1_TOTAL))

/obj/item/projectile/sawblade/proc/updatehealth()
	if (health <= 0)
		if (launcher && launcher.blade == src)
			launcher.stop_firing()

//Override this so it doesn't delete itself when touching anything
/obj/item/projectile/sawblade/Bump(atom/A as mob|obj|turf|area, forced=0)
	if (remote_controlled)
		return 0
	return ..()

//If the blade has health left, this will drop a reuseable sawblade casing on the floor and delete ourself
//Otherwise, it will drop either a broken sawblade or shrapnel, which has no purpose except to recycle for metal
/obj/item/projectile/sawblade/proc/drop()
	if (dropped)
		return


	dropped = TRUE

	playsound(get_turf(src),'sound/effects/weightdrop.ogg', 70, 1, 1) //Clunk!
	if (health < DROP_DAMAGE)
		playsound(src, "shatter", 70, 1)

		var/obj/item/broken = new trash_type(loc)
		broken.set_global_pixel_loc(QDELETED(src) ? global_pixel_loc : get_global_pixel_loc())//Make sure it appears exactly below this disk

		//And lets give it a random rotation to make it look like it just fell there
		var/matrix/M = matrix()
		M.Turn(rand(0,360))
		broken.transform = M

	else
		//If health remains, the sawblade drops on the floor
		health -= DROP_DAMAGE //Take some damage from the dropping
		var/obj/item/ammo_casing/sawblade/ammo = new ammo_type(loc)
		ammo.set_global_pixel_loc(QDELETED(src) ? global_pixel_loc : get_global_pixel_loc())//Make sure it appears exactly below this disk
		ammo.health = health //Set its health to ours
		//And lets give it a random rotation to make it look like it just fell there
		var/matrix/M = matrix()
		M.Turn(rand(0,360))
		ammo.transform = M

	//Once we've placed either a blade or a broken remnant, delete this projectile
	//We spawn it off to prevent recursion issues, make sure the launcher does its cleanup first

	spawn()
		if (!QDELETED(src))
			qdel(src)

/obj/item/projectile/sawblade/proc/set_sound(var/soundin)

	//Null is passed in when the sawblade is deleted. This will stop the sound
	if (!soundin)
		QDEL_NULL(saw_sound)
		return

	if (soundin == current_loop)
		return //Dont restart the sound we're already playing

	//If a sound is already playing, we'll stop it to start the new one, but not immediately
	if (saw_sound)
		qdel(saw_sound)
		//var/datum/sound_token/copied = saw_sound
		//spawn(3)//Let it overlap with the new one for just a little bit, to prevent having any silence
			//qdel(copied)

	var/volume = 15
	var/range = 9
	//The sound is lounder when grinding against objects
	if (soundin == SOUND_GRIND)
		volume = 50
		range = 15

	//And start the new sound
	//This random field is an ID, i assume it has to be unique
	saw_sound = GLOB.sound_player.PlayLoopingSound(src, /obj/item/projectile/sawblade, soundin, volume, range)
	current_loop = soundin


//Will only be called in saw launcher mode. Just overridden here so we can hook in the audio
/obj/item/projectile/sawblade/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	set_sound(SOUND_NORMAL)
	.=..()


//Only called for blades in saw launcher mode, and only if they fail to penetrate through an object under normal rules.
//This proc basically asks if we want to override a failed result.
/obj/item/projectile/sawblade/check_penetrate(var/atom/A)
	//Blades will always slice through mobs
	//Possible TODO: Check that the mob is organic
	if (istype(A, /mob/living))
		return TRUE
	else
		//We don't pass through walls and hard objects
		return FALSE


//Handle some effects on hitting mobs
/obj/item/projectile/sawblade/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	.=..()
	health -= damage
	playsound(target_mob, 'sound/weapons/bladeslice.ogg', 60, 1, 1)
	if (!remote_controlled)

		global_pixel_loc = get_global_pixel_loc() //Cache this so we know where to drop a remnant, for non remote blades

	spawn()
		updatehealth()


/obj/item/projectile/sawblade/on_impact(var/atom/A)
	if (!remote_controlled)
		global_pixel_loc = get_global_pixel_loc() //Cache this so we know where to drop a remnant, for non remote blades
		A.ex_act(3) //Some hefty damage is dealt, though its still less effective than remote control mode
		health -= IMPACT_DAMAGE //Don't bother updating, it will drop momentarily anyway

		drop()

#undef DROP_DAMAGE
#undef IMPACT_DAMAGE

#undef EX3_TOTAL
#undef EX2_TOTAL
#undef EX1_TOTAL

#undef SOUND_GRIND
#undef SOUND_NORMAL

#undef STATE_STABLE
#undef STATE_GRIND
#undef STATE_MOVING