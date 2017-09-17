//////////////////////Scrying orb//////////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/user as mob)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(user, "<span class='warning'>You stare into the orb and see nothing but your own reflection.</span>")
		return

	to_chat(user, "<span class='info'>You can see... everything!</span>") // This never actually happens.
	visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

	user.teleop = user.ghostize(1)
	announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
	return



/////////////////////////Cursed Dice///////////////////////////
/obj/item/weapon/dice/d20/cursed
	desc = "A dice with twenty sides said to have an ill effect on those that are unlucky..."

/obj/item/weapon/dice/d20/cursed/attack_self(mob/living/user)
	..()
	if(icon_state == "[name][sides]")
		user.adjustBruteLoss(-30)
	else if(icon_state == "[name]1")
		user.adjustBruteLoss(30)

/////////////////////////Ring of Invisibility///////////////////////////
/obj/item/clothing/ring/magic
	name = "Ring of Invisibility"
	desc = "A golden ring with symbols carved on it in some strange language."
	icon_state = "magic"

/obj/item/clothing/ring/magic/equipped(var/mob/living/carbon/human/H, var/slot)
	..()
	if(istype(H) && slot==slot_gloves && !H.cloaked)
		H.cloaked = TRUE
		H.update_icons()
		H.visible_message("<span class='warning'>\The [H] seems to disappear before your eyes!</span>", "<span class='notice'>You feel completely invisible.</span>")

/obj/item/clothing/ring/magic/dropped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.cloaked)
		H.cloaked = FALSE
		H.update_icons()
		H.visible_message("<span class='warning'>\The [H] appears from thin air!</span>", "<span class='notice'>You have re-appeared.</span>")