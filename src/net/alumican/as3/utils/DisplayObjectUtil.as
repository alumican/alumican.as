package net.alumican.as3.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * DisplayObjectUtil
	 * 
	 * @author alumican
	 */
	public class DisplayObjectUtil
	{
		/**
		 * DisplayObjectをBitmapDataに転写する
		 */
		static public function toBitmapData(src:DisplayObject, width:int = 0, height:int = 0, transparent:Boolean = true, fillColor:uint = 0xffffffff, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):BitmapData
		{
			var dst:BitmapData = new BitmapData(width > 0 ? width : src.width, height > 0 ? height : src.height, transparent, fillColor);
			dst.draw(src, matrix, colorTransform, blendMode, clipRect, smoothing);
			return dst;
		}
		
		/**
		 * ライブラリシンボルからインスタンスを生成する
		 */
		static public function getInstanceByDefinitionName(linkage:String):DisplayObject
		{
			//コンストラクタに引数を渡せない
			return new (Class(getDefinitionByName(linkage)))();
		}
	}
}