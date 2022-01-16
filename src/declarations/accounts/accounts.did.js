export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getCount' : IDL.Func([], [IDL.Nat], ['query']),
    'register' : IDL.Func([], [IDL.Vec(IDL.Bool)], []),
    'updateProfileURI' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Bool)], []),
    'verify' : IDL.Func([IDL.Principal], [IDL.Vec(IDL.Bool)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
