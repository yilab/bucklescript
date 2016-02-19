(* BuckleScript compiler
 * Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*)

(* Author: Hongbo Zhang  *)



(** Creator utilities for the [J] module *) 






(** check if a javascript ast is constant 

    The better signature might be 
    {[
      J.expresssion -> Js_output.t
    ]}
    for exmaple
    {[
      e ?print_int(3) :  0
                         --->
                         if(e){print_int(3)}
    ]}
*)

val extract_non_pure : J.expression -> J.expression option

type binary_op =   ?comment:string -> J.expression -> J.expression -> J.expression 

type unary_op =  ?comment:string -> J.expression -> J.expression



type t = J.expression 

val mk :
  ?comment:string -> J.expression_desc -> t

val access : binary_op

val string_access : binary_op

val var : ?comment:string  -> J.ident -> t 

val runtime_var_dot : ?comment:string -> string -> string -> t

val runtime_var_vid : string -> string -> J.vident

val ml_var_dot : ?comment:string -> Ident.t -> string -> t

val external_var_dot : ?comment:string -> Ident.t -> string -> string -> t

val ml_var : ?comment:string -> Ident.t -> t

val runtime_call : ?comment:string -> string -> string -> t list -> t
val public_method_call : string -> t -> t -> int -> t list -> t
val runtime_ref : string -> string -> t

val str : ?pure:bool -> ?comment:string -> string -> t 

val fun_ : ?comment:string ->
  ?immutable_mask:bool array -> J.ident list -> J.block -> t

val econd : ?comment:string -> t -> t -> t -> t

val int : ?comment:string -> ?c:char ->  int -> t 

val float : ?comment:string -> string -> t

val zero_float_lit : t 
(** [is_out e range] is equivalent to [e > range or e <0]

*)
val is_out : binary_op
val dot : ?comment:string -> t -> string -> t

val array_length : unary_op

val string_length : unary_op

val string_of_small_int_array : unary_op

val bytes_length :  unary_op

val function_length : unary_op

val char_of_int : unary_op

val char_to_int : unary_op

val array_append : binary_op

val array_copy : unary_op
val string_append : binary_op
(**
   When in ES6 mode, we can use Symbol to guarantee its uniquess,
   we can not tag [js] object, since it can be frozen 
*)

val tag_ml_obj : unary_op

val var_dot : ?comment:string -> Ident.t -> string -> t

val js_global_dot : ?comment:string -> string -> string -> t

val index : ?comment:string -> t -> int -> t

val assign :  binary_op

val triple_equal : binary_op
(* TODO: reduce [triple_equal] use *)    

val float_equal : binary_op
val int_equal : binary_op
val string_equal : binary_op    
val is_type_number : unary_op
val typeof : unary_op

val to_int32 : unary_op
val to_uint32 : unary_op

val int32_add : binary_op
val int32_minus : binary_op
val int32_mul : binary_op
val int32_div : binary_op
val int32_lsl : binary_op
val int32_lsr : binary_op
val int32_asr : binary_op
val int32_mod : binary_op
val int32_bxor : binary_op
val int32_band : binary_op
val int32_bor : binary_op

val float_add : binary_op
val float_minus : binary_op
val float_mul : binary_op
val float_div : binary_op
val float_notequal : binary_op
val float_mod : binary_op  

val int_comp : Lambda.comparison -> binary_op
val string_comp : Js_op.binop -> binary_op
val float_comp :  Lambda.comparison -> binary_op

val bin : ?comment:string -> J.binop -> t -> t -> t

val not : t -> t

val call : ?comment:string  -> ?info:Js_call_info.t -> t -> t list -> t 

val flat_call : binary_op

val dump : ?comment:string -> Js_op.level -> t list -> t

val anything_to_string : unary_op
val int_to_string : unary_op
val to_json_string : unary_op

val new_ : ?comment:string -> J.expression -> J.expression list -> t

val arr : ?comment:string -> J.mutable_flag -> J.expression list -> t

val make_block : 
  ?comment:string ->
  J.expression -> J.tag_info -> J.expression list -> J.mutable_flag -> t

val uninitialized_object : 
  ?comment:string -> J.expression -> J.expression -> t

val uninitialized_array : unary_op

val seq : binary_op

val obj : ?comment:string -> J.property_map -> t 

val true_ : t 

val false_ : t

val bool : bool -> t

val unknown_lambda : ?comment:string -> Lambda.lambda -> t

val unit :  unit -> t
(** [unit] in ocaml will be compiled into [0]  in js *)

val js_var : ?comment:string -> string -> t

val js_global : ?comment:string -> string -> t

val undefined : t
val is_caml_block : ?comment:string -> t -> t
val math : ?comment:string -> string -> t list -> t
(** [math "abs"] --> Math["abs"] *)    

val inc : unary_op

val dec : unary_op

val prefix_inc : ?comment:string -> J.vident -> t

val prefix_dec : ?comment:string -> J.vident -> t

val null : ?comment:string -> unit -> t

val tag : ?comment:string -> J.expression -> t
val set_tag : ?comment:string -> J.expression -> J.expression -> t

(** Note that this is coupled with how we encode block, if we use the 
    `Object.defineProperty(..)` since the array already hold the length,
    this should be a nop 
*)

val set_length : ?comment:string -> J.expression -> J.expression -> t
val obj_length : ?comment:string -> J.expression -> t
val to_ocaml_boolean : unary_op

val and_ : binary_op
val or_ : binary_op

(** we don't expose a general interface, since a general interface is generally not safe *)
val is_instance_array  : unary_op
(** used combined with [caml_update_dummy]*)
val dummy_obj : ?comment:string ->  unit -> t 

(** convert a block to expresion by using IIFE *)    
val of_block : ?comment:string -> J.statement list -> J.expression -> t
