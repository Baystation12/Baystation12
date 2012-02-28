/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY
	m_amt = 2000
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"

	var
		fire_sound = 'Gunshot.ogg'
		obj/item/projectile/in_chamber = null
		caliber = ""
		silenced = 0
		recoil = 0

	proc
		load_into_chamber()
		special_check(var/mob/M)


	load_into_chamber()
		return 0


	special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1


	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)

	attack(mob/living/M as mob, mob/living/user as mob, def_zone)
		if (M == user && user.zone_sel.selecting == "mouth" && load_into_chamber())
			M.visible_message("\red [user] sticks their gun in their mouth, ready to pull the trigger...")
			if(!do_after(user, 40))
				M.visible_message("\blue [user] decided life was worth living")
				return
			if(istype(src.in_chamber, /obj/item/projectile/bullet) && !istype(src.in_chamber, /obj/item/projectile/bullet/stunshot))
				M.apply_damage(75, BRUTE, "head", used_weapon = "Suicide attempt with a projectile weapon.")
				M.apply_damage(85, BRUTE, "chest")
				M.visible_message("\red [user] pulls the trigger.")
			else if(istype(src.in_chamber, /obj/item/projectile/bullet/stunshot) || istype(src.in_chamber, /obj/item/projectile/energy/electrode))
				M.apply_damage(10, BURN, "head", used_weapon = "Suicide attempt with a stun round.")
				M.visible_message("\red [user] pulls the trigger, but luckily it was a stun round.")
			else if(istype(src.in_chamber, /obj/item/projectile/beam) || istype(src.in_chamber, /obj/item/projectile/energy))
				M.apply_damage(75, BURN, "head", used_weapon = "Suicide attempt with an energy weapon")
				M.apply_damage(85, BURN, "chest")
				M.visible_message("\red [user] pulls the trigger.")
			else
				M.apply_damage(75, BRUTE, "head", used_weapon = "Suicide attempt with a gun")
				M.apply_damage(85, BRUTE, "chest")
				M.visible_message("\red [user] pulls the trigger. Ow.")
			del(src.in_chamber)
			return
		else
			return ..()

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)//TODO: go over this
		if(flag)	return //we're placing gun on a table or in backpack
		if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?

		if(istype(user, /mob/living))
			var/mob/living/M = user
			if ((M.mutations & CLUMSY) && prob(50))
				M << "\red The [src.name] blows up in your face."
				M.take_organ_damage(0,20)
				M.drop_item()
				del(src)
				return

		if (!user.IsAdvancedToolUser())
			user << "\red You don't have the dexterity to do this!"
			return

		add_fingerprint(user)

		var/turf/curloc = user.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		if(!special_check(user))	return
		if(!load_into_chamber())
			user << "\red *click*";
			for(var/mob/M in orange(4,src.loc))
				M.show_message("*click, click*")
			return

		if(!in_chamber)	return

		in_chamber.firer = user
		in_chamber.def_zone = user.zone_sel.selecting

		if(targloc == curloc)
			user.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		if(recoil)
			spawn()
				shake_camera(user, recoil + 1, recoil)

		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)
			user.visible_message("\red [user.name] fires the [src.name]!", "\red You fire the [src.name]!", "\blue You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = targloc
		in_chamber.loc = get_turf(user)
		user.next_move = world.time + 4
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x

		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				in_chamber.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				in_chamber.p_y = text2num(mouse_control["icon-y"])

		spawn()
			if(in_chamber)	in_chamber.process()
		sleep(1)
		in_chamber = null

		update_icon()
		return

