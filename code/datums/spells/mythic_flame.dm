/obj/effect/proc_holder/spell/targeted/light
	name = "Light"
	desc = "This simple spell creates a small light on the caster's hand."
	charge_max = 20
	clothes_req = 0
	invocation = null
	invocation_type = "none"
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/light/cast(list/targets)
	world << "We have [targets.len] targets"
	var/mob/living/carbon/target = targets[1]
	if(!istype(target))
		world << "Wrong type"
		return
	
	if(locate(/obj/item/weapon/flame/magicflame) in target)
		return
	
	var/obj/item/weapon/flame/magicflame/flame = new /obj/item/weapon/flame/magicflame
	target.put_in_hands(flame)

/obj/item/weapon/flame/magicflame
	name = "mythic flame"
	desc = "A magical flame created by wizards. No fire can put it out."
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire"
	item_state = "lighter-g"
	w_class = 1
	force = 5
	damtype = "fire"
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/magicflame/New()
	spawn(5)
		if(ismob(loc))
			lit = 1
			loc.SetLuminosity(loc.luminosity + 3)
		else
			del(src)

/obj/item/weapon/flame/magicflame/dropped(mob/user)
	if(lit)
		user.SetLuminosity(user.luminosity - 3)
	del(src)