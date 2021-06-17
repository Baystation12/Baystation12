/obj/item/contract
	name = "contract"
	desc = "written in the blood of some unfortunate fellow."
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "master_open"

	var/contract_master = null
	var/list/contract_spells = list(/spell/contract/reward,/spell/contract/punish,/spell/contract/return_master)

/obj/item/contract/attack_self(mob/user as mob)
	if(contract_master == null)
		to_chat(user, "<span class='notice'>You bind the contract to your soul, making you the recipient of whatever poor fool's soul that decides to contract with you.</span>")
		contract_master = user
		return

	if(contract_master == user)
		to_chat(user, "You can't contract with yourself!")
		return

	var/ans = alert(user,"The contract clearly states that signing this contract will bind your soul to \the [contract_master]. Are you sure you want to continue?","[src]","Yes","No")

	if(ans == "Yes")
		user.visible_message("\The [user] signs the contract, their body glowing a deep yellow.")
		if(!src.contract_effect(user))
			user.visible_message("\The [src] visibly rejects \the [user], erasing their signature from the line.")
			return
		user.visible_message("\The [src] disappears with a flash of light.")
		if(contract_spells.len && istype(contract_master,/mob/living)) //if it aint text its probably a mob or another user
			var/mob/living/M = contract_master
			for(var/spell_type in contract_spells)
				M.add_spell(new spell_type(user), "const_spell_ready")
		log_and_message_admins("signed their soul over to \the [contract_master] using \the [src].", user)
		qdel(src)

/obj/item/contract/proc/contract_effect(mob/user as mob)
	to_chat(user, "<span class='warning'>You've signed your soul over to \the [contract_master] and with that your unbreakable vow of servitude begins.</span>")
	return 1

/obj/item/contract/apprentice
	name = "apprentice wizarding contract"
	desc = "a wizarding school contract for those who want to sign their soul for a piece of the magic pie."
	color = "#993300"

/obj/item/contract/apprentice/contract_effect(mob/user as mob)
	if(user.mind.special_role == ANTAG_APPRENTICE)
		to_chat(user, "<span class='warning'>You are already a wizarding apprentice!</span>")
		return 0
	if(user.mind.special_role == ANTAG_SERVANT)
		to_chat(user, "<span class='notice'>You are a servant. You have no need of apprenticeship.</span>")
		return 0
	if(GLOB.wizards.add_antagonist_mind(user.mind,1,ANTAG_APPRENTICE,"<b>You are an apprentice! Your job is to learn the wizarding arts!</b>"))
		to_chat(user, "<span class='notice'>With the signing of this paper you agree to become \the [contract_master]'s apprentice in the art of wizardry.</span>")
		return 1
	return 0


/obj/item/contract/wizard //contracts that involve making a deal with the Wizard Acadamy (or NON PLAYERS)
	contract_master = "\improper Wizard Academy"

/obj/item/contract/wizard/xray
	name = "xray vision contract"
	desc = "This contract is almost see-through..."
	color = "#339900"

/obj/item/contract/wizard/xray/contract_effect(mob/user as mob)
	..()
	if (!(MUTATION_XRAY in user.mutations))
		user.mutations.Add(MUTATION_XRAY)
		user.set_sight(user.sight|SEE_MOBS|SEE_OBJS|SEE_TURFS)
		user.set_see_in_dark(8)
		user.set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
		to_chat(user, "<span class='notice'>The walls suddenly disappear.</span>")
		return 1
	return 0

/obj/item/contract/wizard/telepathy
	name = "telepathy contract"
	desc = "The edges of the contract grow blurry when you look away from them. To be fair, actually reading it gives you a headache."
	color = "#fcc605"

/obj/item/contract/wizard/telepathy/contract_effect(mob/user as mob)
	..()
	if (!ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user
	if (mRemotetalk in H.mutations)
		return 0
	H.mutations.Add(mRemotetalk)
	H.verbs += /mob/living/carbon/human/proc/remotesay
	to_chat(H, "<span class='notice'>You expand your mind outwards.</span>")
	return 1

/obj/item/contract/boon
	name = "boon contract"
	desc = "this contract grants you a boon for signing it."
	var/path

/obj/item/contract/boon/New(var/newloc, var/new_path)
	..(newloc)
	if(new_path)
		path = new_path
	var/item_name = ""
	if(ispath(path,/obj))
		var/obj/O = path
		item_name = initial(O.name)
	else if(ispath(path,/spell))
		var/spell/S = path
		item_name = initial(S.name)
	name = "[item_name] contract"

/obj/item/contract/boon/contract_effect(mob/user as mob)
	..()
	if(user.mind.special_role == ANTAG_SERVANT)
		to_chat(user, "<span class='warning'>As a servant you find yourself unable to use this contract.</span>")
		return 0
	if(ispath(path,/spell))
		user.add_spell(new path)
		return 1
	else if(ispath(path,/obj))
		new path(get_turf(user.loc))
		playsound(get_turf(usr),'sound/magic/charge.ogg',50,1)
		return 1

/obj/item/contract/boon/wizard
	contract_master = "\improper Wizard Academy"

/obj/item/contract/boon/wizard/artificer
	path = /spell/aoe_turf/conjure/construct
	desc = "This contract has a passage dedicated to an entity known as 'Nar-Sie'."

/obj/item/contract/boon/wizard/fireball
	path = /spell/targeted/projectile/dumbfire/fireball
	desc = "This contract feels warm to the touch."

/obj/item/contract/boon/wizard/smoke
	path = /spell/aoe_turf/smoke
	desc = "This contract smells as dank as they come."

/obj/item/contract/boon/wizard/forcewall
	path = /spell/aoe_turf/conjure/forcewall
	contract_master = "\improper Mime Federation"
	desc = "This contract has a dedication to mimes everywhere at the top."

/obj/item/contract/boon/wizard/knock
	path = /spell/aoe_turf/knock
	desc = "This contract is hard to hold still."

/obj/item/contract/boon/wizard/horsemask
	path = /spell/targeted/equip_item/horsemask
	desc = "This contract is more horse than your mind has room for."

/obj/item/contract/boon/wizard/charge
	path = /spell/aoe_turf/charge
	desc = "This contract is made of 100% post-consumer wizard."

