/proc/anim(atom/target, a_icon, a_icon_state, flick_anim, sleeptime = 0, direction as num)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	var/atom/movable/fake_overlay/animation = new /atom/movable/fake_overlay(target)
	if(direction)
		animation.set_dir(direction)
	animation.icon = a_icon
	animation.plane = target.plane
	animation.layer = target.layer + 0.1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		flick(flick_anim, animation)
	QDEL_IN(animation, max(sleeptime, 15))
