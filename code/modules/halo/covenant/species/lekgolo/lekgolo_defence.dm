
/mob/living/simple_animal/mgalekgolo/bullet_act(var/obj/item/projectile/Proj)
	if(!(get_dir(src,Proj.starting) in get_allowed_attack_dirs()))
		visible_message("<span class = 'danger'>The [Proj.name] is stopped by \the [name]'s armor plating.</span>")
		return
	. = ..()

/mob/living/simple_animal/mgalekgolo/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	if(crouched && !(get_dir(src,user) in get_allowed_attack_dirs()))
		if(effective_force >= resistance)//40 is force of active energysword.
			effective_force -= resistance
			visible_message("<span class = 'danger'>[user] attacks [src.name] with \the [O.name], bypassing the armor plating!</span>")
			.=..()
		else
			visible_message("<span class = 'danger'>The [O.name] bounces off the armor of \the [name]</span>")
			return
	. = ..()

/mob/living/simple_animal/mgalekgolo/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/damage
	switch (severity)
		if (1.0)
			damage = 120

		if (2.0)
			damage = 60

		if(3.0)
			damage = 30

	adjustBruteLoss(damage)

/mob/living/simple_animal/mgalekgolo/adjustToxLoss(damage)
	adjustBruteLoss(damage)

/mob/living/simple_animal/mgalekgolo/attackby(var/obj/item/O, var/mob/user)
	if(!O.force)
		visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
	else
		O.attack(src, user, user.zone_sel.selecting)
