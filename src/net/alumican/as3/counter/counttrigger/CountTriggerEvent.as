/*======================================================================*//**
* 
* Licensed under the MIT License
* 
* Copyright (c) 2008 alumican
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
* 
*//*=======================================================================*/

package net.alumican.as3.counter.counttrigger {
	
	import flash.events.Event;

	/*======================================================================*//**
	*
	* CountTrigger for ActionScript 3.0
	*
	* カウンタベースのフラグを簡単に扱うためのクラスです
	* 
	* @author	alumican
	* @version	1.0.0
	* 
	* @see		http://utils.libspark.org/
	* @see		http://www.libspark.org/
	* @see		http://alumican.net/
	*//*=======================================================================*/

	public class CountTriggerEvent extends Event {

		/*======================================================================*//**
		* メンバ
		*//*=======================================================================*/

		public static const COMPLETE:String = "complete";
		public static const UPDATE:String   = "update";

		//イベント発行元となるTriggerクラス
		private var _trigger:CountTrigger;
		
		/*======================================================================*//**
		* getter/setter
		*//*=======================================================================*/
		public function get trigger():CountTrigger { return _trigger; }

		/*======================================================================*//**
		* コンストラクタ
		* @param	type		イベントのタイプです
		* @param	trigger		イベント発行元となる Trigger クラスです
		* @param	bubbles		イベントがバブリングイベントかどうかを示します
		* @param	cancelable	イベントに関連付けられた動作を回避できるかどうかを示します
		*//*=======================================================================*/
		public function CountTriggerEvent(type:String, trigger:CountTrigger, bubbles:Boolean=false, cancelable:Boolean=false):void {
			super(type, bubbles, cancelable);
			_trigger = trigger;
		}

		/*======================================================================*//**
		* Event サブクラスのインスタンスを複製します
		* @return	元のオブジェクトと同一の新しい Event オブジェクトです
		*//*=======================================================================*/
		override public function clone():Event {
			return new CountTriggerEvent(type, trigger, bubbles, cancelable);
		}
	}
}