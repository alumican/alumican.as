package net.alumican.as3.profiler.logger
{
	import flash.text.TextField;
	
	public class TextFieldLogging implements ILogging
	{
		public var field:TextField;
		
		public function TextFieldLogging(field:TextField = null):void
		{
			this.field = field;
		}
		
		public function put(string:String, level:int = 0):void
		{
			if (field != null)
			{
				field.appendText(string + "\n");
			}
		}
	}
}