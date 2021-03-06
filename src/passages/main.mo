import Array "mo:base/Array";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import None "mo:base/None";
import Principal "mo:base/Principal";
import RBTree "mo:base/RBTree";
import SHA256 "mo:sha256/SHA256";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor Passages {
    class Passage (_prcpl: Principal, _URI: Text) {
        public var URI: Text = _URI;
        public var prcpl: Principal = _prcpl;
        public var history: List.List<Text> = List.nil<Text>();
        public var tags: List.List<Text> = List.nil();

        // first record
        history := List.push<Text>(_URI, history);

        public func revise(_URI: Text) {
            history := List.push<Text>(_URI, history);
            URI := _URI;
        };

        public func addTag(_tag: Text) : Bool {
            func tagFilter(t: Text): Bool {
                t == _tag
            };

            var isIn = List.some(tags, tagFilter);
            if(not isIn) {
                tags := List.push<Text>(_tag, tags);
            };

            true
        };

        public func removeTag(_tag: Text) : Bool {
            func tagFilter(t: Text): Bool {
                t != _tag
            };
            tags := List.filter(tags, tagFilter);

            true
        };
    };

    var count: Nat = 0;
    var passages = RBTree.RBTree<Text, Passage>(Text.compare);
    var defaultBatchSize: Nat = 10;

    // unused yet
    private func nat8Arr2Text(arr: [Nat8]): async Text {
        var res: Text = "";
        var toIter: Iter.Iter<Nat8> = Array.vals(arr);
        for(val in toIter) {
            res := res # Nat8.toText(val);
        };
        res
    };

    // may encounter time efficient problem
    // need to change actor data structure to ease
    // public query func filter(keywords: [Text]): async List.List<Text> {
    private func filter(keywords: [Text]): List.List<Text> {
        var keywordsSize = Iter.size<Text>(Array.vals<Text>(keywords));

        func isIn(_tag: Text): Bool {
            var keywordsIter = Iter.fromArray(keywords);
            for(k in keywordsIter) {
                if(k == _tag) return true;
            };

            false
        };

        var passageIter: Iter.Iter<(Text, Passage)> = passages.entries();
        var res: List.List<Text> = List.nil<Text>();
        for(pIter in passageIter) {
            if(keywordsSize == 0 or List.some(pIter.1.tags, isIn)) res := List.push<Text>(pIter.0, res);
        };
        res
    };

    public shared({caller}) func put(_URI: Text, tags: [Text]): async [Text] {
        var tagIter = Iter.fromArray(tags);
        var p = Passage(caller, _URI);
        for(tag in tagIter) {
            ignore(p.addTag(tag));
        };

        var now: Int = Time.now();
        var nowStr: Text = Int.toText(now);
        var key = _URI # ":" # nowStr;
        passages.put(key, p);

        [key]
    };

    public shared({caller}) func remove(target: Text): async [Bool] {
        var passageOp = passages.get(target);
        var passage = switch(passageOp) {
            case (?p) p;
            case null {
                return [false];
            };
        };

        if(passage.prcpl != caller) {
            return [false];
        };

        passages.delete(target);

        [true]
    };

    public query func batchFilter(keywords: [Text], batch: Nat): async [Text] {
        
        var filterd: List.List<Text> = filter(keywords);
        var chunked: List.List<List.List<Text>> = List.chunks<Text>(defaultBatchSize, filterd);
        var size: Nat = List.size<List.List<Text>>(chunked);

        var resOp = List.get<List.List<Text>>(chunked, batch);
        var res = switch resOp {
            case (?l) l;
            case null List.nil<Text>();
        };

        List.toArray(res)
    };

    public query func exists(passageId: Text): async [Bool] {
        switch (passages.get(passageId)) {
            case (?p) [true];
            case null [false];
        }
    };
};