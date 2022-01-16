import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'getCount' : () => Promise<bigint>,
  'register' : () => Promise<Array<boolean>>,
  'updateProfileURI' : (arg_0: string) => Promise<Array<boolean>>,
  'verify' : (arg_0: Principal) => Promise<Array<boolean>>,
}
