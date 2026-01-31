package zpp_nape
{
   public class ZPP_ID
   {
      
      public static var _Constraint:int = 0;
      
      public static var _Interactor:int = 0;
      
      public static var _CbType:int = 0;
      
      public static var _CbSet:int = 0;
      
      public static var _Listener:int = 0;
      
      public static var _ZPP_SimpleVert:int = 0;
      
      public static var _ZPP_SimpleSeg:int = 0;
      
      public static var _Space:int = 0;
      
      public static var _InteractionGroup:int = 0;
      
      public function ZPP_ID()
      {
      }
      
      public static function Constraint() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._Constraint = (_loc1_ = int(_temp_1._Constraint)) + 1;
         return _loc1_;
      }
      
      public static function Interactor() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._Interactor = (_loc1_ = int(_temp_1._Interactor)) + 1;
         return _loc1_;
      }
      
      public static function CbType() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._CbType = (_loc1_ = int(_temp_1._CbType)) + 1;
         return _loc1_;
      }
      
      public static function CbSet() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._CbSet = (_loc1_ = int(_temp_1._CbSet)) + 1;
         return _loc1_;
      }
      
      public static function Listener() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._Listener = (_loc1_ = int(_temp_1._Listener)) + 1;
         return _loc1_;
      }
      
      public static function ZPP_SimpleVert() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._ZPP_SimpleVert = (_loc1_ = int(_temp_1._ZPP_SimpleVert)) + 1;
         return _loc1_;
      }
      
      public static function ZPP_SimpleSeg() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._ZPP_SimpleSeg = (_loc1_ = int(_temp_1._ZPP_SimpleSeg)) + 1;
         return _loc1_;
      }
      
      public static function Space() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._Space = (_loc1_ = int(_temp_1._Space)) + 1;
         return _loc1_;
      }
      
      public static function InteractionGroup() : int
      {
         var _temp_1:* = ZPP_ID;
         var _loc1_:int;
         _temp_1._InteractionGroup = (_loc1_ = int(_temp_1._InteractionGroup)) + 1;
         return _loc1_;
      }
   }
}

