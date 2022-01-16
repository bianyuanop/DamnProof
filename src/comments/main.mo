import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";
import Text "mo:base/Text";
import Passages "canister:passages";

actor CommentService {
    type Comment = (Nat, Principal, Text);
    type PackedComment = (Nat, Comment);
    class CommentSeries (_prcpl: Principal, opening: Text){
        // reply id, from, comment

        // starts at 1, 0 reserved for default reply
        public var count: Nat = 1;
        var commentsSeries: RBTree.RBTree<Nat,Comment> = RBTree.RBTree(Nat.compare);

        commentsSeries.put(count, (count, _prcpl, opening));
        count += 1;
        

        var defaultBatchSize = 100;
        public func getCommentsBatch(batch: Nat): [PackedComment] {
            var toIter: Iter.Iter<PackedComment> = commentsSeries.entries();
            var commentsArr: List.List<PackedComment> = Iter.toList(toIter);
            var trunked = List.chunks<PackedComment>(defaultBatchSize, commentsArr);

            switch(List.get(trunked, batch)) {
                case null [];
                case (?cmts) List.toArray(cmts);
            }
        };

        public func add(_prcpl: Principal, comment: Text): Bool {
            commentsSeries.put(count, (0, _prcpl, comment));
            count += 1;

            true
        };

        public func reply(from: Principal, to: Nat, comment: Text) : Bool {
            if(to > count) return false;
            commentsSeries.put(count, (to, from, comment));
            count += 1;

            true
        };

        public func delete(from: Principal, id: Nat): Bool {
            switch(commentsSeries.get(id)) {
                // not found
                case null return false;
                case (?cmt) {
                    // not caller
                    if(cmt.1 != from){ return false; }
                    else {
                        commentsSeries.delete(id);
                        true
                    };
                };
            };
        };
    };

    // key-value of (PassageId, CommentSeries)
    var comments: RBTree.RBTree<Text, CommentSeries> = RBTree.RBTree(Text.compare);

    public shared({caller}) func comment(passageId: Text, comment: Text): async [Bool] {
        var existance: [Bool] = await Passages.exists(passageId);
        if(existance[0] == false) return [false];

        var commentSeOp: ?CommentSeries = comments.get(passageId);
        var commentSe: CommentSeries = CommentSeries(caller, comment);
        switch commentSeOp {
            case null {
                comments.put(passageId, commentSe);
            };
            case (?co) {
                ignore(co.add(caller, comment));
                comments.put(passageId, co);
            };
        };

        [true]
    };

    public shared({caller}) func reply(passageId: Text, to: Nat, comment: Text): async [Bool] {
        var commentSeOp: ?CommentSeries = comments.get(passageId);
        var commentSe: CommentSeries = CommentSeries(caller, comment);
        switch commentSeOp {
            case null return [false];
            case (?co) commentSe := co;
        };

        [commentSe.reply(caller, to, comment)]
    };

    public shared({caller}) func delete(passageId: Text, commentId: Nat): async [Bool] {
        switch(comments.get(passageId)) {
            case null [false];
            case (?commentSe) {
                [commentSe.delete(caller, commentId)]
            };
        }
    };

    public query func getComments(passageId: Text, batch: Nat): async [PackedComment] {
        switch(comments.get(passageId)) {
            case null [];
            case (?commentSe) {
                commentSe.getCommentsBatch(batch);
            };
        }
    };
};
