package net.alumican.as3.algorithm.ga
{
	import flash.utils.ByteArray;
	
	import net.alumican.as3.algorithm.ga.events.*;
	import net.alumican.as3.algorithm.ga.packets.*;
	
	/**
	 * 一つの染色体を持つ個体を表すクラス
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Agent 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 染色体配列
		 * getterは染色体配列をコピーして返す
		 * ただし，配列の中身まではディープコピーしない
		 */
		public function get chromosome():Array { return __chromosome.concat(); }
		public function set chromosome(value:Array):void
		{
			__isElite    = false;
			__fitness    = Number.NaN;
			__chromosome = value.concat();
		}
		private var __chromosome:Array;
		
		/**
		 * 個体の適合度
		 * 数値が大きいほど優秀な個体を表す
		 */
		public function get fitness():Number { return __fitness; }
		public function set fitness(value:Number):void { __fitness = value; }
		private var __fitness:Number;
		
		/**
		 * リンクリストにおける次の個体
		 */
		public function get next():Agent { return __next; }
		internal function set _next(value:Agent):void { __next = value; }
		private var __next:Agent;
		
		/**
		 * エリート主義を使用する場合，フラグの立った個体は次世代において淘汰されない
		 */
		public function get isElite():Boolean { return __isElite; }
		internal function set _isElite(value:Boolean):void { __isElite = value; }
		private var __isElite:Boolean;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param chromosome 初期染色体配列
		 */
		public function Agent(chromosome:Array = null):void 
		{
			this.chromosome = (chromosome != null) ? chromosome.concat() : shakeout();
		}
		
		/**
		 * ランダムな染色体配列を新しく生成して返す
		 * このメソッドは自身の染色体を上書きしない
		 */
		public function shakeout():Array
		{
			var n:uint = 100;
			var chromosome:Array = new Array(n);
			for (var i:uint = 0; i < n; ++i)
			{
				chromosome[i] = (Math.random() < 0.5) ? 1 : 0;
			}
			return chromosome;
		}
		
		/**
		 * 自身の染色体と引数で与えられた染色体を交叉し，新たに2つの染色体配列を生成して返す
		 * このメソッドはこの個体の染色体を上書きしない
		 * @param  agent 交配相手となる個体
		 * @return 子供の染色体のペア
		 */
		public function crossoverTo(agent:Agent):Children
		{
			var chromA:Array = chromosome;
			var chromB:Array = agent.chromosome;
			
			//交叉点の数
			var t:uint = 2;
			
			var n:uint = chromA.length;
			var p:uint;
			var c0:Array;
			var c1:Array;
			
			for (var i:uint = 0; i < t; ++i) 
			{
				p = uint(Math.random() * n);
				
				c0 = chromA.slice(0, p).concat(chromB.slice(p, n));
				c1 = chromB.slice(0, p).concat(chromA.slice(p, n));
				
				chromA = c0;
				chromB = c1;
			}
			
			return new Children(chromA, chromB);
		}
		
		/**
		 * 自身の染色体配列のコピーに突然変異を起こさせて返す
		 * このメソッドはこの個体の染色体を上書きしない
		 * @return 突然変異後の染色体配列
		 */
		public function mutation():Array
		{
			var chrom:Array = chromosome;
			
			var index:uint = uint(Math.random() * chrom.length);
			chrom[index] = 1 - chrom[index];
			
			return chrom;
		}
		
		/**
		 * 文字列表現を生成する
		 * @return
		 */
		public function toString():String 
		{
			return "[Agent] fitness = " + __fitness;
		}
	}
}