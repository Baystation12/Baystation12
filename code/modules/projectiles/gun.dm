/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
#define BASE_MOVEDELAY_MOD_APPLYFOR_TIME 1 SECOND
#define FULLCLEAR_MOD_OVERHEAT_MODIFIER 2

/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/weapon/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/weapon/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = ITEM_SIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	slowdown_general = 0.25 //Guns R heavy.

	var/unique_name
	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 0
	var/move_delay_malus = 0.5
	var/fire_sound = 'sound/weapons/gunshot/gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/screen_shake = 0 //shouldn't be greater than 2 unless zoomed
	var/silenced = 0
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0) // 1 = 9 degrees of dispersion in positive, 9 in negative
	var/one_hand_penalty // -1 is used for "unable to fire unless twohandable".
	var/wielded_item_state
	var/can_rename = 1 //Can this weapon be renamed by the user?

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/lock_time = 1 SECOND

	var/last_elevation = BASE_ELEVATION

	//Attachment System Stuff//
	var/list/attachment_slots = list()
	var/list/attachments_on_spawn = list()

	var/is_charged_weapon = 0 //Does the weapon require charging? Defaults to 0 unless it's from /charged weapon sets
	var/arm_time = 25 //Default charge time for weapons that charge
	var/charge_sound = 'code/modules/halo/sounds/Spartan_Laser_Charge_Sound_Effect.ogg'
	var/is_charging = 0
	var/irradiate_non_cov = 0 //Set this to anything above 0, and it'll irradiate humans when fired. Spartans and Orions are ok.
	var/is_heavy = 0 //Set this to anything above 0, and all species that aren't elites/brutes/spartans/orions have to two-hand it
	var/advanced_covenant = 0

	//Fire delay is modified by this, then used to determine the time after last firing to count as the weapon
	//recovering from all the overheat it has accumulated
	//Example: fire_delay 10 with a fullclear_mod of 2 means the player must wait for 20 before firing for the heat to
	//be cleared.
	var/overheat_fullclear_delay = 15
	var/overheat_fullclear_at = -1
	var/overheat_sfx = null
	var/overheat_capacity = -1 //If set above -1, a weapon will decrement this counter per-shot until it hits 0.

	//"Channeled" weapons, aka longfire beam sustained types (sentinel beam)//

	var/sustain_delay = -1 //Set this to the delay between "firing" whilst channeled.Set the weapon tracer to match this value.
	var/sustain_time = -1 //How long does this sustain fire for.
	var/atom/stored_targ

/obj/item/weapon/gun/New()
	..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(!unique_name)
		unique_name = name

	for(var/a in attachments_on_spawn)
		var/obj/item/weapon_attachment/attachment = new a
		if(!istype(attachment))
			continue
		attachment.attach_to(src)

/obj/item/weapon/gun/proc/check_reset_overheat()
	if(overheat_capacity != -1 && world.time >= overheat_fullclear_at)
		overheat_capacity = initial(overheat_capacity)

/obj/item/weapon/gun/proc/calc_overheat_clear_at(var/mob/user,var/alt_overheat_message = 0)//An alternate "we've already warned you esque" overheat message.
	overheat_capacity = max(overheat_capacity-1,0)
	var/modifier = 1
	if(overheat_capacity == 0)
		modifier = FULLCLEAR_MOD_OVERHEAT_MODIFIER
		var/msg = "[src] reaches its thermal limit and quickly starts ventilating heat, disabling their firing mechanism!"
		if(alt_overheat_message)
			msg = "[src] clunks as you pull the trigger, it has overheated and needs to ventilate heat..."
		visible_message("<span class = 'warning'>[msg]</span>")

		if(overheat_sfx)
			playsound(user,overheat_sfx,100,1)

	overheat_fullclear_at = world.time + overheat_fullclear_delay*modifier

/obj/item/weapon/gun/proc/get_attachments(var/names_only = 0)
	var/list/attachments = list()
	for(var/obj/item/weapon_attachment/attachment in src.contents)
		if(names_only)
			attachments += attachment.name
		else
			attachments += attachment
	return attachments

/obj/item/weapon/gun/proc/get_attachment_by_name(var/wanted_name)
	if(isnull(name))
		return
	for(var/obj/item/weapon_attachment/attachment in get_attachments())
		if(attachment.name == wanted_name)
			return attachment

/obj/item/weapon/gun/proc/attachment_removal(var/obj/item/weapon_attachment/attachment_to_remove)
	contents -= attachment_to_remove
	if(isturf(loc))
		attachment_to_remove.loc = loc
	else
		attachment_to_remove.loc = loc.loc
	attachment_to_remove.on_removal(src)
	update_icon()

/obj/item/weapon/gun/verb/remove_attachments()
	set name = "Remove Attachments"
	set category = "Object"

	var/attachment_name_remove = input("Pick an attachment to remove","Attachment Removal","Cancel") in get_attachments(1) + list("Cancel")
	var/obj/item/weapon_attachment/attachment_to_remove = get_attachment_by_name(attachment_name_remove)
	if(attachment_name_remove == "Cancel" || isnull(attachment_to_remove))
		return
	if(!attachment_to_remove.can_remove)
		to_chat(usr,"<span class = 'notice'>You can only replace [attachment_to_remove.name], not remove it.</span>")
		return
	attachment_removal(attachment_to_remove)
	to_chat(usr,"<span class = 'notice'>You remove the [attachment_to_remove.name] from [name]'s [attachment_to_remove.weapon_slot].</span>")

/obj/item/weapon/gun/update_twohanding()
	if(one_hand_penalty)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				name = "[unique_name] (wielded)"
			else
				name = initial(name)
		update_icon() // In case item_state is set somewhere else.
	..()

/obj/item/weapon/gun/update_icon()
	for(var/image/image in overlays)
		overlays -= image
		qdel(image)
	overlays = list()
	for(var/obj/item/weapon_attachment/attachment in get_attachments())
		attachment.attachment_sprite_modify(src)
	if(wielded_item_state)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				item_state_slots[slot_l_hand_str] = wielded_item_state
				item_state_slots[slot_r_hand_str] = wielded_item_state
			else
				item_state_slots[slot_l_hand_str] = initial(item_state)
				item_state_slots[slot_r_hand_str] = initial(item_state)

/obj/item/weapon/gun/verb/rename_gun()
	set name = "Name Gun"
	set category = "Weapon"
	set desc = "Rename your gun."

	var/mob/M = usr
	if(!can_rename)
		to_chat(M,"<span class = 'notice'>You can't rename [name]</span>")
		return 0
	if(!M.mind)	return 0
	if(M.incapacitated()) return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?","Rename gun"), MAX_NAME_LEN)

	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		name = input
		unique_name = input
		to_chat(M, "Your gun is now named '[input]'.")
		return 1

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
		to_chat(M, "<span class='danger'>Your fingers are much too large for the trigger guard!</span>")
		return 0
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_FOOT, BP_R_FOOT)))
				handle_post_fire(user, user)
				user.visible_message(
					"<span class='danger'>\The [user] shoots \himself in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0
	var/mob/living/carbon/human/h = user
	if(istype(h) && h.species.can_operate_advanced_covenant == 0 && advanced_covenant == 1)
		to_chat(h,"<span class= 'danger'>You don't know how to operate this weapon!</span>")
		return 0
	return 1

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return ..()//A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	var/mob/living/carbon/human/h = user

	if (is_heavy ==1 && istype(h) && !(h.species.type in SPECIES_LARGE) && !src.is_held_twohanded(user))
		to_chat(user,"<span class = 'notice'>This weapon is far too heavy for you to fire with just one hand!</span>")
		return

	if(user && user.a_intent == I_HELP) //regardless of what happens, refuse to shoot if help intent is on
		if(get_lunge_dist() > 0) //If we're on help intent and we have a lunge, do the lunge.
			return ..()
		to_chat(user, "<span class='warning'>You refrain from firing your [src] as your intent is set to help.</span>")
		return

	if(is_charging)
		to_chat(user,"<span class = 'notice'>[src] is charging and cannot fire</span>")
		return

	if(is_charged_weapon==1)
		playsound(src.loc, charge_sound, 100, 1)
		user.visible_message("<span class = 'notice'>[user] starts charging the [src]!</span>")

		is_charging = 1
		if (!do_after(user,arm_time,src))
			is_charging = 0
			return
		Fire(A,user,params)
		is_charging = 0
	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/weapon/gun/proc/check_z_compatible(var/atom/target,var/mob/living/user)
	if(target.z != user.z) return 0
	return 1

/obj/item/weapon/gun/proc/pershot_check(var/mob/user) //Placeholder for any checks that must be performed per-shot. Used for vehicles.
	if(overheat_capacity == -1 || overheat_capacity > 0)
		return 1
	return 0

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return
	if(target.elevation != last_elevation && (istype(target,/obj/vehicles) || istype(target,/mob/living)))
		last_elevation = target.elevation
		visible_message("<span class = 'danger'>[user.name] changes their firing elevation to target [target.name]</span>")
	var/list/rounds_nosuppress = list()
	if(istype(user.loc,/obj/vehicles))
		var/obj/vehicles/V = user.loc
		rounds_nosuppress += V.occupants
		if(!istype(src,/obj/item/weapon/gun/vehicle_turret))
			var/user_position = V.occupants[user]
			if(isnull(user_position)) return
			if(user_position == "driver")
				to_chat(user,"<span class = 'warning'>You can't fire from the driver's position!</span>")
				return
			if(!(user_position in V.exposed_positions))
				to_chat(user,"<span class = 'warning'>You can't fire [src.name] from this position in [V.name].</span>")
				return
		if(target.z != V.z) return
	else
		if(!check_z_compatible(target,user)) return

	add_fingerprint(user)
	check_reset_overheat()

	var/list/attachments = get_attachments()
	if(attachments.len > 0)
		var/have_fired = 0
		for(var/obj/item/weapon_attachment/secondary_weapon/attachment in get_attachments())
			if(attachment.alt_fire_active == 1)
				attachment.fire_attachment(target,user,src)
				have_fired = 1
		if(have_fired)
			return //if one of our attachments have fired, let's not fire normally.

	if(!special_check(user))
		return

	if(overheat_capacity == 0)
		calc_overheat_clear_at(user,1)
		return

	if(stored_targ)
		stored_targ = target
		visible_message("<span class = 'notice'>[user] refocuses their aim on [target]</span>")
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	var/held_twohanded = (user.can_wield_item(src) && src.is_held_twohanded(user))

	if(one_hand_penalty == -1)
		if(!held_twohanded)
			to_chat(user,"<span class = 'notice'>You can't fire this weapon with just one hand!</span>")
			return

	var/shoot_time = (burst - 1)* burst_delay
	//user.setClickCooldown(shoot_time) //no clicking on things while shooting
	//user.setMoveCooldown(shoot_time) //no moving while shooting either
	next_fire_time = world.time + shoot_time + fire_delay
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = user
		for(var/obj/item/weapon/gun/g in h.contents)
			g.next_fire_time = next_fire_time

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	var/atom/use_targ = target
	if(sustain_time > 0)
		burst = sustain_time/sustain_delay
		burst_delay = sustain_delay
		stored_targ = target
		use_targ = stored_targ
	. = 1
	if(burst > 1)
		user.visible_message(
		"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""]!</span>",
		"<span class='warning'>You fire \the [src]!</span>",
		"You hear a [fire_sound_text]!"
		)
	for(var/i in 1 to burst)
		if(!pershot_check(user))
			break
		if(stored_targ)
			if(stored_targ == user)
				stored_targ = null
				visible_message("<span class = 'notice'>[user] stops firing [src].</span>")
				break
			targloc = get_turf(stored_targ)
			use_targ = stored_targ
		var/mob/living/carbon/human/h = user
		if(!istype(loc,/obj/item/weapon/gun/dual_wield_placeholder))
			if(isnull(user) || user.stat == DEAD || (istype(h) && (h.l_hand != src && h.r_hand != src)))
				break
		user.currently_firing = move_delay_malus
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			. = 0
			break
		if(overheat_capacity != -1)
			calc_overheat_clear_at(user)

		if(istype(projectile,/obj/item/projectile))
			var/obj/item/projectile/proj_obj = projectile
			proj_obj.target_elevation = last_elevation
			proj_obj.permutated += rounds_nosuppress //Stops people in a vehicle from being suppressed by their own vehicle's shots.

		if(user.loc != targloc) //This should stop people being able to just click on someone for free autotracking.
			var/mob/living/targ_m = target
			if(istype(targ_m))
				if(!targ_m.lying)
					use_targ = targloc
			else
				use_targ = targloc

		process_accuracy(projectile, user, use_targ, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, user, use_targ)

		var/target_zone
		if(user && user.zone_sel)
			target_zone = user.zone_sel.selecting
		else
			target_zone = "chest"

		if(process_projectile(projectile, user, use_targ, target_zone, clickparams))
			handle_post_fire(user, use_targ, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(use_targ && use_targ.loc))
			target = targloc
			pointblank = 0

	//update timing
	stored_targ = null
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	spawn(BASE_MOVEDELAY_MOD_APPLYFOR_TIME)
		user.currently_firing = 0
	//user.setMoveCooldown(move_delay)//
	return

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
	if(!silenced)
		if(reflex)
			user.visible_message(
				"<span class='reflex_shoot'><b>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""] by reflex!</b></span>",
				"<span class='reflex_shoot'>You fire \the [src] by reflex!</span>",
				"You hear a [fire_sound_text]!"
			)
		else
			user.visible_message(
				"<span class='notice'>\The [user] [burst > 1 ? "continues firing":"fires"] \the [src][pointblank ? " point blank at \the [target]":""]!</span>",
				,
				"You hear a [fire_sound_text]!"
				)

	if(one_hand_penalty)
		if(!src.is_held_twohanded(user))
			switch(one_hand_penalty)
				if(1)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(2)
					to_chat(user, "<span class='warning'>Your aim wavers as you fire \the [src] with just one hand.</span>")
				if(3)
					to_chat(user, "<span class='warning'>You have trouble keeping \the [src] on target with just one hand.</span>")
				if(4 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to keep \the [src] on target with just one hand!</span>")
		else if(!user.can_wield_item(src))
			switch(one_hand_penalty)
				if(1)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(2)
					to_chat(user, "<span class='warning'>Your aim wavers as you try to hold \the [src] steady.</span>")
				if(3)
					to_chat(user, "<span class='warning'>You have trouble holding \the [src] steady.</span>")
				if(4 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to hold \the [src] steady!</span>")

	if(irradiate_non_cov > 0 && istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = user
		if(istype(h.species,/datum/species/human))
			h.rad_act(irradiate_non_cov)

	if(screen_shake)
		spawn()
			shake_camera(user, screen_shake+1, screen_shake)
	update_icon()


/obj/item/weapon/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/max_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		for(var/obj/item/grab/G in H.grabbed_by)
			if(G.point_blank_mult() > max_mult)
				max_mult = G.point_blank_mult()
	P.damage *= max_mult

/obj/item/weapon/gun/proc/get_acc_or_disp_mod(var/get_disp_mod = 0)
	var/base
	if(get_disp_mod)
		base = dispersion[min(burst, dispersion.len)]
	else
		base = burst_accuracy[min(burst, burst_accuracy.len)]
	if(isnull(base))
		return
	for(var/obj/item/weapon_attachment/attach in get_attachments())
		var/datum/attachment_profile/prof = attach.get_attachment_profile(src)
		if(isnull(prof))
			continue
		var/list/attach_mods = prof.attribute_modifications[attach.name]
		if(isnull(attach_mods))
			continue
		if(get_disp_mod)
			base += attach_mods[1]
		else
			base += attach_mods[2]
	return base

/obj/item/weapon/gun/proc/process_accuracy(obj/projectile, mob/user, atom/target, var/burst, var/held_twohanded)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = get_acc_or_disp_mod()
	var/disp_mod = get_acc_or_disp_mod(1)

	if(one_hand_penalty)
		if(!held_twohanded)
			acc_mod += -ceil(one_hand_penalty/2)
			var/temp_one_hand_penalty = one_hand_penalty
			if(one_hand_penalty < 0)
				temp_one_hand_penalty = -one_hand_penalty
			disp_mod += temp_one_hand_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod
	P.dispersion = max(0,disp_mod)

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 2

//does the actual launching of the projectile
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return 0 //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)

	//shooting while in shock
	var/x_offset = 0
	var/y_offset = 0
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/mob = user
		if(mob.shock_stage > 120)
			y_offset = rand(-2,2)
			x_offset = rand(-2,2)
		else if(mob.shock_stage > 70)
			y_offset = rand(-1,1)
			x_offset = rand(-1,1)

	var/obj/launched = !P.launch_from_gun(target, user, src, target_zone, x_offset, y_offset)

	if(launched)
		play_fire_sound(user,P)
		if(istype(target,/atom/movable) && istype(launched) && get_dist(target,user) <= 1)
			change_elevation(target.elevation-launched.elevation)

	return launched

/obj/item/weapon/gun/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
	var/shot_sound = fire_sound ? fire_sound : istype(P) ? P.fire_sound : null //Tweaked to favour gun firesound over projectile firesound.;
	if(silenced)
		playsound(user, shot_sound, 10, 0)
	else
		playsound(user, shot_sound, 50, 0)

//Suicide handling.
/obj/item/weapon/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>
/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<span class='danger'>[user] sticks their gun in their mouth, ready to pull the trigger...</span>")
	if(!do_after(user, 40, progress=0))
		M.visible_message("<span class='notice'>[user] decided life was worth living</span>")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		var/shot_sound = in_chamber.fire_sound? in_chamber.fire_sound : fire_sound
		if(silenced)
			playsound(user, shot_sound, 10, 1)
		else
			playsound(user, shot_sound, 50, 1)
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != PAIN)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, 0, in_chamber.damage_flags(), used_weapon = "Point blank shot in the mouth with \a [in_chamber]")
			user.death()
		else
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,PAIN,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/weapon/gun/proc/calculate_attachment_effects()
	var/cumulative_dispmod = 0
	var/cumulative_accmod = 0
	var/cumulative_slowdownmod = 0
	for(var/obj/item/weapon_attachment/attachment in get_attachments())
		var/list/attrib_mods = attachment.get_attribute_mods(src)
		if(!isnull(attrib_mods))
			cumulative_dispmod += attrib_mods[1]
			cumulative_accmod += attrib_mods[2]
			cumulative_slowdownmod += attrib_mods[3]

	if(cumulative_dispmod > 0) //Allowing the changing of dispersion through attachments can be abused for laser accurate guns.
	//Attachments granting dispersion decreases can be used to counter the dispersion increase of other attachments.
		for(var/entry in dispersion)
			entry += cumulative_dispmod
	if(cumulative_accmod != 0)
		for(var/entry in burst_accuracy)
			entry += cumulative_accmod
		accuracy += cumulative_accmod
	slowdown_general += cumulative_slowdownmod

/obj/item/weapon/gun/proc/toggle_scope(mob/user, var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	user.reset_view(user)
	zoom(user, zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(screen_shake)
			screen_shake = round(screen_shake*zoom_amount+1) //screen shake is worse when looking through a scope

/obj/item/weapon/gun/proc/toggle_attachment_light()
	set name = "Toggle Light Attachment"
	set category = "Weapon"
	if(!istype(usr,/mob/living))
		return

	for(var/obj/item/weapon_attachment/light/l in get_attachments())
		l.on = !l.on
		if(l.on)
			if(l.activation_sound)
				playsound(src.loc, l.activation_sound, 75, 1)
			set_light(l.intensity)
		else
			set_light(0)

/obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment()
	set name = "Toggle Attachment"
	set category = "Weapon"
	set desc = "Toggle a secondary-weapon attachment."

	if(!istype(usr,/mob/living))
		to_chat(usr,"<span class = 'notice'>You can't use that in your current form!</span>")
		return

	for(var/obj/item/weapon_attachment/secondary_weapon/wep in get_attachments()) //You probably shouldn't have two secondary-weapon attachment one weapon.
		if(wep.alt_fire_active == -1)
			to_chat(usr,"<span class = 'notice'>This is an error in attachment-defines, please report to the github.</span>")
			return
		wep.alt_fire_active = !wep.alt_fire_active
		to_chat(usr,"<span class = 'notice'>You toggle [wep.name] to [wep.alt_fire_active ? "on":"off"]</span>")

//make sure accuracy and screen_shake are reset regardless of how the item is unzoomed.
/obj/item/weapon/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		screen_shake = initial(screen_shake)
	calculate_attachment_effects()

/obj/item/weapon/gun/examine(mob/user)
	. = ..()
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, "The fire selector is set to [current_mode.name].")
	var/list/attachments_names = get_attachments(1)
	if(attachments_names.len > 0)
		to_chat(user,"It has the following attachments:")
		for(var/name in attachments_names)
			to_chat(user,"\n[name]")

	if(overheat_capacity == 0)
		check_reset_overheat()
		to_chat(user,"[src] is overheating and needs to ventilate heat.")
	else if(overheat_capacity != -1)
		check_reset_overheat()
		to_chat(user,"[src] has [overheat_capacity]/[initial(overheat_capacity)] shots left until overheat.")

/obj/item/weapon/gun/proc/switch_firemodes()
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

	return new_mode

/obj/item/weapon/gun/attack_self(mob/user)
	if(stored_targ)
		to_chat(user,"<span class = 'notice'>You stop your sustained burst from [src]</span>")
		stored_targ = user
		return
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(new_mode)
		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")

/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	var/obj/item/weapon_attachment/attachment = A
	if(istype(attachment))
		attachment.on_attachment(src,user)

/obj/item/weapon/gun/proc/use_scope()
	set category = "Object"
	set name = "Use Scope" //Gives slightly less info to the user but also allows for easy macro use.
	set popup_menu = 1

	var/used_zoom_amount
	var/message = "<span class = 'notice'>You need to have a scope attached to use this.</span>"
	for(var/obj/item/weapon_attachment/sight/s in get_attachments())
		used_zoom_amount = s.zoom_amount
	if(used_zoom_amount <= 1 || used_zoom_amount == 1)
		used_zoom_amount = null
		message = "<span class = 'notice'>Your attached scope has no magnification.</span>"
	if(isnull(used_zoom_amount))
		to_chat(usr,"[message]")
		verbs -= /obj/item/weapon/gun/proc/use_scope
		return
	toggle_scope(usr, used_zoom_amount)
