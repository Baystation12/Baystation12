/*much like grab this item is used primarily for the utility it provides.
Basically: I can use it to target things where I click. I can then pass these targets to a spell and target things not using a list.
*/

/obj/item/magic_hand
	name = "Magic Hand"
	icon = 'icons/mob/screen1.dmi'
	flags = 0
	abstract = 1
	simulated = 0
	icon_state = "spell"
	var/next_spell_time = 0
	var/spell/hand/hand_spell

/obj/item/magic_hand/New(var/spell/hand/S)
	hand_spell = S
	name = "[name] ([S.name])"
	icon_state = S.hand_state

/obj/item/magic_hand/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/magic_hand/attack() //can't be used to actually bludgeon things
	return 1

/obj/item/magic_hand/afterattack(atom/A, mob/living/user)
	if(!hand_spell) //no spell? Die.
		user.drop_from_inventory(src)

	if(!hand_spell.valid_target(A,user))
		return
	if(world.time < next_spell_time)
		to_chat(user, "<span class='warning'>The spell isn't ready yet!</span>")
		return
	if(user.a_intent == I_HELP)
		to_chat(user, "<span class='notice'>You decide against casting this spell as your intent is set to help.</span>")
		return

	if(hand_spell.cast_hand(A,user))
		next_spell_time = world.time + hand_spell.spell_delay
		if(hand_spell.move_delay)
			user.setMoveCooldown(hand_spell.move_delay)
		if(hand_spell.click_delay)
			user.setClickCooldown(hand_spell.move_delay)
	else
		user.drop_from_inventory(src)

/obj/item/magic_hand/throw_at() //no throwing pls
	usr.drop_from_inventory(src)

/obj/item/magic_hand/dropped() //gets deleted on drop
	..()
	loc = null
	qdel(src)

/obj/item/magic_hand/Destroy() //better save than sorry.
	hand_spell = null
	..()