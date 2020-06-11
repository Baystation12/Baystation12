
/obj/item/weapon/melee/hardlight_blade
	name = "C-340 CQB Purification Applicator"
	desc = "A blade made purely of hardlight energy."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "exorcisor"
	item_state = "armblade"
	force = 50 //Lower damage, higher AP than esword
	throwforce = 12
	armor_penetration = 45
	edge = 1
	sharp = 1
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_l.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_r.dmi',
		)

/obj/item/weapon/melee/hardlight_blade/can_embed()
	return FALSE

/obj/item/weapon/melee/hardlight_blade/gauntletbound
	icon_state = "armblade"
	var/obj/our_gauntlet

/obj/item/weapon/melee/hardlight_blade/gauntletbound/proc/check_gauntlet()
	if(!(our_gauntlet in loc.contents))
		var/mob/m = loc
		if(istype(m))
			m.drop_from_inventory(src)
		forceMove(our_gauntlet)
		return 0
	return 1

/obj/item/weapon/melee/hardlight_blade/gauntletbound/New(var/gauntlet)
	our_gauntlet = gauntlet
	. = ..()

/obj/item/weapon/melee/hardlight_blade/gauntletbound/attack()
	if(!check_gauntlet())
		return
	. = ..()

/obj/item/weapon/melee/hardlight_blade/gauntletbound/dropped(var/mob/user)
	. = ..()
	if(user)
		check_gauntlet()