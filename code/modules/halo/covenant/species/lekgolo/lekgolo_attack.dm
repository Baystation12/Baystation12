


// Mgalekgolo Weapon Datum //

/datum/mgalekgolo_weapon
	var/name = "weapon"

	var/obj/item/projectile/proj
	var/charge_sound
	var/fire_sound

	var/active = 0 //Denotes if the weapon is active.
	var/charge_drain = 10 //Amount of charge to drain per fire.
	var/charge_max = 100 //The max charge in their weapon.
	var/charge_amount = 100
	var/charge_recharge_amount = 5 //The amount of "charge" to recharge each life tick.

	var/next_shot
	var/shot_delay = 2 //Delay between each shot, in seconds.

/datum/mgalekgolo_weapon/fuel_rod_cannon
	name = "Fuel Rod Cannon"

	proj = /obj/item/projectile/bullet/covenant/hunter_fuel_rod
	fire_sound = 'code/modules/halo/sounds/hunter_cannon.ogg'
	charge_sound = 'code/modules/halo/sounds/hunter_charge.ogg'

	charge_max = 50
	charge_amount = 50

	shot_delay = 1.5 SECONDS



// Helper procs //

/mob/living/simple_animal/mgalekgolo/proc/get_allowed_attack_dirs(var/facing_forward = 0)
	var/list/allowed_attack_dirs = list()
	var/check_dir = dir
	if(facing_forward)
		check_dir = GLOB.reverse_dir[check_dir]
	switch(check_dir)
		if(NORTH)
			allowed_attack_dirs = list(SOUTH,SOUTHEAST,SOUTHWEST)
		if(NORTHEAST)
			allowed_attack_dirs = list(SOUTH,WEST,SOUTHWEST)
		if(NORTHWEST)
			allowed_attack_dirs = list(SOUTH,EAST,SOUTHEAST)
		if(SOUTH)
			allowed_attack_dirs = list(NORTH,NORTHEAST,NORTHWEST)
		if(SOUTHEAST)
			allowed_attack_dirs = list(NORTH,NORTHWEST,NORTHEAST)
		if(SOUTHWEST)
			allowed_attack_dirs = list(NORTH,EAST,NORTHEAST)
		if(EAST)
			allowed_attack_dirs = list(WEST,NORTHWEST,SOUTHWEST)
		if(WEST)
			allowed_attack_dirs = list(EAST,NORTHEAST,SOUTHEAST)

	return allowed_attack_dirs



// Mgalekgolo ranged attacks //

/mob/living/simple_animal/mgalekgolo/RangedAttack(var/atom/A)
	if(!crouched)
		to_chat(src,"<span class='notice'>You must be crouched to fire!</span>")
		return

	var/attackdir = get_dir(src,A)
	if(!(attackdir in get_allowed_attack_dirs(1)))
		to_chat(src,"<span class='notice'>You must be facing [A] to fire at it!</span>")
		return

	if(isnull(active_weapon))
		return
	if(active_weapon.next_shot > world.time)
		if(current_target)
			to_chat(src,"<span class = 'notice'>You refocus your aim.</span>")
			current_target = A
			return
		else
			to_chat(src,"<span class = 'warning'>Your [active_weapon.name] is still charging.</span>")
		return

	if((active_weapon.charge_amount - active_weapon.charge_drain) <= 0)
		visible_message("<span class = 'warning'>[name]'s [active_weapon.name] fizzles weakly.</span>")
		return

	if(active_weapon.charge_sound)
		playsound_local(loc,active_weapon.charge_sound,110,1,,5)

	current_target = A
	active_weapon.next_shot = world.time + active_weapon.shot_delay
	if(do_after(src, active_weapon.shot_delay))
		var/obj/item/projectile/new_proj = new active_weapon.proj (loc)
		new_proj.permutated += src //A workaround for the projectile colliding with the 64x64 bounds of the sprite.
		new_proj.launch(current_target)
		if(active_weapon.fire_sound)
			playsound_local(loc,active_weapon.fire_sound,110,1,,5)
		current_target = null
		//active_weapon.charge_amount -= active_weapon.charge_drain



// Mgalekgolo melee attacks //

/mob/living/simple_animal/mgalekgolo/UnarmedAttack(var/atom/A, var/proximity)
	var/attackdir = get_dir(src,A)
	if(!(attackdir in get_allowed_attack_dirs(1)))
		to_chat(src,"<span class='notice'>You must be facing [A] to attack it!</span>")
		return

	. = ..()
