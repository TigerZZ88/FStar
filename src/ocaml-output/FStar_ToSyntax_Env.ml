
open Prims

type local_binding =
(FStar_Ident.ident * FStar_Syntax_Syntax.bv * Prims.bool)


type rec_binding =
(FStar_Ident.ident * FStar_Ident.lid * FStar_Syntax_Syntax.delta_depth)


type module_abbrev =
(FStar_Ident.ident * FStar_Ident.lident)

type open_kind =
| Open_module
| Open_namespace


let uu___is_Open_module : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_module -> begin
true
end
| uu____12 -> begin
false
end))


let uu___is_Open_namespace : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_namespace -> begin
true
end
| uu____16 -> begin
false
end))


type open_module_or_namespace =
(FStar_Ident.lident * open_kind)

type record_or_dc =
{typename : FStar_Ident.lident; constrname : FStar_Ident.ident; parms : FStar_Syntax_Syntax.binders; fields : (FStar_Ident.ident * FStar_Syntax_Syntax.typ) Prims.list; is_private_or_abstract : Prims.bool; is_record : Prims.bool}

type scope_mod =
| Local_binding of local_binding
| Rec_binding of rec_binding
| Module_abbrev of module_abbrev
| Open_module_or_namespace of open_module_or_namespace
| Top_level_def of FStar_Ident.ident
| Record_or_dc of record_or_dc


let uu___is_Local_binding : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Local_binding (_0) -> begin
true
end
| uu____92 -> begin
false
end))


let __proj__Local_binding__item___0 : scope_mod  ->  local_binding = (fun projectee -> (match (projectee) with
| Local_binding (_0) -> begin
_0
end))


let uu___is_Rec_binding : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Rec_binding (_0) -> begin
true
end
| uu____104 -> begin
false
end))


let __proj__Rec_binding__item___0 : scope_mod  ->  rec_binding = (fun projectee -> (match (projectee) with
| Rec_binding (_0) -> begin
_0
end))


let uu___is_Module_abbrev : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Module_abbrev (_0) -> begin
true
end
| uu____116 -> begin
false
end))


let __proj__Module_abbrev__item___0 : scope_mod  ->  module_abbrev = (fun projectee -> (match (projectee) with
| Module_abbrev (_0) -> begin
_0
end))


let uu___is_Open_module_or_namespace : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_module_or_namespace (_0) -> begin
true
end
| uu____128 -> begin
false
end))


let __proj__Open_module_or_namespace__item___0 : scope_mod  ->  open_module_or_namespace = (fun projectee -> (match (projectee) with
| Open_module_or_namespace (_0) -> begin
_0
end))


let uu___is_Top_level_def : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Top_level_def (_0) -> begin
true
end
| uu____140 -> begin
false
end))


let __proj__Top_level_def__item___0 : scope_mod  ->  FStar_Ident.ident = (fun projectee -> (match (projectee) with
| Top_level_def (_0) -> begin
_0
end))


let uu___is_Record_or_dc : scope_mod  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Record_or_dc (_0) -> begin
true
end
| uu____152 -> begin
false
end))


let __proj__Record_or_dc__item___0 : scope_mod  ->  record_or_dc = (fun projectee -> (match (projectee) with
| Record_or_dc (_0) -> begin
_0
end))


type string_set =
Prims.string FStar_Util.set

type exported_id_kind =
| Exported_id_term_type
| Exported_id_field


let uu___is_Exported_id_term_type : exported_id_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Exported_id_term_type -> begin
true
end
| uu____164 -> begin
false
end))


let uu___is_Exported_id_field : exported_id_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Exported_id_field -> begin
true
end
| uu____168 -> begin
false
end))


type exported_id_set =
exported_id_kind  ->  string_set FStar_ST.ref

type env =
{curmodule : FStar_Ident.lident Prims.option; curmonad : FStar_Ident.ident Prims.option; modules : (FStar_Ident.lident * FStar_Syntax_Syntax.modul) Prims.list; scope_mods : scope_mod Prims.list; exported_ids : exported_id_set FStar_Util.smap; trans_exported_ids : exported_id_set FStar_Util.smap; includes : FStar_Ident.lident Prims.list FStar_ST.ref FStar_Util.smap; sigaccum : FStar_Syntax_Syntax.sigelts; sigmap : (FStar_Syntax_Syntax.sigelt * Prims.bool) FStar_Util.smap; iface : Prims.bool; admitted_iface : Prims.bool; expect_typ : Prims.bool}

type foundname =
| Term_name of (FStar_Syntax_Syntax.typ * Prims.bool)
| Eff_name of (FStar_Syntax_Syntax.sigelt * FStar_Ident.lident)


let uu___is_Term_name : foundname  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Term_name (_0) -> begin
true
end
| uu____314 -> begin
false
end))


let __proj__Term_name__item___0 : foundname  ->  (FStar_Syntax_Syntax.typ * Prims.bool) = (fun projectee -> (match (projectee) with
| Term_name (_0) -> begin
_0
end))


let uu___is_Eff_name : foundname  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Eff_name (_0) -> begin
true
end
| uu____334 -> begin
false
end))


let __proj__Eff_name__item___0 : foundname  ->  (FStar_Syntax_Syntax.sigelt * FStar_Ident.lident) = (fun projectee -> (match (projectee) with
| Eff_name (_0) -> begin
_0
end))


let all_exported_id_kinds : exported_id_kind Prims.list = (Exported_id_field)::(Exported_id_term_type)::[]


let open_modules : env  ->  (FStar_Ident.lident * FStar_Syntax_Syntax.modul) Prims.list = (fun e -> e.modules)


let current_module : env  ->  FStar_Ident.lident = (fun env -> (match (env.curmodule) with
| None -> begin
(failwith "Unset current module")
end
| Some (m) -> begin
m
end))


let qual : FStar_Ident.lident  ->  FStar_Ident.ident  ->  FStar_Ident.lident = FStar_Syntax_Util.qual_id


let qualify : env  ->  FStar_Ident.ident  ->  FStar_Ident.lident = (fun env id -> (match (env.curmonad) with
| None -> begin
(let _0_274 = (current_module env)
in (qual _0_274 id))
end
| Some (monad) -> begin
(let _0_276 = (let _0_275 = (current_module env)
in (qual _0_275 monad))
in (FStar_Syntax_Util.mk_field_projector_name_from_ident _0_276 id))
end))


let new_sigmap = (fun uu____377 -> (FStar_Util.smap_create (Prims.parse_int "100")))


let empty_env : Prims.unit  ->  env = (fun uu____380 -> (let _0_280 = (new_sigmap ())
in (let _0_279 = (new_sigmap ())
in (let _0_278 = (new_sigmap ())
in (let _0_277 = (new_sigmap ())
in {curmodule = None; curmonad = None; modules = []; scope_mods = []; exported_ids = _0_280; trans_exported_ids = _0_279; includes = _0_278; sigaccum = []; sigmap = _0_277; iface = false; admitted_iface = false; expect_typ = false})))))


let sigmap : env  ->  (FStar_Syntax_Syntax.sigelt * Prims.bool) FStar_Util.smap = (fun env -> env.sigmap)


let has_all_in_scope : env  ->  Prims.bool = (fun env -> (FStar_List.existsb (fun uu____398 -> (match (uu____398) with
| (m, uu____402) -> begin
(FStar_Ident.lid_equals m FStar_Syntax_Const.all_lid)
end)) env.modules))


let set_bv_range : FStar_Syntax_Syntax.bv  ->  FStar_Range.range  ->  FStar_Syntax_Syntax.bv = (fun bv r -> (

let id = (

let uu___171_410 = bv.FStar_Syntax_Syntax.ppname
in {FStar_Ident.idText = uu___171_410.FStar_Ident.idText; FStar_Ident.idRange = r})
in (

let uu___172_411 = bv
in {FStar_Syntax_Syntax.ppname = id; FStar_Syntax_Syntax.index = uu___172_411.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = uu___172_411.FStar_Syntax_Syntax.sort})))


let bv_to_name : FStar_Syntax_Syntax.bv  ->  FStar_Range.range  ->  FStar_Syntax_Syntax.term = (fun bv r -> (FStar_Syntax_Syntax.bv_to_name (set_bv_range bv r)))


let unmangleMap : (Prims.string * Prims.string * FStar_Syntax_Syntax.delta_depth * FStar_Syntax_Syntax.fv_qual Prims.option) Prims.list = ((("op_ColonColon"), ("Cons"), (FStar_Syntax_Syntax.Delta_constant), (Some (FStar_Syntax_Syntax.Data_ctor))))::((("not"), ("op_Negation"), (FStar_Syntax_Syntax.Delta_equational), (None)))::[]


let unmangleOpName : FStar_Ident.ident  ->  (FStar_Syntax_Syntax.term * Prims.bool) Prims.option = (fun id -> (

let t = (FStar_Util.find_map unmangleMap (fun uu____457 -> (match (uu____457) with
| (x, y, dd, dq) -> begin
(match ((id.FStar_Ident.idText = x)) with
| true -> begin
Some ((let _0_281 = (FStar_Ident.lid_of_path (("Prims")::(y)::[]) id.FStar_Ident.idRange)
in (FStar_Syntax_Syntax.fvar _0_281 dd dq)))
end
| uu____471 -> begin
None
end)
end)))
in (match (t) with
| Some (v) -> begin
Some (((v), (false)))
end
| None -> begin
None
end)))

type 'a cont_t =
| Cont_ok of 'a
| Cont_fail
| Cont_ignore


let uu___is_Cont_ok = (fun projectee -> (match (projectee) with
| Cont_ok (_0) -> begin
true
end
| uu____500 -> begin
false
end))


let __proj__Cont_ok__item___0 = (fun projectee -> (match (projectee) with
| Cont_ok (_0) -> begin
_0
end))


let uu___is_Cont_fail = (fun projectee -> (match (projectee) with
| Cont_fail -> begin
true
end
| uu____524 -> begin
false
end))


let uu___is_Cont_ignore = (fun projectee -> (match (projectee) with
| Cont_ignore -> begin
true
end
| uu____535 -> begin
false
end))


let option_of_cont = (fun k_ignore uu___141_554 -> (match (uu___141_554) with
| Cont_ok (a) -> begin
Some (a)
end
| Cont_fail -> begin
None
end
| Cont_ignore -> begin
(k_ignore ())
end))


let find_in_record = (fun ns id record cont -> (

let typename' = (FStar_Ident.lid_of_ids (FStar_List.append ns ((record.typename.FStar_Ident.ident)::[])))
in (match ((FStar_Ident.lid_equals typename' record.typename)) with
| true -> begin
(

let fname = (FStar_Ident.lid_of_ids (FStar_List.append record.typename.FStar_Ident.ns ((id)::[])))
in (

let find = (FStar_Util.find_map record.fields (fun uu____599 -> (match (uu____599) with
| (f, uu____604) -> begin
(match ((id.FStar_Ident.idText = f.FStar_Ident.idText)) with
| true -> begin
Some (record)
end
| uu____606 -> begin
None
end)
end)))
in (match (find) with
| Some (r) -> begin
(cont r)
end
| None -> begin
Cont_ignore
end)))
end
| uu____609 -> begin
Cont_ignore
end)))


let get_exported_id_set : env  ->  Prims.string  ->  exported_id_set Prims.option = (fun e mname -> (FStar_Util.smap_try_find e.exported_ids mname))


let get_trans_exported_id_set : env  ->  Prims.string  ->  exported_id_set Prims.option = (fun e mname -> (FStar_Util.smap_try_find e.trans_exported_ids mname))


let string_of_exported_id_kind : exported_id_kind  ->  Prims.string = (fun uu___142_634 -> (match (uu___142_634) with
| Exported_id_field -> begin
"field"
end
| Exported_id_term_type -> begin
"term/type"
end))


let find_in_module_with_includes = (fun eikind find_in_module find_in_module_default env ns id -> (

let idstr = id.FStar_Ident.idText
in (

let rec aux = (fun uu___143_683 -> (match (uu___143_683) with
| [] -> begin
find_in_module_default
end
| (modul)::q -> begin
(

let mname = modul.FStar_Ident.str
in (

let not_shadowed = (

let uu____691 = (get_exported_id_set env mname)
in (match (uu____691) with
| None -> begin
true
end
| Some (mex) -> begin
(

let mexports = (FStar_ST.read (mex eikind))
in (FStar_Util.set_mem idstr mexports))
end))
in (

let mincludes = (

let uu____699 = (FStar_Util.smap_try_find env.includes mname)
in (match (uu____699) with
| None -> begin
[]
end
| Some (minc) -> begin
(FStar_ST.read minc)
end))
in (

let look_into = (match (not_shadowed) with
| true -> begin
(find_in_module (qual modul id))
end
| uu____719 -> begin
Cont_ignore
end)
in (match (look_into) with
| Cont_ignore -> begin
(aux (FStar_List.append mincludes q))
end
| uu____721 -> begin
look_into
end)))))
end))
in (aux ((ns)::[])))))


let is_exported_id_field : exported_id_kind  ->  Prims.bool = (fun uu___144_725 -> (match (uu___144_725) with
| Exported_id_field -> begin
true
end
| uu____726 -> begin
false
end))


let try_lookup_id'' = (fun env id eikind k_local_binding k_rec_binding k_record find_in_module lookup_default_id -> (

let check_local_binding_id = (fun uu___145_815 -> (match (uu___145_815) with
| (id', uu____817, uu____818) -> begin
(id'.FStar_Ident.idText = id.FStar_Ident.idText)
end))
in (

let check_rec_binding_id = (fun uu___146_822 -> (match (uu___146_822) with
| (id', uu____824, uu____825) -> begin
(id'.FStar_Ident.idText = id.FStar_Ident.idText)
end))
in (

let curmod_ns = (FStar_Ident.ids_of_lid (current_module env))
in (

let proc = (fun uu___147_832 -> (match (uu___147_832) with
| Local_binding (l) when (check_local_binding_id l) -> begin
(k_local_binding l)
end
| Rec_binding (r) when (check_rec_binding_id r) -> begin
(k_rec_binding r)
end
| Open_module_or_namespace (ns, uu____837) -> begin
(find_in_module_with_includes eikind find_in_module Cont_ignore env ns id)
end
| Top_level_def (id') when (id'.FStar_Ident.idText = id.FStar_Ident.idText) -> begin
(lookup_default_id Cont_ignore id)
end
| Record_or_dc (r) when (is_exported_id_field eikind) -> begin
(let _0_282 = (FStar_Ident.lid_of_ids curmod_ns)
in (find_in_module_with_includes Exported_id_field (fun lid -> (

let id = lid.FStar_Ident.ident
in (find_in_record lid.FStar_Ident.ns id r k_record))) Cont_ignore env _0_282 id))
end
| uu____842 -> begin
Cont_ignore
end))
in (

let rec aux = (fun uu___148_848 -> (match (uu___148_848) with
| (a)::q -> begin
(let _0_283 = (proc a)
in (option_of_cont (fun uu____854 -> (aux q)) _0_283))
end
| [] -> begin
(let _0_284 = (lookup_default_id Cont_fail id)
in (option_of_cont (fun uu____855 -> None) _0_284))
end))
in (aux env.scope_mods)))))))


let found_local_binding = (fun r uu____874 -> (match (uu____874) with
| (id', x, mut) -> begin
(let _0_285 = (bv_to_name x r)
in ((_0_285), (mut)))
end))


let find_in_module = (fun env lid k_global_def k_not_found -> (

let uu____917 = (FStar_Util.smap_try_find (sigmap env) lid.FStar_Ident.str)
in (match (uu____917) with
| Some (sb) -> begin
(k_global_def lid sb)
end
| None -> begin
k_not_found
end)))


let try_lookup_id : env  ->  FStar_Ident.ident  ->  (FStar_Syntax_Syntax.term * Prims.bool) Prims.option = (fun env id -> (

let uu____939 = (unmangleOpName id)
in (match (uu____939) with
| Some (f) -> begin
Some (f)
end
| uu____953 -> begin
(try_lookup_id'' env id Exported_id_term_type (fun r -> Cont_ok ((found_local_binding id.FStar_Ident.idRange r))) (fun uu____962 -> Cont_fail) (fun uu____965 -> Cont_ignore) (fun i -> (find_in_module env i (fun uu____972 uu____973 -> Cont_fail) Cont_ignore)) (fun uu____980 uu____981 -> Cont_fail))
end)))


let lookup_default_id = (fun env id k_global_def k_not_found -> (

let find_in_monad = (match (env.curmonad) with
| Some (uu____1033) -> begin
(

let lid = (qualify env id)
in (

let uu____1035 = (FStar_Util.smap_try_find (sigmap env) lid.FStar_Ident.str)
in (match (uu____1035) with
| Some (r) -> begin
Some ((k_global_def lid r))
end
| None -> begin
None
end)))
end
| None -> begin
None
end)
in (match (find_in_monad) with
| Some (v) -> begin
v
end
| None -> begin
(

let lid = (let _0_286 = (current_module env)
in (qual _0_286 id))
in (find_in_module env lid k_global_def k_not_found))
end)))


let module_is_defined : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> ((let _0_287 = (current_module env)
in (FStar_Ident.lid_equals lid _0_287)) || (FStar_List.existsb (fun x -> (FStar_Ident.lid_equals lid (Prims.fst x))) env.modules)))


let resolve_module_name : env  ->  FStar_Ident.lident  ->  Prims.bool  ->  FStar_Ident.lident Prims.option = (fun env lid honor_ns -> (

let nslen = (FStar_List.length lid.FStar_Ident.ns)
in (

let rec aux = (fun uu___149_1089 -> (match (uu___149_1089) with
| [] -> begin
(

let uu____1092 = (module_is_defined env lid)
in (match (uu____1092) with
| true -> begin
Some (lid)
end
| uu____1094 -> begin
None
end))
end
| (Open_module_or_namespace (ns, Open_namespace))::q when honor_ns -> begin
(

let new_lid = (let _0_290 = (let _0_289 = (FStar_Ident.path_of_lid ns)
in (let _0_288 = (FStar_Ident.path_of_lid lid)
in (FStar_List.append _0_289 _0_288)))
in (FStar_Ident.lid_of_path _0_290 (FStar_Ident.range_of_lid lid)))
in (

let uu____1099 = (module_is_defined env new_lid)
in (match (uu____1099) with
| true -> begin
Some (new_lid)
end
| uu____1101 -> begin
(aux q)
end)))
end
| (Module_abbrev (name, modul))::uu____1104 when ((nslen = (Prims.parse_int "0")) && (name.FStar_Ident.idText = lid.FStar_Ident.ident.FStar_Ident.idText)) -> begin
Some (modul)
end
| (uu____1108)::q -> begin
(aux q)
end))
in (aux env.scope_mods))))


let resolve_in_open_namespaces'' = (fun env lid eikind k_local_binding k_rec_binding k_record f_module l_default -> (match (lid.FStar_Ident.ns) with
| (uu____1196)::uu____1197 -> begin
(

let uu____1199 = (let _0_292 = (let _0_291 = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns)
in (FStar_Ident.set_lid_range _0_291 (FStar_Ident.range_of_lid lid)))
in (resolve_module_name env _0_292 true))
in (match (uu____1199) with
| None -> begin
None
end
| Some (modul) -> begin
(let _0_293 = (find_in_module_with_includes eikind f_module Cont_fail env modul lid.FStar_Ident.ident)
in (option_of_cont (fun uu____1203 -> None) _0_293))
end))
end
| [] -> begin
(try_lookup_id'' env lid.FStar_Ident.ident eikind k_local_binding k_rec_binding k_record f_module l_default)
end))


let cont_of_option = (fun k_none uu___150_1218 -> (match (uu___150_1218) with
| Some (v) -> begin
Cont_ok (v)
end
| None -> begin
k_none
end))


let resolve_in_open_namespaces' = (fun env lid k_local_binding k_rec_binding k_global_def -> (

let k_global_def' = (fun k lid def -> (let _0_294 = (k_global_def lid def)
in (cont_of_option k _0_294)))
in (

let f_module = (fun lid' -> (

let k = Cont_ignore
in (find_in_module env lid' (k_global_def' k) k)))
in (

let l_default = (fun k i -> (lookup_default_id env i (k_global_def' k) k))
in (resolve_in_open_namespaces'' env lid Exported_id_term_type (fun l -> (let _0_295 = (k_local_binding l)
in (cont_of_option Cont_fail _0_295))) (fun r -> (let _0_296 = (k_rec_binding r)
in (cont_of_option Cont_fail _0_296))) (fun uu____1317 -> Cont_ignore) f_module l_default)))))


let fv_qual_of_se : FStar_Syntax_Syntax.sigelt  ->  FStar_Syntax_Syntax.fv_qual Prims.option = (fun uu___152_1321 -> (match (uu___152_1321) with
| FStar_Syntax_Syntax.Sig_datacon (uu____1323, uu____1324, uu____1325, l, uu____1327, quals, uu____1329, uu____1330) -> begin
(

let qopt = (FStar_Util.find_map quals (fun uu___151_1337 -> (match (uu___151_1337) with
| FStar_Syntax_Syntax.RecordConstructor (uu____1339, fs) -> begin
Some (FStar_Syntax_Syntax.Record_ctor (((l), (fs))))
end
| uu____1346 -> begin
None
end)))
in (match (qopt) with
| None -> begin
Some (FStar_Syntax_Syntax.Data_ctor)
end
| x -> begin
x
end))
end
| FStar_Syntax_Syntax.Sig_declare_typ (uu____1350, uu____1351, uu____1352, quals, uu____1354) -> begin
None
end
| uu____1357 -> begin
None
end))


let lb_fv : FStar_Syntax_Syntax.letbinding Prims.list  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.fv = (fun lbs lid -> (let _0_297 = (FStar_Util.find_map lbs (fun lb -> (

let fv = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname)
in (

let uu____1369 = (FStar_Syntax_Syntax.fv_eq_lid fv lid)
in (match (uu____1369) with
| true -> begin
Some (fv)
end
| uu____1371 -> begin
None
end)))))
in (FStar_All.pipe_right _0_297 FStar_Util.must)))


let ns_of_lid_equals : FStar_Ident.lident  ->  FStar_Ident.lident  ->  Prims.bool = (fun lid ns -> (((FStar_List.length lid.FStar_Ident.ns) = (FStar_List.length (FStar_Ident.ids_of_lid ns))) && (let _0_298 = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns)
in (FStar_Ident.lid_equals _0_298 ns))))


let try_lookup_name : Prims.bool  ->  Prims.bool  ->  env  ->  FStar_Ident.lident  ->  foundname Prims.option = (fun any_val exclude_interf env lid -> (

let occurrence_range = (FStar_Ident.range_of_lid lid)
in (

let k_global_def = (fun source_lid uu___156_1406 -> (match (uu___156_1406) with
| (uu____1410, true) when exclude_interf -> begin
None
end
| (se, uu____1412) -> begin
(match (se) with
| FStar_Syntax_Syntax.Sig_inductive_typ (uu____1414) -> begin
Some (Term_name ((let _0_299 = (FStar_Syntax_Syntax.fvar source_lid FStar_Syntax_Syntax.Delta_constant None)
in ((_0_299), (false)))))
end
| FStar_Syntax_Syntax.Sig_datacon (uu____1426) -> begin
Some (Term_name ((let _0_301 = (let _0_300 = (fv_qual_of_se se)
in (FStar_Syntax_Syntax.fvar source_lid FStar_Syntax_Syntax.Delta_constant _0_300))
in ((_0_301), (false)))))
end
| FStar_Syntax_Syntax.Sig_let ((uu____1437, lbs), uu____1439, uu____1440, uu____1441, uu____1442) -> begin
(

let fv = (lb_fv lbs source_lid)
in Some (Term_name ((let _0_302 = (FStar_Syntax_Syntax.fvar source_lid fv.FStar_Syntax_Syntax.fv_delta fv.FStar_Syntax_Syntax.fv_qual)
in ((_0_302), (false))))))
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, uu____1456, uu____1457, quals, uu____1459) -> begin
(

let uu____1462 = (any_val || (FStar_All.pipe_right quals (FStar_Util.for_some (fun uu___153_1464 -> (match (uu___153_1464) with
| FStar_Syntax_Syntax.Assumption -> begin
true
end
| uu____1465 -> begin
false
end)))))
in (match (uu____1462) with
| true -> begin
(

let lid = (FStar_Ident.set_lid_range lid (FStar_Ident.range_of_lid source_lid))
in (

let dd = (

let uu____1469 = ((FStar_Syntax_Util.is_primop_lid lid) || ((ns_of_lid_equals lid FStar_Syntax_Const.prims_lid) && (FStar_All.pipe_right quals (FStar_Util.for_some (fun uu___154_1471 -> (match (uu___154_1471) with
| (FStar_Syntax_Syntax.Projector (_)) | (FStar_Syntax_Syntax.Discriminator (_)) -> begin
true
end
| uu____1474 -> begin
false
end))))))
in (match (uu____1469) with
| true -> begin
FStar_Syntax_Syntax.Delta_equational
end
| uu____1475 -> begin
FStar_Syntax_Syntax.Delta_constant
end))
in (

let uu____1476 = (FStar_Util.find_map quals (fun uu___155_1478 -> (match (uu___155_1478) with
| FStar_Syntax_Syntax.Reflectable (refl_monad) -> begin
Some (refl_monad)
end
| uu____1481 -> begin
None
end)))
in (match (uu____1476) with
| Some (refl_monad) -> begin
(

let refl_const = ((FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reflect (refl_monad)))) None occurrence_range)
in Some (Term_name (((refl_const), (false)))))
end
| uu____1497 -> begin
Some (Term_name ((let _0_304 = (let _0_303 = (fv_qual_of_se se)
in (FStar_Syntax_Syntax.fvar lid dd _0_303))
in ((_0_304), (false)))))
end))))
end
| uu____1499 -> begin
None
end))
end
| (FStar_Syntax_Syntax.Sig_new_effect_for_free (ne, _)) | (FStar_Syntax_Syntax.Sig_new_effect (ne, _)) -> begin
Some (Eff_name (((se), ((FStar_Ident.set_lid_range ne.FStar_Syntax_Syntax.mname (FStar_Ident.range_of_lid source_lid))))))
end
| FStar_Syntax_Syntax.Sig_effect_abbrev (uu____1503) -> begin
Some (Eff_name (((se), (source_lid))))
end
| uu____1513 -> begin
None
end)
end))
in (

let k_local_binding = (fun r -> Some (Term_name ((found_local_binding (FStar_Ident.range_of_lid lid) r))))
in (

let k_rec_binding = (fun uu____1532 -> (match (uu____1532) with
| (id, l, dd) -> begin
Some (Term_name ((let _0_305 = (FStar_Syntax_Syntax.fvar (FStar_Ident.set_lid_range l (FStar_Ident.range_of_lid lid)) dd None)
in ((_0_305), (false)))))
end))
in (

let found_unmangled = (match (lid.FStar_Ident.ns) with
| [] -> begin
(

let uu____1543 = (unmangleOpName lid.FStar_Ident.ident)
in (match (uu____1543) with
| Some (f) -> begin
Some (Term_name (f))
end
| uu____1553 -> begin
None
end))
end
| uu____1557 -> begin
None
end)
in (match (found_unmangled) with
| None -> begin
(resolve_in_open_namespaces' env lid k_local_binding k_rec_binding k_global_def)
end
| x -> begin
x
end)))))))


let try_lookup_effect_name' : Prims.bool  ->  env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.sigelt * FStar_Ident.lident) Prims.option = (fun exclude_interf env lid -> (

let uu____1577 = (try_lookup_name true exclude_interf env lid)
in (match (uu____1577) with
| Some (Eff_name (o, l)) -> begin
Some (((o), (l)))
end
| uu____1586 -> begin
None
end)))


let try_lookup_effect_name : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident Prims.option = (fun env l -> (

let uu____1597 = (try_lookup_effect_name' (not (env.iface)) env l)
in (match (uu____1597) with
| Some (o, l) -> begin
Some (l)
end
| uu____1606 -> begin
None
end)))


let try_lookup_effect_name_and_attributes : env  ->  FStar_Ident.lident  ->  (FStar_Ident.lident * FStar_Syntax_Syntax.cflags Prims.list) Prims.option = (fun env l -> (

let uu____1620 = (try_lookup_effect_name' (not (env.iface)) env l)
in (match (uu____1620) with
| Some (FStar_Syntax_Syntax.Sig_new_effect (ne, uu____1629), l) -> begin
Some (((l), (ne.FStar_Syntax_Syntax.cattributes)))
end
| Some (FStar_Syntax_Syntax.Sig_new_effect_for_free (ne, uu____1638), l) -> begin
Some (((l), (ne.FStar_Syntax_Syntax.cattributes)))
end
| Some (FStar_Syntax_Syntax.Sig_effect_abbrev (uu____1646, uu____1647, uu____1648, uu____1649, uu____1650, cattributes, uu____1652), l) -> begin
Some (((l), (cattributes)))
end
| uu____1664 -> begin
None
end)))


let try_lookup_effect_defn : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.eff_decl Prims.option = (fun env l -> (

let uu____1678 = (try_lookup_effect_name' (not (env.iface)) env l)
in (match (uu____1678) with
| Some (FStar_Syntax_Syntax.Sig_new_effect (ne, uu____1684), uu____1685) -> begin
Some (ne)
end
| Some (FStar_Syntax_Syntax.Sig_new_effect_for_free (ne, uu____1689), uu____1690) -> begin
Some (ne)
end
| uu____1693 -> begin
None
end)))


let is_effect_name : env  ->  FStar_Ident.lident  ->  Prims.bool = (fun env lid -> (

let uu____1703 = (try_lookup_effect_name env lid)
in (match (uu____1703) with
| None -> begin
false
end
| Some (uu____1705) -> begin
true
end)))


let lookup_letbinding_quals : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.qualifier Prims.list = (fun env lid -> (

let k_global_def = (fun lid uu___157_1723 -> (match (uu___157_1723) with
| (FStar_Syntax_Syntax.Sig_declare_typ (lid, uu____1729, uu____1730, quals, uu____1732), uu____1733) -> begin
Some (quals)
end
| uu____1737 -> begin
None
end))
in (

let uu____1741 = (resolve_in_open_namespaces' env lid (fun uu____1745 -> None) (fun uu____1747 -> None) k_global_def)
in (match (uu____1741) with
| Some (quals) -> begin
quals
end
| uu____1753 -> begin
[]
end))))


let try_lookup_module : env  ->  Prims.string Prims.list  ->  FStar_Syntax_Syntax.modul Prims.option = (fun env path -> (

let uu____1765 = (FStar_List.tryFind (fun uu____1771 -> (match (uu____1771) with
| (mlid, modul) -> begin
(let _0_306 = (FStar_Ident.path_of_lid mlid)
in (_0_306 = path))
end)) env.modules)
in (match (uu____1765) with
| Some (uu____1778, modul) -> begin
Some (modul)
end
| None -> begin
None
end)))


let try_lookup_let : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term Prims.option = (fun env lid -> (

let k_global_def = (fun lid uu___158_1800 -> (match (uu___158_1800) with
| (FStar_Syntax_Syntax.Sig_let ((uu____1804, lbs), uu____1806, uu____1807, uu____1808, uu____1809), uu____1810) -> begin
(

let fv = (lb_fv lbs lid)
in Some ((FStar_Syntax_Syntax.fvar lid fv.FStar_Syntax_Syntax.fv_delta fv.FStar_Syntax_Syntax.fv_qual)))
end
| uu____1823 -> begin
None
end))
in (resolve_in_open_namespaces' env lid (fun uu____1826 -> None) (fun uu____1827 -> None) k_global_def)))


let try_lookup_definition : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.term Prims.option = (fun env lid -> (

let k_global_def = (fun lid uu___159_1846 -> (match (uu___159_1846) with
| (FStar_Syntax_Syntax.Sig_let (lbs, uu____1853, uu____1854, uu____1855, uu____1856), uu____1857) -> begin
(FStar_Util.find_map (Prims.snd lbs) (fun lb -> (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inr (fv) when (FStar_Syntax_Syntax.fv_eq_lid fv lid) -> begin
Some (lb.FStar_Syntax_Syntax.lbdef)
end
| uu____1874 -> begin
None
end)))
end
| uu____1879 -> begin
None
end))
in (resolve_in_open_namespaces' env lid (fun uu____1886 -> None) (fun uu____1889 -> None) k_global_def)))


let try_lookup_lid' : Prims.bool  ->  Prims.bool  ->  env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.term * Prims.bool) Prims.option = (fun any_val exclude_interf env lid -> (

let uu____1910 = (try_lookup_name any_val exclude_interf env lid)
in (match (uu____1910) with
| Some (Term_name (e, mut)) -> begin
Some (((e), (mut)))
end
| uu____1919 -> begin
None
end)))


let try_lookup_lid : env  ->  FStar_Ident.lident  ->  (FStar_Syntax_Syntax.term * Prims.bool) Prims.option = (fun env l -> (try_lookup_lid' env.iface false env l))


let try_lookup_datacon : env  ->  FStar_Ident.lident  ->  FStar_Syntax_Syntax.fv Prims.option = (fun env lid -> (

let k_global_def = (fun lid uu___161_1948 -> (match (uu___161_1948) with
| (FStar_Syntax_Syntax.Sig_declare_typ (uu____1952, uu____1953, uu____1954, quals, uu____1956), uu____1957) -> begin
(

let uu____1960 = (FStar_All.pipe_right quals (FStar_Util.for_some (fun uu___160_1962 -> (match (uu___160_1962) with
| FStar_Syntax_Syntax.Assumption -> begin
true
end
| uu____1963 -> begin
false
end))))
in (match (uu____1960) with
| true -> begin
Some ((FStar_Syntax_Syntax.lid_as_fv lid FStar_Syntax_Syntax.Delta_constant None))
end
| uu____1965 -> begin
None
end))
end
| (FStar_Syntax_Syntax.Sig_datacon (uu____1966), uu____1967) -> begin
Some ((FStar_Syntax_Syntax.lid_as_fv lid FStar_Syntax_Syntax.Delta_constant (Some (FStar_Syntax_Syntax.Data_ctor))))
end
| uu____1978 -> begin
None
end))
in (resolve_in_open_namespaces' env lid (fun uu____1981 -> None) (fun uu____1982 -> None) k_global_def)))


let find_all_datacons : env  ->  FStar_Ident.lident  ->  FStar_Ident.lident Prims.list Prims.option = (fun env lid -> (

let k_global_def = (fun lid uu___162_2001 -> (match (uu___162_2001) with
| (FStar_Syntax_Syntax.Sig_inductive_typ (uu____2006, uu____2007, uu____2008, uu____2009, uu____2010, datas, uu____2012, uu____2013), uu____2014) -> begin
Some (datas)
end
| uu____2022 -> begin
None
end))
in (resolve_in_open_namespaces' env lid (fun uu____2027 -> None) (fun uu____2029 -> None) k_global_def)))


let record_cache_aux_with_filter : (((Prims.unit  ->  Prims.unit) * (Prims.unit  ->  Prims.unit) * (Prims.unit  ->  record_or_dc Prims.list) * (record_or_dc  ->  Prims.unit) * (Prims.unit  ->  Prims.unit)) * (Prims.unit  ->  Prims.unit)) = (

let record_cache = (FStar_Util.mk_ref (([])::[]))
in (

let push = (fun uu____2063 -> (let _0_309 = (let _0_308 = (FStar_List.hd (FStar_ST.read record_cache))
in (let _0_307 = (FStar_ST.read record_cache)
in (_0_308)::_0_307))
in (FStar_ST.write record_cache _0_309)))
in (

let pop = (fun uu____2081 -> (let _0_310 = (FStar_List.tl (FStar_ST.read record_cache))
in (FStar_ST.write record_cache _0_310)))
in (

let peek = (fun uu____2095 -> (FStar_List.hd (FStar_ST.read record_cache)))
in (

let insert = (fun r -> (let _0_314 = (let _0_313 = (let _0_311 = (peek ())
in (r)::_0_311)
in (let _0_312 = (FStar_List.tl (FStar_ST.read record_cache))
in (_0_313)::_0_312))
in (FStar_ST.write record_cache _0_314)))
in (

let commit = (fun uu____2118 -> (

let uu____2119 = (FStar_ST.read record_cache)
in (match (uu____2119) with
| (hd)::(uu____2127)::tl -> begin
(FStar_ST.write record_cache ((hd)::tl))
end
| uu____2140 -> begin
(failwith "Impossible")
end)))
in (

let filter = (fun uu____2146 -> (

let rc = (peek ())
in ((pop ());
(match (()) with
| () -> begin
(

let filtered = (FStar_List.filter (fun r -> (not (r.is_private_or_abstract))) rc)
in (let _0_316 = (let _0_315 = (FStar_ST.read record_cache)
in (filtered)::_0_315)
in (FStar_ST.write record_cache _0_316)))
end);
)))
in (

let aux = ((push), (pop), (peek), (insert), (commit))
in ((aux), (filter))))))))))


let record_cache_aux : ((Prims.unit  ->  Prims.unit) * (Prims.unit  ->  Prims.unit) * (Prims.unit  ->  record_or_dc Prims.list) * (record_or_dc  ->  Prims.unit) * (Prims.unit  ->  Prims.unit)) = (

let uu____2224 = record_cache_aux_with_filter
in (match (uu____2224) with
| (aux, uu____2262) -> begin
aux
end))


let filter_record_cache : Prims.unit  ->  Prims.unit = (

let uu____2301 = record_cache_aux_with_filter
in (match (uu____2301) with
| (uu____2324, filter) -> begin
filter
end))


let push_record_cache : Prims.unit  ->  Prims.unit = (

let uu____2364 = record_cache_aux
in (match (uu____2364) with
| (push, uu____2384, uu____2385, uu____2386, uu____2387) -> begin
push
end))


let pop_record_cache : Prims.unit  ->  Prims.unit = (

let uu____2412 = record_cache_aux
in (match (uu____2412) with
| (uu____2431, pop, uu____2433, uu____2434, uu____2435) -> begin
pop
end))


let peek_record_cache : Prims.unit  ->  record_or_dc Prims.list = (

let uu____2461 = record_cache_aux
in (match (uu____2461) with
| (uu____2481, uu____2482, peek, uu____2484, uu____2485) -> begin
peek
end))


let insert_record_cache : record_or_dc  ->  Prims.unit = (

let uu____2510 = record_cache_aux
in (match (uu____2510) with
| (uu____2529, uu____2530, uu____2531, insert, uu____2533) -> begin
insert
end))


let commit_record_cache : Prims.unit  ->  Prims.unit = (

let uu____2558 = record_cache_aux
in (match (uu____2558) with
| (uu____2577, uu____2578, uu____2579, uu____2580, commit) -> begin
commit
end))


let extract_record : env  ->  scope_mod Prims.list FStar_ST.ref  ->  FStar_Syntax_Syntax.sigelt  ->  Prims.unit = (fun e new_globs uu___166_2615 -> (match (uu___166_2615) with
| FStar_Syntax_Syntax.Sig_bundle (sigs, uu____2620, uu____2621, uu____2622) -> begin
(

let is_rec = (FStar_Util.for_some (fun uu___163_2633 -> (match (uu___163_2633) with
| (FStar_Syntax_Syntax.RecordType (_)) | (FStar_Syntax_Syntax.RecordConstructor (_)) -> begin
true
end
| uu____2636 -> begin
false
end)))
in (

let find_dc = (fun dc -> (FStar_All.pipe_right sigs (FStar_Util.find_opt (fun uu___164_2644 -> (match (uu___164_2644) with
| FStar_Syntax_Syntax.Sig_datacon (lid, uu____2646, uu____2647, uu____2648, uu____2649, uu____2650, uu____2651, uu____2652) -> begin
(FStar_Ident.lid_equals dc lid)
end
| uu____2657 -> begin
false
end)))))
in (FStar_All.pipe_right sigs (FStar_List.iter (fun uu___165_2659 -> (match (uu___165_2659) with
| FStar_Syntax_Syntax.Sig_inductive_typ (typename, univs, parms, uu____2663, uu____2664, (dc)::[], tags, uu____2667) -> begin
(

let uu____2673 = (let _0_317 = (find_dc dc)
in (FStar_All.pipe_left FStar_Util.must _0_317))
in (match (uu____2673) with
| FStar_Syntax_Syntax.Sig_datacon (constrname, uu____2676, t, uu____2678, uu____2679, uu____2680, uu____2681, uu____2682) -> begin
(

let uu____2687 = (FStar_Syntax_Util.arrow_formals t)
in (match (uu____2687) with
| (formals, uu____2696) -> begin
(

let is_rec = (is_rec tags)
in (

let formals' = (FStar_All.pipe_right formals (FStar_List.collect (fun uu____2722 -> (match (uu____2722) with
| (x, q) -> begin
(

let uu____2730 = ((FStar_Syntax_Syntax.is_null_bv x) || (is_rec && (FStar_Syntax_Syntax.is_implicit q)))
in (match (uu____2730) with
| true -> begin
[]
end
| uu____2736 -> begin
(((x), (q)))::[]
end))
end))))
in (

let fields' = (FStar_All.pipe_right formals' (FStar_List.map (fun uu____2761 -> (match (uu____2761) with
| (x, q) -> begin
(let _0_318 = (match (is_rec) with
| true -> begin
(FStar_Syntax_Util.unmangle_field_name x.FStar_Syntax_Syntax.ppname)
end
| uu____2772 -> begin
x.FStar_Syntax_Syntax.ppname
end)
in ((_0_318), (x.FStar_Syntax_Syntax.sort)))
end))))
in (

let fields = fields'
in (

let record = {typename = typename; constrname = constrname.FStar_Ident.ident; parms = parms; fields = fields; is_private_or_abstract = ((FStar_List.contains FStar_Syntax_Syntax.Private tags) || (FStar_List.contains FStar_Syntax_Syntax.Abstract tags)); is_record = is_rec}
in ((let _0_320 = (let _0_319 = (FStar_ST.read new_globs)
in (Record_or_dc (record))::_0_319)
in (FStar_ST.write new_globs _0_320));
(match (()) with
| () -> begin
((

let add_field = (fun uu____2795 -> (match (uu____2795) with
| (id, uu____2801) -> begin
(

let modul = (FStar_Ident.lid_of_ids constrname.FStar_Ident.ns).FStar_Ident.str
in (

let uu____2807 = (get_exported_id_set e modul)
in (match (uu____2807) with
| Some (my_ex) -> begin
(

let my_exported_ids = (my_ex Exported_id_field)
in ((let _0_322 = (let _0_321 = (FStar_ST.read my_exported_ids)
in (FStar_Util.set_add id.FStar_Ident.idText _0_321))
in (FStar_ST.write my_exported_ids _0_322));
(match (()) with
| () -> begin
(

let projname = (FStar_Syntax_Util.mk_field_projector_name_from_ident constrname id).FStar_Ident.ident.FStar_Ident.idText
in (

let _0_324 = (let _0_323 = (FStar_ST.read my_exported_ids)
in (FStar_Util.set_add projname _0_323))
in (FStar_ST.write my_exported_ids _0_324)))
end);
))
end
| None -> begin
()
end)))
end))
in (FStar_List.iter add_field fields'));
(match (()) with
| () -> begin
(insert_record_cache record)
end);
)
end);
))))))
end))
end
| uu____2828 -> begin
()
end))
end
| uu____2829 -> begin
()
end))))))
end
| uu____2830 -> begin
()
end))


let try_lookup_record_or_dc_by_field_name : env  ->  FStar_Ident.lident  ->  record_or_dc Prims.option = (fun env fieldname -> (

let find_in_cache = (fun fieldname -> (

let uu____2843 = ((fieldname.FStar_Ident.ns), (fieldname.FStar_Ident.ident))
in (match (uu____2843) with
| (ns, id) -> begin
(let _0_326 = (peek_record_cache ())
in (FStar_Util.find_map _0_326 (fun record -> (let _0_325 = (find_in_record ns id record (fun r -> Cont_ok (r)))
in (option_of_cont (fun uu____2854 -> None) _0_325)))))
end)))
in (resolve_in_open_namespaces'' env fieldname Exported_id_field (fun uu____2856 -> Cont_ignore) (fun uu____2857 -> Cont_ignore) (fun r -> Cont_ok (r)) (fun fn -> (let _0_327 = (find_in_cache fn)
in (cont_of_option Cont_ignore _0_327))) (fun k uu____2861 -> k))))


let try_lookup_record_by_field_name : env  ->  FStar_Ident.lident  ->  record_or_dc Prims.option = (fun env fieldname -> (

let uu____2870 = (try_lookup_record_or_dc_by_field_name env fieldname)
in (match (uu____2870) with
| Some (r) when r.is_record -> begin
Some (r)
end
| uu____2874 -> begin
None
end)))


let belongs_to_record : env  ->  FStar_Ident.lident  ->  record_or_dc  ->  Prims.bool = (fun env lid record -> (

let uu____2885 = (try_lookup_record_by_field_name env lid)
in (match (uu____2885) with
| Some (record') when (let _0_329 = (FStar_Ident.text_of_path (FStar_Ident.path_of_ns record.typename.FStar_Ident.ns))
in (let _0_328 = (FStar_Ident.text_of_path (FStar_Ident.path_of_ns record'.typename.FStar_Ident.ns))
in (_0_329 = _0_328))) -> begin
(

let uu____2888 = (find_in_record record.typename.FStar_Ident.ns lid.FStar_Ident.ident record (fun uu____2890 -> Cont_ok (())))
in (match (uu____2888) with
| Cont_ok (uu____2891) -> begin
true
end
| uu____2892 -> begin
false
end))
end
| uu____2894 -> begin
false
end)))


let try_lookup_dc_by_field_name : env  ->  FStar_Ident.lident  ->  (FStar_Ident.lident * Prims.bool) Prims.option = (fun env fieldname -> (

let uu____2905 = (try_lookup_record_or_dc_by_field_name env fieldname)
in (match (uu____2905) with
| Some (r) -> begin
Some ((let _0_331 = (let _0_330 = (FStar_Ident.lid_of_ids (FStar_List.append r.typename.FStar_Ident.ns ((r.constrname)::[])))
in (FStar_Ident.set_lid_range _0_330 (FStar_Ident.range_of_lid fieldname)))
in ((_0_331), (r.is_record))))
end
| uu____2913 -> begin
None
end)))


let string_set_ref_new : Prims.unit  ->  Prims.string FStar_Util.set FStar_ST.ref = (fun uu____2922 -> (FStar_Util.mk_ref (FStar_Util.new_set FStar_Util.compare FStar_Util.hashcode)))


let exported_id_set_new : Prims.unit  ->  exported_id_kind  ->  Prims.string FStar_Util.set FStar_ST.ref = (fun uu____2932 -> (

let term_type_set = (string_set_ref_new ())
in (

let field_set = (string_set_ref_new ())
in (fun uu___167_2941 -> (match (uu___167_2941) with
| Exported_id_term_type -> begin
term_type_set
end
| Exported_id_field -> begin
field_set
end)))))


let empty_include_smap : FStar_Ident.lident Prims.list FStar_ST.ref FStar_Util.smap = (new_sigmap ())


let empty_exported_id_smap : exported_id_set FStar_Util.smap = (new_sigmap ())


let unique : Prims.bool  ->  Prims.bool  ->  env  ->  FStar_Ident.lident  ->  Prims.bool = (fun any_val exclude_if env lid -> (

let filter_scope_mods = (fun uu___168_2967 -> (match (uu___168_2967) with
| Rec_binding (uu____2968) -> begin
true
end
| uu____2969 -> begin
false
end))
in (

let this_env = (

let uu___173_2971 = env
in (let _0_332 = (FStar_List.filter filter_scope_mods env.scope_mods)
in {curmodule = uu___173_2971.curmodule; curmonad = uu___173_2971.curmonad; modules = uu___173_2971.modules; scope_mods = _0_332; exported_ids = empty_exported_id_smap; trans_exported_ids = uu___173_2971.trans_exported_ids; includes = empty_include_smap; sigaccum = uu___173_2971.sigaccum; sigmap = uu___173_2971.sigmap; iface = uu___173_2971.iface; admitted_iface = uu___173_2971.admitted_iface; expect_typ = uu___173_2971.expect_typ}))
in (

let uu____2972 = (try_lookup_lid' any_val exclude_if this_env lid)
in (match (uu____2972) with
| None -> begin
true
end
| Some (uu____2978) -> begin
false
end)))))


let push_scope_mod : env  ->  scope_mod  ->  env = (fun env scope_mod -> (

let uu___174_2989 = env
in {curmodule = uu___174_2989.curmodule; curmonad = uu___174_2989.curmonad; modules = uu___174_2989.modules; scope_mods = (scope_mod)::env.scope_mods; exported_ids = uu___174_2989.exported_ids; trans_exported_ids = uu___174_2989.trans_exported_ids; includes = uu___174_2989.includes; sigaccum = uu___174_2989.sigaccum; sigmap = uu___174_2989.sigmap; iface = uu___174_2989.iface; admitted_iface = uu___174_2989.admitted_iface; expect_typ = uu___174_2989.expect_typ}))


let push_bv' : env  ->  FStar_Ident.ident  ->  Prims.bool  ->  (env * FStar_Syntax_Syntax.bv) = (fun env x is_mutable -> (

let bv = (FStar_Syntax_Syntax.gen_bv x.FStar_Ident.idText (Some (x.FStar_Ident.idRange)) FStar_Syntax_Syntax.tun)
in (((push_scope_mod env (Local_binding (((x), (bv), (is_mutable)))))), (bv))))


let push_bv_mutable : env  ->  FStar_Ident.ident  ->  (env * FStar_Syntax_Syntax.bv) = (fun env x -> (push_bv' env x true))


let push_bv : env  ->  FStar_Ident.ident  ->  (env * FStar_Syntax_Syntax.bv) = (fun env x -> (push_bv' env x false))


let push_top_level_rec_binding : env  ->  FStar_Ident.ident  ->  FStar_Syntax_Syntax.delta_depth  ->  env = (fun env x dd -> (

let l = (qualify env x)
in (

let uu____3028 = (unique false true env l)
in (match (uu____3028) with
| true -> begin
(push_scope_mod env (Rec_binding (((x), (l), (dd)))))
end
| uu____3029 -> begin
(Prims.raise (FStar_Errors.Error ((((Prims.strcat "Duplicate top-level names " l.FStar_Ident.str)), ((FStar_Ident.range_of_lid l))))))
end))))


let push_sigelt : env  ->  FStar_Syntax_Syntax.sigelt  ->  env = (fun env s -> (

let err = (fun l -> (

let sopt = (FStar_Util.smap_try_find (sigmap env) l.FStar_Ident.str)
in (

let r = (match (sopt) with
| Some (se, uu____3048) -> begin
(

let uu____3051 = (FStar_Util.find_opt (FStar_Ident.lid_equals l) (FStar_Syntax_Util.lids_of_sigelt se))
in (match (uu____3051) with
| Some (l) -> begin
(FStar_All.pipe_left FStar_Range.string_of_range (FStar_Ident.range_of_lid l))
end
| None -> begin
"<unknown>"
end))
end
| None -> begin
"<unknown>"
end)
in (Prims.raise (FStar_Errors.Error ((let _0_333 = (FStar_Util.format2 "Duplicate top-level names [%s]; previously declared at %s" (FStar_Ident.text_of_lid l) r)
in ((_0_333), ((FStar_Ident.range_of_lid l))))))))))
in (

let globals = (FStar_Util.mk_ref env.scope_mods)
in (

let env = (

let uu____3062 = (match (s) with
| FStar_Syntax_Syntax.Sig_let (uu____3067) -> begin
((false), (true))
end
| FStar_Syntax_Syntax.Sig_bundle (uu____3076) -> begin
((true), (true))
end
| uu____3084 -> begin
((false), (false))
end)
in (match (uu____3062) with
| (any_val, exclude_if) -> begin
(

let lids = (FStar_Syntax_Util.lids_of_sigelt s)
in (

let uu____3089 = (FStar_Util.find_map lids (fun l -> (

let uu____3092 = (not ((unique any_val exclude_if env l)))
in (match (uu____3092) with
| true -> begin
Some (l)
end
| uu____3094 -> begin
None
end))))
in (match (uu____3089) with
| None -> begin
((extract_record env globals s);
(

let uu___175_3098 = env
in {curmodule = uu___175_3098.curmodule; curmonad = uu___175_3098.curmonad; modules = uu___175_3098.modules; scope_mods = uu___175_3098.scope_mods; exported_ids = uu___175_3098.exported_ids; trans_exported_ids = uu___175_3098.trans_exported_ids; includes = uu___175_3098.includes; sigaccum = (s)::env.sigaccum; sigmap = uu___175_3098.sigmap; iface = uu___175_3098.iface; admitted_iface = uu___175_3098.admitted_iface; expect_typ = uu___175_3098.expect_typ});
)
end
| Some (l) -> begin
(err l)
end)))
end))
in (

let env = (

let uu___176_3101 = env
in (let _0_334 = (FStar_ST.read globals)
in {curmodule = uu___176_3101.curmodule; curmonad = uu___176_3101.curmonad; modules = uu___176_3101.modules; scope_mods = _0_334; exported_ids = uu___176_3101.exported_ids; trans_exported_ids = uu___176_3101.trans_exported_ids; includes = uu___176_3101.includes; sigaccum = uu___176_3101.sigaccum; sigmap = uu___176_3101.sigmap; iface = uu___176_3101.iface; admitted_iface = uu___176_3101.admitted_iface; expect_typ = uu___176_3101.expect_typ}))
in (

let uu____3105 = (match (s) with
| FStar_Syntax_Syntax.Sig_bundle (ses, uu____3119, uu____3120, uu____3121) -> begin
(let _0_335 = (FStar_List.map (fun se -> (((FStar_Syntax_Util.lids_of_sigelt se)), (se))) ses)
in ((env), (_0_335)))
end
| uu____3137 -> begin
((env), (((((FStar_Syntax_Util.lids_of_sigelt s)), (s)))::[]))
end)
in (match (uu____3105) with
| (env, lss) -> begin
((FStar_All.pipe_right lss (FStar_List.iter (fun uu____3167 -> (match (uu____3167) with
| (lids, se) -> begin
(FStar_All.pipe_right lids (FStar_List.iter (fun lid -> ((let _0_337 = (let _0_336 = (FStar_ST.read globals)
in (Top_level_def (lid.FStar_Ident.ident))::_0_336)
in (FStar_ST.write globals _0_337));
(match (()) with
| () -> begin
(

let modul = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns).FStar_Ident.str
in ((

let uu____3186 = (get_exported_id_set env modul)
in (match (uu____3186) with
| Some (f) -> begin
(

let my_exported_ids = (f Exported_id_term_type)
in (let _0_339 = (let _0_338 = (FStar_ST.read my_exported_ids)
in (FStar_Util.set_add lid.FStar_Ident.ident.FStar_Ident.idText _0_338))
in (FStar_ST.write my_exported_ids _0_339)))
end
| None -> begin
()
end));
(match (()) with
| () -> begin
(FStar_Util.smap_add (sigmap env) lid.FStar_Ident.str ((se), ((env.iface && (not (env.admitted_iface))))))
end);
))
end);
))))
end))));
(

let env = (

let uu___177_3199 = env
in (let _0_340 = (FStar_ST.read globals)
in {curmodule = uu___177_3199.curmodule; curmonad = uu___177_3199.curmonad; modules = uu___177_3199.modules; scope_mods = _0_340; exported_ids = uu___177_3199.exported_ids; trans_exported_ids = uu___177_3199.trans_exported_ids; includes = uu___177_3199.includes; sigaccum = uu___177_3199.sigaccum; sigmap = uu___177_3199.sigmap; iface = uu___177_3199.iface; admitted_iface = uu___177_3199.admitted_iface; expect_typ = uu___177_3199.expect_typ}))
in env);
)
end)))))))


let push_namespace : env  ->  FStar_Ident.lident  ->  env = (fun env ns -> (

let uu____3209 = (

let uu____3212 = (resolve_module_name env ns false)
in (match (uu____3212) with
| None -> begin
(

let modules = env.modules
in (

let uu____3220 = (FStar_All.pipe_right modules (FStar_Util.for_some (fun uu____3226 -> (match (uu____3226) with
| (m, uu____3230) -> begin
(FStar_Util.starts_with (Prims.strcat (FStar_Ident.text_of_lid m) ".") (Prims.strcat (FStar_Ident.text_of_lid ns) "."))
end))))
in (match (uu____3220) with
| true -> begin
((ns), (Open_namespace))
end
| uu____3233 -> begin
(Prims.raise (FStar_Errors.Error ((let _0_341 = (FStar_Util.format1 "Namespace %s cannot be found" (FStar_Ident.text_of_lid ns))
in ((_0_341), ((FStar_Ident.range_of_lid ns)))))))
end)))
end
| Some (ns') -> begin
((ns'), (Open_module))
end))
in (match (uu____3209) with
| (ns', kd) -> begin
(push_scope_mod env (Open_module_or_namespace (((ns'), (kd)))))
end)))


let push_include : env  ->  FStar_Ident.lident  ->  env = (fun env ns -> (

let uu____3245 = (resolve_module_name env ns false)
in (match (uu____3245) with
| Some (ns) -> begin
(

let env = (push_scope_mod env (Open_module_or_namespace (((ns), (Open_module)))))
in (

let curmod = (current_module env).FStar_Ident.str
in ((

let uu____3251 = (FStar_Util.smap_try_find env.includes curmod)
in (match (uu____3251) with
| None -> begin
()
end
| Some (incl) -> begin
(let _0_343 = (let _0_342 = (FStar_ST.read incl)
in (ns)::_0_342)
in (FStar_ST.write incl _0_343))
end));
(match (()) with
| () -> begin
(

let uu____3270 = (get_trans_exported_id_set env ns.FStar_Ident.str)
in (match (uu____3270) with
| Some (ns_trans_exports) -> begin
((

let uu____3274 = (let _0_345 = (get_exported_id_set env curmod)
in (let _0_344 = (get_trans_exported_id_set env curmod)
in ((_0_345), (_0_344))))
in (match (uu____3274) with
| (Some (cur_exports), Some (cur_trans_exports)) -> begin
(

let update_exports = (fun k -> (

let ns_ex = (FStar_ST.read (ns_trans_exports k))
in (

let ex = (cur_exports k)
in ((let _0_347 = (let _0_346 = (FStar_ST.read ex)
in (FStar_Util.set_difference _0_346 ns_ex))
in (FStar_ST.write ex _0_347));
(match (()) with
| () -> begin
(

let trans_ex = (cur_trans_exports k)
in (

let _0_349 = (let _0_348 = (FStar_ST.read ex)
in (FStar_Util.set_union _0_348 ns_ex))
in (FStar_ST.write trans_ex _0_349)))
end);
))))
in (FStar_List.iter update_exports all_exported_id_kinds))
end
| uu____3308 -> begin
()
end));
(match (()) with
| () -> begin
env
end);
)
end
| None -> begin
(Prims.raise (FStar_Errors.Error ((let _0_350 = (FStar_Util.format1 "include: Module %s was not prepared" ns.FStar_Ident.str)
in ((_0_350), ((FStar_Ident.range_of_lid ns)))))))
end))
end);
)))
end
| uu____3313 -> begin
(Prims.raise (FStar_Errors.Error ((let _0_351 = (FStar_Util.format1 "include: Module %s cannot be found" ns.FStar_Ident.str)
in ((_0_351), ((FStar_Ident.range_of_lid ns)))))))
end)))


let push_module_abbrev : env  ->  FStar_Ident.ident  ->  FStar_Ident.lident  ->  env = (fun env x l -> (

let uu____3324 = (module_is_defined env l)
in (match (uu____3324) with
| true -> begin
(push_scope_mod env (Module_abbrev (((x), (l)))))
end
| uu____3325 -> begin
(Prims.raise (FStar_Errors.Error ((let _0_352 = (FStar_Util.format1 "Module %s cannot be found" (FStar_Ident.text_of_lid l))
in ((_0_352), ((FStar_Ident.range_of_lid l)))))))
end)))


let check_admits : env  ->  Prims.unit = (fun env -> (FStar_All.pipe_right env.sigaccum (FStar_List.iter (fun se -> (match (se) with
| FStar_Syntax_Syntax.Sig_declare_typ (l, u, t, quals, r) -> begin
(

let uu____3337 = (try_lookup_lid env l)
in (match (uu____3337) with
| None -> begin
((FStar_Util.print_string (let _0_354 = (FStar_Range.string_of_range (FStar_Ident.range_of_lid l))
in (let _0_353 = (FStar_Syntax_Print.lid_to_string l)
in (FStar_Util.format2 "%s: Warning: Admitting %s without a definition\n" _0_354 _0_353))));
(FStar_Util.smap_add (sigmap env) l.FStar_Ident.str ((FStar_Syntax_Syntax.Sig_declare_typ (((l), (u), (t), ((FStar_Syntax_Syntax.Assumption)::quals), (r)))), (false)));
)
end
| Some (uu____3347) -> begin
()
end))
end
| uu____3352 -> begin
()
end)))))


let finish : env  ->  FStar_Syntax_Syntax.modul  ->  env = (fun env modul -> ((FStar_All.pipe_right modul.FStar_Syntax_Syntax.declarations (FStar_List.iter (fun uu___170_3360 -> (match (uu___170_3360) with
| FStar_Syntax_Syntax.Sig_bundle (ses, quals, uu____3363, uu____3364) -> begin
(match (((FStar_List.contains FStar_Syntax_Syntax.Private quals) || (FStar_List.contains FStar_Syntax_Syntax.Abstract quals))) with
| true -> begin
(FStar_All.pipe_right ses (FStar_List.iter (fun uu___169_3372 -> (match (uu___169_3372) with
| FStar_Syntax_Syntax.Sig_datacon (lid, uu____3374, uu____3375, uu____3376, uu____3377, uu____3378, uu____3379, uu____3380) -> begin
(FStar_Util.smap_remove (sigmap env) lid.FStar_Ident.str)
end
| uu____3387 -> begin
()
end))))
end
| uu____3388 -> begin
()
end)
end
| FStar_Syntax_Syntax.Sig_declare_typ (lid, uu____3390, uu____3391, quals, uu____3393) -> begin
(match ((FStar_List.contains FStar_Syntax_Syntax.Private quals)) with
| true -> begin
(FStar_Util.smap_remove (sigmap env) lid.FStar_Ident.str)
end
| uu____3398 -> begin
()
end)
end
| FStar_Syntax_Syntax.Sig_let ((uu____3399, lbs), r, uu____3402, quals, uu____3404) -> begin
((match (((FStar_List.contains FStar_Syntax_Syntax.Private quals) || (FStar_List.contains FStar_Syntax_Syntax.Abstract quals))) with
| true -> begin
(FStar_All.pipe_right lbs (FStar_List.iter (fun lb -> (let _0_355 = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname).FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.str
in (FStar_Util.smap_remove (sigmap env) _0_355)))))
end
| uu____3425 -> begin
()
end);
(match (((FStar_List.contains FStar_Syntax_Syntax.Abstract quals) && (not ((FStar_List.contains FStar_Syntax_Syntax.Private quals))))) with
| true -> begin
(FStar_All.pipe_right lbs (FStar_List.iter (fun lb -> (

let lid = (FStar_Util.right lb.FStar_Syntax_Syntax.lbname).FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let decl = FStar_Syntax_Syntax.Sig_declare_typ (((lid), (lb.FStar_Syntax_Syntax.lbunivs), (lb.FStar_Syntax_Syntax.lbtyp), ((FStar_Syntax_Syntax.Assumption)::quals), (r)))
in (FStar_Util.smap_add (sigmap env) lid.FStar_Ident.str ((decl), (false))))))))
end
| uu____3440 -> begin
()
end);
)
end
| uu____3441 -> begin
()
end))));
(

let curmod = (current_module env).FStar_Ident.str
in ((

let uu____3444 = (let _0_357 = (get_exported_id_set env curmod)
in (let _0_356 = (get_trans_exported_id_set env curmod)
in ((_0_357), (_0_356))))
in (match (uu____3444) with
| (Some (cur_ex), Some (cur_trans_ex)) -> begin
(

let update_exports = (fun eikind -> (

let cur_ex_set = (FStar_ST.read (cur_ex eikind))
in (

let cur_trans_ex_set_ref = (cur_trans_ex eikind)
in (let _0_359 = (let _0_358 = (FStar_ST.read cur_trans_ex_set_ref)
in (FStar_Util.set_union cur_ex_set _0_358))
in (FStar_ST.write cur_trans_ex_set_ref _0_359)))))
in (FStar_List.iter update_exports all_exported_id_kinds))
end
| uu____3469 -> begin
()
end));
(match (()) with
| () -> begin
((filter_record_cache ());
(match (()) with
| () -> begin
(

let uu___178_3475 = env
in {curmodule = None; curmonad = uu___178_3475.curmonad; modules = (((modul.FStar_Syntax_Syntax.name), (modul)))::env.modules; scope_mods = []; exported_ids = uu___178_3475.exported_ids; trans_exported_ids = uu___178_3475.trans_exported_ids; includes = uu___178_3475.includes; sigaccum = []; sigmap = uu___178_3475.sigmap; iface = uu___178_3475.iface; admitted_iface = uu___178_3475.admitted_iface; expect_typ = uu___178_3475.expect_typ})
end);
)
end);
));
))

type env_stack_ops =
{push : env  ->  env; mark : env  ->  env; reset_mark : env  ->  env; commit_mark : env  ->  env; pop : env  ->  env}


let stack_ops : env_stack_ops = (

let stack = (FStar_Util.mk_ref [])
in (

let push = (fun env -> ((push_record_cache ());
(let _0_361 = (let _0_360 = (FStar_ST.read stack)
in (env)::_0_360)
in (FStar_ST.write stack _0_361));
(

let uu___179_3565 = env
in (let _0_362 = (FStar_Util.smap_copy (sigmap env))
in {curmodule = uu___179_3565.curmodule; curmonad = uu___179_3565.curmonad; modules = uu___179_3565.modules; scope_mods = uu___179_3565.scope_mods; exported_ids = uu___179_3565.exported_ids; trans_exported_ids = uu___179_3565.trans_exported_ids; includes = uu___179_3565.includes; sigaccum = uu___179_3565.sigaccum; sigmap = _0_362; iface = uu___179_3565.iface; admitted_iface = uu___179_3565.admitted_iface; expect_typ = uu___179_3565.expect_typ}));
))
in (

let pop = (fun env -> (

let uu____3572 = (FStar_ST.read stack)
in (match (uu____3572) with
| (env)::tl -> begin
((pop_record_cache ());
(FStar_ST.write stack tl);
env;
)
end
| uu____3585 -> begin
(failwith "Impossible: Too many pops")
end)))
in (

let commit_mark = (fun env -> ((commit_record_cache ());
(

let uu____3592 = (FStar_ST.read stack)
in (match (uu____3592) with
| (uu____3597)::tl -> begin
((FStar_ST.write stack tl);
env;
)
end
| uu____3604 -> begin
(failwith "Impossible: Too many pops")
end));
))
in {push = push; mark = push; reset_mark = pop; commit_mark = commit_mark; pop = pop}))))


let push : env  ->  env = (fun env -> (stack_ops.push env))


let mark : env  ->  env = (fun env -> (stack_ops.mark env))


let reset_mark : env  ->  env = (fun env -> (stack_ops.reset_mark env))


let commit_mark : env  ->  env = (fun env -> (stack_ops.commit_mark env))


let pop : env  ->  env = (fun env -> (stack_ops.pop env))


let export_interface : FStar_Ident.lident  ->  env  ->  env = (fun m env -> (

let sigelt_in_m = (fun se -> (match ((FStar_Syntax_Util.lids_of_sigelt se)) with
| (l)::uu____3632 -> begin
(l.FStar_Ident.nsstr = m.FStar_Ident.str)
end
| uu____3634 -> begin
false
end))
in (

let sm = (sigmap env)
in (

let env = (pop env)
in (

let keys = (FStar_Util.smap_keys sm)
in (

let sm' = (sigmap env)
in ((FStar_All.pipe_right keys (FStar_List.iter (fun k -> (

let uu____3652 = (FStar_Util.smap_try_find sm' k)
in (match (uu____3652) with
| Some (se, true) when (sigelt_in_m se) -> begin
((FStar_Util.smap_remove sm' k);
(

let se = (match (se) with
| FStar_Syntax_Syntax.Sig_declare_typ (l, u, t, q, r) -> begin
FStar_Syntax_Syntax.Sig_declare_typ (((l), (u), (t), ((FStar_Syntax_Syntax.Assumption)::q), (r)))
end
| uu____3673 -> begin
se
end)
in (FStar_Util.smap_add sm' k ((se), (false))));
)
end
| uu____3676 -> begin
()
end)))));
env;
)))))))


let finish_module_or_interface : env  ->  FStar_Syntax_Syntax.modul  ->  env = (fun env modul -> ((match ((not (modul.FStar_Syntax_Syntax.is_interface))) with
| true -> begin
(check_admits env)
end
| uu____3687 -> begin
()
end);
(finish env modul);
))


let prepare_module_or_interface : Prims.bool  ->  Prims.bool  ->  env  ->  FStar_Ident.lident  ->  (env * Prims.bool) = (fun intf admitted env mname -> (

let prep = (fun env -> (

let open_ns = (match ((FStar_Ident.lid_equals mname FStar_Syntax_Const.prims_lid)) with
| true -> begin
[]
end
| uu____3709 -> begin
(match ((FStar_Util.starts_with "FStar." (FStar_Ident.text_of_lid mname))) with
| true -> begin
(FStar_Syntax_Const.prims_lid)::(FStar_Syntax_Const.fstar_ns_lid)::[]
end
| uu____3711 -> begin
(FStar_Syntax_Const.prims_lid)::(FStar_Syntax_Const.st_lid)::(FStar_Syntax_Const.all_lid)::(FStar_Syntax_Const.fstar_ns_lid)::[]
end)
end)
in (

let open_ns = (match (((FStar_List.length mname.FStar_Ident.ns) <> (Prims.parse_int "0"))) with
| true -> begin
(

let ns = (FStar_Ident.lid_of_ids mname.FStar_Ident.ns)
in (ns)::open_ns)
end
| uu____3718 -> begin
open_ns
end)
in ((let _0_363 = (exported_id_set_new ())
in (FStar_Util.smap_add env.exported_ids mname.FStar_Ident.str _0_363));
(match (()) with
| () -> begin
((let _0_364 = (exported_id_set_new ())
in (FStar_Util.smap_add env.trans_exported_ids mname.FStar_Ident.str _0_364));
(match (()) with
| () -> begin
((let _0_365 = (FStar_Util.mk_ref [])
in (FStar_Util.smap_add env.includes mname.FStar_Ident.str _0_365));
(match (()) with
| () -> begin
(

let uu___180_3731 = env
in (let _0_366 = (FStar_List.map (fun lid -> Open_module_or_namespace (((lid), (Open_namespace)))) open_ns)
in {curmodule = Some (mname); curmonad = uu___180_3731.curmonad; modules = uu___180_3731.modules; scope_mods = _0_366; exported_ids = uu___180_3731.exported_ids; trans_exported_ids = uu___180_3731.trans_exported_ids; includes = uu___180_3731.includes; sigaccum = uu___180_3731.sigaccum; sigmap = env.sigmap; iface = intf; admitted_iface = admitted; expect_typ = uu___180_3731.expect_typ}))
end);
)
end);
)
end);
))))
in (

let uu____3733 = (FStar_All.pipe_right env.modules (FStar_Util.find_opt (fun uu____3745 -> (match (uu____3745) with
| (l, uu____3749) -> begin
(FStar_Ident.lid_equals l mname)
end))))
in (match (uu____3733) with
| None -> begin
(let _0_367 = (prep env)
in ((_0_367), (false)))
end
| Some (uu____3754, m) -> begin
((match (((not (m.FStar_Syntax_Syntax.is_interface)) || intf)) with
| true -> begin
(Prims.raise (FStar_Errors.Error ((let _0_368 = (FStar_Util.format1 "Duplicate module or interface name: %s" mname.FStar_Ident.str)
in ((_0_368), ((FStar_Ident.range_of_lid mname)))))))
end
| uu____3759 -> begin
()
end);
(let _0_369 = (prep (push env))
in ((_0_369), (true)));
)
end))))


let enter_monad_scope : env  ->  FStar_Ident.ident  ->  env = (fun env mname -> (match (env.curmonad) with
| Some (mname') -> begin
(Prims.raise (FStar_Errors.Error ((((Prims.strcat "Trying to define monad " (Prims.strcat mname.FStar_Ident.idText (Prims.strcat ", but already in monad scope " mname'.FStar_Ident.idText)))), (mname.FStar_Ident.idRange)))))
end
| None -> begin
(

let uu___181_3767 = env
in {curmodule = uu___181_3767.curmodule; curmonad = Some (mname); modules = uu___181_3767.modules; scope_mods = uu___181_3767.scope_mods; exported_ids = uu___181_3767.exported_ids; trans_exported_ids = uu___181_3767.trans_exported_ids; includes = uu___181_3767.includes; sigaccum = uu___181_3767.sigaccum; sigmap = uu___181_3767.sigmap; iface = uu___181_3767.iface; admitted_iface = uu___181_3767.admitted_iface; expect_typ = uu___181_3767.expect_typ})
end))


let fail_or = (fun env lookup lid -> (

let uu____3792 = (lookup lid)
in (match (uu____3792) with
| None -> begin
(

let opened_modules = (FStar_List.map (fun uu____3798 -> (match (uu____3798) with
| (lid, uu____3802) -> begin
(FStar_Ident.text_of_lid lid)
end)) env.modules)
in (

let msg = (FStar_Util.format1 "Identifier not found: [%s]" (FStar_Ident.text_of_lid lid))
in (

let msg = (match (((FStar_List.length lid.FStar_Ident.ns) = (Prims.parse_int "0"))) with
| true -> begin
msg
end
| uu____3807 -> begin
(

let modul = (let _0_370 = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns)
in (FStar_Ident.set_lid_range _0_370 (FStar_Ident.range_of_lid lid)))
in (

let uu____3809 = (resolve_module_name env modul true)
in (match (uu____3809) with
| None -> begin
(

let opened_modules = (FStar_String.concat ", " opened_modules)
in (FStar_Util.format3 "%s\nModule %s does not belong to the list of modules in scope, namely %s" msg modul.FStar_Ident.str opened_modules))
end
| Some (modul') when (not ((FStar_List.existsb (fun m -> (m = modul'.FStar_Ident.str)) opened_modules))) -> begin
(

let opened_modules = (FStar_String.concat ", " opened_modules)
in (FStar_Util.format4 "%s\nModule %s resolved into %s, which does not belong to the list of modules in scope, namely %s" msg modul.FStar_Ident.str modul'.FStar_Ident.str opened_modules))
end
| Some (modul') -> begin
(FStar_Util.format4 "%s\nModule %s resolved into %s, definition %s not found" msg modul.FStar_Ident.str modul'.FStar_Ident.str lid.FStar_Ident.ident.FStar_Ident.idText)
end)))
end)
in (Prims.raise (FStar_Errors.Error (((msg), ((FStar_Ident.range_of_lid lid)))))))))
end
| Some (r) -> begin
r
end)))


let fail_or2 = (fun lookup id -> (

let uu____3836 = (lookup id)
in (match (uu____3836) with
| None -> begin
(Prims.raise (FStar_Errors.Error ((((Prims.strcat "Identifier not found [" (Prims.strcat id.FStar_Ident.idText "]"))), (id.FStar_Ident.idRange)))))
end
| Some (r) -> begin
r
end)))




