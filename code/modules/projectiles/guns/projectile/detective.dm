/obj/item/weapon/gun/projectile/colt/detective
	var/unique_reskin

/obj/item/weapon/gun/projectile/colt/detective
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/colt/detective/update_icon()
	if(ammo_magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-e"
		else
			icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?","Rename gun"), MAX_NAME_LEN)

	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		name = input
		M << "You name the gun '[input]'. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/colt/detective/verb/reskin_gun()
	set name = "Reskin gun"
	set category = "Object"
	set desc = "Click to reskin your gun."

	var/mob/M = usr
	var/list/options = list()
	options["NT Mk. 58"] = "secguncomp"
	options["NT Mk. 58 Custom"] = "secgundark"
	options["Colt M1911"] = "colt"
	options["USP"] = "usp"
	options["H&K VP"] = "VP78"
	options["P08 Luger"] = "p08"
	options["P08 Luger, Brown"] = "p08b"
	var/choice = input(M,"What do you want to skin the gun to?","Reskin Gun", unique_reskin) as null|anything in options
	if(src && choice && !M.incapacitated() && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		M << "Your gun is now skinned as \a [choice]. Say hello to your new friend."
		return 1


//apart of reskins that have two sprites, touching may result in frustration and breaks
/obj/item/weapon/gun/projectile/colt/detective/attack_hand(var/mob/living/user)
	if(!unique_reskin && loc == user)
		reskin_gun(user)
		return
	..()

