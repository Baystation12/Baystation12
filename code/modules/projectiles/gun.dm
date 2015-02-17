//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list("metal" = 2000)
	w_class = 3
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	var/fire_delay = 6
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/recoil = 0		//screen shake
	var/silenced = 0
	var/accuracy = 0 //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null

	var/last_fired = 0
	
	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

/obj/item/weapon/gun/New()
	..()
	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

//Returns 1 if the gun is able to be fired
/obj/item/weapon/gun/proc/ready_to_fire()
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
		return 1
	else
		return 0

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/weapon/gun/proc/special_check(var/mob/user)
	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	
	var/mob/living/M = user
	
	if(HULK in M.mutations)
		M << "<span class='danger'>Your fingers are much too large for the trigger guard!</span>"
		return 0
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				user.visible_message(
					"<span class='danger'>[user] shoots \himself in the foot with \the [src]!</span>", 
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0
	return 1

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	//decide whether to aim or shoot normally
	var/aiming = 0
	if(user && user.client && !(A in aim_targets))
		var/client/C = user.client
		//If help intent is on and we have clicked on an eligible target, switch to aim mode automatically
		if(user.a_intent == "help" && isliving(A) && !C.gun_mode)
			C.ToggleGunMode()

		if(C.gun_mode)
			aiming = PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.

	if (!aiming)
		if(user && user.a_intent == "help") //regardless of what happens, refuse to shoot if help intent is on
			user << "\red You refrain from firing your [src] as your intent is set to help."
		else
			Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == "mouth" && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == "hurt") //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(!user || !target) return

	add_fingerprint(user)

	if(!special_check(user))
		return

	if (!ready_to_fire())
		if (world.time % 3) //to prevent spam
			user << "<span class='warning'>[src] is not ready to fire again!"
		return

	var/obj/projectile = consume_next_projectile(user)
	if(!projectile)
		handle_click_empty(user)
		return

	user.next_move = world.time + 4

	if(process_projectile(projectile, user, target, user.zone_sel.selecting, params, pointblank, reflex))
		handle_post_fire(user, target, pointblank, reflex)

		update_icon()
		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()


//obtains the next projectile to fire
/obj/item/weapon/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/weapon/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone 
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user)

//called if there was no projectile to shoot
/obj/item/weapon/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
	else
		src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

//called after successfully firing
/obj/item/weapon/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 1)
		user.visible_message(
			"<span class='danger'>[user] fires [src][pointblank ? "  point blank at [target]":""][reflex ? " by reflex":""]!</span>",
			"<span class='warning'>You fire [src][reflex ? "by reflex":""]!</span>",
			"You hear a [fire_sound_text]!"
		)
	
	if(recoil)
		spawn()
			shake_camera(user, recoil+1, recoil)
	update_icon()

//does the actual shooting
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null, var/pointblank=0, var/reflex=0)
	if(!istype(projectile, /obj/item/projectile))
		return 0 //default behaviour only applies to true projectiles
	
	var/obj/item/projectile/P = projectile
	
	//shooting while in shock
	var/x_offset = 0
	var/y_offset = 0
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			y_offset = rand(-2,2)
			x_offset = rand(-2,2)
		else if(mob.shock_stage > 70)
			y_offset = rand(-1,1)
			x_offset = rand(-1,1)

	//Point blank bonus
	if(pointblank) P.damage *= 1.3

	//TODO: accuracy modifiers

	if(params)
		P.set_clickpoint(params)

	return !P.launch(target, user, src, target_zone, x_offset, y_offset)

//Suicide handling.
/obj/item/weapon/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>
/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user
	
	mouthshoot = 1
	M.visible_message("\red [user] sticks their gun in their mouth, ready to pull the trigger...")
	if(!do_after(user, 40))
		M.visible_message("\blue [user] decided life was worth living")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != HALLOSS)
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
			user.death()
		else
			user << "<span class = 'notice'>Ow...</span>"
			user.apply_effect(110,AGONY,0)
		del(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/weapon/gun/proc/toggle_scope(var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset
	
	zoom(zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(recoil)
			recoil = round(recoil*zoom_amount+1) //recoil is worse when looking through a scope

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/weapon/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)
