/obj/item/weapon/gun/rocketlauncher
	name = "rocket launcher"
	desc = "Say hello to my little friend."
	icon = 'icons/obj/gun.dmi'
	icon_state = "launcher"
	item_state = "launcher"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	var/list/rockets = new/list()
	var/max_rockets = 1
	m_amt = 2000

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\icon [src] Rocket launcher:"
		if(rockets.len)
			usr << "\blue [rockets] / [max_rockets] Rockets."
		else
			usr << "\blue 0 / [max_rockets] Rockets."

	attackby(obj/item/I as obj, mob/user as mob)

		if((istype(I, /obj/item/weapon/rocket)))
			if(rockets.len < max_rockets)
				user.drop_item()
				I.loc = src
				rockets += I
				user << "\blue You put the rocket in the rocket launcher."
				if(rockets.len)
					user << "\blue [rockets.len] / [max_rockets] Rockets."
				else
					user << "\blue 0 / [max_rockets] Rockets."
			else
				usr << "\red The rocket launcher cannot hold more grenades."

	afterattack(obj/target, mob/user , flag)

		if (istype(target, /obj/item/weapon/storage/backpack ))
			return

		else if (locate (/obj/structure/table, src.loc))
			return

		else if(target == user)
			return

		if(rockets.len)
			spawn(0) fire_rocket(target,user)
		else
			usr << "\red The rocket launcher is empty."

	proc
		fire_rocket(atom/target, mob/user)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] fired a rocket!", user), 1)
			user << "\red You fire the rocket launcher!"


			var/obj/item/weapon/rocket/R = rockets[1] //Now with less copypasta!
			rockets -= R
			R.loc = user.loc
			R.primed = 1
			R.throw_at(target, 30, 2)
			message_admins("[key_name_admin(user)] fired a rocket ([R.name]) from a rocket launcher ([src.name]).")
			log_game("[key_name_admin(user)] used a rocket ([src.name]).")

//			R.icon_state = initial(icon_state) + "_active"
			playsound(usr.loc, fire_sound, 50, 1)
			return



/obj/item/weapon/rocket
	name = "rocket"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "rocket"
	var/primed = null
	throwforce = 15

	throw_impact(atom/hit_atom)
		if(primed)
			explosion(hit_atom, 0, 0, 2, 4)
			del(src)
		else
			..()
		return