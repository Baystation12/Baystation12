/datum/god_form/starlight
	name = "Starlight Herald"
	info = {"Sun and fire incarnate.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Ability to summon powerful minions via sacrifices.<br>
		+Bless one of your minions as a Herald, giving them species powers and armor.<br></font>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant's powers will burn them.<br>
		-You require copious amounts of power regeneration.</font>
	"}
	desc = "The bringer of life, and all that entails."
	god_icon_state = "sungod"
	pylon_icon_state = "god"
	faction = "herald"

	buildables = list(/obj/structure/deity/altar/starlight,
					/obj/structure/deity/pylon/starlight,
					/obj/structure/deity/radiant_statue,
					)
	items = list(/datum/deity_item/general/potential,
				/datum/deity_item/general/regeneration,
				/datum/deity_item/boon/blazing_blade,
				/datum/deity_item/boon/holy_beacon,
				/datum/deity_item/boon/black_death,
				/datum/deity_item/blood_crafting/firecrafting,
				/datum/deity_item/boon/starburst,
				/datum/deity_item/boon/exchange_wounds,
				/datum/deity_item/boon/radiant_aura,
				/datum/deity_item/boon/burning_touch,
				/datum/deity_item/boon/burning_grip,
				/datum/deity_item/boon/blood_boil,
				/datum/deity_item/boon/emp,
				/datum/deity_item/boon/cure_light,
				/datum/deity_item/phenomena/herald,
				/datum/deity_item/phenomena/wisp,
				/datum/deity_item/phenomena/flickering_whisper,
				/datum/deity_item/phenomena/burning_glare,
				/datum/deity_item/phenomena/open_gateway,
				/datum/deity_item/phenomena/divine_right
				)

/datum/god_form/starlight/take_charge(var/mob/living/user, var/charge)
	charge = max(5, charge/100)
	if(prob(charge))
		to_chat(user, "<span class='danger'>Your body burns!</span>")
	user.adjustFireLoss(charge)
	return 1