// Not strictly a bullet, not strictly a laser...
/obj/item/projectile/bullet/pellet/laser
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 16
	damage_type = BURN
	check_armour = "laser"
	eyeblur = 4
	hitscan = 1
	invisibility = 101
	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
