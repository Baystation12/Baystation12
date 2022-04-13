/spell/hand/charges/blood_shard
	name = "Blood Shards"
	desc = "Invoke a corrupted projectile forward that causes an enemy's blood to fly out in painful shards."

	spell_flags = 0
	charge_max = 600
	invocation = "opens their hand, which bursts into vicious red light."
	invocation_type = SpI_EMOTE

	range = 7
	max_casts = 2
	compatible_targets = list(/atom)
	hud_state = "wiz_bshard"
	cast_sound = 'sound/magic/demon_attack1.ogg'

/spell/hand/charges/blood_shard/cast_hand(var/atom/A,var/mob/user)
	var/obj/item/projectile/blood_shard/B = new(get_turf(user))
	B.firer = user
	B.launch(A, BP_CHEST)
	user.visible_message("<span class='danger'>\The [user] shoots out a deep red shard from their hand!</span>")
	return ..()

/obj/item/projectile/blood_shard
	name = "bloodshard"
	damage = 25
	icon_state = "blood"
	damage_type = DAMAGE_BRUTE
	damage_flags = 0

/obj/item/projectile/blood_shard/on_hit(var/atom/movable/target, var/blocked = 0)
	if(..())
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			H.vessel.remove_reagent(/datum/reagent/blood, 30)
			H.visible_message("<span class='danger'>Tiny red shards burst from \the [H]'s skin!</span>")
			fragmentate(get_turf(src), 30, 5, list(/obj/item/projectile/bullet/pellet/blood))

/obj/item/projectile/bullet/pellet/blood
	name = "blood fragment"
	damage = 10
