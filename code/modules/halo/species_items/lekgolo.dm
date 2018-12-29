
//Mgalekgolo defines//
/mob/living/simple_animal/mgalekgolo
	name = "mgalekgolo"
	desc = "A hulking monstrosity of flowing worms encased in starship-grade alloy."

	icon = 'code/modules/halo/icons/species/hunters.dmi'
	icon_state = "hunter0"
	icon_living = "hunter0"
	icon_dead = "hunter_dead"

	layer = ABOVE_HUMAN_LAYER

	maxHealth = 400
	health = 400
	unsuitable_atoms_damage = 0
	var/crouched = 0

	stop_automated_movement = 1
	wander = 0
	mob_size = MOB_LARGE
	speed = 2
	var/crouch_speed = 20

	bound_width = 64
	bound_height = 64

	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	var/custom_name

	languages = list(LANGUAGE_SANGHEILI,LANGUAGE_LEKGOLO)
	melee_damage_lower = 30
	melee_damage_upper = 50
	attacktext = "swiped"
	a_intent = I_HURT
	resistance = 35 //5 below an active energy sword
	attack_sound = 'sound/weapons/heavysmash.ogg'

	/*response_help   = "pokes"
	response_disarm = "pokes"
	response_harm   = "thinks better about punching"*/
	harm_intent_damage = 10

	var/datum/mgalekgolo_weapon/active_weapon = /datum/mgalekgolo_weapon/fuel_rod_cannon
	var/atom/current_target

	var/hud_setup = 0

/mob/living/simple_animal/mgalekgolo/New()
	. = ..()

	name = capitalize(random_name())

	active_weapon = new active_weapon()

	for(var/language in languages)
		languages -= language
		add_language(language)

	//create our actions
	for(var/action_type in typesof(/obj/item/hunter_action) - /obj/item/hunter_action)
		new action_type(src)

/mob/living/simple_animal/mgalekgolo/adjustToxLoss(damage)
	adjustBruteLoss(damage)

/mob/living/simple_animal/mgalekgolo/attackby(var/obj/item/O, var/mob/user)
	if(!O.force)
		visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
	else
		O.attack(src, user, user.zone_sel.selecting)

/mob/living/simple_animal/mgalekgolo/proc/random_name()
 	var/list/syllables = list("rg","rx","ll","rk","ck","rt","tr","rl","sn","ns","sl","ls","sp","ps")
 	var/list/vowels = list("a","e","i","o","u")
 	var/final_name = pick(syllables) + pick(vowels) + pick(syllables) + pick(vowels) + pick(syllables) + pick(vowels) + pick(syllables) + pick(vowels) + pick(syllables) + pick(vowels) + pick(syllables) + pick(vowels)
 	//The loop that was doing the above in previous versions was causing crashes. I've only done it this way as a temporary fix until a more efficient version does not crash.
 	return final_name

/mob/living/simple_animal/mgalekgolo/Life()
	//handle hud updates. there might be a better way to do this
	if(client)
		if(!hud_setup)
			hud_setup = update_action_buttons()
	else if(hud_setup)
		hud_setup = 0

	//heal a little
	if(stat != DEAD && health < maxHealth)
		health += 4

	//regain charge
	if(active_weapon.charge_amount <= active_weapon.charge_max)
		active_weapon.charge_amount += active_weapon.charge_recharge_amount
	return ..()

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

/mob/living/simple_animal/mgalekgolo/bullet_act(var/obj/item/projectile/Proj)
	if(!(get_dir(src,Proj.starting) in get_allowed_attack_dirs()))
		if((Proj.penetrating >= 5) && (Proj.armor_penetration >= 80)) //Values taken from sniper rifle round.
			Proj.damage *= 0.5
			. = ..()
			Proj.damage = initial(Proj.damage)
		return
		if(prob(25))
			visible_message("<span class = 'danger'>The [Proj.name] is partially reflected by \the [name]'s armor plating.</span>")
			Proj.damage *= 0.25 //So you can theoretically just shoot the hunter to death from the front.
			. = ..()
			Proj.damage = initial(Proj.damage)
		else
			visible_message("<span class = 'danger'>The [Proj.name] is stopped by \the [name]'s armor plating.</span>")
		return
	. = ..()

/mob/living/simple_animal/mgalekgolo/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	if(!(get_dir(src,user) in get_allowed_attack_dirs()))
		if(prob(25) && O.force >= 35)//40 is force of active energysword.
			visible_message("<span class = 'danger'>[user] attacks [src.name] with \the [O.name], bypassing the armor plating!</span>")
			.=..()
		else
			visible_message("<span class = 'danger'>The [O.name] bounces off the armor of \the [name]</span>")
		return
	. = ..()

/mob/living/simple_animal/mgalekgolo/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/damage
	switch (severity)
		if (1.0)
			damage = 100

		if (2.0)
			damage = 50

		if(3.0)
			damage = 20

	adjustBruteLoss(damage)

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
		active_weapon.charge_amount -= active_weapon.charge_drain

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

	proj = /obj/item/projectile/covenant/hunter_fuel_rod
	fire_sound = 'code/modules/halo/sounds/hunter_cannon.ogg'
	charge_sound = 'code/modules/halo/sounds/hunter_charge.ogg'

	charge_max = 50
	charge_amount = 50

	shot_delay = 1.5 SECONDS

// Lekgolo Language Define //

/datum/language/lekgolo
	name = LANGUAGE_LEKGOLO
	desc = "A language developed by lekgolo colonies to allow for communication."
	speech_verb = "emits a rumbling sound"
	ask_verb = "emits a rumbling sound"
	exclaim_verb = "emits a rumbling sound"
	colour = "changeling"
	key = "u"
	flags = RESTRICTED | NO_STUTTER
	native = 1
	syllables = list()
	machine_understands = 0

/mob/living/simple_animal/mgalekgolo/verb/set_name()
	set name = "Set Name"

	set category = "Abilities"

	if(custom_name)
		to_chat(src,"<span class = 'notice'>You've already changed your name. Contact an admin for further name modification.</span>")
		return
	var/user_input_name = input("Change your name","Name Change",null)
	if(isnull(user_input_name))
		return
	real_name = user_input_name
	name = real_name
	custom_name = real_name

/mob/living/simple_animal/mgalekgolo/SelfMove(turf/n, direct)
	var/olddir = dir
	.  = Move(n, direct)
	if(crouched)
		dir = olddir

/obj/item/hunter_action
	icon = 'code/modules/halo/icons/species/hunter_actions.dmi'
	var/mob/living/simple_animal/mgalekgolo/owner

/obj/item/hunter_action/New()
	owner = loc
	if(!istype(owner))
		qdel(src)

/obj/item/hunter_action/crouch
	action_button_name = "Crouch"
	icon_state = "crouch"

/obj/item/hunter_action/crouch/ui_action_click()
	if(owner)
		owner.toggle_crouch()

/mob/living/simple_animal/mgalekgolo/verb/toggle_crouch()
	set category = "IC"
	set name = "Toggle crouch"

	if(crouched)
		visible_message("\icon[src] <span class='notice'>[src] stands up.</span>")
	else
		visible_message("\icon[src] <span class='warning'>[src] drops into a combat crouch.</span>")

	if(do_after(src, 10))
		crouched = !crouched
		icon_state = "hunter[crouched]"
		if(crouched)
			speed = crouch_speed
		else
			speed = initial(speed)

		//dont worry about updating the icon, it's more trouble than its worth
		/*
		var/obj/item/hunter_action/crouch/crouch_action = locate() in src
		if(crouch_action)
			if(crouched)
				crouch_action.action_button_name = "Stand up"
				crouch_action.icon_state = "stand"
			else
				crouch_action.action_button_name = "Crouch"
				crouch_action.icon_state = "crouch"
				*/

/obj/item/hunter_action/turn_cw
	action_button_name = "Turn clockwise"
	icon_state = "turn_cw"

/obj/item/hunter_action/turn_cw/ui_action_click()
	if(owner)
		owner.turn_cw()

/mob/living/simple_animal/mgalekgolo/verb/turn_cw()
	set category = "IC"
	set name = "Turn Clockwise"

	visible_message("\icon[src] <span class='notice'>[src] shuffles to face the right.</span>")
	if(do_after(src, 20))
		facedir(GLOB.cw_dir[dir], 1)

/obj/item/hunter_action/turn_ccw
	action_button_name = "Turn counter-clockwise"
	icon_state = "turn_ccw"

/obj/item/hunter_action/turn_ccw/ui_action_click()
	if(owner)
		owner.turn_ccw()

/mob/living/simple_animal/mgalekgolo/verb/turn_ccw()
	set category = "IC"
	set name = "Turn Counterclockwise"

	visible_message("\icon[src] <span class='notice'>[src] shuffles to face the left.</span>")
	if(do_after(src, 20))
		facedir(GLOB.cww_dir[dir], 1)

//see code\modules\mob\mob.dm
/mob/living/simple_animal/mgalekgolo/facedir(var/ndir, var/mgalekgolo_allowed = 0)
	if(mgalekgolo_allowed)
		return ..()
	return 0
