#pragma once

#include "net/DataAtom.h"

#include <vector>

namespace net {
  class StateMapper;
  class BasicState;

  template <typename PacketInfo> class TransmitHandler {
    public:
      virtual void handleTransmission(PacketInfo const& pi, BasicState* sender, BasicState* receiver, std::vector<DataAtomHolder> const& data) const = 0;
      virtual ~TransmitHandler() {}
  };
}

