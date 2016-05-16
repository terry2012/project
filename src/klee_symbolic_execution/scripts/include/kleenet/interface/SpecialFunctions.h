//===-- SpecialFunctions.h --------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// This file does not live in include/kleenet because it is the user includable
// special function header.

#pragma once

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

  /// Return the node id of the active state.
  /// Returns -1 if the node id wasn't set via \ref kleenet_set_node_id.
  int kleenet_get_node_id(void);

  /// Set the node id of the active state.
  ///
  /// \param id - Node id to be set.
  void kleenet_set_node_id(int id);

  /// Copy n bytes from memory area src of the active state to memory
  /// area dest at the destination state(s). The destination memory area
  /// must be visible in the active state. Before copying the data, state
  /// mapping is invoked determining the right target state(s) on the
  /// destination node.
  ///
  /// \param dest - The pointer to the destination memory area.
  /// \param src - The pointer to the source memory area.
  /// \param n - The number of bytes to copy.
  /// \param destId - The node id of the destination node.
  void kleenet_memcpy(void volatile *dest, void volatile const *src, size_t n, int destId);

  /// Copy the content of object to the corresponding object on the
  /// destination state. The engine will figure out the object's size
  /// on its own.
  /// NOTE: If you pass anything other than the pointer to beginning of the object
  ///       the resulting behaviour is **unspecified**.
  ///
  /// \param ptr  - The object to synchronise
  /// \param dest - The node id of the destination node.
  #define kleenet_sync(ptr,dest) kleenet_memcpy(ptr,ptr,sizeof(*ptr),dest)

  /// No-mapping data transmission operation.
  /// Writes a disjunction of all solutions of the targets into the object.
  ///
  /// \param object - The object to reverse synchronise
  /// \param srcId - The node id of the source node.
  void kleenet_reverse_memcpy(void volatile* dest, void volatile *src, size_t n, int sourceId);
  #define kleenet_pull(ptr,src) kleenet_reverse_memcpy(ptr,ptr,sizeof(*ptr),src)

  /// Write n bytes of value c (converted to an unsigned char) to the byte
  /// string dest. The state mapping is performed transparently
  /// (see \ref kleenet_memcpy).
  ///
  /// \param dest - The pointer to the destination memory area.
  /// \param c - The value to be written.
  /// \param destId - The node id of the destination node.
  void kleenet_memset(void volatile *dest, int c, size_t n, int destId);

  /// Terminate the active state, generate a test case,
  /// and write a string to the testXXXXXX.early file.
  ///
  /// \param message - The pointer to the string.
  void kleenet_early_exit(const char *message);

  /// Copy global symbol value(s) from destination node's state(s) to a
  /// area dest in the active state. The destination memory area must
  /// be visible in the active state having size n. Partial explosion is
  /// invoked to split the states on the destination node.
  ///
  /// \param dest - The pointer to the local memory area.
  /// \param symbol - The name of the global symbol on the destination state(s).
  /// \param n - The size of the symbol.
  /// \param dest_id - The node id of the destination node.
  void kleenet_get_global_symbol(void *dest, const char *symbol, size_t n, int dest_id);

  /* The following special functions are only valid in the context of a
   * discrete event searcher, e.g. EventSearcher.
   */

  /// Return the virtual time of the active state measured in ticks/1000.
  /// This function is specific to Contiki/COOJA.
  /// Use <b>only</b> in conjuction with EventSearcher or similar
  /// discrete event searcher.
  unsigned long kleenet_get_virtual_time(void);

  /// Schedule the active state to boot up after given time.
  /// This function is specific to Contiki/COOJA.
  /// Use <b>only</b> in conjuction with EventSearcher or similar
  /// discrete event searcher.
  ///
  /// \param time - Time measured in ticks to sleep until wakeup.
  /// The state cannot wake up earlier.
  void kleenet_schedule_boot_state(unsigned long ticks);

  /// Schedule the active state to wake up after given time.
  /// This function is specific to Contiki/COOJA.
  /// Use <b>only</b> in conjuction with EventSearcher or similar
  /// discrete event searcher.
  ///
  /// \param time - Time measured in ticks to sleep until wakeup.
  /// Note that the state might wake up earlier due to other external events.
  void kleenet_schedule_state(unsigned long ticks);

  /// Yield the active state.
  /// Call \ref kleenet_schedule_state beforehand, otherwise the state
  /// won't be executed anymore if there are no scheduled events in the future.
  /// Use <b>only</b> in conjuction with EventSearcher or similar
  /// discrete event searcher.
  void kleenet_yield_state(void);

  /// Schedule the state(s) on the destination node to wake up immediately.
  /// Use <b>only</b> in conjuction with EventSearcher or similar
  /// discrete event searcher.
  ///
  /// \param destId - The id of the destination node.
  void kleenet_wakeup_dest_states(int destId);

  /// A routine purely for debug purposes, returning a unique designator.
  /// The designator is chosen to match the address of the internal representation
  /// the current state. Note: Future versions may implement this differently or not at all.
  uintptr_t kleenet_get_state(void);


  /// Barrier synchronisation construct.
  /// All nodes in the network (in kleenet lingo: all states in the cluster) must hit
  /// this barrier before any can proceed. Use for meta-debugging.
  void kleenet_barrier(void);

#ifdef __cplusplus
}
#endif
