package net.alumican.as3.profiler.logger
{
	import flash.external.ExternalInterface;
	
	public class FirebugLogging implements ILogging
	{
		public function put(string:String, level:int = 0):void
		{
			ExternalInterface.call('console.log', string);
		}
	}
}