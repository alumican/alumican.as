package net.alumican.as3.framework.betweenas3_fp9 
{
	import flash.geom.ColorTransform;
	import org.libspark.betweenas3_fp9.events.TweenEvent;
	import org.libspark.betweenas3_fp9.tweens.ITween;
	
	public class BetweenAS3Util
	{
		/**
		 * Tweenを実行する
		 */
		static public function execute(tween:ITween, useTransition:Boolean = true, onPlay:Function = null, onStop:Function = null, onUpdate:Function = null, onComplete:Function = null):Class
		{
			if (useTransition && tween.duration > 0)
			{
				//トランジションありの場合
				function $complete():void
				{
					tween.removeEventListener(TweenEvent.COMPLETE, $complete);
					
					if (onPlay     != null) tween.removeEventListener(TweenEvent.PLAY    , onPlay    );
					if (onStop     != null) tween.removeEventListener(TweenEvent.STOP    , onStop    );
					if (onUpdate   != null) tween.removeEventListener(TweenEvent.UPDATE  , onUpdate  );
					if (onComplete != null) tween.removeEventListener(TweenEvent.COMPLETE, onComplete);
				}
				
				if (onPlay     != null) tween.addEventListener(TweenEvent.PLAY    , onPlay    );
				if (onStop     != null) tween.addEventListener(TweenEvent.STOP    , onStop    );
				if (onUpdate   != null) tween.addEventListener(TweenEvent.UPDATE  , onUpdate  );
				if (onComplete != null) tween.addEventListener(TweenEvent.COMPLETE, onComplete);
				
				tween.addEventListener(TweenEvent.COMPLETE, $complete);
				tween.play();
			}
			else
			{
				//トランジションなしの場合
				tween.dispatchEvent( new TweenEvent(TweenEvent.PLAY) );
				if (onPlay != null) onPlay(tween.onStopParams);
				
				tween.gotoAndStop(tween.duration);
				
				tween.dispatchEvent( new TweenEvent(TweenEvent.UPDATE) );
				if (onUpdate != null) onUpdate(tween.onUpdateParams);
				
				tween.dispatchEvent( new TweenEvent(TweenEvent.COMPLETE) );
				if (onComplete != null) onComplete(tween.onCompleteParams);
			}
			
			return BetweenAS3Util;
		}
		
		/**
		 * ColorTransformを表現するObjectを生成する
		 */
		static public function getColorTransformObject(trans:ColorTransform = null):Object
		{
			trans = (trans != null) ? trans : new ColorTransform();
			
			var rm:Number = trans.redMultiplier;
			var gm:Number = trans.greenMultiplier;
			var bm:Number = trans.blueMultiplier;
			var am:Number = trans.alphaMultiplier;
			var ro:Number = trans.redOffset;
			var go:Number = trans.greenOffset;
			var bo:Number = trans.blueOffset;
			var ao:Number = trans.alphaOffset;
			
			return {
				transform : {
				colorTransform : {
						redMultiplier   : rm,
						greenMultiplier : gm,
						blueMultiplier  : bm,
						alphaMultiplier : am,
						redOffset       : ro,
						greenOffset     : go,
						blueOffset      : bo,
						alphaOffset     : ao
					}
				}
			}
		}
	}
}