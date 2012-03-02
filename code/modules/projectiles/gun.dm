/obj/item/weapon/gun
	name = "\improper Gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY
	m_amt = 2000
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"

	var
		fire_sound = 'Gunshot.ogg'
		obj/item/projectile/in_chamber = null
		caliber = ""
		silenced = 0
		recoil = 0
		tmp/mob/target
		tmp/lock_time = -100
		mouthshoot = 0

	proc
		load_into_chamber()
		special_check(var/mob/M)


	load_into_chamber()
		return 0

//Removing the lock and the buttons.
	dropped(mob/user as mob)
		if(target)
			target.NotTargeted(src)
		del(user.item_use_icon)
		del(user.gun_move_icon)
		del(user.gun_run_icon)
		return ..()

	special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1


	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)

//Handling lowering yer gun.
	attack_self()
		if(target)
			target.NotTargeted(src)
			usr.visible_message("[usr] lowers \the [src].")
			return 0
		return 1

//Suiciding.
	attack(mob/living/M as mob, mob/living/user as mob, def_zone)
		if (M == user && user.zone_sel.selecting == "mouth" && load_into_chamber() && !mouthshoot)
			mouthshoot = 1
			M.visible_message("\red [user] sticks their gun in their mouth, ready to pull the trigger...")
			if(!do_after(user, 40))
				M.visible_message("\blue [user] decided life was worth living")
				return
			if(istype(src.in_chamber, /obj/item/projectile/bullet) && !istype(src.in_chamber, /obj/item/projectile/bullet/stunshot))
				M.apply_damage(75, BRUTE, "head", used_weapon = "Suicide attempt with a projectile weapon.")
				M.apply_damage(85, BRUTE, "chest")
				M.visible_message("\red [user] pulls the trigger.")
			else if(istype(src.in_chamber, /obj/item/projectile/bullet/stunshot) || istype(src.in_chamber, /obj/item/projectile/energy/electrode))
				M.apply_damage(10, BURN, "head", used_weapon = "Suicide attempt with a stun round.")
				M.visible_message("\red [user] pulls the trigger, but luckily it was a stun round.")
			else if(istype(src.in_chamber, /obj/item/projectile/beam) || istype(src.in_chamber, /obj/item/projectile/energy))
				M.apply_damage(75, BURN, "head", used_weapon = "Suicide attempt with an energy weapon")
				M.apply_damage(85, BURN, "chest")
				M.visible_message("\red [user] pulls the trigger.")
			else
				M.apply_damage(75, BRUTE, "head", used_weapon = "Suicide attempt with a gun")
				M.apply_damage(85, BRUTE, "chest")
				M.visible_message("\red [user] pulls the trigger. Ow.")
			del(src.in_chamber)
			mouthshoot = 0
			return
		else if(target && M == target)
			PreFire(M,user)
		else
			return ..()


//POWPOW!...  Used to be afterattack.
	proc/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params)//TODO: go over this
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if ((M.mutations & CLUMSY) && prob(50))
				M << "\red \the [src] blows up in your face."
				M.take_organ_damage(0,20)
				M.drop_item()
				del(src)
				return

		if (!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return

		add_fingerprint(user)

		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		if(!special_check(user))	return
		if(!load_into_chamber())
			user << "\red *click*";
			for(var/mob/M in orange(4,src.loc))
				M.show_message("*click, click*")
			return

		if(!in_chamber)	return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting

		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)
			user.visible_message("\red [user] fires the [src]!", "\red You fire the [src]!", "\blue You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = targloc
		in_chamber.loc = get_turf(user)
		user.next_move = world.time + 4
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				in_chamber.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				in_chamber.p_y = text2num(mouse_control["icon-y"])

		spawn()
			if(in_chamber)	in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()
		return


//Aiming at the target mob.
	proc/Aim(var/mob/M)
		if(target != M)
			lock_time = world.time
			if(target)
				//usr.ClearRequest("Aim")
				target.NotTargeted(src)
				usr.visible_message("[usr] turns \the [src] on [M]!")
			else
				usr.visible_message("[usr] aims \a [src] at [M]!")
			for(var/mob/K in viewers(usr))
				K << 'TargetOn.ogg'
			M.Targeted(src)


//HE MOVED, SHOOT HIM!
	proc/TargetActed()
		var/mob/M = loc
		if(target == M) return
		usr.last_move_intent = world.time
		Fire(target,usr)
		var/dir_to_fire = sd_get_approx_dir(M,target)
		if(dir_to_fire != M.dir)
			M.dir = dir_to_fire

	afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
		if(flag)	return //we're placing gun on a table or in backpack
		if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?
		PreFire(A,user,params)

//Compute how to fire.....
	proc/PreFire(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, params)
		if(usr.a_intent in list("help","grab","disarm"))
			//GraphicTrace(usr.x,usr.y,A.x,A.y,usr.z)
			if(lock_time > world.time - 2) return
			if(!ismob(A))
//				var/mob/M = locate() in range(0,A)
//				if(M && !ismob(A))
//					if(M.type == /mob)
//						return FindTarget(M,user,params)
				var/mob/M = GunTrace(usr.x,usr.y,A.x,A.y,usr.z,usr)
				if(M && ismob(M) && !target)
					Aim(M)
					return
			if(ismob(A) && target != A)
				Aim(A)
			else if(lock_time < world.time + 10)
				Fire(A,user,params)
			else if(!target)
				Fire(A,user,params)
			//else
				//var/item/gun/G = usr.OHand
				//if(!G)
					//Fire(A,0)
				//else if(istype(G))
					//G.Fire(A,3)
					//Fire(A,2)
				//else
					//Fire(A)
			var/dir_to_fire = sd_get_approx_dir(usr,A)
			if(dir_to_fire != usr.dir)
				usr.dir = dir_to_fire
		else
			Fire(A, user)


//Yay, math!

#define SIGN(X) ((X<0)?-1:1)

proc/GunTrace(X1,Y1,X2,Y2,Z=1,exc_obj,PX1=16,PY1=16,PX2=16,PY2=16)
	//bluh << "Tracin' [X1],[Y1] to [X2],[Y2] on floor [Z]."
	var/turf/T
	var/mob/M
	if(X1==X2)
		if(Y1==Y2) return 0 //Light cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1+=s
			while(1)
				T = locate(X1,Y1,Z)
				if(!T) return 0
				M = locate() in T
				if(M) return M
				M = locate() in orange(1,T)-exc_obj
				if(M) return M
				Y1+=s
	else
		var
			m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
			b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
			signX = SIGN(X2-X1)
			signY = SIGN(Y2-Y1)
		if(X1<X2) b+=m
		while(1)
			var/xvert = round(m*X1+b-Y1)
			if(xvert) Y1+=signY //Line exits tile vertically
			else X1+=signX //Line exits tile horizontally
			T = locate(X1,Y1,Z)
			if(!T) return 0
			M = locate() in T
			if(M) return M
			M = locate() in orange(1,T)-exc_obj
			if(M) return M
	return 0


//Targeting management procs
mob/var
	list/targeted_by
	target_time = -100
	last_move_intent = -100
	last_target_click = -5
	obj/effect/target_locked/target_locked = null

mob/proc
	Targeted(var/obj/item/weapon/gun/I)
		if(!targeted_by) targeted_by = list()
		targeted_by += I
		I.target = src
		//I.lock_time = world.time + 10 //Target has 1 second to realize they're targeted and stop (or target the opponent).
		src << "((\red <b>Your character is being targeted. They have 1 second to stop any click or move actions.</b> \black While targeted, they may \
		drag and drop items in or into the map, speak, and click on interface buttons. Clicking on the map, their items \
		 (other than a weapon to de-target), or moving will result in being fired upon. \red The aggressor may also fire manually, \
		 so try not to get on their bad side.\black ))"
		if(targeted_by.len == 1)
			spawn(0)
				target_locked = new /obj/effect/target_locked(src)
				overlays += target_locked
				spawn flick("locking",target_locked)
				var/mob/T = I.loc
				//Adding the buttons to the controler person
				if(T)
					T.item_use_icon = new /obj/screen/gun/item(null)
					T.gun_move_icon = new /obj/screen/gun/move(null)
					if(T.client)
						T.client.screen += T.item_use_icon
						T.client.screen += T.gun_move_icon
				while(targeted_by)
					sleep(1)
					if(last_move_intent > I.lock_time + 10 && !T.target_can_move) //If the target moved while targeted
						I.TargetActed()
						I.lock_time = world.time + 5
					else if(last_move_intent > I.lock_time + 10 && !T.target_can_run && m_intent == "run") //If the target ran while targeted
						I.TargetActed()
						I.lock_time = world.time + 5
					if(last_target_click > I.lock_time + 10 && !T.target_can_click) //If the target clicked the map to pick something up/shoot/etc
						I.TargetActed()
						I.lock_time = world.time + 5

	NotTargeted(var/obj/item/weapon/gun/I,silent)
		if(!silent)
			for(var/mob/M in viewers(src))
				M << 'TargetOff.ogg'
		del(target_locked)
		targeted_by -= I
		update_clothing()
		I.target = null
		var/mob/T = I.loc
		if(T && ismob(T))
			del(T.item_use_icon)
			del(T.gun_move_icon)
			del(T.gun_run_icon)
		if(!targeted_by.len) del targeted_by

/*	Captive(var/obj/item/weapon/gun/I)
		Sound(src,'CounterAttack.ogg')
		if(!targeted_by) targeted_by = list()
		targeted_by += I
		I.target = src
//		Stun("Captive")
		I.lock_time = world.time + 10 //Target has 1 second to realize they're targeted and stop (or target the opponent).
		src << "(Your character is being held captive. They have 1 second to stop any click or move actions. While held, they may \
		drag and drop items in or into the map, speak, and click on interface buttons. Clicking on the map or their items \
		 (other than a weapon to de-target) will result in being attacked. The aggressor may also attack manually, \
		 so try not to get on their bad side.)"
		if(targeted_by.len == 1)
			var/mob/T = I.loc
			while(targeted_by)
				sleep(1)
				if(last_target_click > I.lock_time + 10 && !T.target_can_click) //If the target clicked the map to pick something up/shoot/etc
					I.TargetActed()

	NotCaptive(var/obj/item/weapon/gun/I,silent)
		if(!silent) Sound(src,'SwordSheath.ogg')
//		UnStun("Captive")
		targeted_by -= I
		I.target = null
		if(!targeted_by.len) del targeted_by*/


//Used to overlay the awesome stuff
/obj/effect
//	target_locking
//		icon = 'icons/effects/Targeted.dmi'
//		icon_state = "locking"
//		layer = 99
	target_locked
		icon = 'icons/effects/Targeted.dmi'
		icon_state = "locked"
		layer = 99
//	captured
//		icon = 'Captured.dmi'
//		layer = 99

//If you move out of range, it isn't going to still stay locked on you any more.
mob/var
	target_can_move = 0
	target_can_run = 0
	target_can_click = 0
mob/Move()
	. = ..()
	for(var/obj/item/weapon/gun/G in targeted_by)
		var/mob/M = G.loc
		if(!(M in view(src)))
			//ClearRequest("Aim")
			NotTargeted(G)
	for(var/obj/item/weapon/gun/G in src)
		if(G.target)
			if(!(G.target in view(src)))
				//ClearRequest("Aim")
				G.target.NotTargeted(G)
mob/verb
//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
	AllowTargetMove()
		set hidden=1
		spawn(1) target_can_move = !target_can_move
		if(!target_can_move)
//			winset(usr,"default.target_can_move","is-flat=true;border=sunken")
			usr << "Target may now walk."
			gun_run_icon = new /obj/screen/gun/run(null)
			if(client)
				client.screen += gun_run_icon
		else
//			winset(usr,"default.target_can_move","is-flat=false;border=none")
			usr << "Target may no longer move."
			target_can_run = 0
			del(gun_run_icon)
		for(var/obj/item/weapon/gun/G in src)
			G.lock_time = world.time + 5
			if(G.target)
				if(!target_can_move)
					G.target << "Your character may now <b>walk</b> at the discretion of their targeter."
				else
					G.target << "\red <b>Your character will now be shot if they move.</b>"
	AllowTargetRun()
		set hidden=1
		spawn(1) target_can_run = !target_can_run
		if(!target_can_run)
//			winset(usr,"default.target_can_move","is-flat=true;border=sunken")
			usr << "Target may now run."
		else
//			winset(usr,"default.target_can_move","is-flat=false;border=none")
			usr << "Target may no longer run."
		for(var/obj/item/weapon/gun/G in src)
			G.lock_time = world.time + 5
			if(G.target)
				if(!target_can_run)
					G.target << "Your character may now <b>run</b> at the discretion of their targeter."
				else
					G.target << "\red <b>Your character will now be shot if they run.</b>"
	AllowTargetClick()
		set hidden=1
		spawn(1) target_can_click = !target_can_click
		if(!target_can_click)
//			winset(usr,"default.target_can_click","is-flat=true;border=sunken")
			usr << "Target may now use items."
		else
//			winset(usr,"default.target_can_click","is-flat=false;border=none")
			usr << "Target may no longer use items."
		for(var/obj/item/weapon/gun/G in src)
			G.lock_time = world.time + 5
			if(G.target)
				if(!target_can_click)
					G.target << "Your character may now <b>use items</b> at the discretion of their targeter."
				else
					G.target << "\red <b>Your character will now be shot if they use items.</b>"