/turf/proc/turf_animation(var/anim_icon,var/anim_state,var/anim_x=0, var/anim_y=0, var/anim_layer=MOB_LAYER+1, var/anim_sound=null, var/anim_color=null)
	if(!c_animation)//spamming turf animations can have unintended effects, such as the overlays never disapearing. hence this check.
		if(anim_sound)
			playsound(src, anim_sound, 50, 1)
		c_animation = PoolOrNew(/atom/movable/overlay, src)
		c_animation.name = "turf_animation"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = anim_icon
		c_animation.icon_state = anim_state
		c_animation.layer = anim_layer
		c_animation.master = src
		c_animation.pixel_x = anim_x
		c_animation.pixel_y = anim_y
		if(anim_color)
			c_animation.color = anim_color
		flick("turf_animation",c_animation)
		spawn(10)
			if(c_animation)
				qdel(c_animation)
				c_animation = null

proc/anim(turf/location as turf,target as mob|obj,a_icon,a_icon_state as text,flick_anim as text,sleeptime = 0,direction as num)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	if(!location && target)
		location = get_turf(target)
	if(location && !target)
		target = location
	var/atom/movable/overlay/animation = PoolOrNew(/atom/movable/overlay, location)
	if(direction)
		animation.set_dir(direction)
	animation.icon = a_icon
	animation.layer = target:layer+1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = target
		flick(flick_anim, animation)
	spawn(max(sleeptime, 15))
		qdel(animation)
