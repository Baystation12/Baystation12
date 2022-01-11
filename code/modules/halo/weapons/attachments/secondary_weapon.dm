/obj/item/weapon_attachment/secondary_weapon
	name = "weapon attachment"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	var/alt_fire_active = 0 //set to -1 to disable the alt-fire completely
	var/ammotype = null //restricts the ammo-casing that can be loaded.
	var/int_mag_size = 0
	var/list/int_mag = list()
	var/alt_fire_loadsound = null
	var/alt_fire_ejectsound = null
	var/alt_fire_firesound = null
	var/fire_delay = 0 //An extra delay to add to user click_delay when firing this weapon
	var/ejection = 1 //1 for eject automatically, -1 for caseless, 0 for manual ejection

/obj/item/weapon_attachment/secondary_weapon/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs += /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs -= /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/proc/post_fire_handling(var/obj/item/ammo_casing/casing, eject)
	if(!casing) return
	if(eject == -1) //caseless
		qdel(casing)
		return
	casing.expend() //ammo expended
	if(eject == 1) //auto-ejecting
		casing.eject(get_turf(src), angle2dir(dir2angle(loc.loc.dir)+90)) //loc = gun, loc.loc = the man firing


/obj/item/weapon_attachment/secondary_weapon/proc/fire_attachment(var/atom/target, var/mob/living/user)
	var/obj/item/ammo_casing/chambered
	//checks if internal magazine is empty
	if(int_mag.len == 0)
		to_chat(user,"<span class = 'notice'>[name] clicks. It's empty.</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
		return
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN + fire_delay)
	//puts a round in the chamber if we're not empty
	chambered = int_mag[1]
	// removes chambered from the internal magazine
	if (ejection != 0)
		int_mag -= chambered
		contents -= chambered
	//finds the projectile from chambered
	var/obj/item/projectile/proj = chambered.BB
	//removes the projectile from chambered
	chambered.BB = null
	//puts the projectile at the user's loc
	proj.forceMove(user.loc)
	//launches the projectile
	proj.launch(target)
	//weapon sound takes priority over ammo sound
	if(alt_fire_firesound)
		playsound(user, alt_fire_firesound, 50, 1)
	else if(proj.fire_sound)
		playsound(user, proj.fire_sound, 50, 1)
	visible_message("<span class = 'danger'>[user] fires [src] at [target].</span>")

	post_fire_handling(chambered, ejection)
	return 1

/obj/item/weapon_attachment/secondary_weapon/proc/load_attachment(var/obj/item/A, var/mob/user)
	if(!istype(A,ammotype))
		return
	if(int_mag.len >= int_mag_size)
		to_chat(user,"<span class = 'notice'>[src] is full!</span>")
		return

	if(alt_fire_loadsound)
		playsound(src.loc, alt_fire_loadsound, 100, 1)

	to_chat(user,"<span class = 'notice'>[user] loads [A] into [src]</span>")
	user.remove_from_mob(A)
	contents += A
	int_mag += A

/obj/item/weapon_attachment/secondary_weapon/proc/unload_attachment(var/mob/user)
	if(int_mag.len > 0)
		for(var/obj/item/ammo_casing/casing in int_mag)
			contents -= casing
			int_mag -= casing
			casing.forceMove(user.loc)
			spawn(1) playsound(src.loc, alt_fire_ejectsound, 50,1)
		to_chat(user,"<span class = 'notice'>[user] unloads [src]</span>")
	else
		to_chat(user,"<span class = 'notice'>[src] is already empty!</span>")

/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun
	name = "underslung shotgun"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	icon_state = "Underbarrel-Shotgun"
	weapon_slot = "underbarrel rail"
	ammotype = /obj/item/ammo_casing/shotgun
	int_mag_size = 4
	alt_fire_loadsound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	fire_delay = 15

/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun_soe
	name = "SOE underslung shotgun"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	icon_state = "Underbarrel-Shotgun-SOE-obj"
	weapon_slot = "underbarrel rail"
	ammotype = /obj/item/ammo_casing/shotgun
	int_mag_size = 2
	alt_fire_loadsound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	fire_delay = 7

/obj/item/weapon_attachment/secondary_weapon/underslung_grenadelauncher
	name = "M301 Grenade Launcher"
	desc = "An underslung grenade launcher for attaching to the MA5B. Uses 40mm grenades."
	icon_state = "MA5-NadeLauncher"
	weapon_slot = "underbarrel rail"
	ammotype = /obj/item/ammo_casing/g40mm
	int_mag_size = 1
//	alt_fire_loadsound = 'code/modules/halo/sounds/DMR_Reload_Sound_Effect.ogg'
//	get a better sound ^
//	alt_fire_ejectsound =
	ejection = 0