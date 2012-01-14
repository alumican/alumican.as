package net.alumican.as3.external
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.Capabilities;
	
	/**
	 * ポップアップウィンドウ関連をまとめたクラス
	 * 
	 * @author alumican.net
	 */
	public class PopupNavigator
	{
		/**
		 * ポップアップウィンドウを開きます
		 * Safariではポップアップブロック回避のため新規ウィンドウで開きます
		 * 
		 * @param	url	リンク先URL
		 * @param	params	window.open実行時のパラメータ
		 * @return	ポップアップウィンドウが理論上開けられたらtrue、失敗した場合はfalse
		 * 
		 * この関数は以下を参考に作られています
		 * @see	http://feb19.jp/blog/archives/000172.php
		 */
		static public function open(url:String, params:Object = null):Boolean
		{
			//ムービープレビュー時やスタンドアローンで再生されている場合は新規ウィンドウで開く
			if (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone")
			{
				navigateToURL(new URLRequest(url), "_blank");
				return false;
			}
			
			/*
			//インターネット上で動いていない場合は新規ウィンドウで開く
			if (Security.sandboxType != Security.REMOTE)
			{
				navigateToURL(new URLRequest(url), "_blank");
				return false;
			}
			*/
			
			//ExternalInterfaceが使用可能でない場合は新規ウィンドウで開く
			if (!ExternalInterface.available)
			{
				navigateToURL(new URLRequest(url), "_blank");
				return false;
			}
			
			//ブラウザがSafariの場合は新規ウィンドウで開く
			if (String(ExternalInterface.call("function getBrowser(){ return navigator.userAgent; }")).toLowerCase().indexOf("safari") != -1)
			{
				navigateToURL(new URLRequest(url), "_blank");
				return false;
			}
			
			//パラメータを文字列に変換する
			var paramsStr:String = "";
			if (params)
			{
				for (var name:String in params)
				{
					paramsStr += name + "=" + params[name] + ",";
				}
				if (paramsStr.length > 0)
				{
					paramsStr = paramsStr.substr(0, paramsStr.length - 1);
				}
			}
			
			//ポップアップで開く
			ExternalInterface.call("window.open", url, "_blank", paramsStr);
			return true;
		}
	}
}