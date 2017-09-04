/obj/item/weapon/gun/projectile/colt/detective
	var/unique_name
	var/datum/detective_gun_skin/unique_reskin
	var/static/list/gun_options
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/colt/detective/New()
	..()
	if(!gun_options)
		gun_options = init_subtypes(/datum/detective_gun_skin)

/obj/item/weapon/gun/projectile/colt/detective/update_icon()
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

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
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

/obj/item/weapon/gun/projectile/colt/detective/verb/reskin_gun()
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
			name = choice.name
		to_chat(M, "Your gun is now skinned as \a [choice]. Say hello to your new friend.")
		return 1


//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/weapon/gun/projectile/colt/detective/attack_hand(var/mob/living/user)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()

/datum/detective_gun_skin
	var/name
	var/icon_state

/datum/detective_gun_skin/default/New()
	..()
	var/obj/item/weapon/gun/projectile/colt/detective/d = /obj/item/weapon/gun/projectile/colt/detective
	name = initial(d.name)
	icon_state = initial(d.icon_state)

/datum/detective_gun_skin/colt
	name = "\improper Colt M1911"
	icon_state = "colt"

/datum/detective_gun_skin/luger
	name = "\improper P08 Luger"
	icon_state = "p08"

/datum/detective_gun_skin/luger_brown
	name = "\improper P08 Luger, brown"
	icon_state = "p08b"

/datum/detective_gun_skin/mk_standard
	name = "\improper NT Mk. 58"
	icon_state = "secguncomp"

/datum/detective_gun_skin/mk_custom
	name = "\improper NT Mk. 58 Custom"
	icon_state = "secgundark"

/datum/detective_gun_skin/usp
	name = "\improper USP"
	icon_state = "usp"

/datum/detective_gun_skin/vp
	name = "\improper H&K VP"
	icon_state = "VP78"
