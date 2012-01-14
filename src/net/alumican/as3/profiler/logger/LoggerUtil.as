package net.alumican.as3.profiler.logger
{
	/**
	 * LoggerUtil
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class LoggerUtil 
	{
		static public var group:uint = 0x0001;
		
		static public function setup(
			debug:Boolean = true,
			level:int     = 0,
			group:uint    = 0x0001,
			filter:uint   = 0x0001
		):void
		{
			if (debug)
			{
				Logger.logging = new TraceLogging();
				Logger.filter  = filter;
				Logger.level   = level;
			}
			else
			{
				Logger.logging = new NullLogging();
				Logger.filter  = 0x0;
				Logger.level   = int.MAX_VALUE;
			}
			LoggerUtil.group = group;
		}
		
		/**
		 * 初期化時のログ出力
		 */
		static public function set init(m:*):void
		{
			Logger.info("initialize : " + String(m), group);
		}
		
		/**
		 * 終了時のログ出力
		 */
		static public function set fin(m:*):void
		{
			Logger.info("finalize : " + String(m), group);
		}
		
		/**
		 * リサイズ時のログ出力
		 */
		static public function set resize(m:*):void
		{
			Logger.info("resize   : " + String(m), group);
		}
		
		/**
		 * エラー時のログ出力
		 */
		static public function error(e:Error, m:* = null):void
		{
			Logger.error((m ? (String(m) + "\n") : "") + "name = " + e.name + ", stacktrace = " + e.getStackTrace + ", message = " + e.message, group);
		}
	}
}