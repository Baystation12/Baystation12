
/obj/item/weapon/grenade/frag/m9_hedp
	name = "M9 HE-DP grenade"
	desc = "This High-Explosive Dual-Purpose fragmentation grenade is designed to be effective against infantry and lightly armored vehicles."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M9 HEDP"
	num_fragments = 100
	can_adjust_timer = 0
	det_time = 50
	alt_explosion_range = 1 //Low alt-explosion range due to the shrapnel.
	alt_explosion_damage_max = 70

/obj/item/weapon/grenade/frag/m9_hedp/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, -1,explosion_size, round(explosion_size*2))
	do_alt_explosion()

/obj/item/weapon/storage/box/m9_frag
	name = "box of M9 frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause serious bodily laceration or death.</B>"
	startswith = list(/obj/item/weapon/grenade/frag/m9_hedp = 7)
