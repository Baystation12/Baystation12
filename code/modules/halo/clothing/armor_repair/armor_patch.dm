#define ITEM_REPAIR_DELAY 10 SECONDS

/obj/item/weapon/armor_patch
	name ="\improper Armor Repair Kit"
	desc ="A small, simple, limited-use kit that allows armor to be patched up, restoring a portion of the protection it usually affords."
	icon = 'code/modules/halo/clothing/armor_repair/armor_repair_sprites.dmi'
	icon_state = "armor_patch"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT | SLOT_POCKET
	var/repair_supplies = 10 //The amount of armor damage this patch can repair

/obj/item/weapon/armor_patch/examine(var/mob/examiner)
	. = ..()
	var/supply_percentile = repair_supplies / initial(repair_supplies)
	var/message = "all its repair supplies"
	if(supply_percentile < initial(repair_supplies))
		message = "most of its repair supplies"
	if(supply_percentile < 0.5)
		message = "around half its repair supplies"
	if(supply_percentile < 0.25)
		message = "barely any repair supplies"
	to_chat(examiner,"<span class = 'notice'>[name] has [message] left.</span>")

/obj/item/weapon/armor_patch/attack(mob/living/M, mob/living/user, var/target_zone)
	var/mob/living/carbon/human/h = user
	if(istype(h) && user.a_intent == "help" && !isnull(h.wear_suit))
		repair_clothing(h.wear_suit)
	else
		. = ..()

/obj/item/weapon/armor_patch/resolve_attackby(atom/A, mob/user, var/click_params)
	if(istype(A,/obj/item/clothing))
		add_fingerprint(user)
		repair_clothing(A,user)
	else
		. = ..()

/obj/item/weapon/armor_patch/proc/repair_clothing(var/obj/item/clothing/c,var/mob/user)
	var/armor_damage_taken = initial(c.armor_thickness) - c.armor_thickness
	if(armor_damage_taken == 0)
		to_chat(user,"<span class = 'notice'>[c] isn't damaged or has no armor to repair</span>")
		return

	user.visible_message("<span class = 'notice'>[user] starts to patch up damage to [c].</span>")
	if(!do_after(user,ITEM_REPAIR_DELAY,c,1,1,,1))
		return

	user.visible_message("<span class = 'notice'>[user] patches up damage on [c]</span>")
	if(armor_damage_taken > repair_supplies)
		to_chat(user,"<span class = 'notice'>You can't repair all the damage on [c] due to a lack of repair supplies in [name]</span>")
		c.armor_thickness += repair_supplies
		repair_supplies = 0

	else
		to_chat(user,"<span class = 'notice'>You fully repair [c].</span>")
		c.armor_thickness = initial(c.armor_thickness)
		repair_supplies -= armor_damage_taken

	c.update_damage_description()
	if(repair_supplies == 0)
		var/mob/living/carbon/human/h = user
		if(istype(h))
			h.drop_from_inventory(src)
		to_chat(user,"<span class = 'notice'>[src] is empty, so you dispose of it.</span>")
		qdel(src)

/obj/item/weapon/armor_patch/cov
	icon_state = "armor_patch_cov"