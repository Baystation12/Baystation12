/*much like grab this item is used primarily for the utility it provides.
Basically: I can use it to target things where I click. I can then pass these targets to a spell and target things not using a list.
*/

/obj/item/magic_hand
	name = "Magic Hand"
	icon = 'icons/mob/screen1.dmi'
	flags = 0
	abstract = 1
	w_class = 5.0
	icon_state = "spell"
	var/next_spell_time = 0
	var/spell/hand/hand_spell

/obj/item/magic_hand/New(var/spell/hand/S)
	hand_spell = S
	name = "[S.hand_name] ([S.name])"
	icon = S.hand_icon
	icon_state = S.hand_state

/obj/item/magic_hand/attack(mob/living/M, mob/living/user, var/target_zone) //can't be used to actually bludgeon things
	afterattack(M,user)
	return 1

/obj/item/magic_hand/afterattack(atom/A, mob/living/user)
	if(!hand_spell) //no spell? Die.
		user.drop_from_inventory(src)
		return
	if(!hand_spell.valid_target(A,user))
		return
	if(world.time < next_spell_time)
		user << "<span class='warning'>[hand_spell.not_ready_message]</span>"
		return
	if(user.a_intent == I_HELP)
		user << "<span class='notice'>[hand_spell.intent_help_message]</span>"
		return

	if(!hand_spell.take_hand_charge(user, src))
		user.drop_from_inventory(src)
		return
	if(hand_spell.cast_hand(A,user,src))
		if(!hand_spell) //in case cast_hand deletes it
			return
		next_spell_time = world.time + hand_spell.spell_delay
		if(hand_spell.move_delay)
			user.setMoveCooldown(hand_spell.move_delay)
		if(hand_spell.click_delay)
			user.setClickCooldown(hand_spell.move_delay)

/obj/item/magic_hand/throw_at(atom/target, range, speed, thrower) //no throwing pls
	src.afterattack(target,thrower)

/obj/item/magic_hand/dropped() //gets deleted on drop
	loc = null
	qdel(src)

/obj/item/magic_hand/Destroy() //better save than sorry.
	hand_spell = null
	..()