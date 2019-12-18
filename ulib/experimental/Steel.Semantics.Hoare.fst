(*
   Copyright 2019 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
module Steel.Semantics.Hoare
module T = FStar.Tactics

(*
 * This module provides a semantic model for a combined effect of
 * divergence, state, and parallel composition of atomic actions.
 *
 * It also builds a generic separation-logic-style program logic
 * for this effect, in a partial correctness setting.

 * It is also be possible to give a variant of this semantics for
 * total correctness. However, we specifically focus on partial correctness
 * here so that this semantics can be instantiated with lock operations,
 * which may deadlock. See ParTot.fst for a total-correctness variant of
 * these semantics.
 *
 * The program logic is specified in the Hoare-style pre- and postconditions
 *   See Steel.Semantics.fst for the wp variant
 *)

#push-options "--using_facts_from '-* +Prims +FStar.Pervasives +Steel.Semantics.Hoare' \
  --fuel  0 \
  --ifuel 2 \
  --z3rlimit 20 \
  --__temp_no_proj Steel.Semantics.Hoare"


(**** Begin state defn ****)


/// We start by defining some basic notions for a commutative monoid.
///
/// We could reuse FStar.Algebra.CommMonoid, but this style with
/// quanitifers was more convenient for the proof done here.


let symmetry #a (equals: a -> a -> prop) =
  forall x y. {:pattern (x `equals` y)}
    x `equals` y ==> y `equals` x

let transitive #a (equals:a -> a -> prop) =
  forall x y z. x `equals` y /\ y `equals` z ==> x `equals` z

let associative #a (equals: a -> a -> prop) (f: a -> a -> a)=
  forall x y z.{:pattern f x (f y z) \/ f (f x y) z}
    f x (f y z) `equals` f (f x y) z

let commutative #a (equals: a -> a -> prop) (f: a -> a -> a) =
  forall x y.{:pattern f x y}
    f x y `equals` f y x

let is_unit #a (x:a) (equals: a -> a -> prop) (f:a -> a -> a) =
  forall y. {:pattern f x y \/ f y x}
    f x y `equals` y /\
    f y x `equals` y

let equals_ext #a (equals:a -> a -> prop) (f:a -> a -> a) =
  forall x1 x2 y. x1 `equals` x2 ==> f x1 y `equals` f x2 y

let fp_heap_0 (#heap:Type) (#hprop:Type)
              (interp:hprop -> heap -> prop)
              (pre:hprop)
    = h:heap{interp pre h}

let depends_only_on_0 (#heap:Type) (#hprop:Type)
                      (interp:hprop -> heap -> prop)
                      (disjoint: heap -> heap -> prop)
                      (join: (h0:heap -> h1:heap{disjoint h0 h1} -> heap))
                      (q:heap -> prop) (fp: hprop) =
  (forall (h0:fp_heap_0 interp fp) (h1:heap{disjoint h0 h1}). q h0 <==> q (join h0 h1))

let fp_prop_0 (#heap:Type) (#hprop:Type)
              (interp:hprop -> heap -> prop)
              (disjoint: heap -> heap -> prop)
              (join: (h0:heap -> h1:heap{disjoint h0 h1} -> heap))
              (fp:hprop) =
  p:(heap -> prop){p `(depends_only_on_0 interp disjoint join)` fp}

noeq
type st0 = {
  heap:Type u#1;
  mem:Type u#1;
  hprop:Type u#1;
  heap_of_mem: mem -> heap;
  locks_invariant: mem -> hprop;

  m_disjoint: mem -> heap -> prop;
  disjoint: heap -> heap -> prop;
  join: h0:heap -> h1:heap{disjoint h0 h1} -> heap;
  upd_joined_heap: (m:mem) -> (h:heap{m_disjoint m h}) -> mem;

  interp: hprop -> heap -> prop;

  emp:hprop;
  star: hprop -> hprop -> hprop;

  equals: hprop -> hprop -> prop;
}


/// disjointness is symmetric

let disjoint_sym (st:st0)
  = forall h0 h1. st.disjoint h0 h1 <==> st.disjoint h1 h0

let disjoint_join (st:st0)
  = forall m0 m1 m2.
       st.disjoint m1 m2 /\
       st.disjoint m0 (st.join m1 m2) ==>
       st.disjoint m0 m1 /\
       st.disjoint m0 m2 /\
       st.disjoint (st.join m0 m1) m2 /\
       st.disjoint (st.join m0 m2) m1

let join_commutative (st:st0 { disjoint_sym st })
  = forall m0 m1.
      st.disjoint m0 m1 ==>
      st.join m0 m1 == st.join m1 m0

let join_associative (st:st0{disjoint_join st})
  = forall m0 m1 m2.
      st.disjoint m1 m2 /\
      st.disjoint m0 (st.join m1 m2) ==>
      st.join m0 (st.join m1 m2) == st.join (st.join m0 m1) m2

////////////////////////////////////////////////////////////////////////////////

let interp_extensionality #r #s (equals:r -> r -> prop) (f:r -> s -> prop) =
  forall x y h. {:pattern equals x y; f x h} equals x y /\ f x h ==> f y h

let affine (st:st0) =
  forall r0 r1 s. {:pattern (st.interp (r0 `st.star` r1) s) }
    st.interp (r0 `st.star` r1) s ==> st.interp r0 s

let emp_valid (st:st0) =
  forall s.{:pattern st.interp st.emp s}
    st.interp st.emp s

////////////////////////////////////////////////////////////////////////////////

let depends_only_on (#st:st0) (q:st.heap -> prop) (fp: st.hprop) =
  depends_only_on_0 st.interp st.disjoint st.join q fp

let weaken_depends_only_on (st:st0)
  = forall (q:st.heap -> prop) (fp fp': st.hprop).
      depends_only_on q fp ==>
      depends_only_on q (fp `st.star` fp')

let fp_prop (#st:st0) (fp:st.hprop) =
  fp_prop_0 st.interp st.disjoint st.join fp

let lemma_weaken_depends_only_on (#st:st0{weaken_depends_only_on st})
       (fp0 fp1:st.hprop)
       (q:fp_prop fp0)
  : Lemma (q `depends_only_on` (fp0 `st.star` fp1))
  = ()

let interp_depends_only (st:st0) =
  forall p. st.interp p `depends_only_on` p

let m_implies_disjoint (st:st0) =
  forall (m:st.mem) (h1:st.heap).
       st.m_disjoint m h1 ==> st.disjoint (st.heap_of_mem m) h1

let mem_valid_locks_invariant (st:st0) =
  forall (m:st.mem). st.interp (st.locks_invariant m) (st.heap_of_mem m)

let valid_upd_heap (st:st0{m_implies_disjoint st}) =
  forall (m:st.mem) (h:st.heap{st.m_disjoint m h}).
               st.heap_of_mem (st.upd_joined_heap m h) == st.join (st.heap_of_mem m) h /\
               st.locks_invariant m == st.locks_invariant (st.upd_joined_heap m h)

////////////////////////////////////////////////////////////////////////////////
let st_laws (st:st0) =
    (* standard laws about the equality relation *)
    symmetry st.equals /\
    transitive st.equals /\
    interp_extensionality st.equals st.interp /\
    interp_depends_only st /\
    (* standard laws for star forming a CM *)
    associative st.equals st.star /\
    commutative st.equals st.star /\
    is_unit st.emp st.equals st.star /\
    equals_ext st.equals st.star /\
    (* We're working in an affine interpretation of SL *)
    affine st /\
    emp_valid st /\
    (* laws about disjoint and join *)
    disjoint_sym st /\
    disjoint_join st /\
    join_commutative st /\
    join_associative st /\
    weaken_depends_only_on st /\
    (* Relations between mem and heap *)
    m_implies_disjoint st /\
    mem_valid_locks_invariant st /\
    valid_upd_heap st

let st = s:st0 { st_laws s }


(**** End state defn ****)


(**** Begin expects, provides, requires, and ensures defns ****)


/// expects (the heap assertion expected by a computation) is simply an st.hprop
///
/// provides, or the post heap assertion, is a st.hprop on [a]-typed result

let post (st:st) (a:Type) = a -> st.hprop



/// requires is a heap predicate that depends only on a pre heap assertion
///   (where the notion of `depends only on` is defined above as part of the state definition)
///
/// we call the type l_pre for logical precondition

let l_pre (#st:st) (pre:st.hprop) = fp_prop pre


/// ensures is a 2-state postcondition of type heap -> a -> heap -> prop
///
/// To define ensures, we need a notion of depends_only_on_2
///
/// Essentially, in the first heap argument, postconditions depend only on the expects hprop
///   and in the second heap argument, postconditions depend only on the provides hprop
///
/// Also note that the support for depends_only_on_2 is not required from the underlying memory model


let depends_only_on_0_2 (#a:Type) (#heap:Type) (#hprop:Type)
  (interp:hprop -> heap -> prop)
  (disjoint:heap -> heap -> prop)
  (join:(h0:heap -> h1:heap{disjoint h0 h1} -> heap))
  (q:heap -> a -> heap -> prop) (fp_pre:hprop) (fp_post:a -> hprop)

= //can join any disjoint heap to the pre-heap and q is still valid
  (forall x (h_pre:fp_heap_0 interp fp_pre) h_post (h:heap{disjoint h_pre h}).
     q h_pre x h_post <==> q (join h_pre h) x h_post) /\

  //can join any disjoint heap to the post-heap and q is still valid
  (forall x h_pre (h_post:fp_heap_0 interp (fp_post x)) (h:heap{disjoint h_post h}).
     q h_pre x h_post <==> q h_pre x (join h_post h))


/// Abbreviations for two-state depends

let fp_prop_0_2 (#a:Type) (#heap #hprop:Type)
  (interp:hprop -> heap -> prop)
  (disjoint:heap -> heap -> prop)
  (join:(h0:heap -> h1:heap{disjoint h0 h1} -> heap))
  (fp_pre:hprop) (fp_post:a -> hprop) =

  q:(heap -> a -> heap -> prop){depends_only_on_0_2 interp disjoint join q fp_pre fp_post}

let depends_only_on2 (#st:st0) (#a:Type) (q:st.heap -> a -> st.heap -> prop) (fp_pre:st.hprop) (fp_post:a -> st.hprop) =
  depends_only_on_0_2 st.interp st.disjoint st.join q fp_pre fp_post

let fp_prop2 (#st:st0) (#a:Type) (fp_pre:st.hprop) (fp_post:a -> st.hprop) =
  q:(st.heap -> a -> st.heap -> prop){depends_only_on2 q fp_pre fp_post}


/// Finally the type of 2-state postconditions

let l_post (#st:st) (#a:Type) (pre:st.hprop) (post:post st a) = fp_prop2 pre post


(**** End expects, provides, requires, and ensures defns ****)


/// An abbreviation

let hmem (#st:st) (fp:st.hprop) =
  m:st.mem{st.interp (st.locks_invariant m `st.star` fp) (st.heap_of_mem m)}


(**** Begin interface of actions ****)


let action0 (#st:st) (pre:st.hprop) (a:Type) (post:a -> st.hprop) =
  hmem pre -> (x:a & hmem (post x))


/// Actions preserve frames AND all fp_props of frames

let is_frame_preserving (#st:st) #a #pre #post (f:action0 pre a post) =
  forall frame (h0:hmem (pre `st.star` frame)).  //we don't need locks_invariant for h0?
    (let (| x, h1 |) = f h0 in
     st.interp (post x `st.star` frame `st.star` st.locks_invariant h1) (st.heap_of_mem h1) /\
     (forall (f_frame:fp_prop frame). f_frame (st.heap_of_mem h0) <==> f_frame (st.heap_of_mem h1)))

let action_depends_only_on_fp (#st:st) (#pre:st.hprop) #a #post (f:action0 pre a post)
  = forall (m0:hmem pre)
      (h1:st.heap {st.m_disjoint m0 h1})
      (post: (x:a -> fp_prop (post x))).
      (let m1 = st.upd_joined_heap m0 h1 in
       let (| x0, m |) = f m0 in
       let (| x1, m' |) = f m1 in
       x0 == x1 /\
       (post x0 (st.heap_of_mem m) <==> post x1 (st.heap_of_mem m')))

let action_t (#st:st) (fp:st.hprop) (a:Type) (fp':a -> st.hprop) =
  f:action0 fp a fp'{
    is_frame_preserving f /\
    action_depends_only_on_fp f
  }


(**** End interface of actions ****)


(**** Begin definition of the computation AST ****)


/// Gadgets for building lpre- and lpostconditions for various nodes


/// Return node is parametric in provides and ensures

let return_lpre (#st:st) (#a:Type) (#post:post st a) (x:a) (lpost:l_post (post x) post)
: l_pre (post x)
= fun h -> lpost h x h


/// Actions don't have a separate logical payload

let action_lpre (#st:st) (#a:Type) (#pre:st.hprop) (#post:post st a) (_:action_t pre a post)
: l_pre pre
= st.interp pre

let action_lpost (#st:st) (#a:Type) (#pre:st.hprop) (#post:post st a) (_:action_t pre a post)
: l_post pre post
= fun h0 x h1 -> st.interp (post x) h1


let frame_lpre (#st:st) (#pre:st.hprop) (lpre:l_pre pre) (#frame:st.hprop) (f_frame:fp_prop frame)
: l_pre (pre `st.star` frame)
= fun h -> lpre h /\ f_frame h

let frame_lpost (#st:st) (#a:Type) (#pre:st.hprop) (#post:post st a) (lpre:l_pre pre) (lpost:l_post pre post)
  (#frame:st.hprop) (f_frame:fp_prop frame)
: l_post (pre `st.star` frame) (fun x -> post x `st.star` frame)
= fun h0 x h1 -> lpre h0 /\ lpost h0 x h1 /\ f_frame h1


/// The bind rule bakes in weakening of requires / ensures

let bind_lpre (#st:st) (#a:Type) (#pre:st.hprop) (#post_a:post st a)
  (lpre_a:l_pre pre) (lpost_a:l_post pre post_a)
  (lpre_b:(x:a -> l_pre (post_a x)))
: l_pre pre
= fun h -> lpre_a h /\ (forall (x:a) h1. lpost_a h x h1 ==> lpre_b x h1)

let bind_lpost (#st:st) (#a:Type) (#pre:st.hprop) (#post_a:post st a)
  (lpre_a:l_pre pre) (lpost_a:l_post pre post_a)
  (#b:Type) (#post_b:post st b)
  (lpost_b:(x:a -> l_post (post_a x) post_b))
: l_post pre post_b
= fun h0 y h2 -> lpre_a h0 /\ (exists x h1. lpost_a h0 x h1 /\ (lpost_b x) h1 y h2)


/// Parallel composition is pointwise

let par_lpre (#st:st) (#preL:st.hprop) (lpreL:l_pre preL)
  (#preR:st.hprop) (lpreR:l_pre preR)
: l_pre (preL `st.star` preR)
= fun h -> lpreL h /\ lpreR h

let par_lpost (#st:st) (#aL:Type) (#preL:st.hprop) (#postL:post st aL)
  (lpreL:l_pre preL) (lpostL:l_post preL postL)
  (#aR:Type) (#preR:st.hprop) (#postR:post st aR)
  (lpreR:l_pre preR) (lpostR:l_post preR postR)
: l_post (preL `st.star` preR) (fun (xL, xR) -> postL xL `st.star` postR xR)
= fun h0 (xL, xR) h1 -> lpreL h0 /\ lpreR h0 /\ lpostL h0 xL h1 /\ lpostR h0 xR h1


noeq
type m (st:st) : (a:Type u#a) -> pre:st.hprop -> post:post st a -> l_pre pre -> l_post pre post -> Type =
  | Ret:
    #a:Type ->
    post:post st a ->
    x:a ->
    lpost:l_post (post x) post ->
    m st a (post x) post (return_lpre #_ #_ #post x lpost) lpost

  | Act:
    #a:Type ->
    pre:st.hprop ->
    post:post st a ->
    f:action_t pre a post ->
    m st a pre post (action_lpre f) (action_lpost f)

  | Bind:
    #a:Type ->
    #pre:st.hprop ->
    #post_a:post st a ->
    #lpre_a:l_pre pre ->
    #lpost_a:l_post pre post_a ->
    #b:Type ->
    #post_b:post st b ->
    #lpre_b:(x:a -> l_pre (post_a x)) ->
    #lpost_b:(x:a -> l_post (post_a x) post_b) ->
    f:m st a pre post_a lpre_a lpost_a ->
    g:(x:a -> Dv (m st b (post_a x) post_b (lpre_b x) (lpost_b x))) ->
    m st b pre post_b
      (bind_lpre lpre_a lpost_a lpre_b)
      (bind_lpost lpre_a lpost_a lpost_b)

  | Frame:
    #a:Type ->
    #pre:st.hprop ->
    #post:post st a ->
    #lpre:l_pre pre ->
    #lpost:l_post pre post ->
    f:m st a pre post lpre lpost ->
    frame:st.hprop ->
    f_frame:fp_prop frame ->
    m st a (pre `st.star` frame) (fun x -> post x `st.star` frame)
      (frame_lpre lpre f_frame)
      (frame_lpost lpre lpost f_frame)

  | Par:
    #aL:Type ->
    #preL:st.hprop ->
    #postL:post st aL ->
    #lpreL:l_pre preL ->
    #lpostL:l_post preL postL ->
    mL:m st aL preL postL lpreL lpostL ->
    #aR:Type ->
    #preR:st.hprop ->
    #postR:post st aR ->
    #lpreR:l_pre preR ->
    #lpostR:l_post preR postR ->
    mR:m st aR preR postR lpreR lpostR ->
    m st (aL & aR) (preL `st.star` preR) (fun (xL, xR) -> postL xL `st.star` postR xR)
      (par_lpre lpreL lpreR)
      (par_lpost lpreL lpostL lpreR lpostR)

  | Weaken:
    #a:Type ->
    #pre:st.hprop ->
    #post:post st a ->
    #lpre:l_pre pre ->
    #lpost:l_post pre post ->
    #wlpre:l_pre pre ->
    #wlpost:l_post pre post ->
    #_:squash
      ((forall h. wlpre h ==> lpre h) /\
       (forall h0 x h1. lpost h0 x h1 ==> wlpost h0 x h1)) ->
    m st a pre post lpre lpost ->
    m st a pre post wlpre wlpost


(**** End definition of the computation AST ****)


(**** Stepping relation ****)


/// All steps preserve frames and their fp props

noeq
type step_result (#st:st) a (q:post st a) (frame:st.hprop) =
  | Step:
    old_state:st.mem ->
    fpost:st.hprop ->
    new_state:hmem (fpost `st.star` frame){
      forall (f_frame:fp_prop frame).
         f_frame (st.heap_of_mem old_state) <==>
         f_frame (st.heap_of_mem new_state)} ->
    lpre:l_pre fpost{lpre (st.heap_of_mem new_state)} ->
    lpost:l_post fpost q ->
    m st a fpost q lpre lpost ->
    nat ->
    step_result a q frame


(**** Type of the single-step interpreter ****)


/// Interpreter is setup as a Div function from computation trees to computation trees
///
/// While the requires for the Div is standard (that the expects hprop holds and requires is valid),
///   the ensures is interesting
///
/// As the computation evolves, the requires and ensures associated with the computation graph nodes
///   also evolve
/// But they evolve systematically: preconditions become weaker and postconditions become stronger
///
/// Consider { req } c | st { ens }  ~~> { req1 } c1 | st1 { ens1 }
///
/// Then, req st ==> req1 st1  /\
///       (forall x st_final. ens1 st1 x st_final ==> ens st x st_final)


unfold
let step_req (#st:st)
  (#a:Type) (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost)
  (state:st.mem)
= st.interp
    (st.locks_invariant state `st.star` pre `st.star` frame)
    (st.heap_of_mem state) /\
  lpre (st.heap_of_mem state)

let weaker_pre (#st:st)
  (#pre:st.hprop) (lpre:l_pre pre)
  (#next_pre:st.hprop) (next_lpre:l_pre next_pre)
  (state next_state:st.mem)
= lpre (st.heap_of_mem state) ==> next_lpre (st.heap_of_mem next_state)

let stronger_post (#st:st) (#a:Type)
  (#pre:st.hprop) (#post:post st a)
  (lpost:l_post pre post)
  (#next_pre:st.hprop) (next_lpost:l_post next_pre post)
  (state next_state:st.mem)
= forall (x:a) (h_final:st.heap).
    next_lpost (st.heap_of_mem next_state) x h_final ==>
    lpost (st.heap_of_mem state) x h_final                         

unfold
let step_ens (#st:st)
  (#a:Type) (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost)
  (state:st.mem)
: step_result a post frame -> Type0
= fun r ->
  let Step state1 next_pre next_state next_lpre next_lpost _post _frame = r in
  state1 == state /\
  weaker_pre lpre next_lpre state next_state /\
  stronger_post lpost next_lpost state next_state


/// The type of the stepping function

unfold
let step_t =
  #st:st -> i:nat ->
  #a:Type -> #pre:st.hprop -> #post:post st a -> #lpre:l_pre pre -> #lpost:l_post pre post ->
  frame:st.hprop ->
  f:m st a pre post lpre lpost ->
  state:st.mem ->
  Div (step_result a post frame)
      (step_req frame f state)
      (step_ens frame f state)


(**** Auxiliary lemmas ****)


let equals_ext_right (#st:st) (p q r:st.hprop)
: Lemma
  (requires q `st.equals` r)
  (ensures (p `st.star` q) `st.equals` (p `st.star` r))
= calc (st.equals) {
    p `st.star` q;
       (st.equals) { }
    q `st.star` p;
       (st.equals) { }
    r `st.star` p;
       (st.equals) { }
    p `st.star` r;
  }

let ac_reasoning_for_frame (#st:st) (p q r s:st.hprop)
: Lemma
  (((p `st.star` (q `st.star` r)) `st.star` s) `st.equals`
   ((p `st.star` q) `st.star` (r `st.star` s)))
= calc (st.equals) {
    (p `st.star` (q `st.star` r)) `st.star` s;
       (st.equals) { }
    ((p `st.star` q) `st.star` r) `st.star` s;
       (st.equals) { }
    (p `st.star` q) `st.star` (r `st.star` s);
   }

let frame_fp_props_for_frame (#st:st) (frame frame':st.hprop) (f_frame':fp_prop frame')
  (state next_state:st.mem)
: Lemma
  (requires
    f_frame' (st.heap_of_mem state) /\
    (forall (hp:fp_prop (frame' `st.star` frame)).
       hp (st.heap_of_mem state) <==> hp (st.heap_of_mem next_state)))
  (ensures
    f_frame' (st.heap_of_mem next_state) /\
    (forall (hp:fp_prop frame).
       hp (st.heap_of_mem state) <==> hp (st.heap_of_mem next_state)))
= ()

let ac_reasoning_for_par_right (#st:st) (p q r s:st.hprop)
: Lemma
  (((p `st.star` (q `st.star` r)) `st.star` s) `st.equals`
   ((p `st.star` r) `st.star` (q `st.star` s)))
= calc (st.equals) {
    (p `st.star` (q `st.star` r)) `st.star` s;
       (st.equals) { equals_ext_right p (q `st.star` r) (r `st.star` q) }
    (p `st.star` (r `st.star` q)) `st.star` s;
       (st.equals) { }
    ((p `st.star` r) `st.star` q) `st.star` s;
       (st.equals) { }
    (p `st.star` r) `st.star` (q `st.star` s);
  }

/// Lemma frame_post_for_par is used in the par proof
///
/// E.g. in the par rule, when L takes a step, we can frame the requires of R
///   by adding it to the frame used in the stepping relation
///
/// However we also need to frame the ensures of R, basically, we need:
///
/// forall x h_final. postR old_state x h_final <==> postR next_state x h_final
///
/// (the proof only requires the reverse implication, but we can prove iff)
///
/// To prove this, we rely on the framing of all frame fp props provides by the stepping relation
///
/// To use it, we instantiate the fp prop with inst_heap_prop_for_par


let inst_heap_prop_for_par (#st:st) (#a:Type) (#pre:st.hprop) (#post:post st a)
  (lpost:l_post pre post)
  (state:st.mem)
: fp_prop pre
= fun h ->
  forall x final_state. lpost h x final_state <==>
                   lpost (st.heap_of_mem state) x final_state

let frame_post_for_par (#st:st)
  (#a:Type) (#pre:st.hprop) (#post:post st a)
  (lpre:l_pre pre) (lpost:l_post pre post)
  (frame:st.hprop) (m0 m1:st.mem)
: Lemma
  (requires
    forall (f_frame:fp_prop (pre `st.star` frame)).
      f_frame (st.heap_of_mem m0) <==> f_frame (st.heap_of_mem m1))
  (ensures
    forall (x:a) (final_state:st.heap).
      lpost (st.heap_of_mem m0) x final_state <==>
      lpost (st.heap_of_mem m1) x final_state)
= let inst : fp_prop (pre `st.star` frame) =
    inst_heap_prop_for_par lpost m0 in
  ()


/// Finally lemmas for proving that in the par rules preconditions get weaker
///   and postconditions get stronger

let par_weaker_pre_and_stronger_post_l (#st:st) (#preL:st.hprop) (lpreL:l_pre preL)
  (#aL:Type) (#postL:post st aL) (lpostL:l_post preL postL)
  (#next_preL:st.hprop) (next_lpreL:l_pre next_preL) (next_lpostL:l_post next_preL postL)
  (#preR:st.hprop) (lpreR:l_pre preR)
  (#aR:Type) (#postR:post st aR) (lpostR:l_post preR postR)
  (frame:st.hprop)
  (state next_state:st.mem)
: Lemma
  (requires
    weaker_pre lpreL next_lpreL state next_state /\
    stronger_post lpostL next_lpostL state next_state /\
    (forall (f_frame:fp_prop (preR `st.star` frame)).
       f_frame (st.heap_of_mem state) <==> f_frame (st.heap_of_mem next_state)) /\
    lpreL (st.heap_of_mem state) /\
    lpreR (st.heap_of_mem state))
  (ensures
    (forall (f_frame:fp_prop frame).
       f_frame (st.heap_of_mem state) <==> f_frame (st.heap_of_mem next_state)) /\
    weaker_pre
      (par_lpre lpreL lpreR)
      (par_lpre next_lpreL lpreR)
      state next_state /\
    stronger_post
      (par_lpost lpreL lpostL lpreR lpostR)
      (par_lpost next_lpreL next_lpostL lpreR lpostR)
      state next_state)
= frame_post_for_par lpreR lpostR frame state next_state


let par_weaker_pre_and_stronger_post_r (#st:st) (#preL:st.hprop) (lpreL:l_pre preL)
  (#aL:Type) (#postL:post st aL) (lpostL:l_post preL postL)
  (#preR:st.hprop) (lpreR:l_pre preR)
  (#aR:Type) (#postR:post st aR) (lpostR:l_post preR postR)
  (#next_preR:st.hprop) (next_lpreR:l_pre next_preR)
  (next_lpostR:l_post next_preR postR)
  (frame:st.hprop)
  (state next_state:st.mem)
: Lemma
  (requires
    weaker_pre lpreR next_lpreR state next_state /\
    stronger_post lpostR next_lpostR state next_state /\
    (forall (f_frame:fp_prop (preL `st.star` frame)).
       f_frame (st.heap_of_mem state) <==> f_frame (st.heap_of_mem next_state)) /\
    lpreR (st.heap_of_mem state) /\
    lpreL (st.heap_of_mem state))
  (ensures
    (forall (f_frame:fp_prop frame).
       f_frame (st.heap_of_mem state) <==> f_frame (st.heap_of_mem next_state)) /\
    weaker_pre
      (par_lpre lpreL lpreR)
      (par_lpre lpreL next_lpreR)
      state next_state /\
    stronger_post
      (par_lpost lpreL lpostL lpreR lpostR)
      (par_lpost lpreL lpostL next_lpreR next_lpostR)
      state next_state)
= frame_post_for_par lpreL lpostL frame state next_state


(**** Begin stepping functions ****)

let step_ret (#st:st) (i:nat) (#a:Type)
  (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost{Ret? f})
  (state:st.mem)

: Div (step_result a post frame) (step_req frame f state) (step_ens frame f state)

= let Ret p x lp = f in
  Step state (p x) state lpre lpost f i


let step_act (#st:st) (i:nat)
  (#a:Type) (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost{Act? f})
  (state:st.mem)

: Div (step_result a post frame) (step_req frame f state) (step_ens frame f state)

= let Act pre post f = f in
  let (| x, new_state |) = f state in

  let lpost : l_post (post x) post = fun _ x h1 -> st.interp (post x) h1 in
  Step state (post x) new_state (fun h -> lpost h x h) lpost (Ret post x lpost) i


let step_bind (#st:st) (i:nat)
  (#a:Type) (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost{Bind? f})
  (state:st.mem)
  (step:step_t)

: Div (step_result a post frame) (step_req frame f state) (step_ens frame f state)

= match f with
  | Bind #_ #_ #_ #_ #_ #_ #_ #_ #lpre_b #lpost_b (Ret p x _) g ->
    Step state (p x) state (lpre_b x) (lpost_b x) (g x) i

  | Bind #_ #_ #_ #_ #_ #_ #_ #_ #lpre_b #lpost_b f g ->
    let Step _ next_pre next_state next_lpre next_lpost f j = step i frame f state in
    
    Step state next_pre next_state
      (bind_lpre next_lpre next_lpost lpre_b)
      (bind_lpost next_lpre next_lpost lpost_b)
      (Bind f g)
      j

let step_frame (#st:st) (i:nat)
  (#a:Type) (#pre:st.hprop) (#p:post st a) (#lpre:l_pre pre) (#lpost:l_post pre p)
  (frame:st.hprop)
  (f:m st a pre p lpre lpost{Frame? f})
  (state:st.mem)
  (step:step_t)

: Div (step_result a p frame) (step_req frame f state) (step_ens frame f state)

= match f with  
  | Frame (Ret p x lp) frame f_frame ->
    Step state (p x `st.star` frame) state
      (fun h -> lpost h x h)
      lpost
      (Ret (fun x -> p x `st.star` frame) x lpost)
      i

  | Frame #_ #_ #f_pre #_ #f_lpre #f_lpost f frame' f_frame' ->
    ac_reasoning_for_frame (st.locks_invariant state) f_pre frame' frame;

    let Step state next_fpre next_state next_flpre next_flpost f j = step i (frame' `st.star` frame) f state in
    
    ac_reasoning_for_frame (st.locks_invariant next_state) next_fpre frame' frame;

    frame_fp_props_for_frame frame frame' f_frame' state next_state;

    Step state (next_fpre `st.star` frame') next_state
      (frame_lpre next_flpre f_frame')
      (frame_lpost next_flpre next_flpost f_frame')
      (Frame f frame' f_frame')
      j


/// Stream of booleans to decide whether we go left or right

assume val go_left : nat -> bool

let step_par (#st:st) (i:nat)
  (#a:Type) (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost{Par? f})
  (state:st.mem)
  (step:step_t)

: Div (step_result a post frame) (step_req frame f state) (step_ens frame f state)

= match f with
  | Par #_ #aL #_ #_ #_ #_ (Ret pL xL lpL) #aR #_ #_ #_ #_ (Ret pR xR lpR) ->

    let lpost : l_post #st #(aL & aR) _ _ = fun h0 (xL, xR) h1 -> lpL h0 xL h1 /\ lpR h0 xR h1 in

    Step state (pL xL `st.star` pR xR) state
      (fun h -> lpL h xL h /\ lpR h xR h)
      lpost 
      (Ret (fun (xL, xR) -> pL xL `st.star` pR xR) (xL, xR) lpost)
      i

  | Par #_ #aL #preL #postL #lpreL #lpostL mL #aR #preR #postR #lpreR #lpostR mR ->
    if go_left i then begin
      ac_reasoning_for_frame (st.locks_invariant state) preL preR frame;

      let Step state next_preL next_state next_lpreL next_lpostL mL j = step (i + 1) (preR `st.star` frame) mL state in

      ac_reasoning_for_frame (st.locks_invariant next_state) next_preL preR frame;

      par_weaker_pre_and_stronger_post_l lpreL lpostL next_lpreL next_lpostL lpreR lpostR frame state next_state;

      Step state (next_preL `st.star` preR) next_state
        (par_lpre next_lpreL lpreR)
        (par_lpost next_lpreL next_lpostL lpreR lpostR)
        (Par mL mR)
        j
    end
    else begin
      ac_reasoning_for_par_right (st.locks_invariant state) preL preR frame;

      let Step state next_preR next_state next_lpreR next_lpostR mR j = step (i + 1) (preL `st.star` frame) mR state in

      ac_reasoning_for_par_right (st.locks_invariant next_state) preL next_preR frame;
    
      par_weaker_pre_and_stronger_post_r lpreL lpostL lpreR lpostR next_lpreR next_lpostR frame state next_state;

      Step state (preL `st.star` next_preR) next_state
        (par_lpre lpreL next_lpreR)
        (par_lpost lpreL lpostL next_lpreR next_lpostR)
        (Par mL mR)
        j
    end

let step_weaken (#st:st) (i:nat) (#a:Type)
  (#pre:st.hprop) (#post:post st a) (#lpre:l_pre pre) (#lpost:l_post pre post)
  (frame:st.hprop)
  (f:m st a pre post lpre lpost{Weaken? f})
  (state:st.mem)

: Div (step_result a post frame) (step_req frame f state) (step_ens frame f state)

= let Weaken #_ #_ #pre #post #lpre #lpost #_ #_ #_ f = f in

  Step state pre state lpre lpost f i


/// Step function

let rec step : step_t =
  fun #st i #a #pre #post #o_lpre #o_lpost frame f state ->
  match f with
  | Ret _ _ _   ->    step_ret i frame f state
  | Act _ _ _   ->    step_act i frame f state
  | Bind _ _    ->   step_bind i frame f state step
  | Frame _ _ _ ->  step_frame i frame f state step
  | Par _ _     ->    step_par i frame f state step
  | Weaken _    -> step_weaken i frame f state


/// Top-level run function

let rec run (#st:st) (i:nat) (#a:Type) (#pre:st.hprop) (#post:post st a)
  (#lpre:l_pre pre) (#lpost:l_post pre post)
  (f:m st a pre post lpre lpost)
  (state:st.mem)
: Div (a & st.mem)
  (requires
    st.interp (st.locks_invariant state `st.star` pre) (st.heap_of_mem state) /\
    lpre (st.heap_of_mem state))
  (ensures fun (x, new_state) ->
    st.interp (st.locks_invariant new_state `st.star` post x) (st.heap_of_mem new_state) /\
    lpost (st.heap_of_mem state) x (st.heap_of_mem new_state))
= match f with
  | Ret _ x _ -> x, state

  | _ ->
    let Step _ _ state _ _ f j = step i st.emp f state in
    run j f state


(**** Trying to define the layered effect ****)

type repr (a:Type) (st:st) (pre:st.hprop) (post:post st a) (lpre:l_pre pre) (lpost:l_post pre post)
= unit -> m st a pre post lpre lpost


/// This will not be allowed currently as the extra binders must appear before x in the implementation, can change

let return (a:Type) (st:st) (post:post st a) (lpost:(x:a -> l_post (post x) post)) (x:a)
: repr a st (post x) post (fun h -> (lpost x) h x h) (lpost x)
= fun _ -> Ret post x (lpost x)

let bind (a:Type) (b:Type) (st:st)
  (pre_f:st.hprop) (post_f:post st a) (lpre_f:l_pre pre_f) (lpost_f:l_post pre_f post_f)
  (post_g:post st b) (lpre_g:(x:a -> l_pre (post_f x))) (lpost_g:(x:a -> l_post (post_f x) post_g))
  (f:repr a st pre_f post_f lpre_f lpost_f)
  (g:(x:a -> repr b st (post_f x) post_g (lpre_g x) (lpost_g x)))
: repr b st pre_f post_g
    (bind_lpre lpre_f lpost_f lpre_g)
    (bind_lpost lpre_f lpost_f lpost_g)
= fun _ -> Bind (f ()) (fun x -> g x ())

let subcomp (a:Type) (st:st)
  (pre:st.hprop) (post:post st a)
  (lpre_f:l_pre pre) (lpost_f:l_post pre post)
  (lpre_g:l_pre pre) (lpost_g:l_post pre post)
  (f:repr a st pre post lpre_f lpost_f)
: Pure (repr a st pre post lpre_g lpost_g)
  (requires
    (forall h. lpre_g h ==> lpre_f h) /\
    (forall h0 x h1. lpost_f h0 x h1 ==> lpost_g h0 x h1))
  (ensures fun _ -> True)
= fun _ -> Weaken #_ #a #pre #post #lpre_f #lpost_f #lpre_g #lpost_g #() (f ())