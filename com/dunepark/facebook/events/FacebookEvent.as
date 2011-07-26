package com.dunepark.facebook.events
{
	import flash.events.Event;

	public class FacebookEvent extends Event
	{
		public static const LOGIN_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.LOGIN_FAIL";
		public static const LOGIN_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.LOGIN_SUCCESS";
		public static const POST_PHOTO_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.POST_SUCCESS";
		public static const POST_PHOTO_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.POST_FAIL";
		public static const GET_USER_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.GET_USER_SUCCESS";
		public static const GET_USER_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.GET_USER_FAIL";
		public static const GET_FRIENDS_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.GET_FRIENDS_SUCCESS";
		public static const GET_FRIENDS_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.GET_FRIENDS_FAIL";
		public static const GET_LIKES_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.GET_LIKES_SUCCESS";
		public static const GET_LIKES_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.GET_LIKES_FAIL";
		public static const GET_USER_POSTS_SUCCESS:String = "com.dunepark.facebook.events.FacebookEvent.GET_USER_POSTS_SUCCESS";
		public static const GET_USER_POSTS_FAIL:String = "com.dunepark.facebook.events.FacebookEvent.GET_USER_POSTS_FAIL";
		
		
		public var data:Object;
			
		public function FacebookEvent(type:String, data:Object = null)
		{
			this.data = data;
			super(type, false, false);
		}
	
		public override function clone() : Event
		{
			var event:FacebookEvent = new FacebookEvent( this.type, this.data );
			return event;
		}	
	}
}