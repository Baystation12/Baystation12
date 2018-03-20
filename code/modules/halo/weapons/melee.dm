
/obj/item/weapon/material/knife/combat_knife
	name = "combat knife"
	desc = "Multipurpose knife for utility use and close quarters combat"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Knife"
	item_state = "butterflyknife_open"
	w_class = ITEM_SIZE_SMALL
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/melee/baton/humbler
	name = "humbler stun device"
	desc = "A retractable baton capable of inducing a large amount of pain via electrical shocks."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "humbler stun device"
	item_state = "telebaton_0"
	force = 35
	damtype = PAIN
	w_class = 2		//smaller while we're folded up

/obj/item/weapon/melee/baton/humbler/New()
	..()
	bcell = new/obj/item/weapon/cell/high(src)
	update_icon()
	return

/obj/item/weapon/melee/baton/humbler/attack_self(mob/user)
	if(..())
		if(status)
			w_class = 3
			icon_state = "humbler stun device"
		else
			w_class = 2
			item_state = "telebaton_1"

/obj/item/weapon/melee/baton/humbler/deductcharge(var/chrgdeductamt)
	if(!..())
		w_class = 2
		item_state = "telebaton_1"
