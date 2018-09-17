//	Observer Pattern Implementation: Bullet Hit
//		Registration type: /atom
//
//		Raised when: Bullet_act is procced
//
//		Arguments that the called proc should expect:
//			/atom/hittee - The atom being hit
//			/obj/item/projectile - the projectile
//			/def_zone - the defense zone.

GLOBAL_DATUM_INIT(bullet_hit_event, /decl/observ/death, new)

/decl/observ/bullet_hit
	name = "Bullet Hit"
	expected_type = /atom

/*****************
* Bullet Hit Handling *
*****************/

/atom/bullet_act(obj/item/projectile/P, def_zone)
	GLOB.bullet_hit_event.raise_event(src, P, def_zone)
	. = ..()