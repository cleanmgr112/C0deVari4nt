/**
 * @name User-controlled source to dangerous sink
 * @kind path-problem
 * @id taint-to-memcpy
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph
  

class Config extends TaintTracking::Configuration {
  Config() { this = "ReadFileBufferToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    exists(FunctionCall fc | source.asExpr() = fc.getArgument(1) and fc.getTarget().hasName("read"))
  }

  
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(FunctionCall fc |
        fc.getTarget().hasName("read") and
        pred.asExpr() = fc.getArgument(1) and
        succ.asExpr().(FunctionCall).getTarget().hasGlobalName("mempool_alloc")
      )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists (FunctionCall call
      | sink.asExpr() = call.getArgument(2) and
        call.getTarget().hasName("memcpy")
    )
  }
}


from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Taint from fmap_readn call in " + source.getNode().getFunction().getFile().getBaseName() + " to memcpy len arg in " + sink.getNode().getFunction().getName()