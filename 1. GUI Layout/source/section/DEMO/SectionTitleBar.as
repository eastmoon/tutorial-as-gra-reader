/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package section.DEMO
{	
	/*import：Flash內建元件庫*/
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
		
	/*external import：外部元件庫、開發人員自定元件庫*/
	import section.DEMO.enum.*;
	import org.gra.view.WindowSection.Core.SectionSprite;
	import org.gra.controller.Progress.IProgressController;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;

	public class SectionTitleBar extends SectionSprite
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		private var mc_bcakground : Sprite;
		private var tf_textField : TextField;
		/*constructor：建構值*/
		public function SectionTitleBar() : void
		{
			super(ENUM_SECTION.BAR_TITLE);
			
			this.mc_bcakground = new Sprite();
			this.mc_bcakground.graphics.beginFill( 0x888888, 1 );
			this.mc_bcakground.graphics.drawRect( 0, 0, 1, 1 );
			this.mc_bcakground.graphics.endFill();
			this.addChild( this.mc_bcakground );
			
			this.tf_textField = new TextField();
			this.tf_textField.autoSize = TextFieldAutoSize.CENTER;
			this.tf_textField.text = "TITLE";
			this.addChild( this.tf_textField );
			
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
			if( this.mc_bcakground.width != rect.width )
			{
				this.mc_bcakground.width = rect.width;
				this.mc_bcakground.height = Math.floor( rect.height * 0.05 );
				if( this.mc_bcakground.height < 25 )
					this.mc_bcakground.height = 25;
					
				this.tf_textField.x = ( this.mc_bcakground.width - this.tf_textField.width ) / 2;
				this.tf_textField.y = ( this.mc_bcakground.height - this.tf_textField.height ) / 2;
			}
		}
		
		// 顯示內容進場，Progress Flow 控制函數
		public override function Display( a_flow : IProgressController = null ) : void
		{
			this.visible = true;
			a_flow.Next();
		}
		// 顯示內容退場，Progress Flow 控制函數
		public override function Disappear( a_flow : IProgressController = null ) : void
		{
			this.visible = false;
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