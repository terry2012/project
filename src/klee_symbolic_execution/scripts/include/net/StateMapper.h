#pragma once

#include <stddef.h>

#include <set>
#include <deque>
#include <vector>
#include <cstddef>
#include <memory>

// Due to the excessive polymorphism used here you can loose track very easily
// which methods are SUPPOSED to be customised and which are base class methods
// you should not override. Although a missing 'virtual' modificator is already
// a very good hint to decide this we want to make things abundantly clear by
// adding the 'final' keyword. Additionally, functions you can customise are
// typically prefixed by a single underscore (_). Since 'final' is not part of
// the C++ language we introduce /*final*/, to indicate methods you
// should not reimplement. Note that there is no check at all to make sure you
// do not violate this guideline. This solution is inspired by
// http://www.parashift.com/c++-faq-lite/strange-inheritance.html#faq-23.12

namespace net {
  class BasicState;
  class MappingInformation;
  struct Node;
  class StateCluster;
  class SmStateLogger;
  class ClonerI;
  class NodeChangeObserver;

  enum StateMappingType {
    SM_COPY_ON_BRANCH,
    SM_COPY_ON_WRITE,
    SM_COPY_ON_WRITE2,
    SM_SUPER_DSTATE,
    SM_SUPER_DSTATE_WITH_BF_CLUS,
    SM_SUPER_DSTATE_WITH_SMART_CLUS
  };

  struct StateMapperInitialiser {
    public:
      bool const phonyPackets;
      StateMapperInitialiser(bool phonyPackets);
  };

  /****************************************************************************
   * StateMapper - Abstract Base Class                                        *
   ****************************************************************************/
  /// StateMapper is the defintion of the interface for state mappers to the
  /// outside world. It is designed to make the entire interface unchangeable
  /// by derived classes. Derived classes implement protected member functions
  /// which are called by the interface wrapper functions.
  class StateMapper : private StateMapperInitialiser {
    private: // interaction with StateMapperIntermediateBase
      virtual MappingInformation* stateInfo(BasicState const& state) const = 0;
      virtual MappingInformation* stateInfo(BasicState const* state) const = 0;

    protected: // member types
      /// We hide this type because the internal data structure (vector) should not
      /// leak out.
      typedef std::vector<BasicState*> Targets;
    public: // member types
      typedef Targets::iterator iterator;
      typedef std::set<Node> Nodes;

    private:
      /// Finding targets feels side effect free, so we want it to be const.
      /// However, it will have to modify the targets, so we make them mutable.
      mutable Targets targets;
      mutable bool validTargets;
      mutable iterator b;
      mutable iterator e;

      /// If paranoid explosions are enabled, the explode method will perform a
      /// consistency check after exploding a state.
#ifdef NDEBUG
      static bool const PARANOID_EXPLOSIONS = false;
#else
      static bool const PARANOID_EXPLOSIONS = true;
#endif
      bool paranoidExplosionsActive() const;
      /// A log where newly created states are protocolled, you have to subscribe to it.
      std::auto_ptr<SmStateLogger> const stateLogger;
      /// Which nodes are defined?
      Nodes _nodes;
      unsigned _truncatedDScenarios;

      std::auto_ptr<NodeChangeObserver> nco;


    private:
      bool checkMappingAdmissible(BasicState const* es, Node n) const;
    protected:
      StateMapper(StateMapperInitialiser const& initialiser, BasicState* rootState, MappingInformation* rootMI);

      /// Service routine for derived classes when they find a target.
      /// This is used to shield the targets list from manimpulation by
      /// derived classes.
      /// \param ts The new state that was found by a concrete mapper.
      ///           It is not checked of this is already in the list.
      /*final*/ void foundTarget(BasicState const* const ts) const;

      /// Custom mapping algorithm: The main work is done in this method by
      /// derived classes. It is pure virtual because there is no meaningful
      /// implementation for it without a concrete algorithm.
      /// \param state The state that is about to transmit a packet.
      /// \param node The node that is supposed to receive the packet.
      ///             Transmissions to localhost are already caught and dropped.
      virtual void _map(BasicState& state, Node dest) = 0;

      /// Custom mapping algorithm, supporting phonies.
      virtual void _phonyMap(std::set<BasicState*> const& senders, Node dest) = 0;

      /// Custom search algorithm: Instruct the mapping algorithm to find the
      /// candidates for a given state and a destination node.
      /// Note that this method will not resolve any conflicts (it will not map)
      /// hence, it is const. The result can be iterated over with begin() and
      /// end().
      /// \param state The state to which we want to know the targets.
      /// \param dest The destination node. All targets will belong to this node.
      virtual void _findTargets(BasicState const& state, Node const dest) const = 0;

      /// Custom remove algorithm: It requires the set of states to be exactly
      /// one dscenario. Then the whole dscenario will not be considered while
      /// mapping in the future.
      /// \param remstates The set of states that form the dscenario to remove.
      virtual void _remove(std::set<BasicState*> const& remstates) = 0;

      /// A service function for derived classes that will clone the passed state
      /// while being consistent with the engine.
      /// We call this process forking (as opposed to branching).
      /// \param es The state to fork.
      /// \returns The newly created state.
      /*final*/ BasicState* fork(BasicState*);
    public:
      /// Default constructor that will be called when the whole program
      /// terminates. The StateMapper should not be destroyed before, therefore,
      /// we do not really care about tidy-up work. For this base class however,
      /// there is no tidy-up anyway.
      /// It must be virtual because the executor will remove the dervied class
      /// through a pointer to StateMapper and we can expect derived classes
      /// to require explicit clean-up.
      virtual ~StateMapper();

      /// Grabs the node of a state. Esp. useful for code outside the net namespace.
      static Node getStateNode(BasicState const*);
      static void setStateNode(BasicState const*, Node const&);

      /// Called by the engine if the execution state 'state' wants to share
      /// data with states of node 'dest'.
      /// Note that this is a wrapper that will perform some sanity checks and
      /// call the custom _map method.
      /// \param state The state that wants to send.
      /// \param dest The destination node.
      /*final*/ void map(BasicState* state, Node dest);
      /*final*/ void map(BasicState& state, Node dest);

      /// Experimental phony mapping function that try to save some unnecessary
      /// branching by considering all equivalent mapping instructions at once.
      /*final*/ void map(std::set<BasicState*> const& senders, Node dest);

      /// Explode the visible states from 'state' into separate dscenarios.
      /// Currently, explosion can be terribly (!) expensive and cost you more
      /// time and memory then all the execution so far.
      /// This however, depends heavily on the respective state mapping
      /// algorithm.
      /// There are several version for this function that are essentially
      /// wrappers for the last version (with the most parameters). We do this
      /// to make the life of our user easier.
      /*final*/ void explode(BasicState* state);

      /// See void explode(BasicState* state)
      /*final*/ void explode(BasicState* state, std::vector<BasicState*>* siblings);

      /// See void explode(BasicState* state)
      /*final*/ void explode(BasicState* state,
          Nodes const& cleanWithRespectTo,
          Nodes const& nukeNodes,
          std::vector<BasicState*>* siblings);

      /// Remove a state and its visible states from the mapper. You must
      /// guarantee a few things for this to work:
      ///  1) 'state' must be in a uniqe dscenario. Hence it must "see" exactly
      ///     one state on each node.
      ///  2) Afterwards, all visible states of 'state' (including 'state'
      ///     itself) must be removed from the engine.
      ///  3) Neither 'state' nor its targets must be ever passed to us again!
      /// \param state The state for which the induced dscenario is supposed to
      ///              be removed
      /*final*/ void remove(BasicState* state);

      struct TerminateStateHandler {
        virtual void operator()(BasicState&,std::vector<BasicState*> const&) const = 0;
      };
      /// Transitively remove everything that belongs to the same cluster as the passed state.
      /// \param state The pivotal state to figure out which cluster to finish.
      /// \param TerminateStateHandler Functor that will allow implementation specific termination of states.
      /// \returns true iff it knew that state (and by extension its cluster). In any case afterwards the state will be unknown.
      /*final*/ bool terminateCluster(BasicState& state, TerminateStateHandler const&); // <3 λ

      /// Call to find all states that are currently reachable from a given
      /// state.
      /// \param state The state from which to transmit.
      /// \param dest The destination node of which the targets are states of.
      /// \returns The number of targets found.
      /*final*/ size_t findTargets(BasicState const* state, Node const dest) const;
      /*final*/ size_t findTargets(BasicState const& state, Node const dest) const;

      /// Wrapper function to get the content of the targets list.
      /// \returns A reference to the list of all recently found targets.
      /*final*/ Targets const& allFoundTargets() const;

      /// Wrapper function to get the content of the installed nodes.
      /// \returns A reference to all nodes.
      /*final*/ Nodes const& nodes() const;

      /// Get the number of dscenarios that have been terminated so far.
      unsigned truncatedDScenarios() const;

      /// Get an iterator to the first found target if there still is a valid
      /// result.
      /*final*/ iterator& begin();

      /// Get an iterator to the end of the target list if there still is a valid
      /// result.
      /*final*/ iterator& end();

      /// Tell the mapper that the findTargets result has been processed and can
      /// be discarded. You have to call this method before starting a new search
      /// for targets.
      void invalidate();

      /// Count the total number of dscenarios. May be expensive, depending on
      /// the mapper. This will count all dscenarios ever discovered, including
      /// terminated ones.
      virtual unsigned countTotalDistributedScenarios() const = 0;

      /// Tell the mapper the (expected) node count.
      /// Depending on the mapper, this call could be quite expensive: it is
      /// supposed to be called once in the boot phase because adding nodes
      /// independently would be even more expensive.
      /// This information is only a guideline for the mapper not an obligation;
      /// It can choose to ignore this until nodeArrival is called.
      /// What you pass here, may not be reflected in the total set of nodes.
      virtual void setNodeCount(unsigned nodeCount);

      /// Factory method to hide derived classes from the engine.
      /// We want to create the derived classes by specifying only an enum.
      /// \param mt The state mapping algorithm to instaniate.
      /*final*/ static StateMapper* create(
          StateMappingType mt,
          bool usePhonyPackets,
          BasicState* rootState);

      virtual void dumpInternals() const {}
  };

}

