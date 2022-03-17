//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, var/pass_flags=PASS_FLAG_TABLE|PASS_FLAG_GLASS|PASS_FLAG_GRILLE)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	trace.pass_flags = pass_flags

	return trace.launch(target) //Test it!

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	var/list/hit = list()

/obj/item/projectile/test/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/item/projectile/test/Bump(atom/A, forced = FALSE)
	if(A != src)
		hit |= A
	return ..()

/obj/item/projectile/test/attack_mob()
	return
