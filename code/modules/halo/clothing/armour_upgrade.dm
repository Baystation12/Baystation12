
/obj/item/armour_upgrade
	name = "Blank armour patch"
	desc = "Unlikely to make a difference to your armour."
	icon = 'code/modules/halo/clothing/armour_upgrade.dmi'
	icon_state = "basic"

/obj/item/armour_upgrade/proc/attach(var/obj/item/clothing/suit/S)

	//override in children to provide effects

	if(S.patch)
		S.patch.unattach(S)

	//are we being held?
	var/mob/M = src.loc
	if(istype(M))
		M.drop_item()

	src.loc = S
	S.patch = src

/obj/item/armour_upgrade/proc/unattach(var/obj/item/clothing/suit/S)

	//override in children to provide effects

	if(S.patch == src)
		S.patch = null
		qdel(src)
	else
		to_debug_listeners("ARMOUR PATCH: [src.type] is attempting to unattach a different patch (null?) from [S.type]")

/obj/item/clothing/suit
	var/obj/item/armour_upgrade/patch

/obj/item/clothing/suit/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/armour_upgrade))
		var/proceed = TRUE
		if(patch)
			proceed = FALSE
			if(alert("Warning, [src] already has [patch] installed. Replace it?",\
				"Armour patch conflict","Replace","Cancel") == "Replace")
				proceed = TRUE

		if(proceed && do_after(user, 40))
			var/obj/item/armour_upgrade/P = I
			P.attach(src)
			user.visible_message(\
				"<span class='info'>[user] attaches an armour patch to their [src].</span>",\
				"<span class='info'>You attach [P] to the [src].</span>")
		return

	return ..()



/* SUBTYPES */

/obj/item/armour_upgrade/synthfibre
	name = "Synthfibre Armour Patch"
	desc = "Increased armour thickness for greater overall durability."

/obj/item/armour_upgrade/synthfibre/attach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor_thickness += 2
	S.armor_thickness_max += 2

/obj/item/armour_upgrade/synthfibre/unattach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor_thickness -= 2
	S.armor_thickness_max -= 2



/obj/item/armour_upgrade/diamond
	name = "Diamond Weave Patch"
	desc = "More resilient protection for reducing of incoming force."
	icon_state = "diamond"

/obj/item/armour_upgrade/diamond/attach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor["melee"] += 2
	S.armor["bullet"] += 2
	S.armor["bomb"] += 2

/obj/item/armour_upgrade/diamond/unattach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor["melee"] -= 2
	S.armor["bullet"] -= 2
	S.armor["bomb"] -= 2



/obj/item/armour_upgrade/ablative
	name = "Ablative Patch"
	desc = "Dispersal of energy allows for a reduction in heat and energy based attacks."
	icon_state = "ablative"

/obj/item/armour_upgrade/ablative/attach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor["laser"] += 2
	S.armor["energy"] += 2

/obj/item/armour_upgrade/ablative/unattach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor["laser"] -= 2
	S.armor["energy"] -= 2



/obj/item/armour_upgrade/nanolaminate
	name = "Nanolaminate Armour Patch"
	desc = "Increased armour thickness and resistance using advanced alien alloys."
	icon_state = "nanolaminate"

/obj/item/armour_upgrade/nanolaminate/attach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor_thickness += 2
	S.armor_thickness_max += 2
	for(var/entry in S.armor)
		S.armor[entry] += 2

/obj/item/armour_upgrade/nanolaminate/unattach(var/obj/item/clothing/suit/S)
	. = ..()
	S.armor_thickness -= 2
	S.armor_thickness_max -= 2
	for(var/entry in S.armor)
		S.armor[entry] -= 2
