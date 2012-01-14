package net.alumican.as3.profiler.logger
{
	public class PararelLogging implements ILogging
	{
		private var _loggers:Array;
		
		public function PararelLogging(loggers:Array):void
		{
			_loggers = loggers;
		}
		
		public function put(string:String, level:int = 0):void
		{
			for each(var l:ILogging in _loggers)
			{
				l.put(string, level);
			}
		}
	}
}