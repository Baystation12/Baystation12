
/obj/item/weapon/grenade/frag/m9_hedp
	name = "M9 HE-DP grenade"
	desc = "This High-Explosive Dual-Purpose fragmentation grenade is designed to be effective against infantry and lightly armored vehicles."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M9 HEDP"
	num_fragments = 8
	can_adjust_timer = 0
	starttimer_on_hit = 1
	det_time = 30
	explosion_size = 2
	alt_explosion_range = 2
	alt_explosion_damage_max = 40

/obj/item/weapon/grenade/frag/m9_hedp/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(get_turf(O), -1, explosion_size,explosion_size, 0)
	do_alt_explosion()

/obj/item/weapon/storage/box/m9_frag
	name = "box of M9 frag grenades (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause serious bodily laceration or death.</B>"
	startswith = list(/obj/item/weapon/grenade/frag/m9_hedp = 7)
