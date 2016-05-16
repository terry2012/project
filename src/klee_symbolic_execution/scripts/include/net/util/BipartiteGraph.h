//===-- BipartiteGraph.h ----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#pragma once

#include <map>
#include <set>
#include <vector>
#include <deque>

#include "net/util/Functor.h"
#include "net/util/Containers.h"
#include "net/util/SafeList.h"

namespace kleenet {
  namespace bg {

    using net::util::TypeSelection;
    using net::util::ExtractContainerKeys;
    using net::util::extractContainerKeys;
    using net::util::LoopConstIterator;
    using net::util::Functor;
    using net::util::DictionaryType;

    template <typename N1, typename N2, DictionaryType N1_is = net::util::UncontinuousDictionary, DictionaryType N2_is = net::util::UncontinuousDictionary> struct Props {
      typedef N1 Node1;
      typedef N2 Node2;
      typedef net::util::Dictionary<N1,std::set<size_t>,N1_is> Dictionary1;
      typedef net::util::Dictionary<N2,std::set<size_t>,N2_is> Dictionary2;
    };

    template <typename Node, typename P> struct SelectDictionary {
      typedef typename TypeSelection<
        Node,typename P::Node1,typename P::Dictionary1,
        typename TypeSelection<Node,typename P::Node2,typename P::Dictionary2,void>::Type
      >::Type Type;
      typedef typename TypeSelection<
        Node,typename P::Node1,typename P::Dictionary2,
        typename TypeSelection<Node,typename P::Node2,typename P::Dictionary1,void>::Type
      >::Type Reverse;
    };
    template <typename Node, typename P> struct SwapNode {
      typedef typename TypeSelection<
        /*if*/Node, /*equals*/typename P::Node1, /*then*/typename P::Node2, /*else*/typename P::Node1
      >::Type Type;
    };

    template <typename P> class Graph {
      public:
        typedef typename P::Node1 Node1;
        typedef typename P::Node2 Node2;
        typedef typename P::Dictionary1 Dictionary1;
        typedef typename P::Dictionary2 Dictionary2;
      private:
        Dictionary1 nodes1;
        Dictionary2 nodes2;
        Dictionary1& dictionaryOf(Node1 const&) {
          return nodes1;
        }
        Dictionary2& dictionaryOf(Node2 const&) {
          return nodes2;
        }
        Dictionary1 const& dictionaryOf(Node1 const&) const {
          return nodes1;
        }
        Dictionary2 const& dictionaryOf(Node2 const&) const {
          return nodes2;
        }
        template <typename OutputDictionary, typename Iterator>
        void addNodes(OutputDictionary& output, Iterator begin, Iterator end, size_t size) {
          output.reserve(output.size() + size);
          for (Iterator it = begin; it != end; ++it) {
            output[*it]; // merely bumping it
          }
        }
      public:
        template <typename InputContainer>
        void addNodes(InputContainer const& c) {
          addNodes(dictionaryOf(typename InputContainer::value_type()), c.begin(), c.end(), c.size());
        }
        template <typename InputIterator>
        void addNodes(InputIterator begin, InputIterator end, size_t size) {
          addNodes(dictionaryOf(*begin), begin, end, size);
        }
        template <typename From, typename To>
        void addDirectedEdge(From fromNode, To toNode) {
          dictionaryOf(fromNode)[fromNode].insert(dictionaryOf(toNode).getIndex(toNode));
        }
        template <typename NodeA, typename NodeB>
        void addUndirectedEdge(NodeA a, NodeB b) {
          addDirectedEdge(a,b);
          addDirectedEdge(b,a);
        }
        template <typename Node>
        size_t getDegree(Node node) const {
          return dictionaryOf(node).find(node).size();
        }
        template <typename Node>
        size_t countNodes() const {
          return dictionaryOf(Node()).size();
        }

        /* debug
        template <typename Node> struct NodeCollection {
          typedef typename SelectDictionary<Node,P>::Type NodeDictionary;
          typedef typename net::util::ExtractContainerKeys<NodeDictionary> Type;
        };
        typedef typename NodeCollection<Node1>::Type NodeCollection1;
        typedef typename NodeCollection<Node2>::Type NodeCollection2;
        template <typename Node>
        typename NodeCollection<Node>::Type nodeCollection() const {
          return extractContainerKeys(dictionaryOf(Node()));
        }
        eof debug */

        //template <typename Node>
        //std::set<typename SwapNode<Node,P>::Type> traverse(Node root) const { // rvo (we have to copy anyhow)
        //  return dictionaryOf(root).find(root);
        //}
        //template <typename InputContainer>
        //std::set<typename SwapNode<typename InputContainer::value_type,P>::Type> traverse(InputContainer const& input) const { // rvo (we have to copy anyway)
        //  std::set<typename SwapNode<typename InputContainer::value_type,P>::Type> result;
        //  for (LoopConstIterator<std::set<typename SwapNode<typename InputContainer::value_type,P>::Type> > it(input); it.more(); it.next()) {
        //    result.insert(
        //      dictionaryOf(*it).find(*it).begin()
        //    , dictionaryOf(*it).find(*it).end()
        //    );
        //  }
        //  return result;
        //}
        //template <typename InputContainer>
        //std::set<typename InputContainer::value_type> traverse2(InputContainer const& input) const { // rvo (we have to copy anyhow)
        //  return traverse(traverse(input));
        //}

        typedef net::util::SafeList<size_t> SC_Queue;

        template <typename D, typename Func>
        struct SearchContext {
          typedef D Dictionary;
          typedef SC_Queue Queue;
          // TODO: it is probably for the best if we replace this Queue with our SafeList (just for speed)
          //typedef std::deque<typename Dictionary::size_type> Queue;
          // we're using this as a temporary to a function, so we have to pass it as const&
          Dictionary const& dictionary;
          mutable std::vector<bool> visited;
          Queue& queue;
          mutable Func onVisit;
          SearchContext(Dictionary const& dictionary, Queue& queue, Func onVisit)
            : dictionary(dictionary)
            , visited(dictionary.size(),false)
            , queue(queue)
            , onVisit(onVisit) {
          }
          template <typename InputIterator>
          SearchContext const& setQueueWithIndices(InputIterator begin, InputIterator end) const {
            queue.dropAll(); // thanks to pooling this is O(1)
            for (InputIterator it = begin; it != end; ++it) // this aint :(
              if (dictionary.hasIndex(*it))
                queue.put(*it); // we never remove single elements, so we can afford to disregard the SFItem*
            return *this;
          }
          struct ExtractIndex {
            Dictionary const& dictionary;
            ExtractIndex(Dictionary const& dictionary) : dictionary(dictionary) {}
            typename Dictionary::index_type operator()(typename Dictionary::key_type k) const {
              if (dictionary.hasKey(k))
                return dictionary.getIndex(k);
              return dictionary.size();
            }
          };
          template <typename InputIterator>
          SearchContext const& setQueueWithKeys(InputIterator begin, InputIterator end) const {
            typedef net::util::AdHocIteratorTransformation<InputIterator,ExtractIndex,typename Dictionary::index_type> Tx;
            return setQueueWithIndices(Tx(begin,ExtractIndex(dictionary))
                                      ,Tx(end,ExtractIndex(dictionary)));
          }
        };

        template <typename Dictionary, typename Func>
        static SearchContext<Dictionary,Func> searchContext(Dictionary const& dictionary, SC_Queue& queue, Func onVisit) {
          return SearchContext<Dictionary,Func>(dictionary,queue,onVisit);
        }
        template <typename Dictionary>
        static SearchContext<Dictionary,Functor<> > searchContext(Dictionary const& dictionary, SC_Queue& queue) {
          return SearchContext<Dictionary,Functor<> >(dictionary,queue,Functor<>());
        }

        // this is the core graph-search method (it would qualify as bfs)
        template <typename SC1, typename SC2>
        void search(SC1 const& sc1, SC2 const& sc2) const {
          for (typename SC1::Queue::iterator it(sc1.queue); it.more(); it.next())
            if (!sc1.visited[it.get()]) {
              sc1.visited[it.get()] = true;
              sc1.onVisit(it.get());
              for (LoopConstIterator<typename SC1::Dictionary::value_type> edges(sc1.dictionary.findByIndex(it.get())); edges.more(); edges.next())
                if (!sc2.visited[*edges])// redundant test, but may save us from spamming the queue
                  sc2.queue.put(*edges);
            }
          sc1.queue.dropAll();
          if (sc2.queue.size())
            search(sc2,sc1);
          // {sc1.queue.empty} {sc2.queue.empty}
        }
        template <typename Dictionary, typename OutputContainer>
        struct CollectVisits {
        };
        template <typename Dictionary>
        struct CollectVisits<Dictionary,void const> {
          void operator()(typename Dictionary::index_type index) {}
          CollectVisits(Dictionary&, void const*) {}
        };
        template <typename Dictionary>
        struct CollectVisits<Dictionary,void> {
          void operator()(typename Dictionary::index_type index) {}
          CollectVisits(Dictionary&, void*) {}
        };
        template <typename Dictionary>
        struct CollectVisits<Dictionary,std::vector<typename Dictionary::key_type> > {
          Dictionary const& dictionary;
          typedef std::vector<typename Dictionary::key_type> Visited;
          Visited& visited;
          void operator()(typename Dictionary::index_type index) {
            visited.push_back(dictionary.getKey(index));
          }
          CollectVisits(Dictionary& dictionary, Visited* visited)
            : dictionary(dictionary)
            , visited(*visited) {
            this->visited.reserve(this->visited.size() + dictionary.size());
          }
        };
        template <typename Dictionary, typename VisitedContainer>
        static CollectVisits<Dictionary,VisitedContainer> collectVisits(Dictionary& dictionary, VisitedContainer* visited) {
          return CollectVisits<Dictionary,VisitedContainer>(dictionary,visited);
        }
      public:
        static const void* const IGNORE; // pass to search, to ignore reaing values
        template <typename InputContainer, typename OutputContainerSame, typename OutputContainerOther>
        void search(InputContainer const start, OutputContainerSame* outSame, OutputContainerOther* outOther) const { // rvo (we have to copy anyhow)
          typedef typename InputContainer::value_type Node;
          typedef typename SwapNode<typename InputContainer::value_type,P>::Type OtherNode;
          if (start.empty())
            return;
          SC_Queue nodeQ, otherQ;
          search(
            searchContext(dictionaryOf(Node()),nodeQ,collectVisits(dictionaryOf(Node()),outSame)).setQueueWithKeys(start.begin(),start.end())
          , searchContext(dictionaryOf(OtherNode()),otherQ,collectVisits(dictionaryOf(OtherNode()),outOther))
          );
        }
    };
    template <typename P>
    const void* const Graph<P>::IGNORE = 0;
  }
}
