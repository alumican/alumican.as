import mx.utils.Delegate;
/**
 * Initializerクラス
 * 
 * AをattachMovie -> AのonLoadでAの中にBをattachMovie -> attach直後のBのメソッドを実行できない
 * 
 * そんな状態の時
 * 
 * if(b.initialize == null) {
 * 	b.onLoad = Delegate.create(this, function():Void {
 * 		b.initialize(hoge);
 * 		trace("初期化したよ");
 * 	});
 * } else {
 * 	b.initialize(hoge);
 * 	trace("初期化したよ");
 * }
 * 
 * こんな事しなくても
 * 
 * Initializer.register(b, "initialize", [hoge], Delegate.create(this, function():Void { trace("初期化したよ"); }););
 * 
 * 1行で済みました。
 * 
 * @author alumican<Yukiya Okuda>
 */
class net.alumican.as2.utils.Initializer {
	
	//mc.init(a, b, c); -> Initializer.resist(mc, "init", [a, b, c]);
	static function register(target:MovieClip, func:String, args:Array, callback:Function):Void {
		
		var f:Function = target[func];
		
		if(f == undefined) {
			target.onLoad = Delegate.create(this, function():Void {
				callback( f.apply(target, args) );
			});
			
		} else {
			callback( f.apply(target, args) );
		}
	}
}