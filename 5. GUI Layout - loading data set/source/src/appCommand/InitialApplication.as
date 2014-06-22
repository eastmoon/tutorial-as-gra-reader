/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package src.appCommand
{
	/*import：Flash內建元件庫*/
    import flash.display.DisplayObjectContainer;
	// PureMVC Import
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
	// Game rule architecture Import
    import org.gra.ApplicationFacade;
	import org.gra.controller.WSProgressFlow.*;
	// 
	import src.progress.SlideWindow.*;
	import src.enum.*;
	
    /**
     * Create and register <code>Proxy</code>s with the <code>Model</code>.
     */
    public class InitialApplication extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            //facade.registerProxy(new StartupMonitorProxy());
			//trace("Initial Control Class：" , note.getBody());
			
			// 取得Stage
			var root : DisplayObjectContainer = note.getBody() as DisplayObjectContainer;
			
			// 取得Application Facade
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			
			trace("----- Start Application -----");
			//app.sendNotification( SWProgressFlow.EVENT_PROGRESS_FLOW,  new SWPFController( ENUM_WINDOW.MESSAGE, ENUM_SECTION.PAGE_LOAD ));
			app.sendNotification( WSProgressFlow.EVENT_PROGRESS_FLOW,  new WSPFController( ENUM_WINDOW.MESSAGE, ENUM_SECTION.PAGE_LOAD ));
        }
    }
}