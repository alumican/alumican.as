/**
 * Alignment
 * 
 * @author alumican<Yukiya Okuda>
 */
import flash.geom.Point;
import mx.utils.Delegate;
import net.alumican.as2.alignment.ImplAlignment;

class net.alumican.as2.alignment.Alignment {
	
	static var _impl:ImplAlignment;
	
	static function get TL():Number { return ImplAlignment.TL; }
	static function get LT():Number { return ImplAlignment.LT; }
	static function get BL():Number { return ImplAlignment.BL; }
	static function get LB():Number { return ImplAlignment.LB; }
	static function get TR():Number { return ImplAlignment.TR; }
	static function get RT():Number { return ImplAlignment.RT; }
	static function get BR():Number { return ImplAlignment.BR; }
	static function get RB():Number { return ImplAlignment.RB; }
	
	public function Alignment() {
		throw new Error("usage: Alignment.resist();");
	}
	
	/**
	 * 初期化
	 * 
	 * @param	stage	基準となるStageを参照できるMovieClip
	 */
	static function initialize(root:MovieClip) {
		
		_impl = new ImplAlignment();
		
		_impl.initialize(root);
	}
	
	/**
	 * リサイズ時に位置合わせを行うMovieClipの登録
	 * 
	 * @param	target				リサイズ時に位置合わせを行うMovieClip
	 * @param	align				整列方向 Alignment.TL or Alignment.BL or Alignment.TR or Alignment.BR
	 * @param	margin				整列方向端からのマージン[px]
	 * @param	reposition			リサイズ時にMovieClipを再配置させるならtrue, 座標値だけ取得するならfalse
	 * @param	init				登録時に位置合わせを行うならばtrue
	 * @param	callback(e:Object)	リサイズ時のコールバック関数(e.x:Number=x座標値, e.y:Number=y座標値)
	 */
	static function register(target:MovieClip, align:Number, margin:Array, reposition:Boolean, init:Boolean, callback:Function):Void {
		
		_impl.register(target, align, margin, reposition, init, callback);
	}
}