/obj/item/weapon_attachment/secondary_weapon
	name = "weapon attachment"
	desc = "An attachment designed to provide secondary tactical weapon usage."
	var/alt_fire_active = -1 //set to -1 to disable the alt-fire completely
	var/alt_fire_ammo_typepath = null //restricts the ammo-casing that can be loaded.
	var/alt_fire_ammo_max = 0
	var/list/alt_fire_ammo = list()
	var/alt_fire_sound = null

/obj/item/weapon_attachment/secondary_weapon/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs += /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	gun.verbs -= /obj/item/weapon/gun/secondary_weapon/proc/toggle_attachment

/obj/item/weapon_attachment/secondary_weapon/proc/post_fire_handling(var/atom/target,var/mob/living/user,var/obj/item/casing_left)
	qdel(casing_left)

/obj/item/weapon_attachment/secondary_weapon/proc/fire_attachment(var/atom/target, var/mob/living/user)
	var/obj/item/ammo_casing/chambered
	if(!alt_fire_ammo[1])
		to_chat(user,"<span class = 'notice'>[name] clicks. It's empty.</span>")
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
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

/obj/item/weapon_attachment/secondary_weapon/proc/load_attachment(var/obj/item/A, var/mob/user)
	if(!istype(A,alt_fire_ammo_typepath))
		return
	var/ammo_postload = alt_fire_ammo.len + 1
	if(ammo_postload > alt_fire_ammo_max)
		to_chat(user,"<span class = 'notice'>[src] is full!</span>")
		return

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
	icon_state = "MA5-Shotgun"
	weapon_slot = "underbarrel rail"
	alt_fire_active = 0
	alt_fire_ammo_typepath = /obj/item/ammo_casing/shotgun
	alt_fire_ammo_max = 2
	alt_fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
