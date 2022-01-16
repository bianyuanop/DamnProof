export const idlFactory = ({ IDL }) => {
  const Comment = IDL.Tuple(IDL.Nat, IDL.Principal, IDL.Text);
  const PackedComment = IDL.Tuple(IDL.Nat, Comment);
  return IDL.Service({
    'comment' : IDL.Func([IDL.Text, IDL.Text], [IDL.Vec(IDL.Bool)], []),
    'delete' : IDL.Func([IDL.Text, IDL.Nat], [IDL.Vec(IDL.Bool)], []),
    'getComments' : IDL.Func(
        [IDL.Text, IDL.Nat],
        [IDL.Vec(PackedComment)],
        ['query'],
      ),
    'reply' : IDL.Func([IDL.Text, IDL.Nat, IDL.Text], [IDL.Vec(IDL.Bool)], []),
  });
};
export const init = ({ IDL }) => { return []; };
