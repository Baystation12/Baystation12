/datum/god_form/narsie
	name = "Nar-Sie"
	info = {"The Geometer of Blood, you crave blood and destruction.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Can gain power from blood sacrifices.<br>
		+Ability to forge weapons and armor.</font>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant abilities require copious amounts of their blood.</font>
	"}
	desc = "A being made of a million nightmares, a billion deaths."
	god_icon_state = "nar-sie"
	pylon_icon_state = "shade"
	faction = "cult"

	buildables = list(/obj/structure/deity/altar/narsie,
					/obj/structure/deity/pylon
					)
	items = list(/datum/deity_item/general/potential,
				/datum/deity_item/general/regeneration,
				/datum/deity_item/boon/eternal_darkness,
				/datum/deity_item/boon/torment,
				/datum/deity_item/boon/blood_shard,
				/datum/deity_item/boon/drain_blood,
				/datum/deity_item/phenomena/exhude_blood,
				/datum/deity_item/sacrifice,
				/datum/deity_item/boon/sac_dagger,
				/datum/deity_item/boon/sac_spell,
				/datum/deity_item/boon/execution_axe,
				/datum/deity_item/blood_stone,
				/datum/deity_item/minions,
				/datum/deity_item/boon/soul_shard,
				/datum/deity_item/boon/blood_zombie,
				/datum/deity_item/boon/tear_veil,
				/datum/deity_item/phenomena/hellscape,
				/datum/deity_item/blood_crafting,
				/datum/deity_item/blood_crafting/armored,
				/datum/deity_item/blood_crafting/space
				)

/datum/god_form/narsie/take_charge(var/mob/living/user, var/charge)
	charge = min(100, charge * 0.25)
	if(prob(charge))
		to_chat(user, "<span class='warning'>You feel drained...</span>")
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.should_have_organ(BP_HEART))
		H.vessel.remove_reagent(/datum/reagent/blood, charge)
	else
		user.adjustBruteLoss(charge)
	return 1