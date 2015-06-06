//I still dont think this should be a closet but whatever
/obj/structure/closet/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/weapon/material/twohanded/fireaxe/fireaxe
	icon_state = "fireaxe1000"
	icon_closed = "fireaxe1000"
	icon_opened = "fireaxe1100"
	anchored = 1
	density = 0
	var/localopened = 0 //Setting this to keep it from behaviouring like a normal closet and obstructing movement in the map. -Agouri
	opened = 1
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

	New()
		..()
		fireaxe = new /obj/item/weapon/material/twohanded/fireaxe(src)

	attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
		//..() //That's very useful, Erro

		var/hasaxe = 0       //gonna come in handy later~
		if(fireaxe)
			hasaxe = 1

		if (isrobot(usr) || src.locked)
			if(istype(O, /obj/item/device/multitool))
				user << "<span class='warning'>Resetting circuitry...</span>"
				playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
				if(do_after(user, 20))
					src.locked = 0
					user << "<span class = 'caution'> You disable the locking modules.</span>"
					update_icon()
				return
			else if(istype(O, /obj/item/weapon))
				var/obj/item/weapon/W = O
				if(src.smashed || src.localopened)
					if(localopened)
						localopened = 0
						icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
					return
				else
					playsound(user, 'sound/effects/Glasshit.ogg', 100, 1) //We don't want this playing every time
				if(W.force < 15)
					user << "<span class='notice'>The cabinet's protective glass glances off the hit.</span>"
				else
					src.hitstaken++
					if(src.hitstaken == 4)
						playsound(user, 'sound/effects/Glassbr3.ogg', 100, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
						src.smashed = 1
						src.locked = 0
						src.localopened = 1
				update_icon()
			return
		if (istype(O, /obj/item/weapon/material/twohanded/fireaxe) && src.localopened)
			if(!fireaxe)
				if(O:wielded)
					user << "<span class='warning'>Unwield the axe first.</span>"
					return
				fireaxe = O
				user.remove_from_mob(O)
				src.contents += O
				user << "<span class='notice'>You place the fire axe back in the [src.name].</span>"
				update_icon()
			else
				if(src.smashed)
					return
				else
					localopened = !localopened
					if(localopened)
						icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
					else
						icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
		else
			if(src.smashed)
				return
			if(istype(O, /obj/item/device/multitool))
				if(localopened)
					localopened = 0
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
					return
				else
					user << "<span class='warning'>Resetting circuitry...</span>"
					sleep(50)
					src.locked = 1
					user << "<span class='notice'>You re-enable the locking modules.</span>"
					playsound(user, 'sound/machines/lockenable.ogg', 50, 1)
					if(do_after(user,20))
						src.locked = 1
						user << "<span class = 'caution'> You re-enable the locking modules.</span>"
					return
			else
				localopened = !localopened
				if(localopened)
					icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()




	attack_hand(mob/user as mob)

		var/hasaxe = 0
		if(fireaxe)
			hasaxe = 1

		if(src.locked)
			user <<"<span class='warning'>The cabinet won't budge!</span>"
			return
		if(localopened)
			if(fireaxe)
				user.put_in_hands(fireaxe)
				fireaxe = null
				user << "<span class='notice'>You take the fire axe from the [name].</span>"
				src.add_fingerprint(user)
				update_icon()
			else
				if(src.smashed)
					return
				else
					localopened = !localopened
					if(localopened)
						src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
					else
						src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()

		else
			localopened = !localopened //I'm pretty sure we don't need an if(src.smashed) in here. In case I'm wrong and it fucks up teh cabinet, **MARKER**. -Agouri
			if(localopened)
				src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
			else
				src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()

	attack_tk(mob/user as mob)
		if(localopened && fireaxe)
			fireaxe.loc = loc
			user << "<span class='notice'>You telekinetically remove the fire axe.</span>"
			fireaxe = null
			update_icon()
			return
		attack_hand(user)

	verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
		set name = "Open/Close"
		set category = "Object"

		if (isrobot(usr) || src.locked || src.smashed)
			if(src.locked)
				usr << "<span class='warning'>The cabinet won't budge!</span>"
			else if(src.smashed)
				usr << "<span class='notice'>The protective glass is broken!</span>"
			return

		localopened = !localopened
		update_icon()

	verb/remove_fire_axe()
		set name = "Remove Fire Axe"
		set category = "Object"

		if (isrobot(usr))
			return

		if (localopened)
			if(fireaxe)
				usr.put_in_hands(fireaxe)
				fireaxe = null
				usr << "<span class='notice'>You take the Fire axe from the [name].</span>"
			else
				usr << "<span class='notice'>The [src.name] is empty.</span>"
		else
			usr << "<span class='notice'>The [src.name] is closed.</span>"
		update_icon()

	attack_ai(mob/user as mob)
		if(src.smashed)
			user << "<span class='warning'>The security of the cabinet is compromised.</span>"
			return
		else
			locked = !locked
			if(locked)
				user << "<span class='warning'>Cabinet locked.</span>"
			else
				user << "<span class='notice'>Cabinet unlocked.</span>"
			return

	update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
		var/hasaxe = 0
		if(fireaxe)
			hasaxe = 1
		icon_state = text("fireaxe[][][][]",hasaxe,src.localopened,src.hitstaken,src.smashed)

	open()
		return

	close()
		return
