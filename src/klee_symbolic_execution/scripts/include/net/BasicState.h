#pragma once

#include <vector>
#include <stddef.h>

namespace net {
  class StateDependantI;
  class RegisterChildDependant;

  /* Fundamental type whose objects model logical states in the net-module.
   *   Basic States have many *locical* members (e.g. MappingInformation) but these
   *   are not found as actual members of this class as they are dynamic.
   *   Instead we handle logical members in the StateDependant infrastructure.
   *
   *   The reason is automation: A basic state may have members defined loosely in
   *   compilation units without chaing this file. Whenever a Basic state is duplicated
   *   (i.e. via the copy-ctor) the StateDependant type will take care of cloning
   *   all logical members, if they exist.
   */
  class BasicState {
    friend class RegisterChildDependant;
    private:
      typedef StateDependantI* Dependant;
      static size_t& tableSize();
      std::vector<Dependant> dependants;
      bool const fake;
      size_t completedTransmissions;
      size_t completedPullRequests;
    public:
      BasicState();
      BasicState(BasicState const&);
      virtual ~BasicState();
      virtual BasicState* forceFork() = 0;
      bool isFake() const;
      size_t getCompletedTransmissions() const;
      void incCompletedTransmissions();
      size_t getCompletedPullRequests() const;
      void incCompletedPullRequests();
  };
}

