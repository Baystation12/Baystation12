
GLOBAL_LIST_INIT(first_names_kig_yar, world.file2list('code/modules/halo/species_items/first_kig-yar.txt'))

/mob/living/carbon/human/covenant/kigyar/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	..(new_loc,"Kig-Yar")							//Code breaks if not placed in species folder,
	name = pick(GLOB.first_names_kig_yar)
	real_name = name
	faction = "Covenant"

/obj/item/clothing/head/helmet/kigyar
	name = "Kig-Yar Scout Helmet"
	desc = "A Kig-Yar scout helmet with inbuilt night vision."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "scouthelm"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi')
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	species_restricted = list("Kig-Yar")
	action_button_name = "Toggle Night Vision"
	var/linked_glasses
	var/mob/living/carbon/human/u

/obj/item/clothing/head/helmet/kigyar/proc/try_equip_NV()
	if(u.equip_to_slot_if_possible(new /obj/item/clothing/glasses/kigyarNV,slot_glasses))
		linked_glasses = u.glasses
		to_chat(u,"<span class ='notice'>Night Vision active.</span>")
	else
		to_chat(u,"<span class='notice'>NV activation error. Eyes Blocked.</span>")

/obj/item/clothing/head/helmet/kigyar/equipped(mob/user)
	u = user

/obj/item/clothing/head/helmet/kigyar/dropped()
	del(linked_glasses)
	..()

/obj/item/clothing/head/helmet/kigyar/ui_action_click()
	if(u.head != src)
		return
	if(!linked_glasses)
		try_equip_NV()
	else
		del(linked_glasses)
		to_chat(u,"<span class = 'notice'>Night Vision deactivated.</span>")

/obj/item/clothing/glasses/kigyarNV
	name = "Kig-Yar Scout Helmet Night Vision"
	desc = "Scout Helmet night vision active."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "inbuilt_nv"
	icon_override = ""//So nothing appears on the glasses layer.
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	canremove = 0

/obj/item/clothing/under/covenant/kigyar
	name = "Kig-Yar Body-Suit"
	desc = "A Kig-Yar body suit. Meant to be worn underneath a combat harness"
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "jackal_bodysuit_s"
	worn_state = "jackal_bodysuit"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi')
	species_restricted = list("Kig-Yar")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/covenant/kigyar/armless
	icon_state = "jackal_bodysuit_armless_s"
	worn_state = "jackal_bodysuit_armless"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/armor/covenant/kigyar
	name = "Kig-Yar Combat Harness"
	desc = "A protective harness for use during combat."
	icon = 'code/modules/halo/icons/species/jackalclothing.dmi'
	icon_state = "scout"
	item_state = "scout"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/icons/species/jackalclothing.dmi')
	species_restricted = list("Kig-Yar")
	armor = list(melee = 75, bullet = 65, laser = 20, energy = 20, bomb = 40, bio = 25, rad = 20)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/organ/external/arm/hollow_bones
	min_broken_damage = 20 //Needs 10 less damage to break

/obj/item/organ/external/arm/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/leg/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/leg/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/hand/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/hand/right/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/foot/hollow_bones
	min_broken_damage = 20

/obj/item/organ/external/foot/right/hollow_bones
	min_broken_damage = 20