/obj/item/weapon/gun/composite/consume_next_projectile()

	if(jammed)
		var/mob/M = loc
		if(istype(M))
			M << "<span class='warning'>\The [src] has jammed!</span>"
		return

	var/obj/item/projectile/proj = chamber.consume_next_projectile()
	if(proj)
		if(model && !isnull(model.produced_by.damage_mod))
			proj.damage = round(proj.damage * model.produced_by.damage_mod)
		chamber.modify_shot(proj)
	return proj

/obj/item/weapon/gun/composite/handle_post_fire()
	..()
	chamber.handle_post_fire()

/obj/item/weapon/gun/composite/handle_click_empty()
	..()
	chamber.handle_click_empty()
