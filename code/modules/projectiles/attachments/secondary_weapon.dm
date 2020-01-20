/obj/item/weapon_attachment/secondary_weapon
	name = "weapon attachment"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	var/alt_fire_active = 0 //set to -1 to disable the alt-fire completely
	var/alt_fire_ammo_typepath = null //restricts the ammo-casing that can be loaded.
	var/alt_fire_ammo_max = 0
	var/list/alt_fire_ammo = list()
	var/alt_fire_sound = null
	var/alt_fire_loadsound = null
	var/fire_delay = 0 //An extra delay to add to user click_delay when firing this weapon

/obj/item/weapon_attachment/secondary_weapon/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs += /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs -= /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/proc/post_fire_handling(var/atom/target,var/mob/living/user,var/obj/item/casing_left)
	qdel(casing_left)

/obj/item/weapon_attachment/secondary_weapon/proc/fire_attachment(var/atom/target, var/mob/living/user)
	var/obj/item/ammo_casing/chambered
	if(alt_fire_ammo.len == 0)
		to_chat(user,"<span class = 'notice'>[name] clicks. It's empty.</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
		return
	chambered = alt_fire_ammo[1]

	alt_fire_ammo -= chambered
	contents -= chambered
	var/obj/item/projectile/proj = chambered.BB
	chambered.BB = null
	proj.forceMove(user.loc)
	proj.launch(target)
	if(alt_fire_sound)
		playsound(user, alt_fire_sound, 50, 1)
	visible_message("<span class = 'danger'>[user] fires [src] at [target].</span>")

	post_fire_handling(target,user,chambered)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN + fire_delay)
	return 1

/obj/item/weapon_attachment/secondary_weapon/proc/load_attachment(var/obj/item/A, var/mob/user)
	if(!istype(A,alt_fire_ammo_typepath))
		return
	if(alt_fire_ammo.len >= alt_fire_ammo_max)
		to_chat(user,"<span class = 'notice'>[src] is full!</span>")
		return

	if(alt_fire_loadsound)
		playsound(src.loc, alt_fire_loadsound, 100, 1)

	to_chat(user,"<span class = 'notice'>[user] loads [A] into [src]</span>")
	user.remove_from_mob(A)
	contents += A
	alt_fire_ammo += A

/obj/item/weapon_attachment/secondary_weapon/proc/unload_attachment(var/mob/user)
	for(var/obj/item/ammo_casing/casing in alt_fire_ammo)
		contents -= casing
		casing.forceMove(user.loc)

	to_chat(user,"<span class = 'notice'>[user] unloads [src]</span>")

/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun
	name = "underslung shotgun"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	icon_state = "Underbarrel-Shotgun"
	weapon_slot = "underbarrel rail"
	alt_fire_ammo_typepath = /obj/item/ammo_casing/shotgun
	alt_fire_ammo_max = 4
	alt_fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	alt_fire_loadsound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	fire_delay = 15

/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun_soe
	name = "SOE underslung shotgun"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	icon_state = "Underbarrel-Shotgun-SOE-obj"
	weapon_slot = "underbarrel rail"
	alt_fire_ammo_typepath = /obj/item/ammo_casing/shotgun
	alt_fire_ammo_max = 2
	alt_fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	alt_fire_loadsound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	fire_delay = 7

/obj/item/weapon_attachment/secondary_weapon/underslung_grenadelauncher
	name = "underslung grenade launcher"
	desc = "An underslung grenade launcher. What more is there to need?"
	icon_state = "MA5-NadeLauncher"
	weapon_slot = "underbarrel rail"
	//alt_fire_ammo_typepath
	//alt-fire_ammo_max = 1
	//alt_fire_sound =
