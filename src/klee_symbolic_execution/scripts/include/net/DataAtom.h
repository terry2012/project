#pragma once

#include <vector>

#include "net/util/SharedPtr.h"

namespace net {
  class DataAtomHolder;

  class DataAtom {
    friend class DataAtomHolder;
    private:
      DataAtom(DataAtom const&);
    protected:
      static char nextClassId();
      DataAtom();
    public:
      virtual char getClassId() const = 0;
      bool sameClass(DataAtom const&) const;
    public:
      virtual bool forceDistinction() const { return false; }
      virtual bool operator==(DataAtom const&) const = 0;
      virtual bool operator<(DataAtom const&) const = 0;
      virtual ~DataAtom();
  };

  template <typename T> class DataAtomT : public DataAtom {
    protected:
      DataAtomT() : DataAtom() {}
      char getClassId() const {
        return classId();
      }
    public:
      static char classId() {
        static char const _classId = nextClassId();
        return _classId;
      }
  };


  // this is quite similar to a shared pointer, but we need very specific
  // semantics, so we have to slightly reinvent things here
  class DataAtomHolder {
    friend class DataAtom;
    private:
      util::SharedPtr<DataAtom> atom;
    public:
      DataAtomHolder(util::SharedPtr<DataAtom> a);
      DataAtomHolder(DataAtomHolder const& from);
      void operator=(DataAtomHolder const& from);
      bool forceDistinction() const;
      bool operator==(DataAtomHolder const& cmp) const;
      bool operator<(DataAtomHolder const& cmp) const;
      operator util::SharedPtr<DataAtom>() const;
  };

  typedef std::vector<DataAtomHolder> ExData;
}

