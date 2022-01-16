import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'batchFilter' : (arg_0: Array<string>, arg_1: bigint) => Promise<
      Array<string>
    >,
  'exists' : (arg_0: string) => Promise<Array<boolean>>,
  'put' : (arg_0: string, arg_1: Array<string>) => Promise<Array<string>>,
  'remove' : (arg_0: string) => Promise<Array<boolean>>,
}
