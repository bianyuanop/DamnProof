export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'batchFilter' : IDL.Func(
        [IDL.Vec(IDL.Text), IDL.Nat],
        [IDL.Vec(IDL.Text)],
        ['query'],
      ),
    'exists' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Bool)], ['query']),
    'put' : IDL.Func([IDL.Text, IDL.Vec(IDL.Text)], [IDL.Vec(IDL.Text)], []),
    'remove' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Bool)], []),
  });
};
export const init = ({ IDL }) => { return []; };
