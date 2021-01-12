
/obj/item/weapon/material/knife/combat_knife
	name = "\improper combat knife"
	desc = "Multipurpose knife for utility use and close quarters combat"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Knife"
	item_state = "butterflyknife_open"
	w_class = ITEM_SIZE_SMALL
	force = 30
	throwforce = 10
	sharp = 1
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	armor_penetration = 70

	executions_allowed = TRUE
	start_execute_messages = list(BP_CHEST = "\The USER steps on \the VICTIM and brandishes \the WEAPON!", BP_HEAD = "\The USER grips \the VICTIM's shoulder and brandishes \the WEAPON!")
	finish_execute_messages = list(BP_CHEST = "\The USER guts VICTIM with \the WEAPON!", BP_HEAD = "\The USER slices clean through \the VICTIM's neck with \the WEAPON!")

/obj/item/weapon/material/machete
	name = "\improper machete"
	desc = "A standard issue machete used for hacking things apart. It is very sharp "
	icon= 'code/modules/halo/weapons/icons/machete.dmi'
	icon_state = "machete_obj"
	item_state = "machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	armor_penetration = 70


	w_class = ITEM_SIZE_LARGE
	force_divisor = 0.67
	thrown_force_divisor = 0.6
	slot_flags = SLOT_BELT | SLOT_BACK
	sharp = 1
	edge = 1
	unbreakable = 1
	attack_verb = list("chopped", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	unacidable = 1
	lunge_dist = 2

	executions_allowed = TRUE
	start_execute_messages = list(BP_CHEST = "\The USER steps on \the VICTIM and brandishes \the WEAPON!", BP_HEAD = "\The USER grips \the VICTIM's shoulder and brandishes \the WEAPON!")
	finish_execute_messages = list(BP_CHEST = "\The USER guts VICTIM with \the WEAPON!", BP_HEAD = "\The USER slices clean through \the VICTIM's neck with \the WEAPON!")

/obj/item/weapon/material/machete/officersword
	name = "CO's Sword"
	desc = "A reinforced sword capable of safely parrying blows from energy weapons."
	icon_state = "COsword_obj"
	item_state = "machete"
	applies_material_colour = FALSE
	lunge_dist = 3

//Humbler Baton
/obj/item/weapon/melee/baton/humbler
	name = "humbler stun device"
	desc = "A retractable baton capable of inducing a large amount of pain via electrical shocks."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "humbler stun device"
	item_state = "telebaton_0"
	force = 15
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	stunforce = 0
	agonyforce = 60
	status = 0		//whether the thing is on or not
	hitcost = 10


/obj/item/weapon/melee/baton/humbler/New()
	. = ..()
	bcell = new/obj/item/weapon/cell/high(src)
	update_icon()
	return