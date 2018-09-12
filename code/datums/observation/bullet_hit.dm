//	Observer Pattern Implementation: Bullet Hit
//		Registration type: /atom
//
//		Raised when: Right after bullect_act is proc'd on an /atom
//
//		Arguments that the called proc should expect:
//			/obj/item/projectile: projectile that is hitting
//			/atom/hittee: atom that is being hit

GLOBAL_DATUM_INIT(bullet_hit_event, /decl/observ/bullet_hit, new)

/decl/observ/bullet_hit
	name = "Bullet Hit"
	expected_type = /atom

//Raised event is embedded in /obj/projectile/Bump()
//code/modules/projectiles/projectile.dm L268 L272 L275
//Basically wherever bullet_act is proc'd by the projectile.