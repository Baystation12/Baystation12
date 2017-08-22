
/obj/item/weapon/grenade/frag/m9_hedp
	name = "M9 HE-DP grenade"
	desc = "This High-Explosive Dual-Purpose fragmentation grenade is designed to be effective against infantry and lightly armored vehicles."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "M9 HEDP"

/obj/item/weapon/storage/box/m9_frag
	name = "box of M9 frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause serious bodily laceration or death.</B>"
	icon_state = "flashbang"

	New()
		..()
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
		new /obj/item/weapon/grenade/frag/m9_hedp(src)
