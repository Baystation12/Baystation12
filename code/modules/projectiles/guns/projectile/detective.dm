/obj/item/weapon/gun/projectile/pistol/sec/detective
	var/unique_name
	var/datum/detective_gun_skin/unique_reskin
	var/static/list/gun_options

/obj/item/weapon/gun/projectile/pistol/sec/detective/Initialize()
	. = ..()
	if(!gun_options)
		gun_options = init_subtypes(/datum/detective_gun_skin)

/obj/item/weapon/gun/projectile/pistol/sec/detective/on_update_icon()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		if(unique_reskin)
			icon_state = unique_reskin.icon_state
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin.icon_state]-e"
		else
			icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/pistol/sec/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(M.incapacitated()) return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?","Rename gun"), MAX_NAME_LEN)

	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		name = input
		unique_name = input
		to_chat(M, "You name the gun '[input]'. Say hello to your new friend.")
		return 1

/obj/item/weapon/gun/projectile/pistol/sec/detective/verb/reskin_gun()
	set name = "Reskin gun"
	set category = "Object"
	set desc = "Click to reskin your gun."

	var/mob/M = usr
	if(M.incapacitated())
		return

	var/datum/detective_gun_skin/choice = input(M,"What do you want to skin the gun to?","Reskin Gun", unique_reskin) as null|anything in gun_options
	if(src && choice && !M.incapacitated() && in_range(M,src))
		icon_state = choice.icon_state
		unique_reskin = choice
		if(!unique_name)
			SetName(choice.name)
		to_chat(M, "Your gun is now skinned as \a [choice]. Say hello to your new friend.")
		return 1


//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/weapon/gun/projectile/pistol/sec/detective/attack_hand(var/mob/living/user)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()

/datum/detective_gun_skin
	var/name
	var/icon_state
	var/icon

/datum/detective_gun_skin/default/New()
	..()
	var/obj/item/weapon/gun/projectile/pistol/sec/detective/d = /obj/item/weapon/gun/projectile/pistol/sec/detective
	name = initial(d.name)
	icon_state = initial(d.icon)
	icon_state = initial(d.icon_state)

/datum/detective_gun_skin/mk_standard
	name = "\improper NT Mk. 58"
	icon_state = "secguncomp"
	icon = 'icons/obj/guns/pistol.dmi'
