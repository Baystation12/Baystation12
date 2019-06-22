//Fired from the ripper, a sawblade deals constant damage to things it touches

/obj/item/projectile/sawblade
	name = "sawblade"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "melee" //Its a cutting blade, melee armor helps most
	dispersion = 0
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "ripper_projectile"
	mouse_opacity = 1
	pass_flags = PASS_FLAG_TABLE

	//The sawblade has three states
	//STATE_STABLE: The blade is exactly on the user's cursor and is remaining still
	//STATE_MOVING: The blade isnt on the cursor and is moving towards it
	//STATE_GRINDING: The blade ran into a solid object while moving and is now grinding up against it, unable to complete movement
	var/status = STATE_MOVING

	//When the sawblade runs out of health, it breaks
	health = 100

	//The turf we are currently attacking. This may be the same one we're in, or an adjacent one.
	//The sawblade will only damage things in the damage tile
	var/turf/damage_tile	= 	null

	//How quickly the blade moves towards the user's cursor. This is measured in pixels per second.
	var/tracking_speed	=	64
	var/tracking_per_tick

	//How much Damage Per Second is dealt to targets the blade hits. This is broken up into many small hits based on tick interval
	var/dps	=	20

	//Time in seconds between ticks of damage and movement. The lower this is, the smoother and more granular things are
	var/tick_interval	=	0.2

	//These variables cache where the user's cursor is, and thusly where we are trying to get to.
	var/turf/target_turf	=	null

	//Our X/Y location expressed as pixels from world 0. Useful for interpolation
	var/vector2/global_pixel_loc = new /vector2(0,0)

	var/timer_handle //Used for tick timer



/obj/item/projectile/sawblade/Initialize()
	.=..()
	//When created, lets populate some initial variables
	damage_tile = get_turf(src) //Damage tile starts off as wherever we are
	damage = dps * tick_interval
	tracking_per_tick = tracking_speed * tick_interval

//Caches our global pixel location. Used just before we move
/obj/item/projectile/sawblade/proc/set_global_pixel_loc()
	//The extra -16 offset here accounts for the graphics being in the centre of the sprite when at 0 pixel offsets
	global_pixel_loc.x	=	(x*world.icon_size) + pixel_x + 16
	global_pixel_loc.y	=	(y*world.icon_size) + pixel_y + 16


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
	if (status != STATE_MOVING)
		return
	set_global_pixel_loc()

	//Ok now we're going to decide how much we can move.
	var/vector2/diff = pixel_click - global_pixel_loc //Get a vec2 that represents the difference between our current location and the target
	var/pixeldist = diff.Magnitude() //Lets see how far it is
	//If its farther than we can go in one tick...
	if (pixeldist > tracking_per_tick)
		diff = diff.ToMagnitude(tracking_per_tick)//We rescale the magnitude of the diff

	animate(src, pixel_x = (pixel_x + diff.x), pixel_y = (pixel_y + diff.y))



/obj/item/projectile/sawblade/proc/damage_turf()
	//Deals damage to mobs in the damage tile
	for (var/mob/living/L in damage_tile)
		attack_mob(L, 0, 0)
		health -= damage
		updatehealth()

/obj/item/projectile/sawblade/proc/updatehealth()
	if (health <= 0)
		world << "Sawblade ran out of health, deleting"
		qdel(src)

//Override this so it doesn't delete itself when touching anything
/obj/item/projectile/sawblade/Bump(atom/A as mob|obj|turf|area, forced=0)
	return 0


//Ammo version for picking up and loading
/obj/item/ammo_casing/sawblade
	desc = "sawblade"
	caliber = "saw"
	projectile_type = /obj/item/projectile/sawblade