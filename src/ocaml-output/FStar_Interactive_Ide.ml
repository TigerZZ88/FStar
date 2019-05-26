open Prims
let with_captured_errors' :
  'Auu____28 .
    FStar_TypeChecker_Env.env ->
      FStar_Util.sigint_handler ->
        (FStar_TypeChecker_Env.env ->
           'Auu____28 FStar_Pervasives_Native.option)
          -> 'Auu____28 FStar_Pervasives_Native.option
  =
  fun env ->
    fun sigint_handler ->
      fun f ->
        try
          (fun uu___13_58 ->
             match () with
             | () ->
                 FStar_Util.with_sigint_handler sigint_handler
                   (fun uu____64 -> f env)) ()
        with
        | FStar_All.Failure msg ->
            let msg1 =
              Prims.op_Hat "ASSERTION FAILURE: "
                (Prims.op_Hat msg
                   (Prims.op_Hat "\n"
                      (Prims.op_Hat "F* may be in an inconsistent state.\n"
                         (Prims.op_Hat
                            "Please file a bug report, ideally with a "
                            "minimized version of the program that triggered the error.")))) in
            ((let uu____82 = FStar_TypeChecker_Env.get_range env in
              FStar_Errors.log_issue uu____82
                (FStar_Errors.Error_IDEAssertionFailure, msg1));
             FStar_Pervasives_Native.None)
        | FStar_Util.SigInt ->
            (FStar_Util.print_string "Interrupted";
             FStar_Pervasives_Native.None)
        | FStar_Errors.Error (e, msg, r) ->
            (FStar_TypeChecker_Err.add_errors env [(e, msg, r)];
             FStar_Pervasives_Native.None)
        | FStar_Errors.Err (e, msg) ->
            ((let uu____112 =
                let uu____122 =
                  let uu____130 = FStar_TypeChecker_Env.get_range env in
                  (e, msg, uu____130) in
                [uu____122] in
              FStar_TypeChecker_Err.add_errors env uu____112);
             FStar_Pervasives_Native.None)
        | FStar_Errors.Stop -> FStar_Pervasives_Native.None
let with_captured_errors :
  'Auu____155 .
    FStar_TypeChecker_Env.env ->
      FStar_Util.sigint_handler ->
        (FStar_TypeChecker_Env.env ->
           'Auu____155 FStar_Pervasives_Native.option)
          -> 'Auu____155 FStar_Pervasives_Native.option
  =
  fun env ->
    fun sigint_handler ->
      fun f ->
        let uu____182 = FStar_Options.trace_error () in
        if uu____182
        then f env
        else with_captured_errors' env sigint_handler f
let (t0 : FStar_Util.time) = FStar_Util.now ()
let (tf_of_fname : Prims.string -> FStar_JsonHelper.timed_fname) =
  fun fname ->
    let uu____198 =
      FStar_Parser_ParseIt.get_file_last_modification_time fname in
    {
      FStar_JsonHelper.tf_fname = fname;
      FStar_JsonHelper.tf_modtime = uu____198
    }
let (dummy_tf_of_fname : Prims.string -> FStar_JsonHelper.timed_fname) =
  fun fname ->
    { FStar_JsonHelper.tf_fname = fname; FStar_JsonHelper.tf_modtime = t0 }
let (string_of_timed_fname : FStar_JsonHelper.timed_fname -> Prims.string) =
  fun uu____213 ->
    match uu____213 with
    | { FStar_JsonHelper.tf_fname = fname;
        FStar_JsonHelper.tf_modtime = modtime;_} ->
        if modtime = t0
        then FStar_Util.format1 "{ %s }" fname
        else
          (let uu____223 = FStar_Util.string_of_time modtime in
           FStar_Util.format2 "{ %s; %s }" fname uu____223)
type push_query =
  {
  push_kind: FStar_PushHelper.push_kind ;
  push_code: Prims.string ;
  push_line: Prims.int ;
  push_column: Prims.int ;
  push_peek_only: Prims.bool }
let (__proj__Mkpush_query__item__push_kind :
  push_query -> FStar_PushHelper.push_kind) =
  fun projectee ->
    match projectee with
    | { push_kind; push_code; push_line; push_column; push_peek_only;_} ->
        push_kind
let (__proj__Mkpush_query__item__push_code : push_query -> Prims.string) =
  fun projectee ->
    match projectee with
    | { push_kind; push_code; push_line; push_column; push_peek_only;_} ->
        push_code
let (__proj__Mkpush_query__item__push_line : push_query -> Prims.int) =
  fun projectee ->
    match projectee with
    | { push_kind; push_code; push_line; push_column; push_peek_only;_} ->
        push_line
let (__proj__Mkpush_query__item__push_column : push_query -> Prims.int) =
  fun projectee ->
    match projectee with
    | { push_kind; push_code; push_line; push_column; push_peek_only;_} ->
        push_column
let (__proj__Mkpush_query__item__push_peek_only : push_query -> Prims.bool) =
  fun projectee ->
    match projectee with
    | { push_kind; push_code; push_line; push_column; push_peek_only;_} ->
        push_peek_only
type env_t = FStar_TypeChecker_Env.env
let (repl_current_qid :
  Prims.string FStar_Pervasives_Native.option FStar_ST.ref) =
  FStar_Util.mk_ref FStar_Pervasives_Native.None
let (nothing_left_to_pop : FStar_JsonHelper.repl_state -> Prims.bool) =
  fun st ->
    let uu____355 =
      let uu____356 = FStar_ST.op_Bang FStar_PushHelper.repl_stack in
      FStar_List.length uu____356 in
    uu____355 = (FStar_List.length st.FStar_JsonHelper.repl_deps_stack)
type name_tracking_event =
  | NTAlias of (FStar_Ident.lid * FStar_Ident.ident * FStar_Ident.lid) 
  | NTOpen of (FStar_Ident.lid * FStar_Syntax_DsEnv.open_module_or_namespace)
  
  | NTInclude of (FStar_Ident.lid * FStar_Ident.lid) 
  | NTBinding of (FStar_Syntax_Syntax.binding,
  FStar_TypeChecker_Env.sig_binding) FStar_Util.either 
let (uu___is_NTAlias : name_tracking_event -> Prims.bool) =
  fun projectee ->
    match projectee with | NTAlias _0 -> true | uu____456 -> false
let (__proj__NTAlias__item___0 :
  name_tracking_event ->
    (FStar_Ident.lid * FStar_Ident.ident * FStar_Ident.lid))
  = fun projectee -> match projectee with | NTAlias _0 -> _0
let (uu___is_NTOpen : name_tracking_event -> Prims.bool) =
  fun projectee ->
    match projectee with | NTOpen _0 -> true | uu____497 -> false
let (__proj__NTOpen__item___0 :
  name_tracking_event ->
    (FStar_Ident.lid * FStar_Syntax_DsEnv.open_module_or_namespace))
  = fun projectee -> match projectee with | NTOpen _0 -> _0
let (uu___is_NTInclude : name_tracking_event -> Prims.bool) =
  fun projectee ->
    match projectee with | NTInclude _0 -> true | uu____532 -> false
let (__proj__NTInclude__item___0 :
  name_tracking_event -> (FStar_Ident.lid * FStar_Ident.lid)) =
  fun projectee -> match projectee with | NTInclude _0 -> _0
let (uu___is_NTBinding : name_tracking_event -> Prims.bool) =
  fun projectee ->
    match projectee with | NTBinding _0 -> true | uu____567 -> false
let (__proj__NTBinding__item___0 :
  name_tracking_event ->
    (FStar_Syntax_Syntax.binding, FStar_TypeChecker_Env.sig_binding)
      FStar_Util.either)
  = fun projectee -> match projectee with | NTBinding _0 -> _0
let (query_of_ids :
  FStar_Ident.ident Prims.list -> FStar_Interactive_CompletionTable.query) =
  fun ids -> FStar_List.map FStar_Ident.text_of_id ids
let (query_of_lid :
  FStar_Ident.lident -> FStar_Interactive_CompletionTable.query) =
  fun lid ->
    query_of_ids
      (FStar_List.append lid.FStar_Ident.ns [lid.FStar_Ident.ident])
let (update_names_from_event :
  Prims.string ->
    FStar_Interactive_CompletionTable.table ->
      name_tracking_event -> FStar_Interactive_CompletionTable.table)
  =
  fun cur_mod_str ->
    fun table ->
      fun evt ->
        let is_cur_mod lid = lid.FStar_Ident.str = cur_mod_str in
        match evt with
        | NTAlias (host, id1, included) ->
            if is_cur_mod host
            then
              let uu____635 = FStar_Ident.text_of_id id1 in
              let uu____637 = query_of_lid included in
              FStar_Interactive_CompletionTable.register_alias table
                uu____635 [] uu____637
            else table
        | NTOpen (host, (included, kind)) ->
            if is_cur_mod host
            then
              let uu____645 = query_of_lid included in
              FStar_Interactive_CompletionTable.register_open table
                (kind = FStar_Syntax_DsEnv.Open_module) [] uu____645
            else table
        | NTInclude (host, included) ->
            let uu____651 = if is_cur_mod host then [] else query_of_lid host in
            let uu____656 = query_of_lid included in
            FStar_Interactive_CompletionTable.register_include table
              uu____651 uu____656
        | NTBinding binding ->
            let lids =
              match binding with
              | FStar_Util.Inl (FStar_Syntax_Syntax.Binding_lid
                  (lid, uu____668)) -> [lid]
              | FStar_Util.Inr (lids, uu____686) -> lids
              | uu____691 -> [] in
            FStar_List.fold_left
              (fun tbl ->
                 fun lid ->
                   let ns_query =
                     if lid.FStar_Ident.nsstr = cur_mod_str
                     then []
                     else query_of_ids lid.FStar_Ident.ns in
                   let uu____708 =
                     FStar_Ident.text_of_id lid.FStar_Ident.ident in
                   FStar_Interactive_CompletionTable.insert tbl ns_query
                     uu____708 lid) table lids
let (commit_name_tracking' :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    FStar_Interactive_CompletionTable.table ->
      name_tracking_event Prims.list ->
        FStar_Interactive_CompletionTable.table)
  =
  fun cur_mod ->
    fun names1 ->
      fun name_events ->
        let cur_mod_str =
          match cur_mod with
          | FStar_Pervasives_Native.None -> ""
          | FStar_Pervasives_Native.Some md ->
              let uu____739 = FStar_Syntax_Syntax.mod_name md in
              uu____739.FStar_Ident.str in
        let updater = update_names_from_event cur_mod_str in
        FStar_List.fold_left updater names1 name_events
let (commit_name_tracking :
  FStar_JsonHelper.repl_state ->
    name_tracking_event Prims.list -> FStar_JsonHelper.repl_state)
  =
  fun st ->
    fun name_events ->
      let names1 =
        commit_name_tracking' st.FStar_JsonHelper.repl_curmod
          st.FStar_JsonHelper.repl_names name_events in
      let uu___119_765 = st in
      {
        FStar_JsonHelper.repl_line =
          (uu___119_765.FStar_JsonHelper.repl_line);
        FStar_JsonHelper.repl_column =
          (uu___119_765.FStar_JsonHelper.repl_column);
        FStar_JsonHelper.repl_fname =
          (uu___119_765.FStar_JsonHelper.repl_fname);
        FStar_JsonHelper.repl_deps_stack =
          (uu___119_765.FStar_JsonHelper.repl_deps_stack);
        FStar_JsonHelper.repl_curmod =
          (uu___119_765.FStar_JsonHelper.repl_curmod);
        FStar_JsonHelper.repl_env = (uu___119_765.FStar_JsonHelper.repl_env);
        FStar_JsonHelper.repl_stdin =
          (uu___119_765.FStar_JsonHelper.repl_stdin);
        FStar_JsonHelper.repl_names = names1
      }
let (fresh_name_tracking_hooks :
  unit ->
    (name_tracking_event Prims.list FStar_ST.ref *
      FStar_Syntax_DsEnv.dsenv_hooks * FStar_TypeChecker_Env.tcenv_hooks))
  =
  fun uu____781 ->
    let events = FStar_Util.mk_ref [] in
    let push_event evt =
      let uu____795 =
        let uu____798 = FStar_ST.op_Bang events in evt :: uu____798 in
      FStar_ST.op_Colon_Equals events uu____795 in
    (events,
      {
        FStar_Syntax_DsEnv.ds_push_open_hook =
          (fun dsenv1 ->
             fun op ->
               let uu____859 =
                 let uu____860 =
                   let uu____865 = FStar_Syntax_DsEnv.current_module dsenv1 in
                   (uu____865, op) in
                 NTOpen uu____860 in
               push_event uu____859);
        FStar_Syntax_DsEnv.ds_push_include_hook =
          (fun dsenv1 ->
             fun ns ->
               let uu____871 =
                 let uu____872 =
                   let uu____877 = FStar_Syntax_DsEnv.current_module dsenv1 in
                   (uu____877, ns) in
                 NTInclude uu____872 in
               push_event uu____871);
        FStar_Syntax_DsEnv.ds_push_module_abbrev_hook =
          (fun dsenv1 ->
             fun x ->
               fun l ->
                 let uu____885 =
                   let uu____886 =
                     let uu____893 = FStar_Syntax_DsEnv.current_module dsenv1 in
                     (uu____893, x, l) in
                   NTAlias uu____886 in
                 push_event uu____885)
      },
      {
        FStar_TypeChecker_Env.tc_push_in_gamma_hook =
          (fun uu____898 -> fun s -> push_event (NTBinding s))
      })
let (track_name_changes :
  env_t -> (env_t * (env_t -> (env_t * name_tracking_event Prims.list)))) =
  fun env ->
    let set_hooks dshooks tchooks env1 =
      let uu____952 =
        FStar_Universal.with_dsenv_of_tcenv env1
          (fun dsenv1 ->
             let uu____960 = FStar_Syntax_DsEnv.set_ds_hooks dsenv1 dshooks in
             ((), uu____960)) in
      match uu____952 with
      | ((), tcenv') -> FStar_TypeChecker_Env.set_tc_hooks tcenv' tchooks in
    let uu____962 =
      let uu____967 =
        FStar_Syntax_DsEnv.ds_hooks env.FStar_TypeChecker_Env.dsenv in
      let uu____968 = FStar_TypeChecker_Env.tc_hooks env in
      (uu____967, uu____968) in
    match uu____962 with
    | (old_dshooks, old_tchooks) ->
        let uu____984 = fresh_name_tracking_hooks () in
        (match uu____984 with
         | (events, new_dshooks, new_tchooks) ->
             let uu____1019 = set_hooks new_dshooks new_tchooks env in
             (uu____1019,
               ((fun env1 ->
                   let uu____1033 = set_hooks old_dshooks old_tchooks env1 in
                   let uu____1034 =
                     let uu____1037 = FStar_ST.op_Bang events in
                     FStar_List.rev uu____1037 in
                   (uu____1033, uu____1034)))))
let (string_of_repl_task : FStar_JsonHelper.repl_task -> Prims.string) =
  fun uu___0_1071 ->
    match uu___0_1071 with
    | FStar_JsonHelper.LDInterleaved (intf, impl) ->
        let uu____1075 = string_of_timed_fname intf in
        let uu____1077 = string_of_timed_fname impl in
        FStar_Util.format2 "LDInterleaved (%s, %s)" uu____1075 uu____1077
    | FStar_JsonHelper.LDSingle intf_or_impl ->
        let uu____1081 = string_of_timed_fname intf_or_impl in
        FStar_Util.format1 "LDSingle %s" uu____1081
    | FStar_JsonHelper.LDInterfaceOfCurrentFile intf ->
        let uu____1085 = string_of_timed_fname intf in
        FStar_Util.format1 "LDInterfaceOfCurrentFile %s" uu____1085
    | FStar_JsonHelper.PushFragment frag ->
        FStar_Util.format1 "PushFragment { code = %s }"
          frag.FStar_Parser_ParseIt.frag_text
    | FStar_JsonHelper.Noop -> "Noop {}"
let (update_task_timestamps :
  FStar_JsonHelper.repl_task -> FStar_JsonHelper.repl_task) =
  fun uu___1_1096 ->
    match uu___1_1096 with
    | FStar_JsonHelper.LDInterleaved (intf, impl) ->
        let uu____1099 =
          let uu____1104 = tf_of_fname intf.FStar_JsonHelper.tf_fname in
          let uu____1105 = tf_of_fname impl.FStar_JsonHelper.tf_fname in
          (uu____1104, uu____1105) in
        FStar_JsonHelper.LDInterleaved uu____1099
    | FStar_JsonHelper.LDSingle intf_or_impl ->
        let uu____1107 = tf_of_fname intf_or_impl.FStar_JsonHelper.tf_fname in
        FStar_JsonHelper.LDSingle uu____1107
    | FStar_JsonHelper.LDInterfaceOfCurrentFile intf ->
        let uu____1109 = tf_of_fname intf.FStar_JsonHelper.tf_fname in
        FStar_JsonHelper.LDInterfaceOfCurrentFile uu____1109
    | other -> other
let (run_repl_transaction :
  FStar_JsonHelper.repl_state ->
    FStar_PushHelper.push_kind ->
      Prims.bool ->
        FStar_JsonHelper.repl_task ->
          (Prims.bool * FStar_JsonHelper.repl_state))
  =
  fun st ->
    fun push_kind ->
      fun must_rollback ->
        fun task ->
          let st1 =
            FStar_PushHelper.push_repl "run_repl_transaction" push_kind task
              st in
          let uu____1141 = track_name_changes st1.FStar_JsonHelper.repl_env in
          match uu____1141 with
          | (env, finish_name_tracking) ->
              let check_success uu____1186 =
                (let uu____1189 = FStar_Errors.get_err_count () in
                 uu____1189 = (Prims.parse_int "0")) &&
                  (Prims.op_Negation must_rollback) in
              let uu____1193 =
                let uu____1201 =
                  with_captured_errors env FStar_Util.sigint_raise
                    (fun env1 ->
                       let uu____1215 =
                         FStar_PushHelper.run_repl_task
                           st1.FStar_JsonHelper.repl_curmod env1 task in
                       FStar_All.pipe_left
                         (fun _1234 -> FStar_Pervasives_Native.Some _1234)
                         uu____1215) in
                match uu____1201 with
                | FStar_Pervasives_Native.Some (curmod, env1) when
                    check_success () -> (curmod, env1, true)
                | uu____1250 ->
                    ((st1.FStar_JsonHelper.repl_curmod), env, false) in
              (match uu____1193 with
               | (curmod, env1, success) ->
                   let uu____1269 = finish_name_tracking env1 in
                   (match uu____1269 with
                    | (env2, name_events) ->
                        let st2 =
                          if success
                          then
                            let st2 =
                              let uu___197_1290 = st1 in
                              {
                                FStar_JsonHelper.repl_line =
                                  (uu___197_1290.FStar_JsonHelper.repl_line);
                                FStar_JsonHelper.repl_column =
                                  (uu___197_1290.FStar_JsonHelper.repl_column);
                                FStar_JsonHelper.repl_fname =
                                  (uu___197_1290.FStar_JsonHelper.repl_fname);
                                FStar_JsonHelper.repl_deps_stack =
                                  (uu___197_1290.FStar_JsonHelper.repl_deps_stack);
                                FStar_JsonHelper.repl_curmod = curmod;
                                FStar_JsonHelper.repl_env = env2;
                                FStar_JsonHelper.repl_stdin =
                                  (uu___197_1290.FStar_JsonHelper.repl_stdin);
                                FStar_JsonHelper.repl_names =
                                  (uu___197_1290.FStar_JsonHelper.repl_names)
                              } in
                            commit_name_tracking st2 name_events
                          else
                            FStar_PushHelper.pop_repl "run_repl_transaction"
                              st1 in
                        (success, st2)))
let (run_repl_ld_transactions :
  FStar_JsonHelper.repl_state ->
    FStar_JsonHelper.repl_task Prims.list ->
      (FStar_JsonHelper.repl_task -> unit) ->
        (FStar_JsonHelper.repl_state, FStar_JsonHelper.repl_state)
          FStar_Util.either)
  =
  fun st ->
    fun tasks ->
      fun progress_callback ->
        let debug1 verb task =
          let uu____1337 = FStar_Options.debug_any () in
          if uu____1337
          then
            let uu____1340 = string_of_repl_task task in
            FStar_Util.print2 "%s %s" verb uu____1340
          else () in
        let rec revert_many st1 uu___2_1365 =
          match uu___2_1365 with
          | [] -> st1
          | (_id, (task, _st'))::entries ->
              (debug1 "Reverting" task;
               (let st' =
                  FStar_PushHelper.pop_repl "run_repl_ls_transactions" st1 in
                let dep_graph1 =
                  FStar_TypeChecker_Env.dep_graph
                    st1.FStar_JsonHelper.repl_env in
                let st'1 =
                  let uu___223_1418 = st' in
                  let uu____1419 =
                    FStar_TypeChecker_Env.set_dep_graph
                      st'.FStar_JsonHelper.repl_env dep_graph1 in
                  {
                    FStar_JsonHelper.repl_line =
                      (uu___223_1418.FStar_JsonHelper.repl_line);
                    FStar_JsonHelper.repl_column =
                      (uu___223_1418.FStar_JsonHelper.repl_column);
                    FStar_JsonHelper.repl_fname =
                      (uu___223_1418.FStar_JsonHelper.repl_fname);
                    FStar_JsonHelper.repl_deps_stack =
                      (uu___223_1418.FStar_JsonHelper.repl_deps_stack);
                    FStar_JsonHelper.repl_curmod =
                      (uu___223_1418.FStar_JsonHelper.repl_curmod);
                    FStar_JsonHelper.repl_env = uu____1419;
                    FStar_JsonHelper.repl_stdin =
                      (uu___223_1418.FStar_JsonHelper.repl_stdin);
                    FStar_JsonHelper.repl_names =
                      (uu___223_1418.FStar_JsonHelper.repl_names)
                  } in
                revert_many st'1 entries)) in
        let rec aux st1 tasks1 previous =
          match (tasks1, previous) with
          | ([], []) -> FStar_Util.Inl st1
          | (task::tasks2, []) ->
              (debug1 "Loading" task;
               progress_callback task;
               (let uu____1472 = FStar_Options.restore_cmd_line_options false in
                FStar_All.pipe_right uu____1472 (fun a1 -> ()));
               (let timestamped_task = update_task_timestamps task in
                let push_kind =
                  let uu____1476 = FStar_Options.lax () in
                  if uu____1476
                  then FStar_PushHelper.LaxCheck
                  else FStar_PushHelper.FullCheck in
                let uu____1481 =
                  run_repl_transaction st1 push_kind false timestamped_task in
                match uu____1481 with
                | (success, st2) ->
                    if success
                    then
                      let uu____1501 =
                        let uu___248_1502 = st2 in
                        let uu____1503 =
                          FStar_ST.op_Bang FStar_PushHelper.repl_stack in
                        {
                          FStar_JsonHelper.repl_line =
                            (uu___248_1502.FStar_JsonHelper.repl_line);
                          FStar_JsonHelper.repl_column =
                            (uu___248_1502.FStar_JsonHelper.repl_column);
                          FStar_JsonHelper.repl_fname =
                            (uu___248_1502.FStar_JsonHelper.repl_fname);
                          FStar_JsonHelper.repl_deps_stack = uu____1503;
                          FStar_JsonHelper.repl_curmod =
                            (uu___248_1502.FStar_JsonHelper.repl_curmod);
                          FStar_JsonHelper.repl_env =
                            (uu___248_1502.FStar_JsonHelper.repl_env);
                          FStar_JsonHelper.repl_stdin =
                            (uu___248_1502.FStar_JsonHelper.repl_stdin);
                          FStar_JsonHelper.repl_names =
                            (uu___248_1502.FStar_JsonHelper.repl_names)
                        } in
                      aux uu____1501 tasks2 []
                    else FStar_Util.Inr st2))
          | (task::tasks2, prev::previous1) when
              let uu____1547 = update_task_timestamps task in
              (FStar_Pervasives_Native.fst (FStar_Pervasives_Native.snd prev))
                = uu____1547
              -> (debug1 "Skipping" task; aux st1 tasks2 previous1)
          | (tasks2, previous1) ->
              let uu____1564 = revert_many st1 previous1 in
              aux uu____1564 tasks2 [] in
        aux st tasks (FStar_List.rev st.FStar_JsonHelper.repl_deps_stack)
let (js_pushkind : FStar_Util.json -> FStar_PushHelper.push_kind) =
  fun s ->
    let uu____1579 = FStar_JsonHelper.js_str s in
    match uu____1579 with
    | "syntax" -> FStar_PushHelper.SyntaxCheck
    | "lax" -> FStar_PushHelper.LaxCheck
    | "full" -> FStar_PushHelper.FullCheck
    | uu____1584 -> FStar_JsonHelper.js_fail "push_kind" s
let (js_reductionrule : FStar_Util.json -> FStar_TypeChecker_Env.step) =
  fun s ->
    let uu____1593 = FStar_JsonHelper.js_str s in
    match uu____1593 with
    | "beta" -> FStar_TypeChecker_Env.Beta
    | "delta" ->
        FStar_TypeChecker_Env.UnfoldUntil FStar_Syntax_Syntax.delta_constant
    | "iota" -> FStar_TypeChecker_Env.Iota
    | "zeta" -> FStar_TypeChecker_Env.Zeta
    | "reify" -> FStar_TypeChecker_Env.Reify
    | "pure-subterms" -> FStar_TypeChecker_Env.PureSubtermsWithinComputations
    | uu____1601 -> FStar_JsonHelper.js_fail "reduction rule" s
type completion_context =
  | CKCode 
  | CKOption of Prims.bool 
  | CKModuleOrNamespace of (Prims.bool * Prims.bool) 
let (uu___is_CKCode : completion_context -> Prims.bool) =
  fun projectee ->
    match projectee with | CKCode -> true | uu____1630 -> false
let (uu___is_CKOption : completion_context -> Prims.bool) =
  fun projectee ->
    match projectee with | CKOption _0 -> true | uu____1643 -> false
let (__proj__CKOption__item___0 : completion_context -> Prims.bool) =
  fun projectee -> match projectee with | CKOption _0 -> _0
let (uu___is_CKModuleOrNamespace : completion_context -> Prims.bool) =
  fun projectee ->
    match projectee with
    | CKModuleOrNamespace _0 -> true
    | uu____1671 -> false
let (__proj__CKModuleOrNamespace__item___0 :
  completion_context -> (Prims.bool * Prims.bool)) =
  fun projectee -> match projectee with | CKModuleOrNamespace _0 -> _0
let (js_optional_completion_context :
  FStar_Util.json FStar_Pervasives_Native.option -> completion_context) =
  fun k ->
    match k with
    | FStar_Pervasives_Native.None -> CKCode
    | FStar_Pervasives_Native.Some k1 ->
        let uu____1709 = FStar_JsonHelper.js_str k1 in
        (match uu____1709 with
         | "symbol" -> CKCode
         | "code" -> CKCode
         | "set-options" -> CKOption false
         | "reset-options" -> CKOption true
         | "open" -> CKModuleOrNamespace (true, true)
         | "let-open" -> CKModuleOrNamespace (true, true)
         | "include" -> CKModuleOrNamespace (true, false)
         | "module-alias" -> CKModuleOrNamespace (true, false)
         | uu____1737 ->
             FStar_JsonHelper.js_fail
               "completion context (code, set-options, reset-options, open, let-open, include, module-alias)"
               k1)
type lookup_context =
  | LKSymbolOnly 
  | LKModule 
  | LKOption 
  | LKCode 
let (uu___is_LKSymbolOnly : lookup_context -> Prims.bool) =
  fun projectee ->
    match projectee with | LKSymbolOnly -> true | uu____1749 -> false
let (uu___is_LKModule : lookup_context -> Prims.bool) =
  fun projectee ->
    match projectee with | LKModule -> true | uu____1760 -> false
let (uu___is_LKOption : lookup_context -> Prims.bool) =
  fun projectee ->
    match projectee with | LKOption -> true | uu____1771 -> false
let (uu___is_LKCode : lookup_context -> Prims.bool) =
  fun projectee ->
    match projectee with | LKCode -> true | uu____1782 -> false
let (js_optional_lookup_context :
  FStar_Util.json FStar_Pervasives_Native.option -> lookup_context) =
  fun k ->
    match k with
    | FStar_Pervasives_Native.None -> LKSymbolOnly
    | FStar_Pervasives_Native.Some k1 ->
        let uu____1795 = FStar_JsonHelper.js_str k1 in
        (match uu____1795 with
         | "symbol-only" -> LKSymbolOnly
         | "code" -> LKCode
         | "set-options" -> LKOption
         | "reset-options" -> LKOption
         | "open" -> LKModule
         | "let-open" -> LKModule
         | "include" -> LKModule
         | "module-alias" -> LKModule
         | uu____1805 ->
             FStar_JsonHelper.js_fail
               "lookup context (symbol-only, code, set-options, reset-options, open, let-open, include, module-alias)"
               k1)
type position = (Prims.string * Prims.int * Prims.int)
type query' =
  | Exit 
  | DescribeProtocol 
  | DescribeRepl 
  | Segment of Prims.string 
  | Pop 
  | Push of push_query 
  | VfsAdd of (Prims.string FStar_Pervasives_Native.option * Prims.string) 
  | AutoComplete of (Prims.string * completion_context) 
  | Lookup of (Prims.string * lookup_context * position
  FStar_Pervasives_Native.option * Prims.string Prims.list) 
  | Compute of (Prims.string * FStar_TypeChecker_Env.step Prims.list
  FStar_Pervasives_Native.option) 
  | Search of Prims.string 
  | GenericError of Prims.string 
  | ProtocolViolation of Prims.string 
and query = {
  qq: query' ;
  qid: Prims.string }
let (uu___is_Exit : query' -> Prims.bool) =
  fun projectee -> match projectee with | Exit -> true | uu____1922 -> false
let (uu___is_DescribeProtocol : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | DescribeProtocol -> true | uu____1933 -> false
let (uu___is_DescribeRepl : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | DescribeRepl -> true | uu____1944 -> false
let (uu___is_Segment : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | Segment _0 -> true | uu____1957 -> false
let (__proj__Segment__item___0 : query' -> Prims.string) =
  fun projectee -> match projectee with | Segment _0 -> _0
let (uu___is_Pop : query' -> Prims.bool) =
  fun projectee -> match projectee with | Pop -> true | uu____1978 -> false
let (uu___is_Push : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | Push _0 -> true | uu____1990 -> false
let (__proj__Push__item___0 : query' -> push_query) =
  fun projectee -> match projectee with | Push _0 -> _0
let (uu___is_VfsAdd : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | VfsAdd _0 -> true | uu____2017 -> false
let (__proj__VfsAdd__item___0 :
  query' -> (Prims.string FStar_Pervasives_Native.option * Prims.string)) =
  fun projectee -> match projectee with | VfsAdd _0 -> _0
let (uu___is_AutoComplete : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | AutoComplete _0 -> true | uu____2065 -> false
let (__proj__AutoComplete__item___0 :
  query' -> (Prims.string * completion_context)) =
  fun projectee -> match projectee with | AutoComplete _0 -> _0
let (uu___is_Lookup : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | Lookup _0 -> true | uu____2113 -> false
let (__proj__Lookup__item___0 :
  query' ->
    (Prims.string * lookup_context * position FStar_Pervasives_Native.option
      * Prims.string Prims.list))
  = fun projectee -> match projectee with | Lookup _0 -> _0
let (uu___is_Compute : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | Compute _0 -> true | uu____2183 -> false
let (__proj__Compute__item___0 :
  query' ->
    (Prims.string * FStar_TypeChecker_Env.step Prims.list
      FStar_Pervasives_Native.option))
  = fun projectee -> match projectee with | Compute _0 -> _0
let (uu___is_Search : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | Search _0 -> true | uu____2230 -> false
let (__proj__Search__item___0 : query' -> Prims.string) =
  fun projectee -> match projectee with | Search _0 -> _0
let (uu___is_GenericError : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | GenericError _0 -> true | uu____2253 -> false
let (__proj__GenericError__item___0 : query' -> Prims.string) =
  fun projectee -> match projectee with | GenericError _0 -> _0
let (uu___is_ProtocolViolation : query' -> Prims.bool) =
  fun projectee ->
    match projectee with | ProtocolViolation _0 -> true | uu____2276 -> false
let (__proj__ProtocolViolation__item___0 : query' -> Prims.string) =
  fun projectee -> match projectee with | ProtocolViolation _0 -> _0
let (__proj__Mkquery__item__qq : query -> query') =
  fun projectee -> match projectee with | { qq; qid;_} -> qq
let (__proj__Mkquery__item__qid : query -> Prims.string) =
  fun projectee -> match projectee with | { qq; qid;_} -> qid
let (query_needs_current_module : query' -> Prims.bool) =
  fun uu___3_2314 ->
    match uu___3_2314 with
    | Exit -> false
    | DescribeProtocol -> false
    | DescribeRepl -> false
    | Segment uu____2319 -> false
    | Pop -> false
    | Push
        { push_kind = uu____2323; push_code = uu____2324;
          push_line = uu____2325; push_column = uu____2326;
          push_peek_only = false;_}
        -> false
    | VfsAdd uu____2332 -> false
    | GenericError uu____2342 -> false
    | ProtocolViolation uu____2345 -> false
    | Push uu____2348 -> true
    | AutoComplete uu____2350 -> true
    | Lookup uu____2357 -> true
    | Compute uu____2373 -> true
    | Search uu____2384 -> true
let (interactive_protocol_vernum : Prims.int) = (Prims.parse_int "2")
let (interactive_protocol_features : Prims.string Prims.list) =
  ["autocomplete";
  "autocomplete/context";
  "compute";
  "compute/reify";
  "compute/pure-subterms";
  "describe-protocol";
  "describe-repl";
  "exit";
  "lookup";
  "lookup/context";
  "lookup/documentation";
  "lookup/definition";
  "peek";
  "pop";
  "push";
  "search";
  "segment";
  "vfs-add";
  "tactic-ranges";
  "interrupt";
  "progress"]
type query_status =
  | QueryOK 
  | QueryNOK 
  | QueryViolatesProtocol 
let (uu___is_QueryOK : query_status -> Prims.bool) =
  fun projectee ->
    match projectee with | QueryOK -> true | uu____2446 -> false
let (uu___is_QueryNOK : query_status -> Prims.bool) =
  fun projectee ->
    match projectee with | QueryNOK -> true | uu____2457 -> false
let (uu___is_QueryViolatesProtocol : query_status -> Prims.bool) =
  fun projectee ->
    match projectee with
    | QueryViolatesProtocol -> true
    | uu____2468 -> false
let (wrap_js_failure :
  Prims.string -> Prims.string -> FStar_Util.json -> query) =
  fun qid ->
    fun expected ->
      fun got ->
        let uu____2490 =
          let uu____2491 =
            let uu____2493 = FStar_JsonHelper.json_debug got in
            FStar_Util.format2 "JSON decoding failed: expected %s, got %s"
              expected uu____2493 in
          ProtocolViolation uu____2491 in
        { qq = uu____2490; qid }
let (unpack_interactive_query : FStar_Util.json -> query) =
  fun json ->
    let assoc1 errloc key a =
      let uu____2536 = FStar_JsonHelper.try_assoc key a in
      match uu____2536 with
      | FStar_Pervasives_Native.Some v1 -> v1
      | FStar_Pervasives_Native.None ->
          let uu____2540 =
            let uu____2541 =
              FStar_Util.format2 "Missing key [%s] in %s." key errloc in
            FStar_JsonHelper.InvalidQuery uu____2541 in
          FStar_Exn.raise uu____2540 in
    let request = FStar_All.pipe_right json FStar_JsonHelper.js_assoc in
    let qid =
      let uu____2561 = assoc1 "query" "query-id" request in
      FStar_All.pipe_right uu____2561 FStar_JsonHelper.js_str in
    try
      (fun uu___361_2571 ->
         match () with
         | () ->
             let query =
               let uu____2574 = assoc1 "query" "query" request in
               FStar_All.pipe_right uu____2574 FStar_JsonHelper.js_str in
             let args =
               let uu____2586 = assoc1 "query" "args" request in
               FStar_All.pipe_right uu____2586 FStar_JsonHelper.js_assoc in
             let arg1 k = assoc1 "[args]" k args in
             let try_arg k =
               let uu____2615 = FStar_JsonHelper.try_assoc k args in
               match uu____2615 with
               | FStar_Pervasives_Native.Some (FStar_Util.JsonNull) ->
                   FStar_Pervasives_Native.None
               | other -> other in
             let uu____2623 =
               match query with
               | "exit" -> Exit
               | "pop" -> Pop
               | "describe-protocol" -> DescribeProtocol
               | "describe-repl" -> DescribeRepl
               | "segment" ->
                   let uu____2629 =
                     let uu____2631 = arg1 "code" in
                     FStar_All.pipe_right uu____2631 FStar_JsonHelper.js_str in
                   Segment uu____2629
               | "peek" ->
                   let uu____2635 =
                     let uu____2636 =
                       let uu____2637 = arg1 "kind" in
                       FStar_All.pipe_right uu____2637 js_pushkind in
                     let uu____2639 =
                       let uu____2641 = arg1 "code" in
                       FStar_All.pipe_right uu____2641
                         FStar_JsonHelper.js_str in
                     let uu____2644 =
                       let uu____2646 = arg1 "line" in
                       FStar_All.pipe_right uu____2646
                         FStar_JsonHelper.js_int in
                     let uu____2649 =
                       let uu____2651 = arg1 "column" in
                       FStar_All.pipe_right uu____2651
                         FStar_JsonHelper.js_int in
                     {
                       push_kind = uu____2636;
                       push_code = uu____2639;
                       push_line = uu____2644;
                       push_column = uu____2649;
                       push_peek_only = (query = "peek")
                     } in
                   Push uu____2635
               | "push" ->
                   let uu____2657 =
                     let uu____2658 =
                       let uu____2659 = arg1 "kind" in
                       FStar_All.pipe_right uu____2659 js_pushkind in
                     let uu____2661 =
                       let uu____2663 = arg1 "code" in
                       FStar_All.pipe_right uu____2663
                         FStar_JsonHelper.js_str in
                     let uu____2666 =
                       let uu____2668 = arg1 "line" in
                       FStar_All.pipe_right uu____2668
                         FStar_JsonHelper.js_int in
                     let uu____2671 =
                       let uu____2673 = arg1 "column" in
                       FStar_All.pipe_right uu____2673
                         FStar_JsonHelper.js_int in
                     {
                       push_kind = uu____2658;
                       push_code = uu____2661;
                       push_line = uu____2666;
                       push_column = uu____2671;
                       push_peek_only = (query = "peek")
                     } in
                   Push uu____2657
               | "autocomplete" ->
                   let uu____2679 =
                     let uu____2685 =
                       let uu____2687 = arg1 "partial-symbol" in
                       FStar_All.pipe_right uu____2687
                         FStar_JsonHelper.js_str in
                     let uu____2690 =
                       let uu____2691 = try_arg "context" in
                       FStar_All.pipe_right uu____2691
                         js_optional_completion_context in
                     (uu____2685, uu____2690) in
                   AutoComplete uu____2679
               | "lookup" ->
                   let uu____2699 =
                     let uu____2714 =
                       let uu____2716 = arg1 "symbol" in
                       FStar_All.pipe_right uu____2716
                         FStar_JsonHelper.js_str in
                     let uu____2719 =
                       let uu____2720 = try_arg "context" in
                       FStar_All.pipe_right uu____2720
                         js_optional_lookup_context in
                     let uu____2726 =
                       let uu____2729 =
                         let uu____2739 = try_arg "location" in
                         FStar_All.pipe_right uu____2739
                           (FStar_Util.map_option FStar_JsonHelper.js_assoc) in
                       FStar_All.pipe_right uu____2729
                         (FStar_Util.map_option
                            (fun loc ->
                               let uu____2800 =
                                 let uu____2802 =
                                   assoc1 "[location]" "filename" loc in
                                 FStar_All.pipe_right uu____2802
                                   FStar_JsonHelper.js_str in
                               let uu____2806 =
                                 let uu____2808 =
                                   assoc1 "[location]" "line" loc in
                                 FStar_All.pipe_right uu____2808
                                   FStar_JsonHelper.js_int in
                               let uu____2812 =
                                 let uu____2814 =
                                   assoc1 "[location]" "column" loc in
                                 FStar_All.pipe_right uu____2814
                                   FStar_JsonHelper.js_int in
                               (uu____2800, uu____2806, uu____2812))) in
                     let uu____2821 =
                       let uu____2825 = arg1 "requested-info" in
                       FStar_All.pipe_right uu____2825
                         (FStar_JsonHelper.js_list FStar_JsonHelper.js_str) in
                     (uu____2714, uu____2719, uu____2726, uu____2821) in
                   Lookup uu____2699
               | "compute" ->
                   let uu____2838 =
                     let uu____2848 =
                       let uu____2850 = arg1 "term" in
                       FStar_All.pipe_right uu____2850
                         FStar_JsonHelper.js_str in
                     let uu____2853 =
                       let uu____2858 = try_arg "rules" in
                       FStar_All.pipe_right uu____2858
                         (FStar_Util.map_option
                            (FStar_JsonHelper.js_list js_reductionrule)) in
                     (uu____2848, uu____2853) in
                   Compute uu____2838
               | "search" ->
                   let uu____2876 =
                     let uu____2878 = arg1 "terms" in
                     FStar_All.pipe_right uu____2878 FStar_JsonHelper.js_str in
                   Search uu____2876
               | "vfs-add" ->
                   let uu____2882 =
                     let uu____2891 =
                       let uu____2895 = try_arg "filename" in
                       FStar_All.pipe_right uu____2895
                         (FStar_Util.map_option FStar_JsonHelper.js_str) in
                     let uu____2905 =
                       let uu____2907 = arg1 "contents" in
                       FStar_All.pipe_right uu____2907
                         FStar_JsonHelper.js_str in
                     (uu____2891, uu____2905) in
                   VfsAdd uu____2882
               | uu____2914 ->
                   let uu____2916 =
                     FStar_Util.format1 "Unknown query '%s'" query in
                   ProtocolViolation uu____2916 in
             { qq = uu____2623; qid }) ()
    with
    | FStar_JsonHelper.InvalidQuery msg ->
        { qq = (ProtocolViolation msg); qid }
    | FStar_JsonHelper.UnexpectedJsonType (expected, got) ->
        wrap_js_failure qid expected got
let (deserialize_interactive_query : FStar_Util.json -> query) =
  fun js_query ->
    try
      (fun uu___396_2935 ->
         match () with | () -> unpack_interactive_query js_query) ()
    with
    | FStar_JsonHelper.InvalidQuery msg ->
        { qq = (ProtocolViolation msg); qid = "?" }
    | FStar_JsonHelper.UnexpectedJsonType (expected, got) ->
        wrap_js_failure "?" expected got
let (parse_interactive_query : Prims.string -> query) =
  fun query_str ->
    let uu____2955 = FStar_Util.json_of_string query_str in
    match uu____2955 with
    | FStar_Pervasives_Native.None ->
        { qq = (ProtocolViolation "Json parsing failed."); qid = "?" }
    | FStar_Pervasives_Native.Some request ->
        deserialize_interactive_query request
let (read_interactive_query : FStar_Util.stream_reader -> query) =
  fun stream ->
    let uu____2967 = FStar_Util.read_line stream in
    match uu____2967 with
    | FStar_Pervasives_Native.None -> FStar_All.exit (Prims.parse_int "0")
    | FStar_Pervasives_Native.Some line -> parse_interactive_query line
let json_of_opt :
  'Auu____2983 .
    ('Auu____2983 -> FStar_Util.json) ->
      'Auu____2983 FStar_Pervasives_Native.option -> FStar_Util.json
  =
  fun json_of_a ->
    fun opt_a ->
      let uu____3003 = FStar_Util.map_option json_of_a opt_a in
      FStar_Util.dflt FStar_Util.JsonNull uu____3003
let (json_of_issue_level : FStar_Errors.issue_level -> FStar_Util.json) =
  fun i ->
    FStar_Util.JsonStr
      (match i with
       | FStar_Errors.ENotImplemented -> "not-implemented"
       | FStar_Errors.EInfo -> "info"
       | FStar_Errors.EWarning -> "warning"
       | FStar_Errors.EError -> "error")
let (json_of_issue : FStar_Errors.issue -> FStar_Util.json) =
  fun issue ->
    let uu____3023 =
      let uu____3031 =
        let uu____3039 =
          let uu____3047 =
            let uu____3053 =
              let uu____3054 =
                let uu____3057 =
                  match issue.FStar_Errors.issue_range with
                  | FStar_Pervasives_Native.None -> []
                  | FStar_Pervasives_Native.Some r ->
                      let uu____3063 = FStar_Range.json_of_use_range r in
                      [uu____3063] in
                let uu____3064 =
                  match issue.FStar_Errors.issue_range with
                  | FStar_Pervasives_Native.Some r when
                      let uu____3070 = FStar_Range.def_range r in
                      let uu____3071 = FStar_Range.use_range r in
                      uu____3070 <> uu____3071 ->
                      let uu____3072 = FStar_Range.json_of_def_range r in
                      [uu____3072]
                  | uu____3073 -> [] in
                FStar_List.append uu____3057 uu____3064 in
              FStar_Util.JsonList uu____3054 in
            ("ranges", uu____3053) in
          [uu____3047] in
        ("message", (FStar_Util.JsonStr (issue.FStar_Errors.issue_message)))
          :: uu____3039 in
      ("level", (json_of_issue_level issue.FStar_Errors.issue_level)) ::
        uu____3031 in
    FStar_Util.JsonAssoc uu____3023
let (alist_of_symbol_lookup_result :
  FStar_QueryHelper.sl_reponse -> (Prims.string * FStar_Util.json) Prims.list)
  =
  fun lr ->
    let uu____3115 =
      let uu____3123 =
        let uu____3129 =
          json_of_opt FStar_Range.json_of_def_range
            lr.FStar_QueryHelper.slr_def_range in
        ("defined-at", uu____3129) in
      let uu____3132 =
        let uu____3140 =
          let uu____3146 =
            json_of_opt (fun _3148 -> FStar_Util.JsonStr _3148)
              lr.FStar_QueryHelper.slr_typ in
          ("type", uu____3146) in
        let uu____3151 =
          let uu____3159 =
            let uu____3165 =
              json_of_opt (fun _3167 -> FStar_Util.JsonStr _3167)
                lr.FStar_QueryHelper.slr_doc in
            ("documentation", uu____3165) in
          let uu____3170 =
            let uu____3178 =
              let uu____3184 =
                json_of_opt (fun _3186 -> FStar_Util.JsonStr _3186)
                  lr.FStar_QueryHelper.slr_def in
              ("definition", uu____3184) in
            [uu____3178] in
          uu____3159 :: uu____3170 in
        uu____3140 :: uu____3151 in
      uu____3123 :: uu____3132 in
    ("name", (FStar_Util.JsonStr (lr.FStar_QueryHelper.slr_name))) ::
      uu____3115
let (alist_of_protocol_info : (Prims.string * FStar_Util.json) Prims.list) =
  let js_version = FStar_Util.JsonInt interactive_protocol_vernum in
  let js_features =
    let uu____3231 =
      FStar_List.map (fun _3235 -> FStar_Util.JsonStr _3235)
        interactive_protocol_features in
    FStar_All.pipe_left (fun _3238 -> FStar_Util.JsonList _3238) uu____3231 in
  [("version", js_version); ("features", js_features)]
type fstar_option_permission_level =
  | OptSet 
  | OptReset 
  | OptReadOnly 
let (uu___is_OptSet : fstar_option_permission_level -> Prims.bool) =
  fun projectee ->
    match projectee with | OptSet -> true | uu____3267 -> false
let (uu___is_OptReset : fstar_option_permission_level -> Prims.bool) =
  fun projectee ->
    match projectee with | OptReset -> true | uu____3278 -> false
let (uu___is_OptReadOnly : fstar_option_permission_level -> Prims.bool) =
  fun projectee ->
    match projectee with | OptReadOnly -> true | uu____3289 -> false
let (string_of_option_permission_level :
  fstar_option_permission_level -> Prims.string) =
  fun uu___4_3297 ->
    match uu___4_3297 with
    | OptSet -> ""
    | OptReset -> "requires #reset-options"
    | OptReadOnly -> "read-only"
type fstar_option =
  {
  opt_name: Prims.string ;
  opt_sig: Prims.string ;
  opt_value: FStar_Options.option_val ;
  opt_default: FStar_Options.option_val ;
  opt_type: FStar_Options.opt_type ;
  opt_snippets: Prims.string Prims.list ;
  opt_documentation: Prims.string FStar_Pervasives_Native.option ;
  opt_permission_level: fstar_option_permission_level }
let (__proj__Mkfstar_option__item__opt_name : fstar_option -> Prims.string) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_name
let (__proj__Mkfstar_option__item__opt_sig : fstar_option -> Prims.string) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_sig
let (__proj__Mkfstar_option__item__opt_value :
  fstar_option -> FStar_Options.option_val) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_value
let (__proj__Mkfstar_option__item__opt_default :
  fstar_option -> FStar_Options.option_val) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_default
let (__proj__Mkfstar_option__item__opt_type :
  fstar_option -> FStar_Options.opt_type) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_type
let (__proj__Mkfstar_option__item__opt_snippets :
  fstar_option -> Prims.string Prims.list) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_snippets
let (__proj__Mkfstar_option__item__opt_documentation :
  fstar_option -> Prims.string FStar_Pervasives_Native.option) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_documentation
let (__proj__Mkfstar_option__item__opt_permission_level :
  fstar_option -> fstar_option_permission_level) =
  fun projectee ->
    match projectee with
    | { opt_name; opt_sig; opt_value; opt_default; opt_type; opt_snippets;
        opt_documentation; opt_permission_level;_} -> opt_permission_level
let rec (kind_of_fstar_option_type : FStar_Options.opt_type -> Prims.string)
  =
  fun uu___5_3548 ->
    match uu___5_3548 with
    | FStar_Options.Const uu____3550 -> "flag"
    | FStar_Options.IntStr uu____3552 -> "int"
    | FStar_Options.BoolStr -> "bool"
    | FStar_Options.PathStr uu____3556 -> "path"
    | FStar_Options.SimpleStr uu____3559 -> "string"
    | FStar_Options.EnumStr uu____3562 -> "enum"
    | FStar_Options.OpenEnumStr uu____3567 -> "open enum"
    | FStar_Options.PostProcessed (uu____3577, typ) ->
        kind_of_fstar_option_type typ
    | FStar_Options.Accumulated typ -> kind_of_fstar_option_type typ
    | FStar_Options.ReverseAccumulated typ -> kind_of_fstar_option_type typ
    | FStar_Options.WithSideEffect (uu____3587, typ) ->
        kind_of_fstar_option_type typ
let rec (snippets_of_fstar_option :
  Prims.string -> FStar_Options.opt_type -> Prims.string Prims.list) =
  fun name ->
    fun typ ->
      let mk_field field_name =
        Prims.op_Hat "${" (Prims.op_Hat field_name "}") in
      let mk_snippet name1 argstring =
        Prims.op_Hat "--"
          (Prims.op_Hat name1
             (if argstring <> "" then Prims.op_Hat " " argstring else "")) in
      let rec arg_snippets_of_type typ1 =
        match typ1 with
        | FStar_Options.Const uu____3659 -> [""]
        | FStar_Options.BoolStr -> ["true"; "false"]
        | FStar_Options.IntStr desc -> [mk_field desc]
        | FStar_Options.PathStr desc -> [mk_field desc]
        | FStar_Options.SimpleStr desc -> [mk_field desc]
        | FStar_Options.EnumStr strs -> strs
        | FStar_Options.OpenEnumStr (strs, desc) ->
            FStar_List.append strs [mk_field desc]
        | FStar_Options.PostProcessed (uu____3697, elem_spec) ->
            arg_snippets_of_type elem_spec
        | FStar_Options.Accumulated elem_spec ->
            arg_snippets_of_type elem_spec
        | FStar_Options.ReverseAccumulated elem_spec ->
            arg_snippets_of_type elem_spec
        | FStar_Options.WithSideEffect (uu____3707, elem_spec) ->
            arg_snippets_of_type elem_spec in
      let uu____3715 = arg_snippets_of_type typ in
      FStar_List.map (mk_snippet name) uu____3715
let rec (json_of_fstar_option_value :
  FStar_Options.option_val -> FStar_Util.json) =
  fun uu___6_3726 ->
    match uu___6_3726 with
    | FStar_Options.Bool b -> FStar_Util.JsonBool b
    | FStar_Options.String s -> FStar_Util.JsonStr s
    | FStar_Options.Path s -> FStar_Util.JsonStr s
    | FStar_Options.Int n1 -> FStar_Util.JsonInt n1
    | FStar_Options.List vs ->
        let uu____3738 = FStar_List.map json_of_fstar_option_value vs in
        FStar_Util.JsonList uu____3738
    | FStar_Options.Unset -> FStar_Util.JsonNull
let (alist_of_fstar_option :
  fstar_option -> (Prims.string * FStar_Util.json) Prims.list) =
  fun opt ->
    let uu____3754 =
      let uu____3762 =
        let uu____3770 =
          let uu____3776 = json_of_fstar_option_value opt.opt_value in
          ("value", uu____3776) in
        let uu____3779 =
          let uu____3787 =
            let uu____3793 = json_of_fstar_option_value opt.opt_default in
            ("default", uu____3793) in
          let uu____3796 =
            let uu____3804 =
              let uu____3810 =
                json_of_opt (fun _3812 -> FStar_Util.JsonStr _3812)
                  opt.opt_documentation in
              ("documentation", uu____3810) in
            let uu____3815 =
              let uu____3823 =
                let uu____3829 =
                  let uu____3830 = kind_of_fstar_option_type opt.opt_type in
                  FStar_Util.JsonStr uu____3830 in
                ("type", uu____3829) in
              [uu____3823;
              ("permission-level",
                (FStar_Util.JsonStr
                   (string_of_option_permission_level
                      opt.opt_permission_level)))] in
            uu____3804 :: uu____3815 in
          uu____3787 :: uu____3796 in
        uu____3770 :: uu____3779 in
      ("signature", (FStar_Util.JsonStr (opt.opt_sig))) :: uu____3762 in
    ("name", (FStar_Util.JsonStr (opt.opt_name))) :: uu____3754
let (json_of_fstar_option : fstar_option -> FStar_Util.json) =
  fun opt ->
    let uu____3886 = alist_of_fstar_option opt in
    FStar_Util.JsonAssoc uu____3886
let (json_of_response :
  Prims.string -> query_status -> FStar_Util.json -> FStar_Util.json) =
  fun qid ->
    fun status ->
      fun response ->
        let qid1 = FStar_Util.JsonStr qid in
        let status1 =
          match status with
          | QueryOK -> FStar_Util.JsonStr "success"
          | QueryNOK -> FStar_Util.JsonStr "failure"
          | QueryViolatesProtocol -> FStar_Util.JsonStr "protocol-violation" in
        FStar_Util.JsonAssoc
          [("kind", (FStar_Util.JsonStr "response"));
          ("query-id", qid1);
          ("status", status1);
          ("response", response)]
let (write_response :
  Prims.string -> query_status -> FStar_Util.json -> unit) =
  fun qid ->
    fun status ->
      fun response ->
        FStar_JsonHelper.write_json (json_of_response qid status response)
let (json_of_message : Prims.string -> FStar_Util.json -> FStar_Util.json) =
  fun level ->
    fun js_contents ->
      let uu____3982 =
        let uu____3990 =
          let uu____3998 =
            let uu____4004 =
              let uu____4005 = FStar_ST.op_Bang repl_current_qid in
              json_of_opt (fun _4035 -> FStar_Util.JsonStr _4035) uu____4005 in
            ("query-id", uu____4004) in
          [uu____3998;
          ("level", (FStar_Util.JsonStr level));
          ("contents", js_contents)] in
        ("kind", (FStar_Util.JsonStr "message")) :: uu____3990 in
      FStar_Util.JsonAssoc uu____3982
let forward_message :
  'Auu____4079 .
    (FStar_Util.json -> 'Auu____4079) ->
      Prims.string -> FStar_Util.json -> 'Auu____4079
  =
  fun callback ->
    fun level ->
      fun contents ->
        let uu____4102 = json_of_message level contents in
        callback uu____4102
let (json_of_hello : FStar_Util.json) =
  let js_version = FStar_Util.JsonInt interactive_protocol_vernum in
  let js_features =
    let uu____4106 =
      FStar_List.map (fun _4110 -> FStar_Util.JsonStr _4110)
        interactive_protocol_features in
    FStar_Util.JsonList uu____4106 in
  FStar_Util.JsonAssoc (("kind", (FStar_Util.JsonStr "protocol-info")) ::
    alist_of_protocol_info)
let (write_hello : unit -> unit) =
  fun uu____4124 -> FStar_JsonHelper.write_json json_of_hello
let (sig_of_fstar_option :
  Prims.string -> FStar_Options.opt_type -> Prims.string) =
  fun name ->
    fun typ ->
      let flag = Prims.op_Hat "--" name in
      let uu____4142 = FStar_Options.desc_of_opt_type typ in
      match uu____4142 with
      | FStar_Pervasives_Native.None -> flag
      | FStar_Pervasives_Native.Some arg_sig ->
          Prims.op_Hat flag (Prims.op_Hat " " arg_sig)
let (fstar_options_list_cache : fstar_option Prims.list) =
  let defaults1 = FStar_Util.smap_of_list FStar_Options.defaults in
  let uu____4158 =
    FStar_All.pipe_right FStar_Options.all_specs_with_types
      (FStar_List.filter_map
         (fun uu____4193 ->
            match uu____4193 with
            | (_shortname, name, typ, doc1) ->
                let uu____4217 = FStar_Util.smap_try_find defaults1 name in
                FStar_All.pipe_right uu____4217
                  (FStar_Util.map_option
                     (fun default_value ->
                        let uu____4229 = sig_of_fstar_option name typ in
                        let uu____4231 = snippets_of_fstar_option name typ in
                        let uu____4235 =
                          let uu____4236 = FStar_Options.settable name in
                          if uu____4236
                          then OptSet
                          else
                            (let uu____4241 = FStar_Options.resettable name in
                             if uu____4241 then OptReset else OptReadOnly) in
                        {
                          opt_name = name;
                          opt_sig = uu____4229;
                          opt_value = FStar_Options.Unset;
                          opt_default = default_value;
                          opt_type = typ;
                          opt_snippets = uu____4231;
                          opt_documentation =
                            (if doc1 = ""
                             then FStar_Pervasives_Native.None
                             else FStar_Pervasives_Native.Some doc1);
                          opt_permission_level = uu____4235
                        })))) in
  FStar_All.pipe_right uu____4158
    (FStar_List.sortWith
       (fun o1 ->
          fun o2 ->
            FStar_String.compare (FStar_String.lowercase o1.opt_name)
              (FStar_String.lowercase o2.opt_name)))
let (fstar_options_map_cache : fstar_option FStar_Util.smap) =
  let cache = FStar_Util.smap_create (Prims.parse_int "50") in
  FStar_List.iter (fun opt -> FStar_Util.smap_add cache opt.opt_name opt)
    fstar_options_list_cache;
  cache
let (update_option : fstar_option -> fstar_option) =
  fun opt ->
    let uu___568_4280 = opt in
    let uu____4281 = FStar_Options.get_option opt.opt_name in
    {
      opt_name = (uu___568_4280.opt_name);
      opt_sig = (uu___568_4280.opt_sig);
      opt_value = uu____4281;
      opt_default = (uu___568_4280.opt_default);
      opt_type = (uu___568_4280.opt_type);
      opt_snippets = (uu___568_4280.opt_snippets);
      opt_documentation = (uu___568_4280.opt_documentation);
      opt_permission_level = (uu___568_4280.opt_permission_level)
    }
let (current_fstar_options :
  (fstar_option -> Prims.bool) -> fstar_option Prims.list) =
  fun filter1 ->
    let uu____4297 = FStar_List.filter filter1 fstar_options_list_cache in
    FStar_List.map update_option uu____4297
let (trim_option_name : Prims.string -> (Prims.string * Prims.string)) =
  fun opt_name ->
    let opt_prefix = "--" in
    if FStar_Util.starts_with opt_name opt_prefix
    then
      let uu____4324 =
        FStar_Util.substring_from opt_name (FStar_String.length opt_prefix) in
      (opt_prefix, uu____4324)
    else ("", opt_name)
let (json_of_repl_state : FStar_JsonHelper.repl_state -> FStar_Util.json) =
  fun st ->
    let filenames uu____4355 =
      match uu____4355 with
      | (uu____4367, (task, uu____4369)) ->
          (match task with
           | FStar_JsonHelper.LDInterleaved (intf, impl) ->
               [intf.FStar_JsonHelper.tf_fname;
               impl.FStar_JsonHelper.tf_fname]
           | FStar_JsonHelper.LDSingle intf_or_impl ->
               [intf_or_impl.FStar_JsonHelper.tf_fname]
           | FStar_JsonHelper.LDInterfaceOfCurrentFile intf ->
               [intf.FStar_JsonHelper.tf_fname]
           | uu____4388 -> []) in
    let uu____4390 =
      let uu____4398 =
        let uu____4404 =
          let uu____4405 =
            let uu____4408 =
              FStar_List.concatMap filenames
                st.FStar_JsonHelper.repl_deps_stack in
            FStar_List.map (fun _4422 -> FStar_Util.JsonStr _4422) uu____4408 in
          FStar_Util.JsonList uu____4405 in
        ("loaded-dependencies", uu____4404) in
      let uu____4425 =
        let uu____4433 =
          let uu____4439 =
            let uu____4440 =
              let uu____4443 = current_fstar_options (fun uu____4448 -> true) in
              FStar_List.map json_of_fstar_option uu____4443 in
            FStar_Util.JsonList uu____4440 in
          ("options", uu____4439) in
        [uu____4433] in
      uu____4398 :: uu____4425 in
    FStar_Util.JsonAssoc uu____4390
let run_exit :
  'Auu____4474 'Auu____4475 .
    'Auu____4474 ->
      ((query_status * FStar_Util.json) * ('Auu____4475, Prims.int)
        FStar_Util.either)
  =
  fun st ->
    ((QueryOK, FStar_Util.JsonNull), (FStar_Util.Inr (Prims.parse_int "0")))
let run_describe_protocol :
  'Auu____4512 'Auu____4513 .
    'Auu____4512 ->
      ((query_status * FStar_Util.json) * ('Auu____4512, 'Auu____4513)
        FStar_Util.either)
  =
  fun st ->
    ((QueryOK, (FStar_Util.JsonAssoc alist_of_protocol_info)),
      (FStar_Util.Inl st))
let run_describe_repl :
  'Auu____4544 .
    FStar_JsonHelper.repl_state ->
      ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
        'Auu____4544) FStar_Util.either)
  =
  fun st ->
    let uu____4562 =
      let uu____4567 = json_of_repl_state st in (QueryOK, uu____4567) in
    (uu____4562, (FStar_Util.Inl st))
let run_protocol_violation :
  'Auu____4585 'Auu____4586 .
    'Auu____4585 ->
      Prims.string ->
        ((query_status * FStar_Util.json) * ('Auu____4585, 'Auu____4586)
          FStar_Util.either)
  =
  fun st ->
    fun message ->
      ((QueryViolatesProtocol, (FStar_Util.JsonStr message)),
        (FStar_Util.Inl st))
let run_generic_error :
  'Auu____4628 'Auu____4629 .
    'Auu____4628 ->
      Prims.string ->
        ((query_status * FStar_Util.json) * ('Auu____4628, 'Auu____4629)
          FStar_Util.either)
  =
  fun st ->
    fun message ->
      ((QueryNOK, (FStar_Util.JsonStr message)), (FStar_Util.Inl st))
let (collect_errors : unit -> FStar_Errors.issue Prims.list) =
  fun uu____4669 ->
    let errors = FStar_Errors.report_all () in FStar_Errors.clear (); errors
let run_segment :
  'Auu____4681 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____4681) FStar_Util.either)
  =
  fun st ->
    fun code ->
      let frag =
        {
          FStar_Parser_ParseIt.frag_text = code;
          FStar_Parser_ParseIt.frag_line = (Prims.parse_int "1");
          FStar_Parser_ParseIt.frag_col = (Prims.parse_int "0")
        } in
      let collect_decls uu____4716 =
        let uu____4717 = FStar_Parser_Driver.parse_fragment frag in
        match uu____4717 with
        | FStar_Parser_Driver.Empty -> []
        | FStar_Parser_Driver.Decls decls -> decls
        | FStar_Parser_Driver.Modul (FStar_Parser_AST.Module
            (uu____4723, decls)) -> decls
        | FStar_Parser_Driver.Modul (FStar_Parser_AST.Interface
            (uu____4729, decls, uu____4731)) -> decls in
      let uu____4738 =
        with_captured_errors st.FStar_JsonHelper.repl_env
          FStar_Util.sigint_ignore
          (fun uu____4747 ->
             let uu____4748 = collect_decls () in
             FStar_All.pipe_left
               (fun _4759 -> FStar_Pervasives_Native.Some _4759) uu____4748) in
      match uu____4738 with
      | FStar_Pervasives_Native.None ->
          let errors =
            let uu____4777 = collect_errors () in
            FStar_All.pipe_right uu____4777 (FStar_List.map json_of_issue) in
          ((QueryNOK, (FStar_Util.JsonList errors)), (FStar_Util.Inl st))
      | FStar_Pervasives_Native.Some decls ->
          let json_of_decl decl =
            let uu____4803 =
              let uu____4811 =
                let uu____4817 =
                  FStar_Range.json_of_def_range
                    (FStar_Parser_AST.decl_drange decl) in
                ("def_range", uu____4817) in
              [uu____4811] in
            FStar_Util.JsonAssoc uu____4803 in
          let js_decls =
            let uu____4831 = FStar_List.map json_of_decl decls in
            FStar_All.pipe_left (fun _4836 -> FStar_Util.JsonList _4836)
              uu____4831 in
          ((QueryOK, (FStar_Util.JsonAssoc [("decls", js_decls)])),
            (FStar_Util.Inl st))
let run_vfs_add :
  'Auu____4866 .
    FStar_JsonHelper.repl_state ->
      Prims.string FStar_Pervasives_Native.option ->
        Prims.string ->
          ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
            'Auu____4866) FStar_Util.either)
  =
  fun st ->
    fun opt_fname ->
      fun contents ->
        let fname = FStar_Util.dflt st.FStar_JsonHelper.repl_fname opt_fname in
        FStar_Parser_ParseIt.add_vfs_entry fname contents;
        ((QueryOK, FStar_Util.JsonNull), (FStar_Util.Inl st))
let run_pop :
  'Auu____4919 .
    FStar_JsonHelper.repl_state ->
      ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
        'Auu____4919) FStar_Util.either)
  =
  fun st ->
    let uu____4937 = nothing_left_to_pop st in
    if uu____4937
    then
      ((QueryNOK, (FStar_Util.JsonStr "Too many pops")), (FStar_Util.Inl st))
    else
      (let st' = FStar_PushHelper.pop_repl "pop_query" st in
       ((QueryOK, FStar_Util.JsonNull), (FStar_Util.Inl st')))
let (write_progress :
  Prims.string FStar_Pervasives_Native.option ->
    (Prims.string * FStar_Util.json) Prims.list -> unit)
  =
  fun stage ->
    fun contents_alist ->
      let stage1 =
        match stage with
        | FStar_Pervasives_Native.Some s -> FStar_Util.JsonStr s
        | FStar_Pervasives_Native.None -> FStar_Util.JsonNull in
      let js_contents = ("stage", stage1) :: contents_alist in
      let uu____5024 =
        json_of_message "progress" (FStar_Util.JsonAssoc js_contents) in
      FStar_JsonHelper.write_json uu____5024
let (write_repl_ld_task_progress : FStar_JsonHelper.repl_task -> unit) =
  fun task ->
    match task with
    | FStar_JsonHelper.LDInterleaved (uu____5032, tf) ->
        let modname =
          FStar_Parser_Dep.module_name_of_file tf.FStar_JsonHelper.tf_fname in
        write_progress (FStar_Pervasives_Native.Some "loading-dependency")
          [("modname", (FStar_Util.JsonStr modname))]
    | FStar_JsonHelper.LDSingle tf ->
        let modname =
          FStar_Parser_Dep.module_name_of_file tf.FStar_JsonHelper.tf_fname in
        write_progress (FStar_Pervasives_Native.Some "loading-dependency")
          [("modname", (FStar_Util.JsonStr modname))]
    | FStar_JsonHelper.LDInterfaceOfCurrentFile tf ->
        let modname =
          FStar_Parser_Dep.module_name_of_file tf.FStar_JsonHelper.tf_fname in
        write_progress (FStar_Pervasives_Native.Some "loading-dependency")
          [("modname", (FStar_Util.JsonStr modname))]
    | uu____5084 -> ()
let (load_deps :
  FStar_JsonHelper.repl_state ->
    ((FStar_JsonHelper.repl_state * Prims.string Prims.list),
      FStar_JsonHelper.repl_state) FStar_Util.either)
  =
  fun st ->
    let uu____5102 =
      with_captured_errors st.FStar_JsonHelper.repl_env
        FStar_Util.sigint_ignore
        (fun _env ->
           let uu____5130 =
             FStar_PushHelper.deps_and_repl_ld_tasks_of_our_file
               st.FStar_JsonHelper.repl_fname in
           FStar_All.pipe_left
             (fun _5177 -> FStar_Pervasives_Native.Some _5177) uu____5130) in
    match uu____5102 with
    | FStar_Pervasives_Native.None -> FStar_Util.Inr st
    | FStar_Pervasives_Native.Some (deps, tasks, dep_graph1) ->
        let st1 =
          let uu___658_5232 = st in
          let uu____5233 =
            FStar_TypeChecker_Env.set_dep_graph st.FStar_JsonHelper.repl_env
              dep_graph1 in
          {
            FStar_JsonHelper.repl_line =
              (uu___658_5232.FStar_JsonHelper.repl_line);
            FStar_JsonHelper.repl_column =
              (uu___658_5232.FStar_JsonHelper.repl_column);
            FStar_JsonHelper.repl_fname =
              (uu___658_5232.FStar_JsonHelper.repl_fname);
            FStar_JsonHelper.repl_deps_stack =
              (uu___658_5232.FStar_JsonHelper.repl_deps_stack);
            FStar_JsonHelper.repl_curmod =
              (uu___658_5232.FStar_JsonHelper.repl_curmod);
            FStar_JsonHelper.repl_env = uu____5233;
            FStar_JsonHelper.repl_stdin =
              (uu___658_5232.FStar_JsonHelper.repl_stdin);
            FStar_JsonHelper.repl_names =
              (uu___658_5232.FStar_JsonHelper.repl_names)
          } in
        let uu____5234 =
          run_repl_ld_transactions st1 tasks write_repl_ld_task_progress in
        (match uu____5234 with
         | FStar_Util.Inr st2 ->
             (write_progress FStar_Pervasives_Native.None [];
              FStar_Util.Inr st2)
         | FStar_Util.Inl st2 ->
             (write_progress FStar_Pervasives_Native.None [];
              FStar_Util.Inl (st2, deps)))
let (rephrase_dependency_error : FStar_Errors.issue -> FStar_Errors.issue) =
  fun issue ->
    let uu___668_5289 = issue in
    let uu____5290 =
      FStar_Util.format1 "Error while computing or loading dependencies:\n%s"
        issue.FStar_Errors.issue_message in
    {
      FStar_Errors.issue_message = uu____5290;
      FStar_Errors.issue_level = (uu___668_5289.FStar_Errors.issue_level);
      FStar_Errors.issue_range = (uu___668_5289.FStar_Errors.issue_range);
      FStar_Errors.issue_number = (uu___668_5289.FStar_Errors.issue_number)
    }
let run_push_without_deps :
  'Auu____5300 .
    FStar_JsonHelper.repl_state ->
      push_query ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____5300) FStar_Util.either)
  =
  fun st ->
    fun query ->
      let set_nosynth_flag st1 flag =
        let uu___675_5336 = st1 in
        {
          FStar_JsonHelper.repl_line =
            (uu___675_5336.FStar_JsonHelper.repl_line);
          FStar_JsonHelper.repl_column =
            (uu___675_5336.FStar_JsonHelper.repl_column);
          FStar_JsonHelper.repl_fname =
            (uu___675_5336.FStar_JsonHelper.repl_fname);
          FStar_JsonHelper.repl_deps_stack =
            (uu___675_5336.FStar_JsonHelper.repl_deps_stack);
          FStar_JsonHelper.repl_curmod =
            (uu___675_5336.FStar_JsonHelper.repl_curmod);
          FStar_JsonHelper.repl_env =
            (let uu___677_5338 = st1.FStar_JsonHelper.repl_env in
             {
               FStar_TypeChecker_Env.solver =
                 (uu___677_5338.FStar_TypeChecker_Env.solver);
               FStar_TypeChecker_Env.range =
                 (uu___677_5338.FStar_TypeChecker_Env.range);
               FStar_TypeChecker_Env.curmodule =
                 (uu___677_5338.FStar_TypeChecker_Env.curmodule);
               FStar_TypeChecker_Env.gamma =
                 (uu___677_5338.FStar_TypeChecker_Env.gamma);
               FStar_TypeChecker_Env.gamma_sig =
                 (uu___677_5338.FStar_TypeChecker_Env.gamma_sig);
               FStar_TypeChecker_Env.gamma_cache =
                 (uu___677_5338.FStar_TypeChecker_Env.gamma_cache);
               FStar_TypeChecker_Env.modules =
                 (uu___677_5338.FStar_TypeChecker_Env.modules);
               FStar_TypeChecker_Env.expected_typ =
                 (uu___677_5338.FStar_TypeChecker_Env.expected_typ);
               FStar_TypeChecker_Env.sigtab =
                 (uu___677_5338.FStar_TypeChecker_Env.sigtab);
               FStar_TypeChecker_Env.attrtab =
                 (uu___677_5338.FStar_TypeChecker_Env.attrtab);
               FStar_TypeChecker_Env.is_pattern =
                 (uu___677_5338.FStar_TypeChecker_Env.is_pattern);
               FStar_TypeChecker_Env.instantiate_imp =
                 (uu___677_5338.FStar_TypeChecker_Env.instantiate_imp);
               FStar_TypeChecker_Env.effects =
                 (uu___677_5338.FStar_TypeChecker_Env.effects);
               FStar_TypeChecker_Env.generalize =
                 (uu___677_5338.FStar_TypeChecker_Env.generalize);
               FStar_TypeChecker_Env.letrecs =
                 (uu___677_5338.FStar_TypeChecker_Env.letrecs);
               FStar_TypeChecker_Env.top_level =
                 (uu___677_5338.FStar_TypeChecker_Env.top_level);
               FStar_TypeChecker_Env.check_uvars =
                 (uu___677_5338.FStar_TypeChecker_Env.check_uvars);
               FStar_TypeChecker_Env.use_eq =
                 (uu___677_5338.FStar_TypeChecker_Env.use_eq);
               FStar_TypeChecker_Env.is_iface =
                 (uu___677_5338.FStar_TypeChecker_Env.is_iface);
               FStar_TypeChecker_Env.admit =
                 (uu___677_5338.FStar_TypeChecker_Env.admit);
               FStar_TypeChecker_Env.lax =
                 (uu___677_5338.FStar_TypeChecker_Env.lax);
               FStar_TypeChecker_Env.lax_universes =
                 (uu___677_5338.FStar_TypeChecker_Env.lax_universes);
               FStar_TypeChecker_Env.phase1 =
                 (uu___677_5338.FStar_TypeChecker_Env.phase1);
               FStar_TypeChecker_Env.failhard =
                 (uu___677_5338.FStar_TypeChecker_Env.failhard);
               FStar_TypeChecker_Env.nosynth = flag;
               FStar_TypeChecker_Env.uvar_subtyping =
                 (uu___677_5338.FStar_TypeChecker_Env.uvar_subtyping);
               FStar_TypeChecker_Env.tc_term =
                 (uu___677_5338.FStar_TypeChecker_Env.tc_term);
               FStar_TypeChecker_Env.type_of =
                 (uu___677_5338.FStar_TypeChecker_Env.type_of);
               FStar_TypeChecker_Env.universe_of =
                 (uu___677_5338.FStar_TypeChecker_Env.universe_of);
               FStar_TypeChecker_Env.check_type_of =
                 (uu___677_5338.FStar_TypeChecker_Env.check_type_of);
               FStar_TypeChecker_Env.use_bv_sorts =
                 (uu___677_5338.FStar_TypeChecker_Env.use_bv_sorts);
               FStar_TypeChecker_Env.qtbl_name_and_index =
                 (uu___677_5338.FStar_TypeChecker_Env.qtbl_name_and_index);
               FStar_TypeChecker_Env.normalized_eff_names =
                 (uu___677_5338.FStar_TypeChecker_Env.normalized_eff_names);
               FStar_TypeChecker_Env.fv_delta_depths =
                 (uu___677_5338.FStar_TypeChecker_Env.fv_delta_depths);
               FStar_TypeChecker_Env.proof_ns =
                 (uu___677_5338.FStar_TypeChecker_Env.proof_ns);
               FStar_TypeChecker_Env.synth_hook =
                 (uu___677_5338.FStar_TypeChecker_Env.synth_hook);
               FStar_TypeChecker_Env.splice =
                 (uu___677_5338.FStar_TypeChecker_Env.splice);
               FStar_TypeChecker_Env.postprocess =
                 (uu___677_5338.FStar_TypeChecker_Env.postprocess);
               FStar_TypeChecker_Env.is_native_tactic =
                 (uu___677_5338.FStar_TypeChecker_Env.is_native_tactic);
               FStar_TypeChecker_Env.identifier_info =
                 (uu___677_5338.FStar_TypeChecker_Env.identifier_info);
               FStar_TypeChecker_Env.tc_hooks =
                 (uu___677_5338.FStar_TypeChecker_Env.tc_hooks);
               FStar_TypeChecker_Env.dsenv =
                 (uu___677_5338.FStar_TypeChecker_Env.dsenv);
               FStar_TypeChecker_Env.nbe =
                 (uu___677_5338.FStar_TypeChecker_Env.nbe)
             });
          FStar_JsonHelper.repl_stdin =
            (uu___675_5336.FStar_JsonHelper.repl_stdin);
          FStar_JsonHelper.repl_names =
            (uu___675_5336.FStar_JsonHelper.repl_names)
        } in
      let uu____5339 = query in
      match uu____5339 with
      | { push_kind; push_code = text; push_line = line;
          push_column = column; push_peek_only = peek_only;_} ->
          let frag =
            {
              FStar_Parser_ParseIt.frag_text = text;
              FStar_Parser_ParseIt.frag_line = line;
              FStar_Parser_ParseIt.frag_col = column
            } in
          (FStar_TypeChecker_Env.toggle_id_info st.FStar_JsonHelper.repl_env
             true;
           (let st1 = set_nosynth_flag st peek_only in
            let uu____5365 =
              run_repl_transaction st1 push_kind peek_only
                (FStar_JsonHelper.PushFragment frag) in
            match uu____5365 with
            | (success, st2) ->
                let st3 = set_nosynth_flag st2 false in
                let status =
                  if success || peek_only then QueryOK else QueryNOK in
                let json_errors =
                  let uu____5394 =
                    let uu____5397 = collect_errors () in
                    FStar_All.pipe_right uu____5397
                      (FStar_List.map json_of_issue) in
                  FStar_Util.JsonList uu____5394 in
                let st4 =
                  if success
                  then
                    let uu___696_5406 = st3 in
                    {
                      FStar_JsonHelper.repl_line = line;
                      FStar_JsonHelper.repl_column = column;
                      FStar_JsonHelper.repl_fname =
                        (uu___696_5406.FStar_JsonHelper.repl_fname);
                      FStar_JsonHelper.repl_deps_stack =
                        (uu___696_5406.FStar_JsonHelper.repl_deps_stack);
                      FStar_JsonHelper.repl_curmod =
                        (uu___696_5406.FStar_JsonHelper.repl_curmod);
                      FStar_JsonHelper.repl_env =
                        (uu___696_5406.FStar_JsonHelper.repl_env);
                      FStar_JsonHelper.repl_stdin =
                        (uu___696_5406.FStar_JsonHelper.repl_stdin);
                      FStar_JsonHelper.repl_names =
                        (uu___696_5406.FStar_JsonHelper.repl_names)
                    }
                  else st3 in
                ((status, json_errors), (FStar_Util.Inl st4))))
let (capitalize : Prims.string -> Prims.string) =
  fun str ->
    if str = ""
    then str
    else
      (let first =
         FStar_String.substring str (Prims.parse_int "0")
           (Prims.parse_int "1") in
       let uu____5436 =
         FStar_String.substring str (Prims.parse_int "1")
           ((FStar_String.length str) - (Prims.parse_int "1")) in
       Prims.op_Hat (FStar_String.uppercase first) uu____5436)
let (add_module_completions :
  Prims.string ->
    Prims.string Prims.list ->
      FStar_Interactive_CompletionTable.table ->
        FStar_Interactive_CompletionTable.table)
  =
  fun this_fname ->
    fun deps ->
      fun table ->
        let mods = FStar_Parser_Dep.build_inclusion_candidates_list () in
        let loaded_mods_set =
          let uu____5477 = FStar_Util.psmap_empty () in
          let uu____5482 =
            let uu____5486 = FStar_Options.prims () in uu____5486 :: deps in
          FStar_List.fold_left
            (fun acc ->
               fun dep1 ->
                 let uu____5502 = FStar_Parser_Dep.lowercase_module_name dep1 in
                 FStar_Util.psmap_add acc uu____5502 true) uu____5477
            uu____5482 in
        let loaded modname =
          FStar_Util.psmap_find_default loaded_mods_set modname false in
        let this_mod_key = FStar_Parser_Dep.lowercase_module_name this_fname in
        FStar_List.fold_left
          (fun table1 ->
             fun uu____5531 ->
               match uu____5531 with
               | (modname, mod_path) ->
                   let mod_key = FStar_String.lowercase modname in
                   if this_mod_key = mod_key
                   then table1
                   else
                     (let ns_query =
                        let uu____5554 = capitalize modname in
                        FStar_Util.split uu____5554 "." in
                      let uu____5557 = loaded mod_key in
                      FStar_Interactive_CompletionTable.register_module_path
                        table1 uu____5557 mod_path ns_query)) table
          (FStar_List.rev mods)
let run_push_with_deps :
  'Auu____5572 .
    FStar_JsonHelper.repl_state ->
      push_query ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____5572) FStar_Util.either)
  =
  fun st ->
    fun query ->
      (let uu____5596 = FStar_Options.debug_any () in
       if uu____5596
       then FStar_Util.print_string "Reloading dependencies"
       else ());
      FStar_TypeChecker_Env.toggle_id_info st.FStar_JsonHelper.repl_env false;
      (let uu____5604 = load_deps st in
       match uu____5604 with
       | FStar_Util.Inr st1 ->
           let errors =
             let uu____5639 = collect_errors () in
             FStar_List.map rephrase_dependency_error uu____5639 in
           let js_errors =
             FStar_All.pipe_right errors (FStar_List.map json_of_issue) in
           ((QueryNOK, (FStar_Util.JsonList js_errors)),
             (FStar_Util.Inl st1))
       | FStar_Util.Inl (st1, deps) ->
           ((let uu____5673 = FStar_Options.restore_cmd_line_options false in
             FStar_All.pipe_right uu____5673 (fun a2 -> ()));
            (let names1 =
               add_module_completions st1.FStar_JsonHelper.repl_fname deps
                 st1.FStar_JsonHelper.repl_names in
             run_push_without_deps
               (let uu___734_5677 = st1 in
                {
                  FStar_JsonHelper.repl_line =
                    (uu___734_5677.FStar_JsonHelper.repl_line);
                  FStar_JsonHelper.repl_column =
                    (uu___734_5677.FStar_JsonHelper.repl_column);
                  FStar_JsonHelper.repl_fname =
                    (uu___734_5677.FStar_JsonHelper.repl_fname);
                  FStar_JsonHelper.repl_deps_stack =
                    (uu___734_5677.FStar_JsonHelper.repl_deps_stack);
                  FStar_JsonHelper.repl_curmod =
                    (uu___734_5677.FStar_JsonHelper.repl_curmod);
                  FStar_JsonHelper.repl_env =
                    (uu___734_5677.FStar_JsonHelper.repl_env);
                  FStar_JsonHelper.repl_stdin =
                    (uu___734_5677.FStar_JsonHelper.repl_stdin);
                  FStar_JsonHelper.repl_names = names1
                }) query)))
let run_push :
  'Auu____5685 .
    FStar_JsonHelper.repl_state ->
      push_query ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____5685) FStar_Util.either)
  =
  fun st ->
    fun query ->
      let uu____5708 = nothing_left_to_pop st in
      if uu____5708
      then run_push_with_deps st query
      else run_push_without_deps st query
let (run_symbol_lookup :
  FStar_JsonHelper.repl_state ->
    Prims.string ->
      FStar_QueryHelper.position FStar_Pervasives_Native.option ->
        Prims.string Prims.list ->
          (Prims.string,
            (Prims.string * (Prims.string * FStar_Util.json) Prims.list))
            FStar_Util.either)
  =
  fun st ->
    fun symbol ->
      fun pos_opt ->
        fun requested_info ->
          let uu____5775 =
            FStar_QueryHelper.symlookup st.FStar_JsonHelper.repl_env symbol
              pos_opt requested_info in
          match uu____5775 with
          | FStar_Pervasives_Native.None -> FStar_Util.Inl "Symbol not found"
          | FStar_Pervasives_Native.Some result ->
              let uu____5810 =
                let uu____5823 = alist_of_symbol_lookup_result result in
                ("symbol", uu____5823) in
              FStar_Util.Inr uu____5810
let (run_option_lookup :
  Prims.string ->
    (Prims.string,
      (Prims.string * (Prims.string * FStar_Util.json) Prims.list))
      FStar_Util.either)
  =
  fun opt_name ->
    let uu____5878 = trim_option_name opt_name in
    match uu____5878 with
    | (uu____5902, trimmed_name) ->
        let uu____5908 =
          FStar_Util.smap_try_find fstar_options_map_cache trimmed_name in
        (match uu____5908 with
         | FStar_Pervasives_Native.None ->
             FStar_Util.Inl (Prims.op_Hat "Unknown option:" opt_name)
         | FStar_Pervasives_Native.Some opt ->
             let uu____5943 =
               let uu____5956 =
                 let uu____5964 = update_option opt in
                 alist_of_fstar_option uu____5964 in
               ("option", uu____5956) in
             FStar_Util.Inr uu____5943)
let (run_module_lookup :
  FStar_JsonHelper.repl_state ->
    Prims.string ->
      (Prims.string,
        (Prims.string * (Prims.string * FStar_Util.json) Prims.list))
        FStar_Util.either)
  =
  fun st ->
    fun symbol ->
      let query = FStar_Util.split symbol "." in
      let uu____6022 =
        FStar_Interactive_CompletionTable.find_module_or_ns
          st.FStar_JsonHelper.repl_names query in
      match uu____6022 with
      | FStar_Pervasives_Native.None ->
          FStar_Util.Inl "No such module or namespace"
      | FStar_Pervasives_Native.Some
          (FStar_Interactive_CompletionTable.Module mod_info) ->
          let uu____6057 =
            let uu____6070 =
              FStar_Interactive_CompletionTable.alist_of_mod_info mod_info in
            ("module", uu____6070) in
          FStar_Util.Inr uu____6057
      | FStar_Pervasives_Native.Some
          (FStar_Interactive_CompletionTable.Namespace ns_info) ->
          let uu____6101 =
            let uu____6114 =
              FStar_Interactive_CompletionTable.alist_of_ns_info ns_info in
            ("namespace", uu____6114) in
          FStar_Util.Inr uu____6101
let (run_code_lookup :
  FStar_JsonHelper.repl_state ->
    Prims.string ->
      FStar_QueryHelper.position FStar_Pervasives_Native.option ->
        Prims.string Prims.list ->
          (Prims.string,
            (Prims.string * (Prims.string * FStar_Util.json) Prims.list))
            FStar_Util.either)
  =
  fun st ->
    fun symbol ->
      fun pos_opt ->
        fun requested_info ->
          let uu____6194 = run_symbol_lookup st symbol pos_opt requested_info in
          match uu____6194 with
          | FStar_Util.Inr alist -> FStar_Util.Inr alist
          | FStar_Util.Inl uu____6268 ->
              let uu____6283 = run_module_lookup st symbol in
              (match uu____6283 with
               | FStar_Util.Inr alist -> FStar_Util.Inr alist
               | FStar_Util.Inl err_msg ->
                   FStar_Util.Inl "No such symbol, module, or namespace.")
let (run_lookup' :
  FStar_JsonHelper.repl_state ->
    Prims.string ->
      lookup_context ->
        FStar_QueryHelper.position FStar_Pervasives_Native.option ->
          Prims.string Prims.list ->
            (Prims.string,
              (Prims.string * (Prims.string * FStar_Util.json) Prims.list))
              FStar_Util.either)
  =
  fun st ->
    fun symbol ->
      fun context ->
        fun pos_opt ->
          fun requested_info ->
            match context with
            | LKSymbolOnly ->
                run_symbol_lookup st symbol pos_opt requested_info
            | LKModule -> run_module_lookup st symbol
            | LKOption -> run_option_lookup symbol
            | LKCode -> run_code_lookup st symbol pos_opt requested_info
let run_lookup :
  'Auu____6471 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        lookup_context ->
          FStar_QueryHelper.position FStar_Pervasives_Native.option ->
            Prims.string Prims.list ->
              ((query_status * FStar_Util.json) *
                (FStar_JsonHelper.repl_state, 'Auu____6471)
                FStar_Util.either)
  =
  fun st ->
    fun symbol ->
      fun context ->
        fun pos_opt ->
          fun requested_info ->
            let uu____6521 =
              run_lookup' st symbol context pos_opt requested_info in
            match uu____6521 with
            | FStar_Util.Inl err_msg ->
                ((QueryNOK, (FStar_Util.JsonStr err_msg)),
                  (FStar_Util.Inl st))
            | FStar_Util.Inr (kind, info) ->
                ((QueryOK,
                   (FStar_Util.JsonAssoc (("kind", (FStar_Util.JsonStr kind))
                      :: info))), (FStar_Util.Inl st))
let code_autocomplete_mod_filter :
  'Auu____6625 .
    ('Auu____6625 * FStar_Interactive_CompletionTable.mod_symbol) ->
      ('Auu____6625 * FStar_Interactive_CompletionTable.mod_symbol)
        FStar_Pervasives_Native.option
  =
  fun uu___7_6640 ->
    match uu___7_6640 with
    | (uu____6645, FStar_Interactive_CompletionTable.Namespace uu____6646) ->
        FStar_Pervasives_Native.None
    | (uu____6651, FStar_Interactive_CompletionTable.Module
       { FStar_Interactive_CompletionTable.mod_name = uu____6652;
         FStar_Interactive_CompletionTable.mod_path = uu____6653;
         FStar_Interactive_CompletionTable.mod_loaded = true;_})
        -> FStar_Pervasives_Native.None
    | (pth, FStar_Interactive_CompletionTable.Module md) ->
        let uu____6663 =
          let uu____6668 =
            let uu____6669 =
              let uu___811_6670 = md in
              let uu____6671 =
                let uu____6673 =
                  FStar_Interactive_CompletionTable.mod_name md in
                Prims.op_Hat uu____6673 "." in
              {
                FStar_Interactive_CompletionTable.mod_name = uu____6671;
                FStar_Interactive_CompletionTable.mod_path =
                  (uu___811_6670.FStar_Interactive_CompletionTable.mod_path);
                FStar_Interactive_CompletionTable.mod_loaded =
                  (uu___811_6670.FStar_Interactive_CompletionTable.mod_loaded)
              } in
            FStar_Interactive_CompletionTable.Module uu____6669 in
          (pth, uu____6668) in
        FStar_Pervasives_Native.Some uu____6663
let run_code_autocomplete :
  'Auu____6687 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____6687) FStar_Util.either)
  =
  fun st ->
    fun search_term ->
      let needle = FStar_Util.split search_term "." in
      let mods_and_nss =
        FStar_Interactive_CompletionTable.autocomplete_mod_or_ns
          st.FStar_JsonHelper.repl_names needle code_autocomplete_mod_filter in
      let lids =
        FStar_Interactive_CompletionTable.autocomplete_lid
          st.FStar_JsonHelper.repl_names needle in
      let json =
        FStar_List.map
          FStar_Interactive_CompletionTable.json_of_completion_result
          (FStar_List.append lids mods_and_nss) in
      ((QueryOK, (FStar_Util.JsonList json)), (FStar_Util.Inl st))
let run_module_autocomplete :
  'Auu____6749 'Auu____6750 'Auu____6751 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        'Auu____6749 ->
          'Auu____6750 ->
            ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
              'Auu____6751) FStar_Util.either)
  =
  fun st ->
    fun search_term ->
      fun modules1 ->
        fun namespaces ->
          let needle = FStar_Util.split search_term "." in
          let mods_and_nss =
            FStar_Interactive_CompletionTable.autocomplete_mod_or_ns
              st.FStar_JsonHelper.repl_names needle
              (fun _6798 -> FStar_Pervasives_Native.Some _6798) in
          let json =
            FStar_List.map
              FStar_Interactive_CompletionTable.json_of_completion_result
              mods_and_nss in
          ((QueryOK, (FStar_Util.JsonList json)), (FStar_Util.Inl st))
let (candidates_of_fstar_option :
  Prims.int ->
    Prims.bool ->
      fstar_option ->
        FStar_Interactive_CompletionTable.completion_result Prims.list)
  =
  fun match_len ->
    fun is_reset ->
      fun opt ->
        let uu____6832 =
          match opt.opt_permission_level with
          | OptSet -> (true, "")
          | OptReset -> (is_reset, "#reset-only")
          | OptReadOnly -> (false, "read-only") in
        match uu____6832 with
        | (may_set, explanation) ->
            let opt_type = kind_of_fstar_option_type opt.opt_type in
            let annot =
              if may_set
              then opt_type
              else
                Prims.op_Hat "("
                  (Prims.op_Hat explanation
                     (Prims.op_Hat " " (Prims.op_Hat opt_type ")"))) in
            FStar_All.pipe_right opt.opt_snippets
              (FStar_List.map
                 (fun snippet ->
                    {
                      FStar_Interactive_CompletionTable.completion_match_length
                        = match_len;
                      FStar_Interactive_CompletionTable.completion_candidate
                        = snippet;
                      FStar_Interactive_CompletionTable.completion_annotation
                        = annot
                    }))
let run_option_autocomplete :
  'Auu____6895 'Auu____6896 .
    'Auu____6895 ->
      Prims.string ->
        Prims.bool ->
          ((query_status * FStar_Util.json) * ('Auu____6895, 'Auu____6896)
            FStar_Util.either)
  =
  fun st ->
    fun search_term ->
      fun is_reset ->
        let uu____6928 = trim_option_name search_term in
        match uu____6928 with
        | ("--", trimmed_name) ->
            let matcher opt =
              FStar_Util.starts_with opt.opt_name trimmed_name in
            let options = current_fstar_options matcher in
            let match_len = FStar_String.length search_term in
            let collect_candidates =
              candidates_of_fstar_option match_len is_reset in
            let results = FStar_List.concatMap collect_candidates options in
            let json =
              FStar_List.map
                FStar_Interactive_CompletionTable.json_of_completion_result
                results in
            ((QueryOK, (FStar_Util.JsonList json)), (FStar_Util.Inl st))
        | (uu____6984, uu____6985) ->
            ((QueryNOK,
               (FStar_Util.JsonStr "Options should start with '--'")),
              (FStar_Util.Inl st))
let run_autocomplete :
  'Auu____7008 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        completion_context ->
          ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
            'Auu____7008) FStar_Util.either)
  =
  fun st ->
    fun search_term ->
      fun context ->
        match context with
        | CKCode -> run_code_autocomplete st search_term
        | CKOption is_reset ->
            run_option_autocomplete st search_term is_reset
        | CKModuleOrNamespace (modules1, namespaces) ->
            run_module_autocomplete st search_term modules1 namespaces
let run_and_rewind :
  'Auu____7059 'Auu____7060 .
    FStar_JsonHelper.repl_state ->
      'Auu____7059 ->
        (FStar_JsonHelper.repl_state -> 'Auu____7059) ->
          ('Auu____7059 * (FStar_JsonHelper.repl_state, 'Auu____7060)
            FStar_Util.either)
  =
  fun st ->
    fun sigint_default ->
      fun task ->
        let st1 =
          FStar_PushHelper.push_repl "run_and_rewind"
            FStar_PushHelper.FullCheck FStar_JsonHelper.Noop st in
        let results =
          try
            (fun uu___870_7101 ->
               match () with
               | () ->
                   FStar_Util.with_sigint_handler FStar_Util.sigint_raise
                     (fun uu____7112 ->
                        let uu____7113 = task st1 in
                        FStar_All.pipe_left
                          (fun _7118 -> FStar_Util.Inl _7118) uu____7113)) ()
          with | FStar_Util.SigInt -> FStar_Util.Inl sigint_default
          | e -> FStar_Util.Inr e in
        let st2 = FStar_PushHelper.pop_repl "run_and_rewind" st1 in
        match results with
        | FStar_Util.Inl results1 -> (results1, (FStar_Util.Inl st2))
        | FStar_Util.Inr e -> FStar_Exn.raise e
let run_with_parsed_and_tc_term :
  'Auu____7167 'Auu____7168 'Auu____7169 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        'Auu____7167 ->
          'Auu____7168 ->
            (FStar_TypeChecker_Env.env ->
               FStar_Syntax_Syntax.term -> (query_status * FStar_Util.json))
              ->
              ((query_status * FStar_Util.json) *
                (FStar_JsonHelper.repl_state, 'Auu____7169)
                FStar_Util.either)
  =
  fun st ->
    fun term ->
      fun line ->
        fun column ->
          fun continuation ->
            let dummy_let_fragment term1 =
              let dummy_decl =
                FStar_Util.format1 "let __compute_dummy__ = (%s)" term1 in
              {
                FStar_Parser_ParseIt.frag_text = dummy_decl;
                FStar_Parser_ParseIt.frag_line = (Prims.parse_int "0");
                FStar_Parser_ParseIt.frag_col = (Prims.parse_int "0")
              } in
            let find_let_body ses =
              match ses with
              | {
                  FStar_Syntax_Syntax.sigel = FStar_Syntax_Syntax.Sig_let
                    ((uu____7270,
                      { FStar_Syntax_Syntax.lbname = uu____7271;
                        FStar_Syntax_Syntax.lbunivs = univs1;
                        FStar_Syntax_Syntax.lbtyp = uu____7273;
                        FStar_Syntax_Syntax.lbeff = uu____7274;
                        FStar_Syntax_Syntax.lbdef = def;
                        FStar_Syntax_Syntax.lbattrs = uu____7276;
                        FStar_Syntax_Syntax.lbpos = uu____7277;_}::[]),
                     uu____7278);
                  FStar_Syntax_Syntax.sigrng = uu____7279;
                  FStar_Syntax_Syntax.sigquals = uu____7280;
                  FStar_Syntax_Syntax.sigmeta = uu____7281;
                  FStar_Syntax_Syntax.sigattrs = uu____7282;_}::[] ->
                  FStar_Pervasives_Native.Some (univs1, def)
              | uu____7321 -> FStar_Pervasives_Native.None in
            let parse1 frag =
              let uu____7342 =
                FStar_Parser_ParseIt.parse
                  (FStar_Parser_ParseIt.Toplevel frag) in
              match uu____7342 with
              | FStar_Parser_ParseIt.ASTFragment
                  (FStar_Util.Inr decls, uu____7348) ->
                  FStar_Pervasives_Native.Some decls
              | uu____7369 -> FStar_Pervasives_Native.None in
            let desugar env decls =
              let uu____7387 =
                let uu____7392 =
                  FStar_ToSyntax_ToSyntax.decls_to_sigelts decls in
                uu____7392 env.FStar_TypeChecker_Env.dsenv in
              FStar_Pervasives_Native.fst uu____7387 in
            let typecheck tcenv decls =
              let uu____7414 = FStar_TypeChecker_Tc.tc_decls tcenv decls in
              match uu____7414 with | (ses, uu____7428, uu____7429) -> ses in
            run_and_rewind st
              (QueryNOK, (FStar_Util.JsonStr "Computation interrupted"))
              (fun st1 ->
                 let tcenv = st1.FStar_JsonHelper.repl_env in
                 let frag = dummy_let_fragment term in
                 let uu____7450 = parse1 frag in
                 match uu____7450 with
                 | FStar_Pervasives_Native.None ->
                     (QueryNOK,
                       (FStar_Util.JsonStr "Could not parse this term"))
                 | FStar_Pervasives_Native.Some decls ->
                     let aux uu____7476 =
                       let decls1 = desugar tcenv decls in
                       let ses = typecheck tcenv decls1 in
                       match find_let_body ses with
                       | FStar_Pervasives_Native.None ->
                           (QueryNOK,
                             (FStar_Util.JsonStr
                                "Typechecking yielded an unexpected term"))
                       | FStar_Pervasives_Native.Some (univs1, def) ->
                           let uu____7512 =
                             FStar_Syntax_Subst.open_univ_vars univs1 def in
                           (match uu____7512 with
                            | (univs2, def1) ->
                                let tcenv1 =
                                  FStar_TypeChecker_Env.push_univ_vars tcenv
                                    univs2 in
                                continuation tcenv1 def1) in
                     let uu____7524 = FStar_Options.trace_error () in
                     if uu____7524
                     then aux ()
                     else
                       (try
                          (fun uu___953_7538 -> match () with | () -> aux ())
                            ()
                        with
                        | uu___952_7547 ->
                            let uu____7552 =
                              FStar_Errors.issue_of_exn uu___952_7547 in
                            (match uu____7552 with
                             | FStar_Pervasives_Native.Some issue ->
                                 let uu____7560 =
                                   let uu____7561 =
                                     FStar_Errors.format_issue issue in
                                   FStar_Util.JsonStr uu____7561 in
                                 (QueryNOK, uu____7560)
                             | FStar_Pervasives_Native.None ->
                                 FStar_Exn.raise uu___952_7547)))
let run_compute :
  'Auu____7576 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        FStar_TypeChecker_Env.step Prims.list FStar_Pervasives_Native.option
          ->
          ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
            'Auu____7576) FStar_Util.either)
  =
  fun st ->
    fun term ->
      fun rules ->
        let rules1 =
          FStar_List.append
            (match rules with
             | FStar_Pervasives_Native.Some rules1 -> rules1
             | FStar_Pervasives_Native.None ->
                 [FStar_TypeChecker_Env.Beta;
                 FStar_TypeChecker_Env.Iota;
                 FStar_TypeChecker_Env.Zeta;
                 FStar_TypeChecker_Env.UnfoldUntil
                   FStar_Syntax_Syntax.delta_constant])
            [FStar_TypeChecker_Env.Inlining;
            FStar_TypeChecker_Env.Eager_unfolding;
            FStar_TypeChecker_Env.UnfoldTac;
            FStar_TypeChecker_Env.Primops] in
        let normalize_term1 tcenv rules2 t =
          FStar_TypeChecker_Normalize.normalize rules2 tcenv t in
        run_with_parsed_and_tc_term st term (Prims.parse_int "0")
          (Prims.parse_int "0")
          (fun tcenv ->
             fun def ->
               let normalized = normalize_term1 tcenv rules1 def in
               let uu____7654 =
                 let uu____7655 =
                   FStar_QueryHelper.term_to_string tcenv normalized in
                 FStar_Util.JsonStr uu____7655 in
               (QueryOK, uu____7654))
type search_term' =
  | NameContainsStr of Prims.string 
  | TypeContainsLid of FStar_Ident.lid 
and search_term = {
  st_negate: Prims.bool ;
  st_term: search_term' }
let (uu___is_NameContainsStr : search_term' -> Prims.bool) =
  fun projectee ->
    match projectee with | NameContainsStr _0 -> true | uu____7690 -> false
let (__proj__NameContainsStr__item___0 : search_term' -> Prims.string) =
  fun projectee -> match projectee with | NameContainsStr _0 -> _0
let (uu___is_TypeContainsLid : search_term' -> Prims.bool) =
  fun projectee ->
    match projectee with | TypeContainsLid _0 -> true | uu____7712 -> false
let (__proj__TypeContainsLid__item___0 : search_term' -> FStar_Ident.lid) =
  fun projectee -> match projectee with | TypeContainsLid _0 -> _0
let (__proj__Mksearch_term__item__st_negate : search_term -> Prims.bool) =
  fun projectee ->
    match projectee with | { st_negate; st_term;_} -> st_negate
let (__proj__Mksearch_term__item__st_term : search_term -> search_term') =
  fun projectee -> match projectee with | { st_negate; st_term;_} -> st_term
let (st_cost : search_term' -> Prims.int) =
  fun uu___8_7747 ->
    match uu___8_7747 with
    | NameContainsStr str -> - (FStar_String.length str)
    | TypeContainsLid lid -> (Prims.parse_int "1")
type search_candidate =
  {
  sc_lid: FStar_Ident.lid ;
  sc_typ: FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option FStar_ST.ref ;
  sc_fvars:
    FStar_Ident.lid FStar_Util.set FStar_Pervasives_Native.option
      FStar_ST.ref
    }
let (__proj__Mksearch_candidate__item__sc_lid :
  search_candidate -> FStar_Ident.lid) =
  fun projectee ->
    match projectee with | { sc_lid; sc_typ; sc_fvars;_} -> sc_lid
let (__proj__Mksearch_candidate__item__sc_typ :
  search_candidate ->
    FStar_Syntax_Syntax.typ FStar_Pervasives_Native.option FStar_ST.ref)
  =
  fun projectee ->
    match projectee with | { sc_lid; sc_typ; sc_fvars;_} -> sc_typ
let (__proj__Mksearch_candidate__item__sc_fvars :
  search_candidate ->
    FStar_Ident.lid FStar_Util.set FStar_Pervasives_Native.option
      FStar_ST.ref)
  =
  fun projectee ->
    match projectee with | { sc_lid; sc_typ; sc_fvars;_} -> sc_fvars
let (sc_of_lid : FStar_Ident.lid -> search_candidate) =
  fun lid ->
    let uu____7881 = FStar_Util.mk_ref FStar_Pervasives_Native.None in
    let uu____7888 = FStar_Util.mk_ref FStar_Pervasives_Native.None in
    { sc_lid = lid; sc_typ = uu____7881; sc_fvars = uu____7888 }
let (sc_typ :
  FStar_TypeChecker_Env.env -> search_candidate -> FStar_Syntax_Syntax.typ) =
  fun tcenv ->
    fun sc ->
      let uu____7912 = FStar_ST.op_Bang sc.sc_typ in
      match uu____7912 with
      | FStar_Pervasives_Native.Some t -> t
      | FStar_Pervasives_Native.None ->
          let typ =
            let uu____7940 =
              FStar_TypeChecker_Env.try_lookup_lid tcenv sc.sc_lid in
            match uu____7940 with
            | FStar_Pervasives_Native.None ->
                FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown
                  FStar_Pervasives_Native.None FStar_Range.dummyRange
            | FStar_Pervasives_Native.Some ((uu____7959, typ), uu____7961) ->
                typ in
          (FStar_ST.op_Colon_Equals sc.sc_typ
             (FStar_Pervasives_Native.Some typ);
           typ)
let (sc_fvars :
  FStar_TypeChecker_Env.env ->
    search_candidate -> FStar_Ident.lident FStar_Util.set)
  =
  fun tcenv ->
    fun sc ->
      let uu____8011 = FStar_ST.op_Bang sc.sc_fvars in
      match uu____8011 with
      | FStar_Pervasives_Native.Some fv -> fv
      | FStar_Pervasives_Native.None ->
          let fv =
            let uu____8055 = sc_typ tcenv sc in
            FStar_Syntax_Free.fvars uu____8055 in
          (FStar_ST.op_Colon_Equals sc.sc_fvars
             (FStar_Pervasives_Native.Some fv);
           fv)
let (json_of_search_result :
  FStar_TypeChecker_Env.env -> search_candidate -> FStar_Util.json) =
  fun tcenv ->
    fun sc ->
      let typ_str =
        let uu____8099 = sc_typ tcenv sc in
        FStar_QueryHelper.term_to_string tcenv uu____8099 in
      let uu____8100 =
        let uu____8108 =
          let uu____8114 =
            let uu____8115 =
              let uu____8117 =
                FStar_Syntax_DsEnv.shorten_lid
                  tcenv.FStar_TypeChecker_Env.dsenv sc.sc_lid in
              uu____8117.FStar_Ident.str in
            FStar_Util.JsonStr uu____8115 in
          ("lid", uu____8114) in
        [uu____8108; ("type", (FStar_Util.JsonStr typ_str))] in
      FStar_Util.JsonAssoc uu____8100
exception InvalidSearch of Prims.string 
let (uu___is_InvalidSearch : Prims.exn -> Prims.bool) =
  fun projectee ->
    match projectee with
    | InvalidSearch uu____8150 -> true
    | uu____8153 -> false
let (__proj__InvalidSearch__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee ->
    match projectee with | InvalidSearch uu____8163 -> uu____8163
let run_search :
  'Auu____8172 .
    FStar_JsonHelper.repl_state ->
      Prims.string ->
        ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
          'Auu____8172) FStar_Util.either)
  =
  fun st ->
    fun search_str ->
      let tcenv = st.FStar_JsonHelper.repl_env in
      let empty_fv_set = FStar_Syntax_Syntax.new_fv_set () in
      let st_matches candidate term =
        let found =
          match term.st_term with
          | NameContainsStr str ->
              FStar_Util.contains (candidate.sc_lid).FStar_Ident.str str
          | TypeContainsLid lid ->
              let uu____8219 = sc_fvars tcenv candidate in
              FStar_Util.set_mem lid uu____8219 in
        found <> term.st_negate in
      let parse1 search_str1 =
        let parse_one term =
          let negate = FStar_Util.starts_with term "-" in
          let term1 =
            if negate
            then FStar_Util.substring_from term (Prims.parse_int "1")
            else term in
          let beg_quote = FStar_Util.starts_with term1 "\"" in
          let end_quote = FStar_Util.ends_with term1 "\"" in
          let strip_quotes str =
            if (FStar_String.length str) < (Prims.parse_int "2")
            then FStar_Exn.raise (InvalidSearch "Empty search term")
            else
              FStar_Util.substring str (Prims.parse_int "1")
                ((FStar_String.length term1) - (Prims.parse_int "2")) in
          let parsed =
            if beg_quote <> end_quote
            then
              let uu____8278 =
                let uu____8279 =
                  FStar_Util.format1 "Improperly quoted search term: %s"
                    term1 in
                InvalidSearch uu____8279 in
              FStar_Exn.raise uu____8278
            else
              if beg_quote
              then
                (let uu____8285 = strip_quotes term1 in
                 NameContainsStr uu____8285)
              else
                (let lid = FStar_Ident.lid_of_str term1 in
                 let uu____8290 =
                   FStar_Syntax_DsEnv.resolve_to_fully_qualified_name
                     tcenv.FStar_TypeChecker_Env.dsenv lid in
                 match uu____8290 with
                 | FStar_Pervasives_Native.None ->
                     let uu____8293 =
                       let uu____8294 =
                         FStar_Util.format1 "Unknown identifier: %s" term1 in
                       InvalidSearch uu____8294 in
                     FStar_Exn.raise uu____8293
                 | FStar_Pervasives_Native.Some lid1 -> TypeContainsLid lid1) in
          { st_negate = negate; st_term = parsed } in
        let terms =
          FStar_List.map parse_one (FStar_Util.split search_str1 " ") in
        let cmp x y = (st_cost x.st_term) - (st_cost y.st_term) in
        FStar_Util.sort_with cmp terms in
      let pprint_one term =
        let uu____8322 =
          match term.st_term with
          | NameContainsStr s -> FStar_Util.format1 "\"%s\"" s
          | TypeContainsLid l -> FStar_Util.format1 "%s" l.FStar_Ident.str in
        Prims.op_Hat (if term.st_negate then "-" else "") uu____8322 in
      let results =
        try
          (fun uu___1066_8356 ->
             match () with
             | () ->
                 let terms = parse1 search_str in
                 let all_lidents = FStar_TypeChecker_Env.lidents tcenv in
                 let all_candidates = FStar_List.map sc_of_lid all_lidents in
                 let matches_all candidate =
                   FStar_List.for_all (st_matches candidate) terms in
                 let cmp r1 r2 =
                   FStar_Util.compare (r1.sc_lid).FStar_Ident.str
                     (r2.sc_lid).FStar_Ident.str in
                 let results = FStar_List.filter matches_all all_candidates in
                 let sorted1 = FStar_Util.sort_with cmp results in
                 let js =
                   FStar_List.map (json_of_search_result tcenv) sorted1 in
                 (match results with
                  | [] ->
                      let kwds =
                        let uu____8404 = FStar_List.map pprint_one terms in
                        FStar_Util.concat_l " " uu____8404 in
                      let uu____8410 =
                        let uu____8411 =
                          FStar_Util.format1
                            "No results found for query [%s]" kwds in
                        InvalidSearch uu____8411 in
                      FStar_Exn.raise uu____8410
                  | uu____8418 -> (QueryOK, (FStar_Util.JsonList js)))) ()
        with | InvalidSearch s -> (QueryNOK, (FStar_Util.JsonStr s)) in
      (results, (FStar_Util.Inl st))
let (run_query :
  FStar_JsonHelper.repl_state ->
    query' ->
      ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
        Prims.int) FStar_Util.either))
  =
  fun st ->
    fun q ->
      match q with
      | Exit -> run_exit st
      | DescribeProtocol -> run_describe_protocol st
      | DescribeRepl -> run_describe_repl st
      | GenericError message -> run_generic_error st message
      | ProtocolViolation query -> run_protocol_violation st query
      | Segment c -> run_segment st c
      | VfsAdd (fname, contents) -> run_vfs_add st fname contents
      | Push pquery -> run_push st pquery
      | Pop -> run_pop st
      | AutoComplete (search_term, context) ->
          run_autocomplete st search_term context
      | Lookup (symbol, context, pos_opt, rq_info) ->
          run_lookup st symbol context pos_opt rq_info
      | Compute (term, rules) -> run_compute st term rules
      | Search term -> run_search st term
let (validate_query : FStar_JsonHelper.repl_state -> query -> query) =
  fun st ->
    fun q ->
      match q.qq with
      | Push
          { push_kind = FStar_PushHelper.SyntaxCheck; push_code = uu____8549;
            push_line = uu____8550; push_column = uu____8551;
            push_peek_only = false;_}
          ->
          {
            qq =
              (ProtocolViolation
                 "Cannot use 'kind': 'syntax' with 'query': 'push'");
            qid = (q.qid)
          }
      | uu____8557 ->
          (match st.FStar_JsonHelper.repl_curmod with
           | FStar_Pervasives_Native.None when
               query_needs_current_module q.qq ->
               { qq = (GenericError "Current module unset"); qid = (q.qid) }
           | uu____8559 -> q)
let (validate_and_run_query :
  FStar_JsonHelper.repl_state ->
    query ->
      ((query_status * FStar_Util.json) * (FStar_JsonHelper.repl_state,
        Prims.int) FStar_Util.either))
  =
  fun st ->
    fun query ->
      let query1 = validate_query st query in
      FStar_ST.op_Colon_Equals repl_current_qid
        (FStar_Pervasives_Native.Some (query1.qid));
      run_query st query1.qq
let (js_repl_eval :
  FStar_JsonHelper.repl_state ->
    query ->
      (FStar_Util.json * (FStar_JsonHelper.repl_state, Prims.int)
        FStar_Util.either))
  =
  fun st ->
    fun query ->
      let uu____8632 = validate_and_run_query st query in
      match uu____8632 with
      | ((status, response), st_opt) ->
          let js_response = json_of_response query.qid status response in
          (js_response, st_opt)
let (js_repl_eval_js :
  FStar_JsonHelper.repl_state ->
    FStar_Util.json ->
      (FStar_Util.json * (FStar_JsonHelper.repl_state, Prims.int)
        FStar_Util.either))
  =
  fun st ->
    fun query_js ->
      let uu____8698 = deserialize_interactive_query query_js in
      js_repl_eval st uu____8698
let (js_repl_eval_str :
  FStar_JsonHelper.repl_state ->
    Prims.string ->
      (Prims.string * (FStar_JsonHelper.repl_state, Prims.int)
        FStar_Util.either))
  =
  fun st ->
    fun query_str ->
      let uu____8722 =
        let uu____8732 = parse_interactive_query query_str in
        js_repl_eval st uu____8732 in
      match uu____8722 with
      | (js_response, st_opt) ->
          let uu____8755 = FStar_Util.string_of_json js_response in
          (uu____8755, st_opt)
let (js_repl_init_opts : unit -> unit) =
  fun uu____8768 ->
    let uu____8769 = FStar_Options.parse_cmd_line () in
    match uu____8769 with
    | (res, fnames) ->
        (match res with
         | FStar_Getopt.Error msg ->
             failwith (Prims.op_Hat "repl_init: " msg)
         | FStar_Getopt.Help -> failwith "repl_init: --help unexpected"
         | FStar_Getopt.Success ->
             (match fnames with
              | [] ->
                  failwith
                    "repl_init: No file name given in --ide invocation"
              | h::uu____8792::uu____8793 ->
                  failwith
                    "repl_init: Too many file names given in --ide invocation"
              | uu____8802 -> ()))
let rec (go : FStar_JsonHelper.repl_state -> Prims.int) =
  fun st ->
    let query = read_interactive_query st.FStar_JsonHelper.repl_stdin in
    let uu____8815 = validate_and_run_query st query in
    match uu____8815 with
    | ((status, response), state_opt) ->
        (write_response query.qid status response;
         (match state_opt with
          | FStar_Util.Inl st' -> go st'
          | FStar_Util.Inr exitcode -> exitcode))
let (interactive_error_handler : FStar_Errors.error_handler) =
  let issues = FStar_Util.mk_ref [] in
  let add_one1 e =
    let uu____8868 =
      let uu____8871 = FStar_ST.op_Bang issues in e :: uu____8871 in
    FStar_ST.op_Colon_Equals issues uu____8868 in
  let count_errors uu____8925 =
    let uu____8926 =
      let uu____8929 = FStar_ST.op_Bang issues in
      FStar_List.filter
        (fun e -> e.FStar_Errors.issue_level = FStar_Errors.EError)
        uu____8929 in
    FStar_List.length uu____8926 in
  let report uu____8964 =
    let uu____8965 = FStar_ST.op_Bang issues in
    FStar_List.sortWith FStar_Errors.compare_issues uu____8965 in
  let clear1 uu____8996 = FStar_ST.op_Colon_Equals issues [] in
  {
    FStar_Errors.eh_add_one = add_one1;
    FStar_Errors.eh_count_errors = count_errors;
    FStar_Errors.eh_report = report;
    FStar_Errors.eh_clear = clear1
  }
let (interactive_printer : (FStar_Util.json -> unit) -> FStar_Util.printer) =
  fun printer ->
    {
      FStar_Util.printer_prinfo =
        (fun s -> forward_message printer "info" (FStar_Util.JsonStr s));
      FStar_Util.printer_prwarning =
        (fun s -> forward_message printer "warning" (FStar_Util.JsonStr s));
      FStar_Util.printer_prerror =
        (fun s -> forward_message printer "error" (FStar_Util.JsonStr s));
      FStar_Util.printer_prgeneric =
        (fun label ->
           fun get_string ->
             fun get_json ->
               let uu____9057 = get_json () in
               forward_message printer label uu____9057)
    }
let (install_ide_mode_hooks : (FStar_Util.json -> unit) -> unit) =
  fun printer ->
    FStar_Util.set_printer (interactive_printer printer);
    FStar_Errors.set_handler interactive_error_handler
let (initial_range : FStar_Range.range) =
  let uu____9071 =
    FStar_Range.mk_pos (Prims.parse_int "1") (Prims.parse_int "0") in
  let uu____9074 =
    FStar_Range.mk_pos (Prims.parse_int "1") (Prims.parse_int "0") in
  FStar_Range.mk_range "<input>" uu____9071 uu____9074
let (build_initial_repl_state : Prims.string -> FStar_JsonHelper.repl_state)
  =
  fun filename ->
    let env = FStar_Universal.init_env FStar_Parser_Dep.empty_deps in
    let env1 = FStar_TypeChecker_Env.set_range env initial_range in
    let uu____9088 = FStar_Util.open_stdin () in
    {
      FStar_JsonHelper.repl_line = (Prims.parse_int "1");
      FStar_JsonHelper.repl_column = (Prims.parse_int "0");
      FStar_JsonHelper.repl_fname = filename;
      FStar_JsonHelper.repl_deps_stack = [];
      FStar_JsonHelper.repl_curmod = FStar_Pervasives_Native.None;
      FStar_JsonHelper.repl_env = env1;
      FStar_JsonHelper.repl_stdin = uu____9088;
      FStar_JsonHelper.repl_names = FStar_Interactive_CompletionTable.empty
    }
let interactive_mode' :
  'Auu____9104 . FStar_JsonHelper.repl_state -> 'Auu____9104 =
  fun init_st ->
    write_hello ();
    (let exit_code =
       let uu____9113 =
         (FStar_Options.record_hints ()) || (FStar_Options.use_hints ()) in
       if uu____9113
       then
         let uu____9117 =
           let uu____9119 = FStar_Options.file_list () in
           FStar_List.hd uu____9119 in
         FStar_SMTEncoding_Solver.with_hints_db uu____9117
           (fun uu____9126 -> go init_st)
       else go init_st in
     FStar_All.exit exit_code)
let (interactive_mode : Prims.string -> unit) =
  fun filename ->
    install_ide_mode_hooks FStar_JsonHelper.write_json;
    FStar_Util.set_sigint_handler FStar_Util.sigint_ignore;
    (let uu____9140 =
       let uu____9142 = FStar_Options.codegen () in
       FStar_Option.isSome uu____9142 in
     if uu____9140
     then
       FStar_Errors.log_issue FStar_Range.dummyRange
         (FStar_Errors.Warning_IDEIgnoreCodeGen, "--ide: ignoring --codegen")
     else ());
    (let init1 = build_initial_repl_state filename in
     let uu____9151 = FStar_Options.trace_error () in
     if uu____9151
     then interactive_mode' init1
     else
       (try
          (fun uu___1214_9157 ->
             match () with | () -> interactive_mode' init1) ()
        with
        | uu___1213_9160 ->
            (FStar_Errors.set_handler FStar_Errors.default_handler;
             FStar_Exn.raise uu___1213_9160)))