package net.alumican.as3.utils 
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * BitmapDataUtil
	 * 
	 * @author alumican
	 */
	public class BitmapDataUtil
	{
		/**
		 * リンケージIDからBitmapDataを取得する
		 * @param	assetID
		 * @return
		 */
		static public function getBitmapDataFromAsset(assetID:String):BitmapData
		{
			var klass:Class, bmd:BitmapData;
			try
			{
				klass = Class( getDefinitionByName(assetID) );
			}
			catch (e:Error)
			{
				throw new ArgumentError("指定されたassetID = " + assetID + " は有効なリンケージIDではありません");
			}
			try
			{
				bmd = new klass(0, 0) as BitmapData;
			}
			catch (e:Error)
			{
				throw new ArgumentError("指定されたassetID = " + assetID + " はに関連付けられたシンボルはBitmapDataではありません");
			}
			return bmd;
		}
		
		/**
		 * 画像の平均色を算出する
		 * @param	image
		 * @param	rect
		 * @return
		 */
		static public function calcAverageColor(src:BitmapData, rect:Rectangle = null):uint
		{
			var hist:Vector.<Vector.<Number>> = src.histogram(rect),
				r:Number = 0,
				g:Number = 0,
				b:Number = 0,
				a:Number = 0,
				i:int,
				p:int;
			for (i = 0; i < 256; ++i)
			{
				r += hist[0][i] * i;
				g += hist[1][i] * i;
				b += hist[2][i] * i;
				a += hist[3][i] * i;
			}
			p = rect ? (rect.width * rect.height) : (src.width * src.height);
			r /= p;
			g /= p;
			b /= p;
			a /= p;
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		/**
		 * RGBを指定してカラーイメージを生成する
		 * @param	src
		 * @param	r
		 * @param	g
		 * @param	b
		 */
		static public function getColordImageFromRGB(src:BitmapData, r:uint, g:uint, b:uint):BitmapData
		{
			var dst:BitmapData = src.clone();
			dst.applyFilter(src, src.rect, new Point(), new ColorMatrixFilter([
				r / 255, 0      , 0      , 0, 0,
				0      , g / 255, 0      , 0, 0,
				0      , 0      , b / 255, 0, 0,
				0      , 0      , 0      , 1, 0
			]));
			return dst;
		}
	}
}