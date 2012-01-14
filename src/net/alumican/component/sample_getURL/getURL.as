package{
	//必要なパッケージの読み込み
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class getURL extends MovieClip{
		protected var __url:String = "URL";
		protected var __target = "target";
		protected var __preTarget = "no";
		protected var __window = "_blank";
	
		//コンストラクタ関数
		public function getURL(){
			//初期化
			visible = false;
			super();
		}
		
		
		//コンポーネントインスペクタで変更可能な変数urlの定義-------------------------------------------
		[Inspectable(defaultValue="URL", name="URL")]
		public function get url():String{
			return __url;
		}
		
		public function set url(nVar:String):void{
			__url = nVar;
		}
		//-----------------------------------------------------------------------------------
		
		
		//コンポーネントインスペクタで変更可能な変数windowの定義---------------------------------------
		[Inspectable(defaultValue="_blank", name="target")]
		public function get window():String{
			return __window;
		}
		
		public function set window(nVar:String):void{
			__window = nVar;
		}
		//-----------------------------------------------------------------------------------
		
		//コンポーネントインスペクタで変更可能な変数targetBtの定義---------------------------------------
		[Inspectable(defaultValue="target", name=" Trigger Button Name")]
		public function get targetBt():String{
			return __target;
		}
	
		public function set targetBt(nVar:String):void{
			var MC:MovieClip = MovieClip(this.parent);
			
			if(__preTarget !== "no"){
				MC[__preTarget].removeEventListener(MouseEvent.CLICK , onClick);
			}
			
			//指定したインスタンスにリスナーを登録する
			__target = __preTarget = nVar;
			MC[__target].addEventListener(MouseEvent.CLICK , onClick);
			
		}
		//-----------------------------------------------------------------------------------
		
		
		//リスナー関数
		private function onClick(event:MouseEvent){
			
			//URLRequest
			var U:URLRequest = new URLRequest( __url);
			
			//指定先URLにリンク実行
			navigateToURL(U,__window);
			
		}
		
	
		
	}
}

