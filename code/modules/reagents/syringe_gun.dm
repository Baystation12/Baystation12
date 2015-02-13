/obj/item/ammo_casing/gas_cartridge
	name = "compressed gas cartridge"
	desc = "An impact-triggered compressed gas cartridge that can fitted to a syringe for rapid injection. It's not very useful until primed though."  //i.e. only works when shot out of a syringe gun. 
	icon_state = "syringe-cartridge"
	caliber = "syringe"
	projectile_type = /obj/item/projectile/bullet/syringe
	w_class = 2 //mainly so that they can be yanked out
	var/obj/item/weapon/reagent_containers/syringe/syringe

/obj/item/ammo_casing/gas_cartridge/update_icon()
	underlays.Cut()
	if(syringe)
		underlays += image(syringe.icon, src, syringe.icon_state)
		underlays += syringe.filling

/obj/item/ammo_casing/gas_cartridge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		syringe = I
		user << "<span class='notice'>You carefully insert [syringe] into [src].</span>"
		user.remove_from_mob(syringe)
		syringe.loc = src
		var/obj/item/projectile/bullet/syringe/S = BB
		if(istype(S))
			S.damage = 1
			S.sharp = 1
		update_icon()

/obj/item/ammo_casing/gas_cartridge/attack_self(mob/user)
	if(syringe)
		user << "<span class='notice'>You remove [syringe] from [src].</span>"
		user.put_in_hands(syringe)
		syringe = null
		var/obj/item/projectile/bullet/syringe/S = BB
		if(istype(S))
			S.damage = initial(S.damage)
			S.sharp = initial(S.sharp)
		update_icon()

//This was kind of rushed, there may very well be a simpler way to implement this.
//Sort of hacky, though nearly not as bad as the previous implementation:
//Basically the syringe gun is supposed to launch the entire syringe+cartrige assemby, but hitby() isn't powerfull enough to do what we need.
//Instead, we fire a projectile that transfers the reagents, and teleport the cartridge once we impact something.
/obj/item/projectile/bullet/syringe
	name = "syringe dart"
	icon_state = "cbbolt"
	damage = 3
	check_armour = "bullet"
	sharp = 0
	embed = 0 //we handle this ourselves
	var/obj/item/ammo_casing/gas_cartridge/cartridge
	var/embedded = 0
	kill_count = 10 //short range

/obj/item/projectile/bullet/syringe/New(newloc)
	..()
	//ensure that cartridge is always set
	cartridge = newloc
	if(!istype(cartridge))
		del(src)

/obj/item/projectile/bullet/syringe/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	//..() //not really necessary
	if(blocked < 2 && cartridge.syringe && isliving(target))
		var/mob/living/L = target
		
		//inject
		if(L.can_inject(target_zone=def_zone))
			if(cartridge.syringe.reagents)
				cartridge.syringe.reagents.trans_to(L, 15)
			cartridge.syringe.update_icon()
			cartridge.update_icon()
		
		//embed
		L.embed(cartridge, def_zone)
		embedded = 1

/obj/item/projectile/bullet/syringe/on_impact(atom/A)
	if(!embedded)
		cartridge.loc = src.loc
	if(cartridge.syringe)
		cartridge.syringe.break_syringe(iscarbon(A)? A : null)
		cartridge.update_icon()

			
			
/obj/item/weapon/gun/projectile/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, designed to incapacitate unruly patients from a distance."
	icon = 'icons/obj/gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = 3
	force = 7
	matter = list("metal" = 2000)
	slot_flags = SLOT_BELT
	
	caliber = "syringe"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	var/drawn = 0

/obj/item/weapon/gun/projectile/syringe/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/syringe/attack_self(mob/living/user as mob)
	if(!chambered && loaded.len)
		playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.visible_message("[user] draws back the bolt on [src], clicking it into place.", "<span class='warning'>You draw back the bolt on the [src], loading the spring!</span>")
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC
		max_shells -= 1 //to prevent people from storing an extra syringe
		update_icon()

/obj/item/weapon/gun/projectile/syringe/handle_post_fire()
	..()
	chambered = null
	max_shells = initial(max_shells)

/obj/item/weapon/gun/projectile/syringe/rapid
	name = "rapid syringe gun"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to four syringes. The spring still needs to be drawn between shots."
	icon_state = "rapidsyringegun"
	max_shells = 4
