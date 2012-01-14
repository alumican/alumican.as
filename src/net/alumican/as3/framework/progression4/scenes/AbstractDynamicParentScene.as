package net.alumican.as3.framework.progression4.scenes
{
	import jp.progression.events.SceneEvent;
	import jp.progression.scenes.getSceneBySceneId;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * AbstractDynamicParentScene
	 * 
	 * @author alumican
	 */
	public class AbstractDynamicParentScene extends SceneObject
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 表示中のシーン
		 */
		public function get newChildScene():SceneObject { return _newChildScene; }
		public function get oldChildScene():SceneObject { return _oldChildScene; }
		private var _newChildScene:SceneObject;
		private var _oldChildScene:SceneObject;
		
		/**
		 * 動的に生成するシーンオブジェクトのクラス
		 */
		public function get childSceneClass():Class { return _childSceneClass; }
		public function set childSceneClass(value:Class):void { _childSceneClass = (value == null) ? SceneObject : value; }
		private var _childSceneClass:Class;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function AbstractDynamicParentScene(name:String = null, initObject:Object = null):void 
		{
			super(name, initObject);
			_newChildScene = null;
			_oldChildScene = null;
			_childSceneClass = SceneObject;
		}
		
		
		
		
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void
		{
			var isSceneIdEqualsToDestinedScene:Boolean = sceneId.equals(manager.destinedSceneId);
			if (sceneId.contains(manager.destinedSceneId) && !isSceneIdEqualsToDestinedScene)
			{
				//子シーンへ向かう場合
				atSceneDestinedForChild();
			}
			else if (isSceneIdEqualsToDestinedScene)
			{
				//自身のシーンが到達点だった場合
				atSceneDestinedForSelf();
			}
			
			//非同期処理
			addCommand(
			);
		}
		
		/**
		 * atSceneLoad 呼び出し時に、目的地となるシーンが子階層だった場合に呼び出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		protected function atSceneDestinedForChild():void
		{
			//遷移先のシーンを動的に生成する
			addDynamicDestinedScene(_childSceneClass);
			
			//非同期処理
			addCommand(
			);
		}
		
		/**
		 * atSceneLoad 呼び出し時に、目的地となるシーンがシーンオブジェクト自身だった場合に呼び出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		protected function atSceneDestinedForSelf():void
		{
			//非同期処理
			addCommand(
			);
		}
		
		
		
		
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void
		{
			//非同期処理
			addCommand(
			);
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void
		{
			//非同期処理
			addCommand(
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			//子シーンが存在しているなら削除する
			_removeOldScene();
			_oldChildScene = null;
			_newChildScene = null;
			
			//非同期処理
			addCommand(
			);
		}
		
		/**
		 * 先回りしてシーンを動的に生成する
		 */
		protected function addDynamicDestinedScene(sceneClass:Class):void
		{
			//遷移先の取得
			var destinedSceneIdString:String = manager.destinedSceneId.toString();
			var destinedScenePath:Array      = destinedSceneIdString.split("/");
		//	var destinedSceneName:String     = destinedScenePath[destinedScenePath.length - 1];
			
			//----------------------------------------
			//一気に孫シーンまで飛ばないように、自身の子シーンへのパスを取得する
			var path:String = "/" + destinedScenePath[0];
			for (var i:int = 1; i < destinedScenePath.length; ++i)
			{
				path += destinedScenePath[i] + "/";
				var sceneId:SceneId   = new SceneId(path);
				var scene:SceneObject = getSceneBySceneId(sceneId);
				if (!scene) break;
			}
			var destinedSceneName:String = destinedScenePath[i];
			//----------------------------------------
			
			//遷移先のシーンを動的に生成
			_newChildScene = new sceneClass(destinedSceneName) as SceneObject;
			_newChildScene.addEventListener(SceneEvent.SCENE_LOAD, _childSceneLoadCompleteHandler);
			_newChildScene.addEventListener(SceneEvent.SCENE_UNLOAD, _childSceneUnloadCompleteHandler);
			addScene(_newChildScene);
		}
		
		/**
		 * 前のシーンを削除する
		 */
		private function _removeOldScene():void
		{
			if (_oldChildScene && contains(_oldChildScene))
			{
				_oldChildScene.removeEventListener(SceneEvent.SCENE_LOAD, _childSceneLoadCompleteHandler);
				_oldChildScene.removeEventListener(SceneEvent.SCENE_UNLOAD, _childSceneUnloadCompleteHandler);
				removeScene(_oldChildScene);
			}
		}
		
		/**
		 * 子シーンのload完了ハンドラ
		 * @param	e
		 */
		private function _childSceneLoadCompleteHandler(e:SceneEvent):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			//前のシーンが存在しているなら削除する
			_removeOldScene();
			_oldChildScene = _newChildScene;
		}
		
		/**
		 * 子シーンのunload完了ハンドラ
		 * @param	e
		 */
		private function _childSceneUnloadCompleteHandler(e:SceneEvent):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			var isSceneIdEqualsToDestinedScene:Boolean = sceneId.equals(manager.destinedSceneId);
			if (sceneId.contains(manager.destinedSceneId) && !isSceneIdEqualsToDestinedScene)
			{
				//子シーンから別の子シーンへ向かう場合
				atSceneDestinedForChild();
			}
			else if (isSceneIdEqualsToDestinedScene)
			{
				//自身のシーンが到達点だった場合
				atSceneDestinedForCurrent();
			}
		}
	}
}