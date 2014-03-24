/*

Some math procs used by lighting, including ul's fastroot.

*/

var/list/fastroot = list(0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,
							5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
							7, 7)

proc/get_square_dist(Ax,Ay,Az,Bx,By,Bz)
	var/X = (Ax - Bx)
	var/Y = (Ay - By)
	var/Z = (Az - Bz)
	return (X * X + Y * Y + Z * Z)

proc/fsqrt(n)
	if (n > fastroot.len)
		//world << "Adding [n-fastroot.len] entries to root table."
		for(var/i = fastroot.len, i <= n, i++)
			fastroot += round(sqrt(i))
	return fastroot[n + 1]