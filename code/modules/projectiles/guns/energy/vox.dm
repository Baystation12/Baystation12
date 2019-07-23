
/*
 * Vox Darkmatter Cannon
 */
/obj/item/weapon/gun/energy/darkmatter
	name = "flux cannon"
	desc = "A vicious beam weapon that crushes targets with dark-matter gravity pulses. Parts of it quiver and writhe, as if alive."
	icon = 'icons/obj/guns/darkcannon.dmi'
	icon_state = "darkcannon"
	item_state = "darkcannon"
	w_class = ITEM_SIZE_LARGE
	projectile_type = /obj/item/projectile/beam/stun/darkmatter
	one_hand_penalty = 2 //a little bulky
	self_recharge = 1

	firemodes = list(
		list(mode_name="stunning", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/stun/darkmatter, charge_cost = 50),
		list(mode_name="focused", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/darkmatter, charge_cost = 75),
		list(mode_name="scatter burst", burst=8, fire_delay=null, move_delay=4, burst_accuracy=list(0, 0, 0, 0, 0, 0, 0, 0), dispersion=list(0, 1, 2, 2, 3, 3, 3, 3, 3), projectile_type=/obj/item/projectile/energy/darkmatter, charge_cost = 10),
		)

/obj/item/weapon/gun/energy/darkmatter/special_check(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.get_bodytype(H) != SPECIES_VOX)
			to_chat(user, "<span class='warning'>\The [src] hisses and jumps out of your grasping appendage.</span>") //gotta be all inclusive with your hand descriptors
			playsound (user,'sound/voice/BugHiss.ogg', 50, 1)
			usr.unEquip(src)
			return 0
		return ..()


/*
 * Vox Sonic Cannon
 */
/obj/item/weapon/gun/energy/sonic
	name = "soundcannon"
	desc = "A vicious alien sound weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon = 'icons/obj/guns/noise.dmi'
	icon_state = "noise"
	item_state = "noise"
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 1
	self_recharge = 1
	recharge_time = 10
	fire_delay = 15

	projectile_type=/obj/item/projectile/sonic/weak

	firemodes = list(
		list(mode_name="normal", projectile_type=/obj/item/projectile/sonic/weak, charge_cost = 50),
		list(mode_name="overcharge", projectile_type=/obj/item/projectile/sonic/strong, charge_cost = 200),
		)

/obj/item/weapon/gun/energy/sonic/special_check(user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species && H.species.get_bodytype(H) != SPECIES_VOX)
			to_chat(user, "<span class='warning'>\The [src] hisses and jumps out of your grasping appendage.</span>") //gotta be all inclusive with your hand descriptors
			playsound (user,'sound/voice/BugHiss.ogg', 50, 1)
			usr.unEquip(src)
			return 0
		return ..()