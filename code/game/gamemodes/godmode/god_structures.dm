/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	var/mob/living/deity/linked_god
	var/health = 10
	var/power_adjustment = 10 //How much power we get/lose
	var/build_cost = 0 //How much it costs to build this item.
	var/must_be_converted_turf = 1 //Whether we can only spawn this structure if it is near an altar.
	var/important_structure = 0 //Whether this structure is required to use certian spells/grant boons/etc
	density = 1
	anchored = 1
	icon_state = "tomealtar"

/obj/structure/deity/New(var/newloc, var/god)
	..(newloc)
	if(god)
		linked_god = god
		linked_god.form.sync_structure(src)
		linked_god.add_source(power_adjustment, src)

/obj/structure/deity/Destroy()
	if(linked_god)
		linked_god.add_source(-power_adjustment, src)
		linked_god = null
	return ..()

/obj/structure/deity/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 50, 1)
	user.visible_message(
		"<span class='danger'>[user] hits \the [src] with \the [W]!</span>",
		"<span class='danger'>You hit \the [src] with \the [W]!</span>",
		"<span class='danger'>You hear something breaking!</span>"
		)
	take_damage(W.force)

/obj/structure/deity/proc/take_damage(var/amount)
	health -= amount
	if(health < 0)
		src.visible_message("\The [src] crumbles!")
		qdel(src)

/obj/structure/deity/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)

/obj/structure/deity/proc/attack_deity(var/mob/living/deity/deity)
	return