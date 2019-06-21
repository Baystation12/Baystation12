proc
	hypot(x, y)
		if(x || y)
			var t
			x = abs(x)
			y = abs(y)
			if(x <= y)
				t = x
				x = y
			else
				t = y
			t /= x
			return x * sqrt(1 + t * t)
		return 0
