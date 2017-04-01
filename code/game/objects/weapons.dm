/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"

/mob/var/weapon_warned
/obj/item/weapon/attack_hand(mob/user)
	. = ..()
	if(user == loc && !user.weapon_warned)
		user.weapon_warned = 1
		to_chat(user, "<font size=3><b><span class ='danger'>UH HOH</span> looks like you got \a <span class ='danger'>[uppertext(name)]</span>!</b></font>")
		to_chat(user, "It's might look harmless and innocent (or it doesn't!) but that thing that can <span class ='danger'>HURT</span> someone or even <span class ='danger'>KILL THEM</span> (they won't be able to RP if they're dead!).")
		to_chat(user, "That is very scary. Be very careful about pointing this at people, it' all fun and games until someone <span class ='danger'>LOSES AN EYE</span>!")
