/*A god form basically is a combination of a sprite sheet choice and a gameplay choice.
Each plays slightly different and has different challenges/benefits
*/

/datum/god_form
	var/name = "Form"
	var/info = "This is a form your being can take."
	var/desc = "This is the mob's description given."
	var/faction = "neutral" //For stuff like mobs and shit
	var/god_icon_state = "nar-sie" //What you look like
	var/pylon_icon_state //What image shows up when appearing in a pylon
	var/mob/living/deity/linked_god = null
	var/starting_power_min = 10
	var/starting_regeneration = 1
	var/list/buildables = list() //Both a list of var changes and a list of buildables.
	var/list/icon_states = list()
	var/list/items

/datum/god_form/New(var/mob/living/deity/D)
	..()
	D.icon_state = god_icon_state
	D.desc = desc
	D.power_min = starting_power_min
	D.power_per_regen = starting_regeneration
	linked_god = D
	if(items && items.len)
		var/list/complete_items = list()
		for(var/l in items)
			var/datum/deity_item/di = new l()
			complete_items[di.name] = di
		D.set_items(complete_items)
		items.Cut()

/datum/god_form/proc/sync_structure(var/obj/O)
	var/list/svars = buildables[O.type]
	if(!svars)
		return
	for(var/V in svars)
		O.vars[V] = svars[V]

/datum/god_form/proc/take_charge(var/mob/living/user, var/charge)
	return 1

/datum/god_form/Destroy()
	if(linked_god)
		linked_god.form = null
		linked_god = null
	return ..()

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

	buildables = list(/obj/structure/deity/altar = list("name" = "altar",
														"desc" = "A small desk, covered in blood.",
														"icon_state" = "talismanaltar"),
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

/datum/god_form/wizard
	name = "The Tower"
	info = {"Only from destruction does the Tower grow. Its bricks smelted from crumbled ignorance and the fires of ambition.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Learn spells from two different schools.<br>
		+Deity gains power through each spell use.</font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>-Abilities hold a single charge and must be charged at a fountain of power.</font>
	"}
	desc = "A single solitary tower"
	god_icon_state = "tower"
	pylon_icon_state = "nim"

	buildables = list(/obj/structure/deity/altar = list("icon_state" = "tomealtar"),
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