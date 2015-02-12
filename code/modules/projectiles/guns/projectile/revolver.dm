/obj/item/weapon/gun/projectile/revolver
	name = "revolver"
	desc = "A classic revolver. Uses .357 ammo"
	icon_state = "revolver"
	caliber = "357"
	origin_tech = "combat=2;materials=2"
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	ammo_type = /obj/item/ammo_casing/a357

/obj/item/weapon/gun/projectile/revolver/mateba
	name = "mateba"
	desc = "When you absolutely, positively need a 10mm hole in the other guy. Uses .357 ammo."	//>10mm hole >.357
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/projectile/revolver/detective
	name = "revolver"
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	icon_state = "detective"
	max_shells = 6
	caliber = "38"
	origin_tech = "combat=2;materials=2"
	ammo_type = /obj/item/ammo_casing/c38

	special_check(var/mob/living/carbon/human/M)
		if(caliber == initial(caliber) && prob(70 - (loaded.len * 10)))	//minimum probability of 10, maximum of 60
			M << "<span class='danger'>[src] blows up in your face.</span>"
			M.take_organ_damage(0,20)
			M.drop_item()
			del(src)
			return 0
		return ..()

	verb/rename_gun()
		set name = "Name Gun"
		set category = "Object"
		set desc = "Click to rename your gun. If you're the detective."

		var/mob/M = usr
		if(!M.mind)	return 0
		if(!M.mind.assigned_role == "Detective")
			M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
			return 0

		var/input = stripped_input(usr,"What do you want to name the gun?", ,"", MAX_NAME_LEN)

		if(src && input && !M.stat && in_range(M,src))
			name = input
			M << "You name the gun [input]. Say hello to your new friend."
			return 1

	attackby(var/obj/item/A as obj, mob/user as mob)
		..()
		if(istype(A, /obj/item/weapon/screwdriver))
			if(caliber == "38")
				user << "<span class='notice'>You begin to reinforce the barrel of [src].</span>"
				if(loaded.len)
					afterattack(user, user)	//you know the drill
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
					return
				if(do_after(user, 30))
					if(loaded.len)
						user << "<span class='notice'>You can't modify it!</span>"
						return
					caliber = "357"
					desc = "The barrel and chamber assembly seems to have been modified."
					user << "<span class='warning'>You reinforce the barrel of [src]! Now it will fire .357 rounds.</span>"
			else if (caliber == "357")
				user << "<span class='notice'>You begin to revert the modifications to [src].</span>"
				if(loaded.len)
					afterattack(user, user)	//and again
					playsound(user, fire_sound, 50, 1)
					user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>[src] goes off in your face!</span>")
					return
				if(do_after(user, 30))
					if(loaded.len)
						user << "<span class='notice'>You can't modify it!</span>"
						return
					caliber = "38"
					desc = initial(desc)
					user << "<span class='warning'>You remove the modifications on [src]! Now it will fire .38 rounds.</span>"
