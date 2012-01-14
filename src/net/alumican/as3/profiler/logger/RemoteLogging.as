package net.alumican.as3.profiler.logger
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	/**
	 * ログを任意のサーバーに転送するロギングクラス. 
	 * <p>
	 * サーバー側で、POSTパラメータlogでログ文字列を受け取るスクリプトを用意する必要があります
	 * </p>
	 * 
	 * @access    public
	 * @package   ken39arg.logging
	 * @author    K.Araga
	 * @varsion   $id : RemoteLogging.as, v 1.0 2008/02/15 K.Araga Exp $
	 */
	public class RemoteLogging implements ILogging
	{
		private var _url:String;
		
		public function RemoteLogging(url:String):void
		{
			_url = url;
		}
		
		public function put(string:String, level:int = 0):void
		{
			var request:URLRequest = new URLRequest(_url);
			var valiable:URLVariables = new URLVariables();
			valiable.log = string;
			request.data = valiable;
			request.method = URLRequestMethod.POST;
			
			try
			{
				sendToURL(request);
			}
			catch(e:SecurityError) { }
		}
	}
}