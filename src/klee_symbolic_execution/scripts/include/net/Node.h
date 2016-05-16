#pragma once

namespace net {

  typedef int NodeId; // base type
  typedef unsigned int NodeCount;

  struct Node {
    NodeId id;
    Node() : id(INVALID_NODE.id) {}
    Node(NodeId id) : id(id) {}
    ~Node() {}
    Node operator=(NodeId _id) {
      return id = _id;
    }
    Node operator++();
    Node operator++(int);
    bool operator==(const Node) const;
    bool operator!=(const Node) const;
    bool operator<(const Node) const;
    bool operator>(const Node) const;
    bool operator<=(const Node) const;
    bool operator>=(const Node) const;
    static const Node FIRST_NODE;
    static const Node INVALID_NODE;
  };
}

