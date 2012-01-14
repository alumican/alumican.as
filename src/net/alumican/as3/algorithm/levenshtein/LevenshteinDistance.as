package net.alumican.as3.algorithm.levenshtein
{
	/**
	 * Levenshtein Distance
	 * @author Yukiya Okuda<alumican.net>
	 * @see http://www.merriampark.com/ld.htm
	 */
	public class LevenshteinDistance
	{
		/**
		 * Get Levenshtein Distance between a and b.
		 * @param	a	first string.
		 * @param	b	second string.
		 */
		static public function getDistance(a:String, b:String):int
		{
			var n:int = a.length,
				m:int = b.length;
			
			if (n == 0) return m;
			if (m == 0) return n;
			
			var table:Array = new Array(n + 1),
				i:int,
				j:int,
				c:String,
				d_0:int,
				d_1:int,
				d_2:int;
			
			for (i = 0; i <= n; ++i)
			{
				table[i] = new Array(m);
				table[i][0] = i;
			}
			for (j = 1; j <= m; ++j)
			{
				table[0][j] = j;
			}
			
			if (debugMode > 0)
			{
				debugLog = new Array();
				if (debugMode == 2) _log(table);
			}
			
			for (i = 1; i <= n; ++i)
			{
				c = a.charAt(i - 1);
				for (j = 1; j <= m; ++j)
				{
					d_0 = table[i - 1][j    ] + 1;
					d_1 = table[    i][j - 1] + 1;
					d_2 = table[i - 1][j - 1] + (c == b.charAt(j - 1) ? 0 : 1);
					if (d_1 < d_0) d_0 = d_1;
					if (d_2 < d_0) d_0 = d_2;
					table[i][j] = d_0;
					
					if (debugMode == 2) _log(table);
				}
			}
			if (debugMode == 1) _log(table);
			
			return table[n][m];
		}
		
		static private function _log(table:Array):void
		{
			var s:String = "",
				c:String,
				l:Array,
				n:int = table.length,
				m:int = table[0].length,
				i:int,
				j:int;
			for (i = 0; i < n; ++i)
			{
				l = table[i];
				for (j = 0; j < m; ++j)
				{
					c = l[j];
					s += (c == null ? "-" : c) + " ";
				}
				s += "\n";
			}
			debugLog.push(s);
			trace(s);
		}
		
		static public var debugMode:uint = 0;
		static public var debugLog:Array = new Array();
	}
}