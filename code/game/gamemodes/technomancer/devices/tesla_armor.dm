/datum/technomancer/equipment/tesla_armor
	name = "Tesla Armor"
	desc = "This piece of armor offers a retaliation-based defense.  When the armor is 'ready', it will completely protect you from \
	the next attack you suffer, and strike the attacker with a strong bolt of lightning.  This effect requires twenty seconds to \
	recharge.  If you are attacked while this is recharging, a weaker lightning bolt is sent out, however you won't be protected from \
	the person beating you."
	cost = 150
	obj_path = /obj/item/clothing/suit/armor/tesla

/obj/item/clothing/suit/armor/tesla
	name = "tesla armor"
	desc = "This rather dangerous looking armor will hopefully shock your enemies, and not you in the process."
	icon_state = "reactiveoff" //wip
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	var/ready = 1 //Determines if the next attack will be blocked, as well if a strong lightning bolt is sent out at the attacker.
	var/ready_icon_state = "reactive" //also wip
	var/cooldown_to_charge = 20 SECONDS

/obj/item/clothing/suit/armor/tesla/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/armor/tesla/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//First, some retaliation.
	if(attacker && attacker != user)
		if(get_dist(user, attacker) <= 3) //Anyone farther away than three tiles is too far to shoot lightning at.
			if(ready)
				shoot_lightning(attacker, 40)
			else
				shoot_lightning(attacker, 15)

	//Deal with protecting our wearer now.
	if(ready)
		ready = 0
		spawn(cooldown_to_charge)
			ready = 1
			update_icon()
			to_chat(user,"<span class='notice'>\The [src] is ready to protect you once more.</span>")
		visible_message("<span class='danger'>\The [user]'s [src.name] blocks [attack_text]!</span>")
		update_icon()
		return 1
	return 0

/obj/item/clothing/suit/armor/tesla/update_icon()
	..()
	if(ready)
		icon_state = ready_icon_state
	else
		icon_state = initial(icon_state)

/obj/item/clothing/suit/armor/tesla/proc/shoot_lightning(var/mob/target, var/power)
	var/obj/item/projectile/beam/lightning/lightning = new(src)
	lightning.power = power
	lightning.launch(target)
	visible_message("<span class='danger'>\The [src] strikes \the [target] with lightning!</span>")