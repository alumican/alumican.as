package net.alumican.as3.algorithm.ga
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import net.alumican.as3.algorithm.ga.events.*;
	import net.alumican.as3.algorithm.ga.packets.*;
	
	/**
	 * Generation
	 * 世代(同時に評価される個体の集合)を表すクラス
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class Generation extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 個体を格納する配列
		 */
		public function get agents():Array { return __agents; }
		private var __agents:Array;
		
		/**
		 * 個体数
		 */
		public function get agentCount():uint { return __agentCount; }
		private var __agentCount:uint;
		
		/**
		 * リンクリストの先頭となる個体
		 */
		public function get head():Agent { return __head; }
		private var __head:Agent;
		
		/**
		 * リンクリストの最後尾となる個体
		 */
		public function get tail():Agent { return __tail; }
		private var __tail:Agent;
		
		/**
		 * 一世代で淘汰される個体数
		 */
		public function get cullingCount():Number { return __cullingCount; }
		public function set cullingCount(value:Number):void { __cullingCount = value; }
		private var __cullingCount:Number;
		
		/**
		 * 一世代で交配するペア数
		 */
		public function get crossoverCount():Number { return __crossoverCount; }
		public function set crossoverCount(value:Number):void { __crossoverCount = value; }
		private var __crossoverCount:Number;
		
		/**
		 * 各個体毎に突然変異が起こる確率
		 */
		public function get mutationProbability():Number { return __mutationProbability; }
		public function set mutationProbability(value:Number):void { __mutationProbability = value; }
		private var __mutationProbability:Number;
		
		/**
		 * エリート主義を使用する場合のエリート個体数
		 */
		public function get eliteCount():uint { return __eliteCount; }
		public function set eliteCount(value:uint):void { __eliteCount = value; }
		private var __eliteCount:uint;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Generation(cullingCount:uint = 0, crossoverCount:uint = 1, mutationProbability:Number = 0.05, eliteCount:uint = 1):void 
		{
			__cullingCount        = cullingCount;
			__crossoverCount      = crossoverCount;
			__mutationProbability = mutationProbability;
			__eliteCount          = eliteCount;
			
			__agents     = new Array();
			__agentCount = 0;
		}
		
		/**
		 * 個体を追加する
		 * @param	agent 追加する個体
		 * @return 追加後の個体数
		 */
		public function addAgent(agent:Agent):uint
		{
			var n:uint = __agentCount = __agents.push(agent);
			
			if (n > 1)
			{
				//追加後に2体以上となった場合は最後尾に追加
				__tail._next = agent;
			}
			else
			{
				//追加後に1体の場合は追加個体が先頭
				__head = agent;
			}
			
			//最後尾を更新
			__tail = agent;
			
			return n;
		}
		
		/**
		 * 交配をおこなう
		 * 交配は選択，交叉，突然変異の3セクションに分かれる
		 */
		internal function _heredity():void
		{
			//交配の要求通知
			dispatchEvent( new HeredityEvent(HeredityEvent.REQUEST) );
			
			//選択
			if (__cullingCount > 0)
			{
				_selection(__cullingCount);
			}
			
			//交叉
			if (__crossoverCount > 0)
			{
				_crossover(__crossoverCount);
			}
			
			//突然変異
			if (__mutationProbability > 0)
			{
				mutation(__mutationProbability);
			}
			
			//交配の完了通知
			dispatchEvent( new HeredityEvent(HeredityEvent.COMPLETE) );
		}
		
		/**
		 * 選択をおこなう
		 * 指定した個体数が任意の方法によって選ばれ，淘汰される
		 * @param	cullingCount 淘汰数
		 */
		protected function _selection(cullingCount:uint):void
		{
			var chromosomes:Chromosomes = _chooseCullingChromosomes(__agents, cullingCount);
			
			var n:uint = (agentCount < chromosomes.length) ? agentCount : chromosomes.length;
			for (var i:uint = 0; i < agentCount; ++i)
			{
				if (chromosomes.get(i))
				{
					Agent(__agents[i]).chromosome = chromosomes.get(i);
				}
			}
		}
		
		/**
		 * 淘汰する遺伝子配列の代わりの遺伝子配列をもった配列を返す
		 * 配列長はcullingCount，淘汰しない遺伝子配列のインデックスにはnullを入れておくこと
		 * @param	agents
		 * @param	cullingCount
		 * @return
		 */
		protected function _chooseCullingChromosomes(agents:Array, cullingCount:uint):Chromosomes
		{
			var chromosomes:Chromosomes = new Chromosomes(agentCount);
			
			var n:uint = (agentCount - cullingCount > 0) ? (agentCount - cullingCount) : 0;
			for (var i:int = agentCount - 1; i >= n; --i)
			{
				chromosomes.set(i, Agent(agents[i]).shakeout());
			}
			
			return chromosomes;
		}
		
		/**
		 * 交叉をおこなう
		 * @param	crossoverCount 交叉をおこなうペア数
		 */
		protected function _crossover(crossoverCount:uint):void
		{
			var p:uint = agentCount - 1;
			var parentA:Agent;
			var parentB:Agent;
			var chromsomes:Children;
			var childA:Agent;
			var childB:Agent;
			var pair:Array;
			
			var indices:Parents = _chooseCrossoverParentIndices(__agents, __crossoverCount);
			
			for (var i:uint = 0; i < crossoverCount; ++i)
			{
				//親の選択
				pair = indices.getPair(i);
				parentA = __agents[ pair[0] ];
				parentB = __agents[ pair[1] ];
				
				//交叉
				chromsomes = parentA.crossoverTo(parentB);
				childA = __agents[p--];
				childB = __agents[p--];
				
				//子の染色体の書き換え
				childA.chromosome = chromsomes.a;
				childB.chromosome = chromsomes.b;
			}
		}
		
		/**
		 * 交叉する親のインデックスのペアを配列で返す関数
		 * @param	agents
		 * @param	crossoverCount
		 * @return
		 */
		protected function _chooseCrossoverParentIndices(agents:Array, crossoverCount:uint):Parents
		{
			var indexA:uint,
			    indexB:uint,
			    indices:Parents = new Parents();
			
			for (var i:uint = 0; i < crossoverCount; ++i) 
			{
				//ランダム選択
				indexA = uint(Math.random() * agentCount);
				do
				{
					indexB = uint(Math.random() * agentCount);
				}
				while (indexA == indexB);
				
				indices.addPair(indexA, indexB);
			}
			
			return indices;
		}
		
		/**
		 * 突然変異をおこなう
		 * @param	probability
		 */
		public function mutation(probability:Number):void
		{
			var agent:Agent = head;
			do {
				if (Math.random() < probability && !agent.isElite)
				{
					agent.chromosome = agent.mutation();
				}
			}
			while (agent = agent.next);
		}
		
		/**
		 * 世代を保存する
		 * @return
		 */
		public function save():ByteArray
		{
			var data:ByteArray = new ByteArray();
			return data;
		}
		
		/**
		 * 世代を読み出す
		 * @param	data
		 * @return
		 */
		public function load(data:ByteArray):Boolean
		{
			return false;
		}
	}
}