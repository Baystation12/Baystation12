/obj/item/weapon/gun/projectile/flintlock_pistol
	name = "flintlock pistol"
	desc = "Extremely rare."
	icon = 'icons/obj/musketeer.dmi'
	icon_state = "flintlock_pistol"
	icon_override = 'icons/obj/musketeer.dmi'
	item_state = "flintlock_pistol"
	max_shells = 1
	force = 10
	slot_flags = SLOT_BACK | SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/old_bullet"
//	fire_sound(src.loc, 'sound/effects/musket.ogg', 100, 1)
	var/loaded = 0
	var/powder = 0
	var/ramroded = 0
	var/obj/item/weapon/ramrod/ramrod = null
	var/cock = 0
	var/wielded = 0
	var/force_unwielded = 10
	var/force_wielded = 13

	New()
		ramrod = new /obj/item/weapon/ramrod/bulletstarter(src)

	attackby(var/obj/item/A as obj, mob/user as mob)
		if(istype(A, /obj/item/weapon/ramrod))
			if(loaded && !ramroded)
				ramroded = 1
				user.visible_message("<span class='notice'>[user] ramroded the [name].</span>", "<span class='notice'>You ramroded the [name].</span>")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			else if(!ramrod && istype(A, /obj/item/weapon/ramrod/bulletstarter))
				user.u_equip(A)
				ramrod = A
				A.loc = src
				user.visible_message("<span class='notice'>[user] puts ramrod into the [name].</span>", "<span class='notice'>You put ramrod into the [name].</span>")
			return
		if(istype(A, /obj/item/powder_bag))
			if(!A:amount)
				usr << "\red Powder bag is empty."
				return
			if(powder || loaded)
				usr << "\red You can`t load powder, rifle is allready loaded."
				return
			powder = 1
			A:amount -= 1
			user.visible_message("<span class='notice'>[user] loads a rifle by the powder.</span>", "<span class='notice'>You load a rifle by the powder.</span>")
			return
		if(istype(A, /obj/item/bullet_bag))
			if(!A:amount)
				usr << "\red Powder bag is empty."
				return
			if(loaded)
				usr << "\red You can`t load bullet, rifle is allready loaded."
				return
			loaded = 1
			A:amount -= 1
			user.visible_message("<span class='notice'>[user] loads a rifle by the bullet.</span>", "<span class='notice'>You load a rifle by the bullet.</span>")
			return
		if(istype(A, /obj/item/projectile/bullet/classic))
			if(loaded)
				usr << "\red You can`t load bullet, rifle is allready loaded."
			else
				loaded = 1
				del(A)


	load_into_chamber()
		if(!cock)
			world << "cock [cock]"
			return 0
		if(loaded && !in_chamber)
			in_chamber = new /obj/item/projectile/bullet/classic(src)
		return 1


	Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
		if(!cock) //код пушки странный, так что сделаю тут проверку
			return
		//если всё сделано, то норм
		if(powder && loaded && !ramroded)//если пуля не забита, то летит криво
			var/turf/turf = locate(target.x, target.y, target.z)
			target = turf
			if(!wielded)//слабая отдача
				user.apply_effect(2, STUN, 0)
				user.apply_effect(2, WEAKEN, 0)
				user.apply_effect(2, STUTTER, 0)
		if(powder && !loaded)//если только порох
			playsound(user, fire_sound, 50, 1)
			powder = 0
			ramroded = 0
			cock = 0
			if(!wielded)//слабая отдача
				user.apply_effect(2, STUN, 0)
				user.apply_effect(2, WEAKEN, 0)
				user.apply_effect(2, STUTTER, 0)
			return
		/*
		var/turf/T
		if(user.dir == 1)
			T = get_turf(user.x, user.y+1, user.z)
		if(user.dir == 2)
			T = get_turf(user.x, user.y-1, user.z)
		if(user.dir == 4)
			T = get_turf(user.x+1, user.y, user.z)
		if(user.dir == 8)
			T = get_turf(user.x+1, user.y, user.z)
		new /obj/effect/mist(T.loc)//дымок
		world << "qwe"
		*/
		if(!powder && loaded)//если только пуля
			world << "asd"
			in_chamber = 0
			loaded = 0
			playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
			return
		..()
		loaded = 0
		powder = 0
		ramroded = 0
		cock = 0

	MouseDrop(atom/over_object)
		if(usr.stat || !ishuman(usr) || !usr.canmove || usr.restrained())
			return
		if(istype(over_object, /obj/screen))
			if(over_object.name == ("l_hand" || "r_hand"))
				if(cock)
					usr << "<span class='notice'>You cocked down the trigger.</span>"//хз как правильно это назвать
					cock = 0
				else
					playsound(src.loc, 'sound/weapons/TargetOff.ogg', 30, 1)
					usr << "<span class='notice'>You cocked the trigger.</span>"
					cock = 1

	/*
			Мушкет
	*/
	musket
		name = "musket"
		desc = "Extremely rare."
		icon_state = "musket"
		item_state = "musket"
		slot_flags = SLOT_BACK
		var/obj/item/weapon/bayonet/bayonet = null
		force_wielded = 20

		New()
			ramrod = new /obj/item/weapon/ramrod(src)
			bayonet = new /obj/item/weapon/bayonet(src)
			update()

		proc/update()
			if(bayonet)
				if(wielded)
					force = initial(force) + force_wielded + 15
					icon_state = "[initial(name)]_t_b"
					item_state = "[initial(name)]_t_b"
					usr.update_inv_l_hand()
					usr.update_inv_r_hand()
				else
					force = initial(force) + 15
					icon_state = "[initial(name)]_b"
					item_state = "[initial(name)]_b"
					usr.update_inv_l_hand()
					usr.update_inv_r_hand()
			else
				if(wielded)
					force = initial(force) + force_wielded
					icon_state = "[initial(name)]_t"
					item_state = "[initial(name)]_t"
					usr.update_inv_l_hand()
					usr.update_inv_r_hand()
				else
					force = initial(force)
					icon_state = "[initial(name)]"
					item_state = "[initial(name)]"
					usr.update_inv_l_hand()
					usr.update_inv_r_hand()
			update_icon()

		unwield()
			..()
			update()

		wield()
			..()
			update()


		attackby(var/obj/item/A as obj, mob/user as mob)
			if(istype(A, /obj/item/weapon/ramrod))
				if(loaded && !ramroded && !istype(A, /obj/item/weapon/ramrod/bulletstarter))
					ramroded = 1
					user.visible_message("<span class='notice'>[user] ramroded the [name].</span>", "<span class='notice'>You ramroded the [name].</span>")
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				else if(!ramrod && !istype(A, /obj/item/weapon/ramrod/bulletstarter))
					user.u_equip(A)
					ramrod = A
					A.loc = src
					user.visible_message("<span class='notice'>[user] puts ramrod into the [name].</span>", "<span class='notice'>You put ramrod into the [name].</span>")
				return
			if(istype(A, /obj/item/weapon/bayonet))
				if(!bayonet)
					user.u_equip(A)
					bayonet = A
					A.loc = src
					user.visible_message("<span class='notice'>[user] puts ramrod into the [name].</span>", "<span class='notice'>You put ramrod into the [name].</span>")
					update()
				return
			..()


		Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
			if(!cock) //код пушки странный, так что сделаю тут проверку
				return
			//если всё сделано, то норм

			if(powder && loaded && !wielded)//у ружья отдача сильнее
				user.apply_effect(5, STUN, 0)
				user.apply_effect(5, WEAKEN, 0)
				user.apply_effect(5, STUTTER, 0)
			..()

		verb/EjectBayonet()
			set name = "Eject Bayonet"
			set category = "Object"
			if(bayonet)
				var/obj/item/weapon/bayonet/B = bayonet
				B.loc = usr.loc
				bayonet = null
				B.pickup(usr)
				usr.put_in_any_hand_if_possible(B)
				usr.visible_message("<span class='notice'>[usr] ejects a [name] from the rifle.</span>", "<span class='notice'>You eject a [name] from the rifle.</span>")
				update()

	/*
			Хватка двумя руками
	*/

	proc/unwield()
		wielded = 0
		force = force_unwielded
		name = "[initial(name)]"
		update_icon()

	proc/wield()
		wielded = 1
		force = force_wielded
		name = "[initial(name)] (Wielded)"
		update_icon()

	mob_can_equip(M as mob, slot)
		//Cannot equip wielded items.
		if(wielded)
			M << "<span class='warning'>Unwield the [initial(name)] first!</span>"
			return 0
		return ..()

	dropped(mob/user as mob)
		//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
		if(user)
			var/obj/item/weapon/gun/projectile/flintlock_pistol/O = user.get_inactive_hand()
			if(istype(O))
				O.unwield()
		return	unwield()

//	update_icon()
//		return

	pickup(mob/user)
		unwield()

	attack_self(mob/user as mob)
		..()
		if(wielded)
			unwield()
			user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
			var/obj/item/weapon/gun/projectile/flintlock_pistol/offhand/O = user.get_inactive_hand()
			if(O && istype(O))
				O.unwield()
			return

		else //Trying to wield it
			if(user.get_inactive_hand())
				user << "<span class='warning'>You need your other hand to be empty</span>"
				return
			wield()
			user << "<span class='notice'>You grab the [initial(name)] with both hands.</span>"
			var/obj/item/weapon/gun/projectile/flintlock_pistol/offhand/O = new(user) ////Let's reserve his other hand~
			O.name = "[initial(name)] - offhand"
			O.desc = "Your second grip on the [initial(name)]"
			user.put_in_inactive_hand(O)
			return

	offhand
		w_class = 5.0
		icon = 'icons/obj/weapons.dmi'
		icon_state = "offhand"
		item_state = null
		name = "offhand"

		unwield()
			del(src)

		wield()
			del(src)

	verb/EjectRamrod()
		set name = "Eject Ramrod"
		set category = "Object"
		if(ramrod)
			var/obj/item/weapon/ramrod/R = ramrod
			R.loc = usr.loc
			ramrod = null
			R.pickup(usr)
			usr.put_in_any_hand_if_possible(R)
			usr.visible_message("<span class='notice'>[usr] ejects a ramrod from the rifle.</span>", "<span class='notice'>You eject a ramrod from the rifle.</span>")




/*
		ramrod - шомпол
		bulletstarter - укороченный шомпол для пистолетов
*/

/obj/item/weapon/ramrod/
	name = "ramrod"
	desc = "Uses to load powder and bullets into a rifle."
	icon = 'icons/obj/musketeer.dmi'
	icon_state = "ramrod"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	g_amt = 0
	m_amt = 75
	attack_verb = list("stabbed")

	bulletstarter
		name = "Bulletstarter"
		desc = "Uses to load powder and bullets into a pistol."
		icon = 'icons/obj/musketeer.dmi'
		icon_state = "bulletstarter"

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(!istype(M))	return ..()
		if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
			return ..()
		if((CLUMSY in user.mutations) && prob(50))
			M = user
		return eyestab(M,user)

/obj/item/weapon/bayonet
	name = "bayonet"
	desc = "Uses to ventilation holes in human bodies."
	icon = 'icons/obj/musketeer.dmi'
	icon_state = "bayonet"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 3
	throw_range = 5
	g_amt = 0
	m_amt = 75
	force = 10.0
	throwforce = 10.0
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "sliced", "cut")

	attack(target as mob, mob/living/user as mob)
		if ((CLUMSY in user.mutations) && prob(50))
			user << "\red You accidentally cut yourself with the [src]."
			user.take_organ_damage(20)
			return
		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
		return ..()

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>")
		return (BRUTELOSS)


/obj/item/ammo_casing/old_bullet
	desc = "Classic bullet."
	caliber = "old_rifle"
	projectile_type = "/obj/item/projectile/bullet/classic"

/obj/item/projectile/bullet/classic
	name = "classic bullet"
	damage = 60
	embed = 0
	sharp = 0

/obj/item/powder_bag
	name = "powder bag"
	desc = "Bag of powder"
	icon = 'icons/obj/musketeer.dmi'
	icon_state = "powder_bag"
	slot_flags = SLOT_BELT | SLOT_POCKET
	var/amount = 50

	attackby(var/obj/item/powder_bag/PB as obj)
		if(amount == 50)
			usr << "\red Powder bag is full."
			return
		if(amount >= 45 && PB.amount >= 50-amount)
			PB.amount -= 50-amount
			amount += 50-amount
			return
		if(PB.amount < 5)
			amount += PB.amount
			PB.amount = 0
			return
		amount += 5
		PB.amount -=5

	examine()
		..()
		usr << "Powder amount:[amount]."

/obj/item/bullet_bag
	name = "bullet bag"
	desc = "Bag of bullets"
	icon = 'icons/obj/musketeer.dmi'
	icon_state = "bullet_bag"
	slot_flags = SLOT_BELT | SLOT_POCKET
	var/amount = 50

	attack_hand(mob/user as mob)
		if(!amount)
			usr << "\red Bullet bag is empty."
		else
			amount--
			var/obj/item/projectile/bullet/classic/B = new /obj/item/projectile/bullet/classic(src.loc)
			B.pickup(user)
			user.put_in_any_hand_if_possible(B)

	attackby(var/obj/item/projectile/bullet/classic/O as obj)
		if(amount == 50)
			usr << "\red Bullet bag is full."
		else
			amount++
			del(O)

	MouseDrop(atom/over_object)
		var/mob/M = usr
		if(usr.stat || !ishuman(usr) || !usr.canmove || usr.restrained())
			return
		if(Adjacent(usr))
			if(over_object == M && loc != M)
				M.put_in_hands(src)
				usr << "<span class='notice'>You pick up the bullet bag.</span>"

			else if(istype(over_object, /obj/screen))
				switch(over_object.name)
					if("l_hand")
						M.put_in_l_hand(src)
					else if("r_hand")
						M.put_in_r_hand(src)
					usr << "<span class='notice'>You pick up the bullet bag.</span>"
		else
			usr << "<span class='notice'>You can't reach it from here.</span>"

	examine()
		..()
		usr << "Bullets amount:[amount]."


/obj/item/weapon/claymore/broadsword
	name = "broadsword"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon = 'icons/obj/musketeer.dmi'
	icon_override = 'icons/obj/musketeer.dmi'
	slot_flags = SLOT_BELT
	icon_state = "broadsword"
	item_state = "broadsword"
	force = 40