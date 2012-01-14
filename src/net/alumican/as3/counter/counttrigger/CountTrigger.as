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
	import flash.events.EventDispatcher;

	/*======================================================================*//**
	*
	* CountTrigger for ActionScript 3.0
	*
	* カウンタベースのフラグを簡単に扱うためのクラスです<br />
	* 値の増減によるフラグ管理を行う場合に適しています<br />
	* 条件式は自由にカスタマイズでき, 2値の関係性からフラグ条件を判定する用途に広く応用できます
	* 
	* @author	alumican
	* @version	1.0.0
	* 
	* @see		http://utils.libspark.org/
	* @see		http://www.libspark.org/
	* @see		http://alumican.net/
	*
	* =============== EXAMPLE CODE ===============
	* <code>
	*
	* import net.alumican.as3.utils.counttrigger.CountTrigger;
	* import net.alumican.as3.utils.counttrigger.CountTriggerEvent;
	* 
	* //プリセットの条件式を用います
	* var t:CountTrigger = new CountTrigger(5, 0, true, CountTrigger.EQ, null);
	* 
	* //3の倍数で100以内ならば条件達成とします
	* //コンストラクタ内で カウンタ値==0 による条件達が生じますがコールバック関数を渡していないためイベントが発行されません
	* //var t:CountTrigger = new CountTrigger(100, 0, false, function(a:Number, b:Number):Boolean { return (a % 3 == 0 && a <= b) ? true : false}, null);
	* 
	* //コンストラクタでいきなり条件達成してもコールバック関数を渡しておけば安心です
	* //var t:CountTrigger = new CountTrigger(3, 5, true, CountTrigger.GE, function(e:CountTriggerEvent):void{ trace("いきなり達成!"); });
	* 
	* t.addEventListener(CountTriggerEvent.UPDATE  , updateHandler);
	* t.addEventListener(CountTriggerEvent.COMPLETE, completeHandler);
	* 
	* function updateHandler(e:CountTriggerEvent):void {
	* 	trace("更新された! count:" + e.trigger.count.toString() + 
	* 				  " , target:" + e.trigger.target.toString() + 
	* 					" , flag:" + e.trigger.flag.toString() + 
	* 				   " , total:" + e.trigger.total.toString() + 
	* 				   " , moved:" + e.trigger.moved.toString());
	* }
	* 
	* function completeHandler(e:CountTriggerEvent):void {
	* 	trace("達成した! count:" + e.trigger.count.toString() + 
	* 				" , target:" + e.trigger.target.toString() + 
	* 				  " , flag:" + e.trigger.flag.toString() + 
	* 				 " , total:" + e.trigger.total.toString() + 
	* 				 " , moved:" + e.trigger.moved.toString());
	* }
	* 
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp();
	* t.countUp(5);
	* t.countUp(-5);
	* t.countSet(100);
	*
	* </code>
	*//*=======================================================================*/

	public class CountTrigger extends EventDispatcher {
		
		/*======================================================================*//**
		* メンバ
		*//*=======================================================================*/
		
		//カウンタの目標値
		private var _target:Number;
		
		//カウンタの現在値
		private var _count:Number;
		
		//現在までに条件を達成した回数
		private var _total:Number;
	
		//現在までにカウンタが更新された回数
		private var _moved:Number;
	
		//現在条件を満たしていればtrue
		private var _flag:Boolean;
		
		//過去一度でも条件を達成していればtrue
		private var _is_completed:Boolean;
		
		//completeイベントを一回のみ発行するならばtrue(updateイベントの発行も止まる)
		private var _at_once:Boolean;

		//条件達成の判定に用いられる比較関数(カスタマイズ可能)
		private var _operator:Function;
		
		/*======================================================================*//**
		* getter/setter
		*//*=======================================================================*/
		public function get count():Number      { return _count;    }
		public function get target():Number     { return _target;   }
		public function get flag():Boolean      { return _flag;     }
		public function get total():Number      { return _total;    }
		public function get moved():Number      { return _moved;    }
		public function get operator():Function { return _operator; }
		public function get at_once():Boolean   { return _at_once;  }
	
		public function set count(n:Number):void  {
			_count = n;
			++_moved;
			_check();
		}
	
		public function set target(n:Number):void {
			_target = n;
			_check();
		}
	
		public function set operator(f:Function):void {
			_operator = f;
			_check();
		}
	
		public function set at_once(flag:Boolean):void   {
			_at_once = flag;
		}

		/*======================================================================*//**
		* 比較関数のプリセット
		*
		* @param	a	現在値
		* @param	b	目標値
		* @return	a,bが条件式を満たしているならばtrue
		*
		* EQ 達成条件 : 現在値 == 目標値
		* NE 達成条件 : 現在値 != 目標値
		* GT 達成条件 : 現在値 >  目標値
		* GE 達成条件 : 現在値 >= 目標値
		* LT 達成条件 : 現在値 <  目標値
		* LE 達成条件 : 現在値 <= 目標値
		*//*=======================================================================*/
		static public function EQ(a:Number, b:Number):Boolean { return (a == b) ? true : false;}
		static public function NE(a:Number, b:Number):Boolean { return (a != b) ? true : false;}
		static public function GT(a:Number, b:Number):Boolean { return (a >  b) ? true : false;}
		static public function GE(a:Number, b:Number):Boolean { return (a >= b) ? true : false;}
		static public function LT(a:Number, b:Number):Boolean { return (a <  b) ? true : false;}
		static public function LE(a:Number, b:Number):Boolean { return (a <= b) ? true : false;}

		/*======================================================================*//**
		* コンストラクタ
		* @param	target		カウンタの目標値
		* @param	init		カウンタの初期値
		* @param	at_once		trueならば一度条件式を満たした時点で以後イベントを発行しません
		* @param	onComplete	条件達成時に実行される関数です(コンストラクタでいきなり条件達成した場合も呼ばれます)
		*//*=======================================================================*/
		public function CountTrigger(target:Number, 
								init:Number=0, 
								at_once:Boolean=true, 
								operator:Function=null, 
								onComplete:Function=null):void {

			_target   = target;
			_total    = 0;
			_moved    = 0;
			_count    = init;
			_at_once  = at_once;
			_operator = (operator == null) ? CountTrigger.EQ : operator;
			if(onComplete != null) addEventListener(CountTriggerEvent.COMPLETE, onComplete);
	
			_is_completed = false;
			
			_check();
		}
	
		/*======================================================================*//**
		* カウンタの現在値をインクリメントorデクリメントします
		* @param	n	カウンタの増分です
		*//*=======================================================================*/
		public function countUp(n:Number=1):void {
			count += n;
		}
	
		/*======================================================================*//**
		* カウンタの現在値を指定値にセットします
		* @param	n	カウンタの新しい値です
		*//*=======================================================================*/
		public function countSet(n:Number):void {
			count = n;
		}
	
		/*======================================================================*//**
		* カウンタの目標値と現在値が条件式 _oparator を満たしているか判定します
		*//*=======================================================================*/
		private function _check():void {
			_flag = _operator(_count, _target);
			var update_flag:Boolean = false;
			var complete_flag:Boolean = false;
			if(_moved > 0) {
				update_flag = true;
			}
			if(_flag) {
				++_total;
				complete_flag = true;
			}

			if(!_at_once || !_is_completed) {
				if(update_flag) {
					var update_event:CountTriggerEvent = new CountTriggerEvent(CountTriggerEvent.UPDATE, this);
					dispatchEvent(update_event);
				}
				if(complete_flag) {
					_is_completed = true;
					var complete_event:CountTriggerEvent = new CountTriggerEvent(CountTriggerEvent.COMPLETE, this);
					dispatchEvent(complete_event);
				}
			}
		}
	}
}