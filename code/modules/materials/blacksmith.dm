
//blacksmithing core//
/obj/item/stack/material/steel
	var/is_whitehot = 0
	var/is_redhot = 0

/obj/item/stack/material/steel/attackby(/obj/item/weapon/weldingtool as obj, mob/user as mob)
		if(has_been_heated)
		to_chat(user, "<span class='notice'>The [src] is already white hot!</span>")
		return
	is_whitehot = 1
	user.visible_message("<span class='notice'>[user] heats up \the [src].</span>", "You heat \the [src] to a white hot glow.")
	timer(200)
		to_chat(user, "You think \the [src] is ready to be forged now.")
		SetName("white hot " + name)
		cooltime()

/obj/item/stack/material/steel/proc/cooltime()
	if (src.is_whitehot)
		timer(4200)
			src.is_whitehot = 0
			src.is_redhot = 1
			src.SetName(initial(name))
			src.SetName("red hot " + name)
			cooldown()

/obj/item/stack/material/steel/proc/cooldown()
	if (src.is_redhot)
		timer(4200)
			src.is_redhot = 0
			src.SetName(initial(name))



/obj/item/stack/material/steel(obj/item/W as obj, mob/user as mob)
//check if material is white hot or red hot
//check if mob is using W, W being a hammer or wrench or other blunt instrument
	if(istype(W,/obj/item/weapon/wrench))
		..()
		return
//alternative check for having pliers (made using blacksmithing) or wirecutters in off-hand to hold down the material while forging
		if(isWirecutter(user.l_hand) || isWirecutter(user.r_hand))
		else
			to_chat(user, "<span class='warning'>Were you planning to hold the hot metal down with your bare hand?</span>")
//last check to ensure material is on a sturdy surface (eg: reinforced table) before you begin forging
//add hammer noises
//reduce risk of self-injury by wearing gloves and apron!
//uses some existing skillset, e.g goood skills give better crafted weapons and gear
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		to_chat(user, "<span class='warning'>You should probably find a sturdy table to do this on!</span>")
	return

