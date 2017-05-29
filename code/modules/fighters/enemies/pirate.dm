/obj/fighter/pirate
	name = "Pirate Fighter"
	desc = "An advanced fightercraft, capable of dogfighting in space"
	icon = 'icons/obj/fighter.dmi'//TODO
	icon_state = "fighter" //TODO
	density = 1
	anchored = 1
	faction = "spacepirates"

	var/obj/fighter/target = 0

/obj/fighter/pirate/New()
	..()
	processing_objects += src

/obj/fighter/pirate/process()
	if(!target)
		find_target() //If we have no target, find one
	if(target)
		walk_to(src,target,2,15)
		if(prob(15))
			piratepewpew() //15% chance to shoot the target
		if(prob(10))
			find_target() //10% chance of switching targets



/obj/fighter/pirate/proc/find_target()
	if(prob(30))
		var/list/can_see = oview(src, 20)
		for(var/obj/fighter/F in can_see)
			if(F.faction == src.faction)
				continue
			else
				target = F
				break
		return target
	if(prob(10))
		target = 0 //10% chance to lose the target

/obj/fighter/pirate/proc/piratepewpew()
	if(weapon)
		var/P = new weapon.projectile(src.loc)
		weapon.Fire(P, target)
		playsound (src,'sound/weapons/Laser.ogg', 40.1)