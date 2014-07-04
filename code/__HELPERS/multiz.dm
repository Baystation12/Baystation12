/proc/get_dir_3d(var/atom/ref, var/atom/target)
	if (get_turf(ref) == get_turf(target))
		return 0
	return get_dir(ref, target) | (target.z > ref.z ? UP : 0) | (target.z < ref.z ? DOWN : 0)

/proc/get_dist_3d(var/atom/ref, var/atom/trg)
	return max(abs(trg.x - ref.x), abs(trg.y - ref.y), abs(trg.z - ref.z))
