import type { Principal } from '@dfinity/principal';
export type Comment = [bigint, Principal, string];
export type PackedComment = [bigint, Comment];
export interface _SERVICE {
  'comment' : (arg_0: string, arg_1: string) => Promise<Array<boolean>>,
  'delete' : (arg_0: string, arg_1: bigint) => Promise<Array<boolean>>,
  'getComments' : (arg_0: string, arg_1: bigint) => Promise<
      Array<PackedComment>
    >,
  'reply' : (arg_0: string, arg_1: bigint, arg_2: string) => Promise<
      Array<boolean>
    >,
}
