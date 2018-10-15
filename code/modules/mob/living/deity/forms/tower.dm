/datum/god_form/wizard
	name = "The Tower"
	info = {"Only from destruction does the Tower grow. Its bricks smelted from crumbled ignorance and the fires of ambition.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Learn spells from two different schools.<br>
		+Deity gains power through each spell use.</font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>-Abilities hold a limited amount of charge and must be charged at a fountain of power.</font>
	"}
	desc = "A single solitary tower"
	god_icon_state = "tower"
	pylon_icon_state = "nim"

	buildables = list(/obj/structure/deity/altar/tower,
					/obj/structure/deity/pylon,
					/obj/structure/deity/wizard_recharger
					)
	items = list(/datum/deity_item/general/potential,
				/datum/deity_item/general/regeneration,
				/datum/deity_item/conjuration,
				/datum/deity_item/boon/single_charge/create_air,
				/datum/deity_item/boon/single_charge/acid_spray,
				/datum/deity_item/boon/single_charge/force_wall,
				/datum/deity_item/phenomena/dimensional_locker,
				/datum/deity_item/boon/single_charge/faithful_hound,
				/datum/deity_item/wizard_armaments,
				/datum/deity_item/boon/single_charge/sword,
				/datum/deity_item/boon/single_charge/shield,
				/datum/deity_item/phenomena/portals,
				/datum/deity_item/boon/single_charge/fireball,
				/datum/deity_item/boon/single_charge/force_portal,
				/datum/deity_item/phenomena/banishing_smite,
				/datum/deity_item/transmutation,
				/datum/deity_item/boon/single_charge/slippery_surface,
				/datum/deity_item/boon/single_charge/smoke,
				/datum/deity_item/boon/single_charge/knock,
				/datum/deity_item/boon/single_charge/burning_grip,
				/datum/deity_item/phenomena/warp_body,
				/datum/deity_item/boon/single_charge/jaunt,
				/datum/deity_item/healing_spells,
				/datum/deity_item/boon/single_charge/heal,
				/datum/deity_item/boon/single_charge/heal/major,
				/datum/deity_item/boon/single_charge/heal/area,
				/datum/deity_item/phenomena/rock_form
				)

/datum/god_form/wizard/take_charge(var/mob/living/user, var/charge)
	linked_god.adjust_power_min(max(round(charge/100), 1),silent = 1)
	return 1