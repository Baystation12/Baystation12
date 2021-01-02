


/* CLOTHING */

/obj/item/clothing
	var/armor_thickness = 20 //The thickness of the armor, in mm. Keep null to opt-out usage of system for item. This value, set at compile time is the maximum value of thickness for this item. Armor can only lose 10% of this value per-hit.
	var/armor_thickness_max = 20
	var/list/armor_thickness_modifiers = list()//A list containing the weaknesses of the armor, used when performing armor-thickness depletion. Format: damage_type - multiplier
	var/dam_desc = ""
	var/next_warning_time = 0

#define WARNING_DELAY 2 SECONDS

/obj/item/clothing/proc/degrade_armor_thickness(var/damage,var/damage_type)
	damage /= 10
	var/thickness_dam_cap = ARMOUR_THICKNESS_DAMAGE_CAP
	if(damage_type in armor_thickness_modifiers)
		thickness_dam_cap /= armor_thickness_modifiers[damage_type]

	var/new_thickness = round(armor_thickness - min(damage,thickness_dam_cap))
	new_thickness = max(0, new_thickness)
	armor_thickness = new_thickness
	update_damage_description()

	var/mob/user = src.loc
	if(istype(user))
		if(new_thickness < 0)
			to_chat(user, "<span class = 'warning'>Your [name]'s armor plating is [damage_type == BURN ? "melted away" : "destroyed"]! </span>")

		else if(istype(user) && world.time >= next_warning_time)
			next_warning_time = world.time + WARNING_DELAY
			to_chat(user, "<span class = 'warning'>Your [name]'s armor plating is [damage_type == BURN ? "scorched" : "damaged"]! </span>")

/obj/item/clothing/proc/update_damage_description(var/damage_type = BRUTE)
	var/desc_addition_to_apply = " "
	if(armor_thickness < initial(armor_thickness) * 0.75)
		desc_addition_to_apply = "<span class = 'warning'> It is [damage_type == BURN ? "slightly scorched" : "partially damaged"].</span>"
	if(armor_thickness < initial(armor_thickness) * 0.5)
		desc_addition_to_apply = "<span class = 'warning'> It is [damage_type == BURN ? "half-melted" : "scarred and cracked"].</span>"
	if(armor_thickness < initial(armor_thickness) * 0.25)
		desc_addition_to_apply = "<span class = 'warning'> It is [damage_type == BURN ? "mostly melted" : "scarred and shattered"].</span>"
	if(armor_thickness <= 0)
		desc_addition_to_apply = "<span class = 'warning'> It has [damage_type == BURN ? "melted away" : "become scarred and deformed"].</span>"
	dam_desc = desc_addition_to_apply
