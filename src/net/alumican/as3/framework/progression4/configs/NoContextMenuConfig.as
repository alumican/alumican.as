/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.1 Public Beta 1.4
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package net.alumican.as3.framework.progression4.configs { 
	import flash.system.Capabilities;
	import jp.nium.core.debug.Logger;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.IWebConfig;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.managers.WebHistoryManager;
	import jp.progression.core.managers.WebInitializer;
	import jp.progression.core.managers.WebSynchronizer;
	import jp.progression.core.proto.Configuration;
	import jp.progression.data.WebDataHolder;
	import jp.progression.executors.CommandExecutor;
	import jp.progression.ui.ContextMenuBuilder;
	import jp.progression.ui.ToolTip;
	import jp.progression.ui.WebContextMenuBuilder;
	import jp.progression.ui.WebKeyboardMapper;
	
	/**
	 * <span lang="ja">WebConfig クラスは、Progression を Web サイト制作に特化したモードで動作させるための環境設定クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.ActivatedLicenseType
	 * @see jp.progression.Progression#initialize()
	 * 
	 * @example <listing version="3.0">
	 * // WebConfig を作成する
	 * var config:WebConfig = new WebConfig();
	 * 
	 * // Progression を初期化する
	 * Progression.initialize( config );
	 * 
	 * // Progression インスタンスを作成する
	 * var manager:Progression = new Progression( "index", stage );
	 * </listing>
	 */
	public final class NoContextMenuConfig extends Configuration implements IWebConfig {
		
		/**
		 * <span lang="ja">SWFWheel を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get useSWFWheel():Boolean { return _useSWFWheel; }
		private var _useSWFWheel:Boolean = true;
		
		/**
		 * <span lang="ja">SWFSize を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get useSWFSize():Boolean { return _useSWFSize; }
		private var _useSWFSize:Boolean = true;
		
		/**
		 * <span lang="ja">HTML インジェクション機能を有効化するかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get useHTMLInjection():Boolean { return _useHTMLInjection; }
		private var _useHTMLInjection:Boolean = true;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WebConfig インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebConfig object.</span>
		 * 
		 * @param activatedLicenseType
		 * <span lang="ja">適用させたいライセンスの種類です。</span>
		 * <span lang="en"></span>
		 * @param useSWFWheel
		 * <span lang="ja">SWFWheel を有効化するかどうかです。</span>
		 * <span lang="en"></span>
		 * @param SWFSize
		 * <span lang="ja">SWFSize を有効化するかどうかです。</span>
		 * <span lang="en"></span>
		 * @param useHTMLInjection
		 * <span lang="ja">HTML インジェクション機能を有効化するかどうかです。</span>
		 * <span lang="en"></span>
		 * @param executor
		 * <span lang="ja">汎用的な処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param toolTipRenderer
		 * <span lang="ja">ツールチップ処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 */
		public function NoContextMenuConfig( activatedLicenseType:String = null, useSWFWheel:Boolean = true, useSWFSize:Boolean = true, useHTMLInjection:Boolean = false, executor:Class = null, toolTipRenderer:Class = null ) {
			// 引数を設定する
			_useSWFWheel = useSWFWheel;
			_useSWFSize = useSWFSize;
			_useHTMLInjection = useHTMLInjection;
			
			// 親クラスを初期化する
			super( activatedLicenseType, WebInitializer, WebSynchronizer, WebHistoryManager, executor || CommandExecutor, WebKeyboardMapper, ContextMenuBuilder, toolTipRenderer || ToolTip, WebDataHolder );
			
			// ライセンスを制限する
			switch( super.activatedLicenseType ) {
				case "GPL"				:
				case "PLL Basic"		:
				case "PLL Web"			:
				case "PLL Application"	: { break; }
				default					: { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_017 ).toString( super.className, super.activatedLicenseType ) ); }
			}
			
			// プレイヤーを判別する
			switch ( Capabilities.playerType ) {
				case "ActiveX"		:
				case "External"		:
				case "PlugIn"		:
				case "StandAlone"	: { break; }
				case "Desktop"		: { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_000 ).toString( super.className ) ); }
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, "activatedLicenseType", "useSWFWheel", "useSWFSize", "useHTMLInjection" );
		}
	}
}
