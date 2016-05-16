#pragma once

#ifdef __cplusplus
extern "C" {
#endif

  unsigned knTest_get_nodeId(KTest const*);
  unsigned knTest_get_dscenarioId(KTest const*);
  char const* knTest_get_err(KTest const*);

  void knTest_set_nodeId(KTest*,unsigned);
  void knTest_set_dscenarioId(KTest*,unsigned);
  void knTest_set_err(KTest*,char const*);

#ifdef __cplusplus
}
#endif
