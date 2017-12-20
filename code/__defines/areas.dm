#define AreaUsage(channel, area,  tot) \
	tot = 0                  \
	switch(channel)          \
	{                        \
		if(LIGHT)            \
		{ \
			tot += area.used_light \
		} \
		if(EQUIP)             \
		{ \
			tot += area.used_equip \
		} \
		if(ENVIRON)           \
		{ \
			tot += area.used_environ \
		} \
		if(TOTAL) \
		{ \
			tot += area.used_light + area.used_equip + area.used_environ \
		} \
	}       \
	return tot \