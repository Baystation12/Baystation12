
#define EJECT_CASINGS	2

/obj/structure/turret
	name = "Turret"
	desc = "A turret"

	icon = 'code/modules/halo/weapons/turrets/turrets_unsc.dmi'
	icon_state = "bipod"
	layer = ABOVE_HUMAN_LAYER

	anchored = 1
	density = 1
	buckle_movable = 1

	pixel_x = -6
	pixel_y = -6

	var/mob/living/carbon/human/mob_manning //The mob manning the gun.
	var/list/manning_pixel_offsets = list(25,25) //Format is offset (EW,NS)
	var/obj/kit_undeploy = null
	var/obj/item/weapon/gun/projectile/turret_gun = /obj/item/weapon/gun/projectile/turret //The "gun" the turret uses to fire.
	var/obj/stand = /obj/structure/bipod //The object reference to the object to replace with when the gun is removed.
	var/remove_time = 5 //The time it takes to rip the gun off the stand, in seconds. Half this is pack-up time.
	var/bullet_deflect_chance = 40 //The chance the gun has to reflect projectiles, from the sides
	var/bullet_facing_deflect_chance = 75 //the chance the gun has to reflect projectiles from the "front" + the two angles.

/obj/structure/turret/New()
	. = ..()
	if(kit_undeploy)
		verbs += /obj/structure/turret/proc/pack_up_turret

/obj/structure/turret/proc/pack_up_turret()
	set name = "Pack Up Turret"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated())
		to_chat(usr,"<span class = 'notice'>You cannot do that!</span>")
		return
	visible_message("<span class = 'warning'>[user] starts packing up [src]...</span>")
	if(!do_after(user,remove_time/4 SECONDS,src))
		return
	visible_message("<span class = 'notice'>[user] packs up [src], readying it for movement.</span>")
	new kit_undeploy (loc)
	unman_turret()
	qdel(src)

/obj/structure/turret/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/prob_use = bullet_deflect_chance
	if(get_dir(src, P.starting) in list(dir,turn(dir,-45),turn(dir,45)))
		prob_use = bullet_facing_deflect_chance
	if(dir == turn(dir,180) || !prob(prob_use))
		if(mob_manning)
			mob_manning.bullet_act(P,def_zone)
			return
	else
		if(P.damtype == BRUTE)
			visible_message("<span class = 'danger'>The [P.name] pings off the [name]</span>","<span class = 'notice'>You hear something ricochet</span>")
		else if(P.damtype == BURN)
			visible_message("<span class = 'danger'>The [P.name] harmlessly splashes against the armour of the [name]</span>","<span class = 'notice'>You hear something violently boiling</span>")
		else
			visible_message("<span class = 'danger'>The [P.name] ineffectively skims the armour of the [name]</span>","<span class = 'notice'>You hear something ricochet</span>")

/obj/structure/turret/proc/rip_turret(var/mob/living/carbon/human/user)
	visible_message("<span class = 'danger'>[user] starts ripping the turret off the [name]</span>",)
	if(do_after(user,remove_time SECONDS,src,1,1,,1))
		unman_turret()
		var/detached_turret_path = text2path("[turret_gun]/detached")
		var/obj/item/weapon/gun/projectile/gun = new detached_turret_path
		stand = new stand(loc)
		stand.dir = dir
		if(!user.put_in_active_hand(gun))
			if(!user.put_in_inactive_hand(gun))
				gun.loc = user.loc
		qdel(src)
		return

/obj/structure/turret/proc/check_attack_valid(var/mob/user)
	if(!istype(user,/mob/living/carbon/human))
		to_chat(user,"<span class = 'notice'>You can't understand how to use the [name]</span>")
		return 0
	if(mob_manning)
		to_chat(user,"<span class = 'notice'>Someone's already using the [name]</span>")
		return 0
	if(user.incapacitated())
		return 0
	return 1

/obj/structure/turret/proc/handle_dir()
	if(!mob_manning)
		return
	mob_manning.pixel_y = initial(mob_manning.pixel_y)
	mob_manning.pixel_x = initial(mob_manning.pixel_x)
	switch(mob_manning.dir)
		if(1)
			mob_manning.pixel_y = -manning_pixel_offsets[2]
			dir = NORTH
		if(2)
			mob_manning.pixel_y = manning_pixel_offsets[2]
			dir = SOUTH
		if(4)
			mob_manning.pixel_x = -manning_pixel_offsets[1]
			dir = EAST
		if(8)
			mob_manning.pixel_x = manning_pixel_offsets[1]
			dir = WEST

/obj/structure/turret/proc/give_manning_gun()
	var/obj/gun = new turret_gun
	if(!mob_manning.put_in_active_hand(gun))
		if(!mob_manning.put_in_inactive_hand(gun))
			unman_turret()
			return 0
	return 1

/obj/structure/turret/proc/remove_manning_gun()
	if(mob_manning.l_hand && (mob_manning.l_hand.type == turret_gun))
		mob_manning.drop_from_inventory(mob_manning.l_hand)
		qdel(mob_manning.l_hand)
	if(mob_manning.r_hand && (mob_manning.r_hand.type == turret_gun))
		mob_manning.drop_from_inventory(mob_manning.r_hand)
		qdel(mob_manning.r_hand)


/obj/structure/turret/proc/man_turret(var/mob/living/carbon/human/user)
	mob_manning = user
	mob_manning.forceMove(loc)
	mob_manning.buckled = src
	give_manning_gun()
	handle_dir()
	GLOB.processing_objects += src

/obj/structure/turret/proc/unman_turret()
	if(mob_manning)
		mob_manning.buckled = null
		mob_manning.pixel_x = initial(mob_manning.pixel_x)
		mob_manning.pixel_y = initial(mob_manning.pixel_y)
		remove_manning_gun()
		mob_manning = null
	GLOB.processing_objects -= src

/obj/structure/turret/attack_hand(var/mob/user)
	if(!mob_manning)
		man_turret(user)
	else
		unman_turret(user)

/obj/structure/turret/attackby(var/obj/item/W, var/mob/user)
	if(W.type == turret_gun)
		var/obj/item/weapon/gun/projectile/gun = W
		if(gun.ammo_magazine)
			gun.ammo_magazine.stored_ammo.Cut()
			gun.unload_ammo(user,,1)
		gun.load_ammo(new gun.magazine_type,user)

/obj/structure/turret/proc/check_user_has_gun()
	var/unman = 0
	if(isnull(mob_manning))
		unman = 1
	else if(!mob_manning.l_hand && !mob_manning.r_hand)
		unman = 1
	else if(mob_manning.l_hand && (mob_manning.l_hand.type != turret_gun) && (mob_manning.r_hand && (mob_manning.r_hand.type != turret_gun)))
		unman = 1
	else if(mob_manning.incapacitated())
		unman = 1
	else if(!mob_manning.Adjacent(src))
		unman = 1

	if(unman)
		unman_turret()

/obj/structure/turret/process()
	check_user_has_gun()
	handle_dir()

/obj/structure/turret/Destroy()
	unman_turret()
	. = ..()

/obj/structure/turret/verb/remove_turret()
	set name = "Remove Turret"
	set category = "Object"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || user.incapacitated())
		to_chat(usr,"<span class = 'notice'>You cannot do that!</span>")
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = user
		if(!(h.species.type in SPECIES_LARGE))
			to_chat(user,"<span class = 'notice'>You're not strong enough to carry the [src.name]</span>")
			return
	rip_turret(usr)

//Bipod Define//
/obj/structure/bipod
	name = "Bipod"
	desc = "The swivel that used to hold a weapon has been rendered non-functional."

	icon = 'code/modules/halo/weapons/turrets/turrets_unsc.dmi'
	icon_state = "bipod"

	pixel_x = -6
	pixel_y = -6

//Inbuilt Gun Define//
/obj/item/weapon/gun/projectile/turret
	name = "Mounted Turret Gun"
	desc = "A turret's gun."

	icon = 'code/modules/halo/weapons/turrets/turret_items.dmi'
	icon_state = "chaingun_obj"
	item_state = "chaingun_obj"
	one_hand_penalty = -1

	slowdown_general = 7
	w_class = ITEM_SIZE_HUGE
	can_rename = 0
	item_icons = list( //Null here due to this version being used only when manning the turret, Every turret requires a /detached define with the item_icons set.
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	load_method = MAGAZINE
	handle_casings = EJECT_CASINGS
	slot_flags = 0

	caliber = "a762"
	magazine_type = /obj/item/ammo_magazine/a762_box_ap

	fire_delay = 15
	burst = 10
	burst_delay = 1
	burst_accuracy = list(0,0,0,0,0,0,-1)
	dispersion = list(0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4)

	var/load_time = 1 //The time it takes to load the weapon, in seconds.
	var/removed_from_turret = 0 //If the gun has been removed from the turret base.

/obj/item/weapon/gun/projectile/turret/unload_ammo(var/mob/user,var/allow_dump,var/force_drop)
	if(force_drop)
		return ..(user,allow_dump)
	to_chat(user,"<span class = 'notice'>You can't unload the [name]</span>")

/obj/item/weapon/gun/projectile/turret/load_ammo(var/obj/item/A, mob/user)
	visible_message("<span class = 'danger'>[user.name] loads the [name]</span>",)
	..(A,user)

/obj/item/weapon/gun/projectile/turret/dropped()
	. = ..()
	if(!removed_from_turret)
		qdel(src)

/obj/item/weapon/gun/projectile/turret/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_unloaded"

/obj/item/weapon/gun/projectile/turret/verb/scope()
	set category = "Weapon"
	set name = "Use Scope (Mounted)"
	set popup_menu = 1

	if(removed_from_turret)
		to_chat(usr,"<span class = 'notice'>[src]'s scope cannot function whilst detached!</span>")
		verbs -= /obj/item/weapon/gun/projectile/turret/verb/scope
		return

	toggle_scope(usr, 1.75) //Equal to a sniper's scope, we'll be unlikely to hit anything at this range though.

//Detached Turret Gun Define// Every detachable turret gun needs this.
/obj/item/weapon/gun/projectile/turret/detached
	removed_from_turret = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/mob_turret.dmi',
		)

#undef EJECT_CASINGS