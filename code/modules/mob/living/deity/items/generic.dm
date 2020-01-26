/datum/deity_item/boon
	var/boon_path

/datum/deity_item/boon/buy(var/mob/living/deity/D)
	..()
	if(boon_path)
		. = new boon_path()
		D.set_boon(.)

/datum/deity_item/phenomena
	var/phenomena_path
	max_level = 1

/datum/deity_item/phenomena/buy(var/mob/living/deity/D)
	..()
	if(level == 1 && phenomena_path)
		D.add_phenomena(phenomena_path)
		D.update_phenomenas()

/datum/deity_item/boon/single_charge/buy(var/mob/living/deity/D)
	. = ..()
	if(istype(.,/spell))
		var/spell/S = .
		S.charge_counter = S.charge_max
		S.charge_type = Sp_CHARGES