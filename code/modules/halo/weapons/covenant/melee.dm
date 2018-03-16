 // make unweildy to use for marines.
 //Ideas: Half damage, make two handed.
/obj/item/weapon/melee/energy/elite_sword
	name = "Type-1 Energy Weapon"
	desc = "A small handle conceals the equipment required to generate a long shimmering blade of shaped plasma, capable of burning through most armor with ease."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "T1EW Handle"
	force = 1
	throwforce = 1
	active_force = 40
	active_throwforce = 12
	edge = 0
	sharp = 0

/obj/item/weapon/melee/energy/elite_sword/activate(mob/living/user)
	..()
	playsound(src.loc,'code/modules/halo/sounds/Energysworddeploy.ogg',75)
	to_chat(user, "<span class='notice'>\The [src] bursts from it's handle.</span>")
	icon_state = "T1EW-deployed"
	w_class = ITEM_SIZE_HUGE
	edge = 1
	sharp = 1
	flags = NOBLOODY
	item_icons = list(slot_l_hand_str ='code/modules/halo/icons/Energy Sword_inhand Human.dmi',slot_r_hand_str = 'code/modules/halo/icons/Energy Sword_inhand Human.dmi')
	item_state_slots = list(
	slot_l_hand_str = "Energy sword_inhand Human l",
	slot_r_hand_str = "Energy sword_inhand Human r" )
	hitsound = 'code/modules/halo/sounds/Energyswordhit.ogg'

/obj/item/weapon/melee/energy/elite_sword/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, "<span class='notice'>\The [src] disappears.</span>")
	w_class = ITEM_SIZE_SMALL
	flags = null
	item_icons = list(slot_l_hand_str = null,slot_r_hand_str = null)
	item_state_slots = null
	hitsound = "swing_hit"

/obj/item/weapon/melee/energy/elite_sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)
		visible_message("The [src] disappears.")

/obj/item/weapon/melee/energysword/attack(var/mob/m)
	if(ismob(m))
		damtype = BURN
	return ..()