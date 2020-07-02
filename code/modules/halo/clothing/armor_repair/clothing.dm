


/* CLOTHING */

/obj/item/clothing
	var/armor_thickness = 20 //The thickness of the armor, in mm. Keep null to opt-out usage of system for item. This value, set at compile time is the maximum value of thickness for this item. Armor can only lose 10% of this value per-hit.
	var/armor_thickness_max = 20
	var/list/armor_thickness_modifiers = list()//A list containing the weaknesses of the armor, used when performing armor-thickness depletion. Format: damage_type - multiplier
	var/dam_desc = ""

#define ARMOR_DESTROYED 1
#define ARMOR_DAMAGED 0

/obj/item/clothing/proc/degrade_armor_thickness(var/damage,var/damage_type)
	damage /= 10
	var/thickness_dam_cap = ARMOUR_THICKNESS_DAMAGE_CAP
	if(damage_type in armor_thickness_modifiers)
		thickness_dam_cap /= armor_thickness_modifiers[damage_type]
	var/new_thickness = (armor_thickness - min(damage,thickness_dam_cap))
	if(new_thickness < 0)
		armor_thickness = 0
		update_damage_description()
		return ARMOR_DESTROYED
	else
		armor_thickness = round(new_thickness)
		update_damage_description()
		return ARMOR_DAMAGED

#undef ARMOR_DESTROYED
#undef ARMOR_DAMAGED

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
