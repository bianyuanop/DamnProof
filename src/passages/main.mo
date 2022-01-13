import List "mo:base/List";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";

actor Passages {
    class Passage (_prcpl: Principal, _URI: Text) {
        public var URI: Text = _URI;
        public var prcpl: Principal = _prcpl;
        public var history: List.List<Text> = List.nil<Text>();

        // first record
        history := List.push<Text>(_URI, history);

        public func revise(_URI: Text) {
            history := List.push<Text>(_URI, history);
            URI := _URI;
        };
    };

    class Section (_name: Text) {
        public var name: Text = _name;
        public var passages: List.List<Passage> = List.nil<Passage>();
        public var count = 0;

    };

    var count: Nat = 0;

};