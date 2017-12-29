
/obj/item/weapon/grenade/plasma
	name = "Type-1 Antipersonnel Grenade"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "plasmagrenade"

/obj/item/weapon/grenade/plasma/throw_impact(var/atom/A)
	. = ..()
	if(!active)
		return
	var/mob/living/L = A
	if(!istype(L))
		return
	L.embed(src)
	A.visible_message("<span class = 'danger'>[src.name] sticks to [L.name]!</span>")

/obj/item/weapon/grenade/plasma/detonate()
	explosion(src.loc, -1, 1, 3, 2, 0)
	qdel(src)