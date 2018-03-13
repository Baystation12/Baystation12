
/obj/item/turret_deploy_kit
	name = "Turret Deploy Kit"
	desc = "Contains all the parts and single-use tools to construct a turret emplacement"

	w_class = ITEM_SIZE_HUGE
	slowdown_general = 4

	icon = 'code/modules/halo/weapons/turrets/deploy_kit_items.dmi'
	icon_state = "hmg_kit"
	item_state = "hmgkit"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/turrets/deploy_kit_inhands_l.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/turrets/deploy_kit_inhands_r.dmi',
		)

	var/obj/turret_contained = /obj/structure/turret
	var/deploy_time = 15 //The time it takes to deploy the turret, in seconds.

/obj/item/turret_deploy_kit/attack_self(var/mob/user)
	visible_message("<span class = 'danger'>[user] starts setting up a turret emplacement</span>")
	if(do_after(user,deploy_time SECONDS,src,1,1,,1))
		new turret_contained (user.loc)
		qdel(src)

/obj/item/turret_deploy_kit/HMG
	name = "Heavy Machine Gun Deploy Kit"

	icon_state = "hmg_kit"
	item_state = "hmgkit"

	turret_contained = /obj/structure/turret/HMG

/obj/item/turret_deploy_kit/chaingun
	name = "Chaingun Deploy Kit"

	icon_state = "chaingun_kit"
	item_state = "chaingunkit"

	turret_contained = /obj/structure/turret/chaingun