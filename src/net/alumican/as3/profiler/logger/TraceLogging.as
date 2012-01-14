package net.alumican.as3.profiler.logger
{
	public class TraceLogging implements ILogging
	{
		public function put(string:String, level:int = 0):void
		{
			trace(string);
		}
	}
}