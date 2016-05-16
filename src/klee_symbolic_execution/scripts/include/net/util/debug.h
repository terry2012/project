#pragma once

namespace net {
  namespace debug {
    enum DebugFlags {
        slack      = ((1u<<0x0))       /*default reason*/
      , mapping    = ((1u<<0x1))       /*debugging mapping*/
      , clusters   = ((1u<<0x2))       /*debugging clustering*/
      , searchers  = ((1u<<0x3))       /*debugging searchers*/
      , term       = ((1u<<0x4))       /*debugging termination*/
      , pcache     = ((1u<<0x5))       /*debugging packet cache*/
      , transmit   = ((1u<<0xc))       /*debugging transmission handlers*/
      , external1  = ((1u<<0xd))       /*debugging external module (1)*/
      , external2  = ((1u<<0xe))       /*debugging external module (2)*/
      , all        = ((1u<<0xf)-1)     /*everything!*/
    };
  }
}

//#define ENABLE_DEBUG all
// undefine this to have none

#ifdef NDEBUG
#  undef ENABLE_DEBUG
#endif

#ifdef ENABLE_DEBUG
#  include <iostream>
#  define ENABLE_DEBUG_VALUE ENABLE_DEBUG
#else
#  define ENABLE_DEBUG_VALUE 0
#endif

namespace net {
  namespace debug {
    enum EnableDebugWrapper { enable = ENABLE_DEBUG_VALUE };
    struct Fake {};
    template <typename T>
    Fake& operator<<(Fake& out, T const&) {
      return out;
    }
    template <bool enable>
    struct ifdebug {
    };
    template <>
    struct ifdebug<false> {
      typedef Fake OutType;
      typedef Fake EndlType;
      OutType cout;
      OutType cerr;
      EndlType endl;
      static bool const enable = false;
    };
#ifdef ENABLE_DEBUG
    template <>
    struct ifdebug<true> {
      typedef ::std::ostream OutType;
      typedef OutType& EndlType(OutType&);
      OutType& cout;
      OutType& cerr;
      EndlType& endl;
      static bool const enable = true;
      ifdebug() : cout(::std::cout), cerr(::std::cerr), endl(::std::endl) {}
    };
#endif
  }
  template <unsigned flag>
  struct DEBUG {
    typedef debug::ifdebug<flag & debug::enable> Manifold;
    static Manifold deb;
    static typename Manifold::OutType& cout;
    static typename Manifold::OutType& cerr;
    static typename Manifold::EndlType& endl;
    static bool const enable = Manifold::enable;
  };
  template <unsigned flag>
    typename DEBUG<flag>::Manifold DEBUG<flag>::deb;
  template <unsigned flag>
    typename DEBUG<flag>::Manifold::OutType& DEBUG<flag>::cout = DEBUG<flag>::deb.cout;
  template <unsigned flag>
    typename DEBUG<flag>::Manifold::OutType& DEBUG<flag>::cerr = DEBUG<flag>::deb.cerr;
  template <unsigned flag>
    typename DEBUG<flag>::Manifold::EndlType& DEBUG<flag>::endl = DEBUG<flag>::deb.endl;
}

#undef ENABLE_DEBUG
#undef ENABLE_DEBUG_VALUE
