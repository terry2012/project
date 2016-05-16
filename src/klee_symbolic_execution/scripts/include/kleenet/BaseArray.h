#pragma once

namespace kleenet {
  class DistributedSymbol;

  class BaseArray {
    protected:
      // KleeNet patch: Array is extended in the kleenet:: module to efficiently handle transmissions,
      // and whoever cares to delete this, will do this via an klee::Array* handle. So we need the dtor to be virtual.
      virtual ~BaseArray() {}
      BaseArray() : metaSymbol(NULL) {
      }
      BaseArray(BaseArray const&) : metaSymbol(NULL) {
      }
    public:
      typedef DistributedSymbol* MetaSymbol; // this *will* leak, but so does the Array
      mutable MetaSymbol metaSymbol;
      virtual bool isBaseArray() const {return true;}
  };
}
