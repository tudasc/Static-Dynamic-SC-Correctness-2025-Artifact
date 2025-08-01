#di_basic_type = #llvm.di_basic_type<tag = DW_TAG_base_type, name = "char", sizeInBits = 8, encoding = DW_ATE_signed_char>
#di_file = #llvm.di_file<"results-20250730-140308/SPMDIR/dynamic/004-MPI-dynamic-while-local-no.c" in "/home/yo30qaqy/data-race-detection-benchmark-suite">
#tbaa_root = #llvm.tbaa_root<id = "Simple C/C++ TBAA">
#di_composite_type = #llvm.di_composite_type<tag = DW_TAG_array_type, baseType = #di_basic_type, sizeInBits = 392, elements = #llvm.di_subrange<count = 49 : i64>>
#di_composite_type1 = #llvm.di_composite_type<tag = DW_TAG_array_type, baseType = #di_basic_type, sizeInBits = 752, elements = #llvm.di_subrange<count = 94 : i64>>
#di_global_variable = #llvm.di_global_variable<file = #di_file, line = 33, type = #di_composite_type, isLocalToUnit = true, isDefined = true>
#di_global_variable1 = #llvm.di_global_variable<file = #di_file, line = 56, type = #di_composite_type1, isLocalToUnit = true, isDefined = true>
#tbaa_type_desc = #llvm.tbaa_type_desc<id = "omnipotent char", members = {<#tbaa_root, 0>}>
#di_global_variable_expression = #llvm.di_global_variable_expression<var = #di_global_variable, expr = <>>
#di_global_variable_expression1 = #llvm.di_global_variable_expression<var = #di_global_variable1, expr = <>>
#tbaa_type_desc1 = #llvm.tbaa_type_desc<id = "int", members = {<#tbaa_type_desc, 0>}>
#tbaa_type_desc2 = #llvm.tbaa_type_desc<id = "any pointer", members = {<#tbaa_type_desc, 0>}>
#tbaa_tag = #llvm.tbaa_tag<base_type = #tbaa_type_desc1, access_type = #tbaa_type_desc1, offset = 0>
#tbaa_type_desc3 = #llvm.tbaa_type_desc<id = "p2 omnipotent char", members = {<#tbaa_type_desc2, 0>}>
#tbaa_type_desc4 = #llvm.tbaa_type_desc<id = "p1 omnipotent char", members = {<#tbaa_type_desc2, 0>}>
#tbaa_tag1 = #llvm.tbaa_tag<base_type = #tbaa_type_desc3, access_type = #tbaa_type_desc3, offset = 0>
#tbaa_tag2 = #llvm.tbaa_tag<base_type = #tbaa_type_desc4, access_type = #tbaa_type_desc4, offset = 0>
module attributes {dlti.dl_spec = #dlti.dl_spec<!llvm.ptr<272> = dense<64> : vector<4xi64>, i64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>, !llvm.ptr<271> = dense<32> : vector<4xi64>, f16 = dense<16> : vector<2xi64>, !llvm.ptr<270> = dense<32> : vector<4xi64>, f64 = dense<64> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, !llvm.ptr = dense<64> : vector<4xi64>, i1 = dense<8> : vector<2xi64>, f80 = dense<128> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, "dlti.endianness" = "little", "dlti.stack_alignment" = 128 : i64>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", llvm.ident = "clang version 20.0.0git (https://github.com/burakSemih/llvm-project.git a5b8f53f3db10b0ff5451335362b36a25139a3f8)", llvm.target_triple = "x86_64-unknown-linux-gnu", spmd.executionKind = "All"} {
  llvm.mlir.global private unnamed_addr constant @".str"("Wrong number of MPI processes: %d. Expected: %d\0A\00") {addr_space = 0 : i32, alignment = 1 : i64, dbg_exprs = [#di_global_variable_expression], dso_local, spmd.executionKind = "All"}
  llvm.mlir.global private unnamed_addr constant @".str.1"("Process %d: Execution finished, variable contents: value = %d, value2 = %d, win_base[0] = %d\0A\00") {addr_space = 0 : i32, alignment = 1 : i64, dbg_exprs = [#di_global_variable_expression1], dso_local, spmd.executionKind = "All"}
  llvm.func local_unnamed_addr @main(%arg0: i32 {llvm.noundef}, %arg1: !llvm.ptr {llvm.noundef}) -> (i32 {llvm.noundef}) attributes {no_unwind, passthrough = [["uwtable", "2"], ["min-legal-vector-width", "0"], ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], spmd.executionKind = "All", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic"} {
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c0_i64 = arith.constant {spmd.executionKind = "All"} 0 : i64
    %c-1_i32 = arith.constant {spmd.executionKind = "All"} -1 : i32
    %0 = llvm.mlir.addressof @".str.1" {spmd.executionKind = "All"} : !llvm.ptr
    %false = arith.constant {spmd.executionKind = "All"} false
    %c9999_i32 = arith.constant {spmd.executionKind = "All"} 9999 : i32
    %c3_i32 = arith.constant {spmd.executionKind = "All"} 3 : i32
    %c-6_i32 = arith.constant {spmd.executionKind = "All"} -6 : i32
    %c4_i32 = arith.constant {spmd.executionKind = "All"} 4 : i32
    %c40_i64 = arith.constant {spmd.executionKind = "All"} 40 : i64
    %1 = llvm.mlir.addressof @".str" {spmd.executionKind = "All"} : !llvm.ptr
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c10_i32 = arith.constant {spmd.executionKind = "All"} 10 : i32
    %2 = llvm.mlir.zero {spmd.executionKind = "All"} : !llvm.ptr
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %4 = "spmd.constLockTypeOp"() <{stringAttr = "EXCLUSIVE", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.lock
    %5 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %6 = llvm.alloca %c1_i32 x i32 {alignment = 4 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %7 = llvm.alloca %c1_i32 x !llvm.ptr {alignment = 8 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %8 = llvm.alloca %c1_i32 x i32 {alignment = 4 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %9 = llvm.alloca %c1_i32 x i32 {alignment = 4 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %10 = llvm.alloca %c1_i32 x i32 {alignment = 4 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %11 = llvm.alloca %c1_i32 x !llvm.ptr {alignment = 8 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    %12 = llvm.alloca %c1_i32 x i32 {alignment = 4 : i64, spmd.executionKind = "All"} : (i32) -> !llvm.ptr
    llvm.store %arg0, %6 {alignment = 4 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag]} : i32, !llvm.ptr
    llvm.store %arg1, %7 {alignment = 8 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag1]} : !llvm.ptr, !llvm.ptr
    llvm.intr.lifetime.start 4, %8 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.start 4, %9 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.start 4, %10 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.start 8, %11 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.start 4, %12 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.store %c1_i32, %12 {alignment = 4 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag]} : i32, !llvm.ptr
    %13 = arith.cmpi sgt, %arg0, %c1_i32 {spmd.executionKind = "All"} : i32
    %14 = scf.if %13 -> (i32) {
      %23 = llvm.getelementptr inbounds %arg1[8] {spmd.executionKind = "All"} : (!llvm.ptr) -> !llvm.ptr, i8
      %24 = llvm.load %23 {alignment = 8 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag2]} : !llvm.ptr -> !llvm.ptr
      %25 = llvm.call tail @strtol(%24, %2, %c10_i32) {no_unwind, spmd.executionKind = "All", will_return} : (!llvm.ptr, !llvm.ptr, i32) -> i64
      %26 = arith.trunci %25 {spmd.executionKind = "All"} : i64 to i32
      scf.yield {spmd.executionKind = "All"} %26 : i32
    } else {
      scf.yield {spmd.executionKind = "All"} %c10_i32 : i32
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %15 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_0 = "spmd.getSizeOfComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %16 = arith.cmpi eq, %size, %c2_i32 {spmd.executionKind = "All"} : i32
    scf.if %16 {
    } else {
      %23 = llvm.call @printf(%1, %size, %c2_i32) vararg(!llvm.func<i32 (ptr, ...)>) {no_unwind, spmd.executionKind = "All"} : (!llvm.ptr, i32, i32) -> i32
      %24 = "spmd.abort"(%3, %c1_i32) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, i32) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %baseAddress, %win, %error_1 = "spmd.winAlloc"(%3, %c40_i64, %c4_i32) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, i64, i32) -> (!llvm.ptr, !spmd.win, !spmd.error)
    scf.for %arg2 = %c0_i32 to %c10_i32 step %c1_i32  : i32 {
      %23 = arith.extui %arg2 {nonNeg, spmd.executionKind = "All"} : i32 to i64
      %24 = llvm.getelementptr inbounds %baseAddress[%23] {spmd.executionKind = "All"} : (!llvm.ptr, i64) -> !llvm.ptr, i32
      llvm.store %c0_i32, %24 {alignment = 4 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag]} : i32, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %error_2 = "spmd.barrier"(%3) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %17 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %17 {
      %23 = "spmd.lock"(%c1_i32, %win, %4, %c0_i32) <{usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (i32, !spmd.win, !spmd.lock, i32) -> !spmd.error
      %24 = scf.while (%arg2 = %14) : (i32) -> i32 {
        %26 = arith.addi %arg2, %c-6_i32 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        %27 = arith.remsi %26, %c3_i32 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        %28 = arith.cmpi slt, %27, %c2_i32 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        %29 = llvm.load %12 {alignment = 4 : i64, spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : !llvm.ptr -> i32
        %30 = arith.cmpi slt, %29, %c9999_i32 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        %31 = arith.select %28, %30, %false {fastmathFlags = #llvm.fastmath<none>, spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i1
        scf.condition(%31) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} %arg2 : i32
      } do {
      ^bb0(%arg2: i32):
        %26 = arith.addi %arg2, %c-1_i32 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        %error_4 = "spmd.get"(%12, %c1_i64, %5, %c1_i64, %c1_i32, %win, %c0_i64, %c1_i64, %5, %c1_i64) <{isAtomic = true, isBlocking = false, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr, i64, !spmd.datatype, i64, i32, !spmd.win, i64, i64, !spmd.datatype, i64) -> !spmd.error
        %27 = "spmd.flush"(%c1_i32, %win) <{isLocal = false, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (i32, !spmd.win) -> !spmd.error
        scf.yield {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} %26 : i32
      } attributes {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static", spmd.isMultiValued = false}
      %25 = "spmd.unlock"(%c1_i32, %win) <{usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (i32, !spmd.win) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %error_3 = "spmd.barrier"(%3) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %18 = llvm.load %12 {alignment = 4 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag]} : !llvm.ptr -> i32
    %19 = llvm.load %baseAddress {alignment = 4 : i64, spmd.executionKind = "All", tbaa = [#tbaa_tag]} : !llvm.ptr -> i32
    %20 = llvm.call @printf(%0, %rank, %18, %c2_i32, %19) vararg(!llvm.func<i32 (ptr, ...)>) {no_unwind, spmd.executionKind = "All"} : (!llvm.ptr, i32, i32, i32, i32) -> i32
    %21 = "spmd.winFree"(%win) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.win) -> !spmd.error
    %22 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    llvm.intr.lifetime.end 4, %12 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.end 8, %11 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.end 4, %10 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.end 4, %9 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.intr.lifetime.end 4, %8 {spmd.executionKind = "All"} : !llvm.ptr
    llvm.return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  llvm.func local_unnamed_addr @printf(!llvm.ptr {llvm.nocapture, llvm.noundef, llvm.readonly}, ...) -> (i32 {llvm.noundef}) attributes {no_unwind, passthrough = ["nofree", ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], spmd.executionKind = "All", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic"}
  llvm.func local_unnamed_addr @strtol(!llvm.ptr {llvm.noundef, llvm.readonly}, !llvm.ptr {llvm.nocapture, llvm.noundef}, i32 {llvm.noundef}) -> i64 attributes {no_unwind, passthrough = ["mustprogress", "nofree", ["no-trapping-math", "true"], ["stack-protector-buffer-size", "8"], ["target-cpu", "x86-64"]], spmd.executionKind = "All", target_cpu = "x86-64", target_features = #llvm.target_features<["+cmov", "+cx8", "+fxsr", "+mmx", "+sse", "+sse2", "+x87"]>, tune_cpu = "generic", will_return}
}

