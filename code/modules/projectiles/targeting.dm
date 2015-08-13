/obj/item/weapon/gun/verb/toggle_firerate()
	set name = "Toggle Continue Aiming"
	set category = "Object"

	keep_aim = !keep_aim

	if (keep_aim)
		loc << "You will now continue firing when your target moves."
	else
		loc << "You will now only fire once, then lower your aim, when your target moves."

/obj/item/weapon/gun/verb/lower_aim()
	set name = "Lower Aim"
	set category = "Object"
	if(aim_targets)
		stop_aim()
		usr.visible_message("<span class='notice'> \The [usr] lowers \the [src]...</span>")

//Removing the lock and the buttons.
/obj/item/weapon/gun/dropped(mob/user as mob)
	stop_aim()
	if(user && user.client)
		user.client.remove_gun_icons()
	return ..()

/obj/item/weapon/gun/equipped(var/mob/user, var/slot)
	if (slot != slot_l_hand && slot != slot_r_hand)
		stop_aim()
		if (user.client)
			user.client.remove_gun_icons()
	return ..()

//Removes lock from all targets
/obj/item/weapon/gun/proc/stop_aim()
	if(aim_targets)
		for(var/mob/living/M in aim_targets)
			if(M)
				M.NotTargeted(src) //Untargeting people.
		qdel(aim_targets)

//Compute how to fire.....
//Return 1 if a target was found, 0 otherwise.
/obj/item/weapon/gun/proc/PreFire(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, params)
	//Lets not spam it.
	if(lock_time > world.time - 2) return

	user.set_dir(get_cardinal_dir(src, A))
	if(isliving(A) && !(A in aim_targets))
		Aim(A) 	//Clicked a mob, aim at them
		return 1

	//Didn't click someone, check if there is anyone along that guntrace
	var/mob/living/M = GunTrace(usr.x,usr.y,A.x,A.y,usr.z,usr)  //Find dat mob.
	if(isliving(M) && (M in view(user)) && !(M in aim_targets))
		Aim(M) //Aha!  Aim at them!
		return 1

	return 0

//Aiming at the target mob.
/obj/item/weapon/gun/proc/Aim(var/mob/living/M)
	if(!aim_targets || !(M in aim_targets))
		lock_time = world.time
		if(aim_targets && !multi_aim) //If they're targeting someone and they have a non multi_aim weapon.
			for(var/mob/living/L in aim_targets)
				if(L)
					L.NotTargeted(src)
			qdel(aim_targets)
			usr.visible_message("<span class='danger'><b>[usr] turns \the [src] on [M]!</b></span>")
		else
			usr.visible_message("<span class='danger'><b>[usr] aims \a [src] at [M]!</b></span>")
		M.Targeted(src)

//HE MOVED, SHOOT HIM!
/obj/item/weapon/gun/proc/TargetActed(var/mob/living/T)
	var/mob/living/M = loc
	if(M == T) return
	if(!istype(M)) return
	if(src != M.get_active_hand())
		stop_aim()
		return

	//reflex firing is disabled when help intent is set
	if (M.a_intent == I_HELP)
		M << "<span class='danger'>You refrain from firing your [src] as your intent is set to help.</span>"
		return

	M.last_move_intent = world.time
	var/firing_check = can_hit(T,usr) //0 if it cannot hit them, 1 if it is capable of hitting, and 2 if a special check is preventing it from firing.
	if(firing_check > 0)
		if(firing_check == 1)
			Fire(T,usr, reflex = 1)
	else if(!told_cant_shoot)
		M << "<span class='danger'>They can't be hit from here!</span>"
		told_cant_shoot = 1
		spawn(30)
			told_cant_shoot = 0

	usr.set_dir(get_cardinal_dir(src, T))

	if (!keep_aim) // If keep_aim is set to lower aim after one shot, untarget the target
		T.NotTargeted(src)

//Yay, math!

#define SIGN(X) ((X<0)?-1:1)

/proc/GunTrace(X1,Y1,X2,Y2,Z=1,exc_obj,PX1=16,PY1=16,PX2=16,PY2=16)
	//bluh << "Tracin' [X1],[Y1] to [X2],[Y2] on floor [Z]."
	var/turf/T
	var/mob/living/M
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
/mob/var
	list/targeted_by
	target_time = -100
	last_move_intent = -100
	last_target_click = -5
	target_locked = null
	last_target_radio = -5;

/mob/living/proc/Targeted(var/obj/item/weapon/gun/I) //Self explanitory.
	if(!I.aim_targets)
		I.aim_targets = list(src)
	else if(I.multi_aim && I.aim_targets.len < 5) //multi_aim weapon, they can hold down a room.
		I.aim_targets += src
	else if(I.aim_targets.len >= 5)
		if(ismob(I.loc))
			I.loc << "You can only target 5 people at once!"
		return
	else
		return
	for(var/mob/living/K in viewers(usr))
		K << 'sound/weapons/TargetOn.ogg'

	if(!targeted_by) targeted_by = list()
	targeted_by += I
	I.lock_time = world.time + 20 //Target has 2 second to realize they're targeted and stop (or target the opponent).
	src << "((<span class='danger'><b>Your character is being targeted. They have 2 seconds to stop any click or move actions.</b></span> While targeted, they may \
	drag and drop items in or into the map, speak, and click on interface buttons. Clicking on the map objects (floors and walls are fine), their items \
	 (other than a weapon to de-target), moving, or talking into a radio will result in being fired upon. <span class='danger'>The aggressor may also fire manually, \
	 so try not to get on their bad side.</span>))"

	if(targeted_by.len == 1)
		spawn(0)
			target_locked = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "locking")
			overlays += target_locked
			spawn(0)
				sleep(20)
				if(target_locked)
					target_locked = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "locked")
					update_targeted()

	//Adding the buttons to the controller person
	var/mob/living/T = I.loc
	if(T)
		if(T.client)
			T.client.add_gun_icons()
		else
			I.lower_aim()
			return
		if(iscarbon(src) && m_intent == "run" && T.client.target_can_move == 1 && T.client.target_can_run == 0)
			src << "<span class='danger'>Your move intent is now set to walk, as your targeter permits it.</span>"  //Self explanitory.
			set_m_intent("walk")

		//Processing the aiming. Should be probably in separate object with process() but lasy.
		while(targeted_by && T.client)
			if(last_move_intent > I.lock_time + 10 && !T.client.target_can_move) //If target moved when not allowed to
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			else if(last_move_intent > I.lock_time + 10 && !T.client.target_can_run && m_intent == "run") //If the target ran while targeted
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			if(last_target_click > I.lock_time + 10 && !T.client.target_can_click) //If the target clicked the map to pick something up/shoot/etc
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			if(last_target_radio > I.lock_time + 10 && !T.client.target_can_radio)
				I.TargetActed(src)
				if(I.last_moved_mob == src) //If they were the last ones to move, give them more of a grace period, so that an automatic weapon can hold down a room better.
					I.lock_time = world.time + 5
				I.lock_time = world.time + 5
				I.last_moved_mob = src
			sleep(1)

/mob/living/proc/NotTargeted(var/obj/item/weapon/gun/I)
	if(!I.silenced)
		for(var/mob/living/M in viewers(src))
			M << 'sound/weapons/TargetOff.ogg'
	targeted_by -= I
	I.aim_targets.Remove(src) //De-target them
	if(!I.aim_targets.len)
		qdel(I.aim_targets)
	var/mob/living/T = I.loc //Remove the targeting icons
	if(T && ismob(T) && !I.aim_targets && T.client)
		T.client.remove_gun_icons()
	if(!targeted_by.len)
		qdel(target_locked) //Remove the overlay
		qdel(targeted_by)
	spawn(1) update_targeted()

/mob/living/Move()
	. = ..()
	for(var/obj/item/weapon/gun/G in targeted_by) //Handle moving out of the gunner's view.
		var/mob/living/M = G.loc
		if(!(M in view(src)))
			NotTargeted(G)
	for(var/obj/item/weapon/gun/G in src) //Handle the gunner loosing sight of their target/s
		if(G.aim_targets)
			for(var/mob/living/M in G.aim_targets)
				if(M && !(M in view(src)))
					M.NotTargeted(G)

//If you move out of range, it isn't going to still stay locked on you any more.
/client/var
	target_can_move = 0
	target_can_run = 0
	target_can_click = 0
	target_can_radio = 0
	gun_mode = 0

//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/client/proc/add_gun_icons()
	if(!usr) return 1 // This can runtime if someone manages to throw a gun out of their hand before the proc is called.
	screen += usr.item_use_icon
	screen += usr.gun_move_icon
	screen += usr.radio_use_icon
	if (target_can_move)
		screen += usr.gun_run_icon



/client/proc/remove_gun_icons()
	if(!usr) return 1 // Runtime prevention on N00k agents spawning with SMG
	screen -= usr.item_use_icon
	screen -= usr.gun_move_icon
	screen -= usr.radio_use_icon
	if (target_can_move)
		screen -= usr.gun_run_icon

/client/verb/ToggleGunMode()
	set name = "Toggle Gun Mode"
	set hidden = 1
	gun_mode = !gun_mode
	if(gun_mode)
		usr << "You will now take people captive."
	else
		usr << "You will now shoot where you target."
		for(var/obj/item/weapon/gun/G in usr)
			G.stop_aim()
		remove_gun_icons()
	if(usr.gun_setting_icon)
		usr.gun_setting_icon.icon_state = "gun[gun_mode]"


/client/verb/AllowTargetMove()
	set hidden=1

	//Changing client's permissions
	target_can_move = !target_can_move
	if(target_can_move)
		usr << "Target may now walk."
		//usr.gun_run_icon = new /obj/screen/gun/run(null)	//adding icon for running permission
		screen += usr.gun_run_icon
	else
		usr << "Target may no longer move."
		target_can_run = 0
		qdel(usr.gun_run_icon)	//no need for icon for running permission

	//Updating walking permission button
	if(usr.gun_move_icon)
		usr.gun_move_icon.icon_state = "no_walk[target_can_move]"
		usr.gun_move_icon.name = "[target_can_move ? "Disallow" : "Allow"] Walking"

	//Handling change for all the guns on client
	for(var/obj/item/weapon/gun/G in usr)
		G.lock_time = world.time + 5
		if(G.aim_targets)
			for(var/mob/living/M in G.aim_targets)
				if(target_can_move)
					M << "Your character may now <b>walk</b> at the discretion of their targeter."
					if(!target_can_run)
						M << "<span class='danger'>Your move intent is now set to walk, as your targeter permits it.</span>"
						M.set_m_intent("walk")
				else
					M << "<span class='danger'><b>Your character will now be shot if they move.</b></span>"

/mob/living/proc/set_m_intent(var/intent)
	if (intent != "walk" && intent != "run")
		return 0
	m_intent = intent
	if(hud_used)
		if (hud_used.move_intent)
			hud_used.move_intent.icon_state = intent == "walk" ? "walking" : "running"

client/verb/AllowTargetRun()
	set hidden=1

	//Changing client's permissions
	target_can_run = !target_can_run
	if(target_can_run)
		usr << "Target may now run."
	else
		usr << "Target may no longer run."

	//Updating running permission button
	if(usr.gun_run_icon)
		usr.gun_run_icon.icon_state = "no_run[target_can_run]"
		usr.gun_run_icon.name = "[target_can_run ? "Disallow" : "Allow"] Running"

	//Handling change for all the guns on client
	for(var/obj/item/weapon/gun/G in src)
		G.lock_time = world.time + 5
		if(G.aim_targets)
			for(var/mob/living/M in G.aim_targets)
				if(target_can_run)
					M << "Your character may now <b>run</b> at the discretion of their targeter."
				else
					M << "<span class='danger'><b>Your character will now be shot if they run.</b></span>"

/client/verb/AllowTargetClick()
	set hidden=1

	//Changing client's permissions
	target_can_click = !target_can_click
	if(target_can_click)
		usr << "Target may now use items."
	else
		usr << "Target may no longer use items."

	if(usr.item_use_icon)
		usr.item_use_icon.icon_state = "no_item[target_can_click]"
		usr.item_use_icon.name = "[target_can_click ? "Disallow" : "Allow"] Item Use"

	//Handling change for all the guns on client
	for(var/obj/item/weapon/gun/G in src)
		G.lock_time = world.time + 5
		if(G.aim_targets)
			for(var/mob/living/M in G.aim_targets)
				if(target_can_click)
					M << "Your character may now <b>use items</b> at the discretion of their targeter."
				else
					M << "<span class='danger'><b>Your character will now be shot if they use items.</b></span>"

/client/verb/AllowTargetRadio()
	set hidden=1

	target_can_radio = !target_can_radio
	if(target_can_radio)
		usr << "Target may now use radio."
	else
		usr << "Target may no longer use radio."

	if(usr.radio_use_icon)
		usr.radio_use_icon.icon_state = "no_radio[target_can_radio]"
		usr.radio_use_icon.name = "[target_can_radio ? "Disallow" : "Allow"] Radio Use"

	//Handling change for all the guns on client
	for(var/obj/item/weapon/gun/G in src)
		G.lock_time = world.time + 5
		if(G.aim_targets)
			for(var/mob/living/M in G.aim_targets)
				if(target_can_radio)
					M << "Your character may now <b>use the radio</b> at the discretion of their targeter."
				else
					M << "<span class='danger'><b>Your character will now be shot if they use the radio.</b></span>"
