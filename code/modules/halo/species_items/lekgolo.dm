
/mob/living/simple_animal/lekgolo
	name = "Lekgolo"
	desc = "A large mass of constantly squirming worms."

	maxHealth = 300
	health = 300
	unsuitable_atoms_damage = 0
	var/custom_name

	stop_automated_movement = 1
	wander = 0

	melee_damage_lower = 1
	melee_damage_upper = 2
	attacktext = "ineffectively pushed"
	a_intent = I_HURT

	languages = list(LANGUAGE_SANGHEILI,LANGUAGE_LEKGOLO)

	response_help   = "pokes"
	response_disarm = "pokes"
	response_harm   = "scoops out a handful of worms from"
	harm_intent_damage = 10

/mob/living/simple_animal/lekgolo/New()
	for(var/language in languages)
		languages -= language
		add_language(language)
	return ..()

/mob/living/simple_animal/lekgolo/adjustToxLoss(damage)
	adjustBruteLoss(damage)

/mob/living/simple_animal/lekgolo/attackby(var/obj/item/O, var/mob/user)
	if(!O.force)
		visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
	else
		O.attack(src, user, user.zone_sel.selecting)

/mob/living/simple_animal/lekgolo/proc/regen_health()
	if(health <= 0)
		return
	health += 5

/mob/living/simple_animal/lekgolo/proc/random_name()
 	var/list/syllables = list("rg","rx","ll","rk","ck","rt","tr","rl","sn","ns","sl","ls","sp","ps")
 	var/list/vowels = list("a","e","i","o","u")
 	var/syllables_left = rand(4,10)
 	var/final_name = ""
 	while(syllables_left > 0)
		syllables_left -= 1
		final_name += pick(vowels)
		final_name += pick(syllables)
 	return final_name

/mob/living/simple_animal/lekgolo/verb/set_name()
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

/mob/living/simple_animal/lekgolo/Life()
	if(health < maxHealth)
		regen_health()
	return ..()

//Mgalekgolo defines//
/mob/living/simple_animal/lekgolo/mgalekgolo
	name = "mgalekgolo"
	desc = "A hulking monstrosity of flowing worms encased in starship-grade alloy."

	icon = 'code/modules/halo/icons/species/hunters.dmi'
	icon_state = "hunter_fuel_rod"
	icon_living = "hunter_fuel_rod"

	layer = ABOVE_HUMAN_LAYER

	maxHealth = 400
	health = 400
	unsuitable_atoms_damage = 0

	stop_automated_movement = 1
	wander = 0
	mob_size = MOB_LARGE
	speed = 2

	bound_width = 64
	bound_height = 64

	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY

	melee_damage_lower = 30
	melee_damage_upper = 50
	attacktext = "attacked"
	resistance = 35 //5 below an active energy sword

	response_help   = "pokes"
	response_disarm = "pokes"
	response_harm   = "thinks better about punching"
	harm_intent_damage = 0

	var/list/equipped_weapons = newlist(/datum/mgalekgolo_weapon/fuel_rod_cannon)
	var/atom/current_target

/mob/living/simple_animal/lekgolo/mgalekgolo/New()
	. = ..()
	name = capitalize(random_name())

/mob/living/simple_animal/lekgolo/mgalekgolo/Life()
	for(var/datum/mgalekgolo_weapon/W in equipped_weapons)
		if(W.charge_amount <= W.charge_max)
			W.charge_amount += W.charge_recharge_amount
	return ..()

/mob/living/simple_animal/lekgolo/mgalekgolo/proc/get_allowed_attack_dirs()
	var/list/allowed_attack_dirs = list()
	switch(dir)
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

/mob/living/simple_animal/lekgolo/mgalekgolo/bullet_act(var/obj/item/projectile/Proj)
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

/mob/living/simple_animal/lekgolo/mgalekgolo/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	if(!(get_dir(src,user) in get_allowed_attack_dirs()))
		if(prob(25) && O.force >= 35)//40 is force of active energysword.
			visible_message("<span class = 'danger'>[user] attacks [src.name] with \the [O.name], bypassing the armor plating!</span>")
			.=..()
		else
			visible_message("<span class = 'danger'>The [O.name] bounces off the armor of \the [name]</span>")
		return
	. = ..()

/mob/living/simple_animal/lekgolo/mgalekgolo/ex_act(severity)
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

//Mgalekgolo ranged-attacks //

/mob/living/simple_animal/lekgolo/mgalekgolo/proc/get_active_weapon()
	for(var/datum/mgalekgolo_weapon/W in equipped_weapons)
		if(W.active)
			return W

/mob/living/simple_animal/lekgolo/mgalekgolo/verb/activate_weapons()
	set name = "Switch Active Weapon"

	set category = "Abilities"

	var/weapon_to_activate = input("Activate which weapon?","Weapon Activation","Cancel") as anything in (equipped_weapons + list("Deactivate Weapons","Cancel"))
	if(weapon_to_activate == "Cancel")
		return
	if(weapon_to_activate == "Deactivate Weapons")
		weapon_to_activate = null
	set_active_weapon(weapon_to_activate)

/mob/living/simple_animal/lekgolo/mgalekgolo/proc/set_active_weapon(var/datum/mgalekgolo_weapon/new_weapon)
	for(var/datum/mgalekgolo_weapon/W in equipped_weapons)
		if(istype(W,new_weapon))
			W.active = 1
			visible_message("<span class = 'warning'>[name] readies their [W.name].</span>")
		else
			if(W.active)
				W.active = 0
				visible_message("<span class = 'warning'>[name] lowers their [W.name].</span>")

	if(get_active_weapon())//Move slower if you have a weapon readied.
		speed = 5
	else
		speed = initial(speed)

/mob/living/simple_animal/lekgolo/mgalekgolo/RangedAttack(var/atom/A)
	dir = get_dir(src,A)
	var/datum/mgalekgolo_weapon/active_weapon = get_active_weapon()
	if(isnull(active_weapon))
		return
	if(active_weapon.next_shot > world.time)
		if(current_target)
			to_chat(src,"<span class = 'notice'>You refocus your aim.</span>")
			current_target = A
		else
			to_chat(src,"<span class = 'warning'>Your [active_weapon.name] is still charging.</span>")
		return
	if((active_weapon.charge_amount - active_weapon.charge_drain) <= 0)
		visible_message("<span class = 'warning'>[name]'s [active_weapon.name] fizzles weakly.</span>")
		return
	if(active_weapon.charge_sound)
		playsound_local(loc,active_weapon.charge_sound,110,1,,5)
	spawn(active_weapon.shot_delay)
		var/obj/item/projectile/new_proj = new active_weapon.proj (loc)
		new_proj.permutated += src //A workaround for the projectile colliding with the 64x64 bounds of the sprite.
		new_proj.launch(current_target)
		if(active_weapon.fire_sound)
			playsound_local(loc,active_weapon.fire_sound,110,1,,5)
		current_target = null
	current_target = A
	active_weapon.charge_amount -= active_weapon.charge_drain
	active_weapon.next_shot = world.time + active_weapon.shot_delay

/mob/living/simple_animal/lekgolo/mgalekgolo/death()
	. = ..()
	spawn(10)
		visible_message("<span class = 'danger'>[name]'s fuel cell storage overloads!</span>")
		explosion(loc,0,0,0,10)
		qdel(src)

//Mgalekgolo Weapon Datum//
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

//Lekgolo Language Define//
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
