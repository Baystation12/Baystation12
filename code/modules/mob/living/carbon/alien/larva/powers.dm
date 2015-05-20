/mob/living/carbon/alien/larva/proc/check_can_infest(var/mob/living/M)
	if(!src)
		return 0
	if(!istype(loc, /turf))
		src << "<span class='danger'>You cannot infest a target in your current position.</span>"
		return 0
	if(stat)
		src << "<span class='danger'>You cannot infest a target in your current state.</span>"
		return 0
	if(!M)
		return 0
	if(!M.lying)
		src << "<span class='danger'>\The [M] is not prone.</span>"
		return 0
	if(!(src.Adjacent(M)))
		src << "<span class='danger'>\The [M] is not in range.</span>"
		return 0
	return 1

/mob/living/carbon/alien/larva/verb/attach_host()

	set name = "Attach to host"
	set desc = "Burrow into a prone victim and begin drinking their blood."
	set category = "Abilities"

	if(!check_can_infest())
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		if(src.Adjacent(H) || !H.lying)
			choices += H

	if(!choices.len)
		src << "<span class='danger'>There are no viable hosts within range.</span>"
		return

	var/mob/living/carbon/human/H = input(src,"Who do you wish to infest?") in null|choices

	if(!H || !src || !H.lying) return

	if(!do_after(src,30))
		return

	if(!check_can_infest(H))
		return

	var/obj/item/weapon/holder/larva/holder = new (loc)
	src.loc = holder
	holder.name = src.name
	var/obj/item/organ/external/E = pick(H.organs)
	E.embed(holder,0,"\The [src] burrows deeply into \the [H]'s [E.name]!")