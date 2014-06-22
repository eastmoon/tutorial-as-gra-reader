/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package section.DEMO
{	
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import section.DEMO.enum.*;
	import org.gra.view.WindowSection.Core.SectionSprite;
	import org.gra.controller.Progress.IProgressController;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;

	public class SectionBackground extends SectionSprite
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function SectionBackground() : void
		{
			super(ENUM_SECTION.BACKGROUND);
		}
		/*public function：對外公開函數*/
		public override function Active() : void
		{
		}
		public override function Unactive() : void
		{
			
		}
		public override function Update() : void
		{
			
		}
		public override function Draw() : void
		{
			var rect : Rectangle = this.getWindow().getCurrentViewport();
			var graphic : Graphics = this.graphics;
			graphic.beginFill( 0xffffaa, 1 );
			graphic.drawRect( 0, 0, rect.width, rect.height );
			graphic.endFill();
		}
		
		// 顯示內容進場，Progress Flow 控制函數
		public override function Display( a_flow : IProgressController = null ) : void
		{
			if( a_flow != null )
				a_flow.Next();
		}
		// 顯示內容退場，Progress Flow 控制函數
		public override function Disappear( a_flow : IProgressController = null ) : void
		{
			if( a_flow != null )
				a_flow.Next();
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		/*private function：私用函數*/
	}
}