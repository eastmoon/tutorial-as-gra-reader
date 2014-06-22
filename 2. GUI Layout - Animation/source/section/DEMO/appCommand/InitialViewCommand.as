/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package section.DEMO.appCommand
{
	/*import：Flash內建元件庫*/
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
	// PureMVC Import
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
	// Game rule architecture Import
    import org.gra.ApplicationFacade;
	import org.gra.view.WindowSection.Interface.ISection;
    import org.gra.view.WindowSection.Interface.IWindow;
    import org.gra.view.WindowSection.Core.Window;
	// DEMO
	import section.DEMO.*;
	import section.DEMO.enum.*;
	
    /**
     * Create and register <code>Proxy</code>s with the <code>Model</code>.
     */
    public class InitialViewCommand extends SimpleCommand
    {
		/*public function：對外公開函數*/
        override public function execute( note:INotification ) :void    
		{
            //facade.registerProxy(new StartupMonitorProxy());
			trace("Initial View Class：" , note.getBody());
			
			// 取得Stage
			var root : DisplayObjectContainer = note.getBody() as DisplayObjectContainer;
			
			// 取得Application Facade
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			
			trace("----- Initial Window-Section -----");
			
			// 設定視窗物件
			
			// 設定視窗物件
			// 1. 背景層
			this.CreateWindow( ENUM_WINDOW.BACKGROUND, root, app );
			// 2. 內容層
			this.CreateWindow( ENUM_WINDOW.CONTENT, root, app );
			// 3. 頂部欄
			this.CreateWindow( ENUM_WINDOW.TOP_BAR, root, app );
			// 3. 底部欄
			this.CreateWindow( ENUM_WINDOW.BOTTOM_BAR, root, app );
			// 4. 訊息層
			this.CreateWindow( ENUM_WINDOW.MESSAGE, root, app );
			
			// 設定內容物件
			var section : ISection = null;
			// 1. 背景
			section = new SectionBackground();
			app.registerSection( section );
			this.DefaultSection( ENUM_WINDOW.BACKGROUND, section, app );
							
			// 2. 介紹首頁
			section = new SectionIntro();
			app.registerSection( section );
			this.DefaultSection( ENUM_WINDOW.CONTENT, section, app );
			
			// 3. 書櫃
			section = new SectionBookcasePage();
			app.registerSection( section );
			
			
			// 4. 閱讀
			section = new SectionReaderPage();
			app.registerSection( section );
			
			
			// 5. 下載
			section = new SectionDownloadPage();
			app.registerSection( section );
			
			
			// 6. 設定
			section = new SectionConfigPage();
			app.registerSection( section );
			
			// 7. 標題
			section = new SectionTitleBar();
			app.registerSection( section );
			this.DefaultSection( ENUM_WINDOW.TOP_BAR, section, app );
				
			// 8. 功能
			section = new SectionFunctionBar;
			app.registerSection( section );
			this.DefaultSection( ENUM_WINDOW.BOTTOM_BAR, section, app );
			
			// 註冊視窗與內容至Application Facade
        }
		
		/*private function：私用函數*/
		private function CreateWindow( a_windowName : String, a_stage : DisplayObjectContainer, a_app : ApplicationFacade ) : void
		{
			var window : IWindow = new Window(a_windowName);
			window.setViewport( a_stage.stage.stageWidth, a_stage.stage.stageHeight );
			a_app.registerWindow( window );
			a_stage.addChild( window as DisplayObject );
		}
		private function DefaultSection( a_windowName : String, a_section : ISection, a_app : ApplicationFacade ) : void
		{
			var window : IWindow = a_app.retrieveWindow( a_windowName );
			if( window != null )
				window.setSection( a_section );
		}
    }
}