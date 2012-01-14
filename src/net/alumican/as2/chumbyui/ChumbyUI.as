/**
 * Chumby用にマウス入力, センサー取得などをまとめたクラスです. 
 * Singletonパターンで実装されています. 
 * ChumbyUI.instanceでインスタンスを受け取ってください. 
 * 
 * @author alumican<Yukiya Okuda>
 * @link http://alumican.net
 * @link http://www.libspark.org
 * 
 * //やること
 * TODO マウスジェスチャ機能の実装 @2008.12.02 22:57
 * TODO iPhoneライクなキーボード入力インターフェースの実装 @2008.12.02 22:57
 * TODO マウスジェスチャとボタンアクションの競合を防ぐためにボタンアクションをChumbyUIで管理する @2008.12.02 22:57
 * TODO スラッシュ動作の検出 @2008/12/03 1:35
 */
import mx.utils.Delegate;

class net.alumican.as2.chumbyui.ChumbyUI {
	
	/*============================================*//**
	 * 通常の加速度センサ
	 */
	public function get accelX1():Number { return _acceleration(2); }
	public function get accelY1():Number { return _acceleration(3); }
	public function get accelZ1():Number { return _acceleration(4); }
	public function get accel1():Array   { return [_acceleration(2), _acceleration(3), _acceleration(4)]; }
	
	/*============================================*//**
	 * 平均の加速度センサ
	 */
	public function get accelX2():Number { return _acceleration(5); }
	public function get accelY2():Number { return _acceleration(6); }
	public function get accelZ2():Number { return _acceleration(7); }
	public function get accel2():Array   { return [_acceleration(5), _acceleration(6), _acceleration(7)]; }
	
	/*============================================*//**
	 * 衝撃の加速度センサ
	 */
	public function get accelX3():Number { return _acceleration(8); }
	public function get accelY3():Number { return _acceleration(9); }
	public function get accelZ3():Number { return _acceleration(10); }
	public function get accel3():Array   { return [_acceleration(8), _acceleration(9), _acceleration(10)]; }
	
	/*============================================*//**
	 * 加速度センサ取得用のASnative関数
	 */
	private var _acceleration:Function;
	public function get acceleration():Function { return _acceleration; }
	
	/*============================================*//**
	 * 登録されているマウスジェスチャー情報
	 */
	private var _gesture:Object;
	private var _gesture_callback_list:Object;
	private var _gesture_callback_id:Number;
	
	/*============================================*//**
	 * 現在マウスジェスチャー中であればtrue
	 */
	private var _is_gesture:Boolean;
	public function get is_gesture():Boolean { return _is_gesture; }
	
	/*============================================*//**
	 * 登録されているボタンアクション情報
	 */
	private var _release:Object;
	private var _release_callback_list:Object;
	private var _release_callback_id:Number;
	
	/*============================================*//**
	 * インスタンスを取得する
	 */
	private static var _instance:ChumbyUI = new ChumbyUI();
	public static function get instance():ChumbyUI { return _instance; }
	
	/*============================================*//**
	 * コンストラクタ
	 */
	public function ChumbyUI() {
		
		//コンストラクタで生成不可とする
		if (_instance != null) {
			throw new Error("Error : ChumbyUI is Singleton.");
			return;
		}
		
		
		//============================================
		//
		// 加速度センサ
		//
		//============================================
		
		//加速度センサ取得用のASnative関数
		_acceleration = _global.ASnative(5, 60);
		
		
		//============================================
		//
		// マウスジェスチャー
		//
		//============================================
		
		//登録されているマウスジェスチャー情報
		_gesture = new Object();
		_gesture_callback_list = new Object();
		_gesture_callback_id = 0;
		
		//現在マウスジェスチャー中であればtrue
		_is_gesture = false;
		
		//マウスジェスチャー用マウスイベントの設定
		_setupMouseGesture();
		
		
		//============================================
		//
		// ボタンアクション
		//
		//============================================
		
		//登録されているボタンアクション情報
		_release = new Object();
		_release_callback_list = new Object();
		_release_callback_id = 0;
	}
	
	/*============================================*//**
	 * 新規マウスジェスチャーを登録する
	 * 
	 * @param	command:Array		ジェスチャーコマンド
	 * @param	callback:Function	ジェスチャー完成時に呼び出されるコールバック関数
	 * @return	id:Number			ジェスチャーの登録ID
	 */
	public function addGesture(command:String, callback:Function):Number {
		
		if (!_gesture.hasOwnProperty(command)) {
			_gesture[command] = new Object();
		}
		
		if (!_gesture.command.hasOwnProperty(callback)) {
			_gesture[command].callback   = new Object();
			_gesture[command].callback_n = 0;
		}
		
		++_gesture[command].callback_n;
		
		_gesture[command].callback[_gesture_callback_id] = callback;
		
		_gesture_callback_list[_gesture_callback_id] = {callback:callback, command:command};
		
		return _gesture_callback_id++;
	}
	
	/*============================================*//**
	 * マウスジェスチャーを解除する
	 * 
	 * @param	id:Number	ジェスチャーの登録ID
	 * @return	id:Number	登録削除されたジェスチャーの登録ID
	 */
	public function removeGestureById(id:Number):Number {
		
		var command:String = _gesture_callback_list[id].command;
		
		delete _gesture_callback_list[id];
		delete _gesture[command].callback[id];
		
		--_gesture[command].callback_n;
		
		if (_gesture[command].callback_n == 0) {
			delete _gesture[command];
		}
		
		return id;
	}
	
	/*============================================*//**
	 * マウスジェスチャーを解除する
	 * 
	 * @param	command:Array	ジェスチャーコマンド
	 * @return	id:Array		登録削除されたジェスチャーの登録IDの羅列
	 */
	public function removeGestureByCommand(command:Array):Array {
		
		var id_ary:Array = new Array();
		
		for (var id in _gesture[command].callback) {
			
			delete _gesture_callback_list[id];
			
			delete _gesture[command].callback;
			
			id_ary.push(Number(id));
		}
		
		delete _gesture[command];
		
		return id_ary;
	}
	
	/*============================================*//**
	 * マウスジェスチャー用マウスイベントの設定
	 */
	private function _setupMouseGesture():Void {
		
		//イベントリスナの登録
		var mouse_listener:Object = new Object();
		mouse_listener.onMouseDown = _startGesture;
		Mouse.addListener(mouse_listener);
		
		//ジェスチャートラッキング用変数
		var track:String;
		
		//直前の動作
		var recent:String;
		
		//マウスのぶれの許容範囲(pixel)
		var r:Number  = 20;
		var r2:Number = r * r;
		
		//ジェスチャーの中心座標
		var px:Number;
		var py:Number;
		
		//マウスジェスチャーの開始
		function _startGesture():Void {
			
			_is_gesture = true;
			
			//トラッキングのクリア
			track  = "";
			recent = "";
			
			//ジェスチャーの中心座標
			px = _root._xmouse;
			py = _root._ymouse;
			
			mouse_listener.onMouseMove = _operateGesture;
			mouse_listener.onMouseUp   = _stopGesture;
		}
		
		//マウスジェスチャー中
		function _operateGesture():Void {
			trace(1)
			if (!_is_gesture) return;
			
			//トラッキング
			
			var dx:Number = _root._xmouse - px;
			var dy:Number = _root._ymouse - py;
			
			var dist:Number = dx * dx + dy * dy;
			
			if (dist < r2) return;
			
			var angle:String = String( Math.round( (Math.atan2(dy, dx) + Math.PI) / (Math.PI * 2) * 4 + 2.5) % 4 );
			
			//トラッキングヒストリーの更新
			if (angle != recent) {
				track += angle;
				recent = angle;
			}
			
			//ジェスチャーの中心座標の更新
			/*
			var vertical:Boolean = (angle == 0 || angle == 2 ) ? true : false;
			px = (vertical) ? px            : _root._xmouse;
			py = (vertical) ? _root._ymouse : py;
			*/
			px = _root._xmouse;
			py = _root._ymouse;
		}
		
		//マウスジェスチャーの終了
		function _stopGesture():Void {
			
			_is_gesture = false;
			
			//クリックアクション
			if (track == "") {
				trace("detect click");
				return;
			}
			
			//マウスジェスチャーアクション
			if (_gesture.hasOwnProperty(track)) {
				
				//成功
				trace("detect gesture success , command : " + track);
				
			} else {
				
				//失敗
				trace("detect gesture failure , command : " + track);
			}
			
			mouse_listener.onMouseMove = null;
			mouse_listener.onMouseUp   = null;
		}
	}
	
	/*============================================*//**
	 * ボタンアクションの登録
	 */
	/*
	public function addReleaseEvent(target:MovieClip, callback:Function):Number {
		
		_release_callback_list[_release_callback_id] = callback;
		
		target.onRelease = Delegate.create(this, function():Void {
			if (_is_gesture) return;
			callback();
		});
		
		return _release_callback_id++;
	}
	*/
	
	/*============================================*//**
	 * ボタンアクションの解除
	 */
	/*
	public function removeReleaseEvent(id:Number):Void {
		
		delete _release_callback_list[_release_callback_id];
	}
	*/
}