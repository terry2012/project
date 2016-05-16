//===-- KleeNet.h -----------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#pragma once

#include <vector>
#include <memory>

#include "net/DataAtom.h"
#include "net/ClusterCounter.h"

namespace klee {
  class ExecutionState;
}

namespace net {
  class StateMapper;
  class ClusterCounter;
  class Node;
  template <typename I> class PacketCache;
}

namespace kleenet {
  class Searcher;
  class PacketInfo;
  class TransmitHandler;
  class Executor;

  class KleeNet {
    public:
      typedef net::PacketCache<PacketInfo> PacketCache;
      struct RunEnv : net::Observer<net::ClusterCounter> {
        friend class KleeNet;
        private:
          KleeNet& kleenet;
          std::auto_ptr<net::StateMapper> stateMapper;
          std::auto_ptr<TransmitHandler> transmitHandler;
          std::auto_ptr<PacketCache> packetCache;
          std::auto_ptr<net::ClusterCounter> clusterCounter;
          virtual void notify(net::Observable<net::ClusterCounter>* observable);
          virtual void notifyNew(net::Observable<net::ClusterCounter>* observable, net::Observable<net::ClusterCounter> const* toldBy) {}
          virtual void notifyDie(net::Observable<net::ClusterCounter> const* observable) {}
        public:
          RunEnv(KleeNet& kleenet, klee::ExecutionState* rootState);
          ~RunEnv();
      };
      friend class TerminateStateCache;
      friend class RunEnv;
    private:
      bool phonyPackets;
      RunEnv* env;
      Executor* const executor;
    public:
      KleeNet(Executor* executor);
      PacketCache* getPacketCache() const;
      bool isPhonyPackets() const;
      net::StateMapper* getStateMapper() const;
      TransmitHandler* getTransmitHandler() const;
      static net::Node getStateNode(klee::ExecutionState const*);
      static net::Node getStateNode(klee::ExecutionState const&);
      static void setStateNode(klee::ExecutionState*,net::Node const&);
      static void setStateNode(klee::ExecutionState&,net::Node const&);
      void registerSearcher(Searcher*); // Called by kleenet::Searcher. Do not call otherwise!!!
      void memTxRequest(klee::ExecutionState&, PacketInfo const&, net::ExData const&) const;
      struct TerminateStateHandler {
        virtual void operator()(klee::ExecutionState&,std::vector<klee::ExecutionState*> const&) const = 0;
        virtual ~TerminateStateHandler();
      };
      void terminateCluster(klee::ExecutionState& state, TerminateStateHandler const&); // <3 λ
      ~KleeNet();
  };
}

