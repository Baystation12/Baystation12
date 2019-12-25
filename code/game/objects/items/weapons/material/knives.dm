//knives for stabbing and slashing and so on and so forth
/obj/item/weapon/material/knife //master obj
	name = "the concept of a knife"
	desc = "You call that a knife? This is a master item - berate the admin or mapper who spawned this"
	icon = 'icons/obj/knife.dmi'
	icon_state = "knife"
	item_state = "knife"
	max_force = 15
	force_divisor = 0.3
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	matter = list(MATERIAL_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	unbreakable = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = TRUE
	edge = TRUE
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES

/obj/item/weapon/material/knife/attack(mob/living/carbon/M, mob/living/carbon/user, target_zone)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M, user)

	return ..()

//table knives
/obj/item/weapon/material/knife/table
	name = "table knife"
	desc = "A simple table knife, used to cut up individual portions of food."
	icon_state = "table"
	default_material = MATERIAL_ALUMINIUM
	max_force = 7
	force_divisor = 0.1
	sharp = FALSE
	attack_verb = list("prodded")
	applies_material_name = FALSE
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/material/knife/table/plastic
	default_material = MATERIAL_PLASTIC

/obj/item/weapon/material/knife/table/unathi
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon_state = "unathiknife"
	default_material = MATERIAL_WOOD
	applies_material_colour = FALSE
	w_class = ITEM_SIZE_NORMAL

//kitchen knives
/obj/item/weapon/material/knife/kitchen
	name = "kitchen knife"
	icon_state = "kitchenknife"
	desc = "A general purpose chef's knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	applies_material_name = FALSE

/obj/item/weapon/material/knife/kitchen/cleaver
	name = "butcher's cleaver"
	desc = "A heavy blade used to process food, especially animal carcasses."
	icon_state = "butch"
	armor_penetration = 5
	force_divisor = 0.18
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/material/knife/kitchen/cleaver/bronze
	name = "master chef's cleaver"
	desc = "A heavy blade used to process food. This one is so fancy, it must be for a truly exceptional chef. There aren't any here, so what it's doing here is anyone's guess."
	default_material = MATERIAL_BRONZE
	force_divisor = 1 //25 with material bronze

//fighting knives
/obj/item/weapon/material/knife/combat
	name = "combat knife"
	desc = "A blade with a saw-like pattern on the reverse edge and a heavy handle."
	icon_state = "tacknife"
	force_divisor = 0.2
	w_class = ITEM_SIZE_SMALL

//random stuff
/obj/item/weapon/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"
	item_state = "hook_knife"
	sharp = FALSE

/obj/item/weapon/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = FALSE
	applies_material_name = FALSE