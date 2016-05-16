#pragma once

#include <cassert>
#include <stdlib.h>
#include <sys/types.h>

namespace net {
  namespace util {
    struct SafeListPoolDefault {
      static const bool value = true;
    };
    // forward declarations
    template <class T, bool pool = SafeListPoolDefault::value> class SafeList;
    template <class T, bool pool = SafeListPoolDefault::value> class SharedSafeList;
    template <class T, bool pool = SafeListPoolDefault::value> class SafeListMonad;
    template <class T, bool pool = SafeListPoolDefault::value> class SafeListIterator;
    template <class T, bool pool = SafeListPoolDefault::value> class SafeListHeadItem;
    template <class T, bool pool = SafeListPoolDefault::value> class SafeListItem;

    template <class T, bool pool> struct DestroySafeListItems {
      static void dtorContent(SafeListItem<T,pool>* sli);
    };

    // no need to free the item, as the destructor is guaranteed trivial
    template <class T_, bool pool> struct DestroySafeListItems<T_*,pool> {
      static void dtorContent(SafeListItem<T_*,pool>* sli) {}
    };
    template <bool pool> struct DestroySafeListItems<int,pool> {
      static void dtorContent(SafeListItem<int,pool>* sli) {}
    };
    template <bool pool> struct DestroySafeListItems<size_t,pool> {
      static void dtorContent(SafeListItem<size_t,pool>* sli) {}
    };
    // ... may add additional specialsations

    template <typename T> struct PassContentAs {
      typedef T const& Type;
    };
    template <typename T> struct PassContentAs<T&> {
      typedef T& Type;
    };
    template <typename T> struct PassContentAs<T*> {
      typedef T* Type;
    };

    template <class T, bool pool> class SafeListItem {
      friend class SafeList<T,pool>;
      friend class SafeListIterator<T,pool>;
      friend class DestroySafeListItems<T,pool>;
      public:
        typedef typename PassContentAs<T>::Type Tref;
      private:
        SafeListItem* left;
        SafeListItem* right;
        SafeListHeadItem<T,pool>* head;
        char content_space[sizeof(T)]; // always access via the content member!
        struct Arena {
          SafeListItem* list;
          Arena() : list(NULL) {}
          void cleanup() {
            SafeListItem* const old = list;
            while (list) {
              list->left = NULL;
              SafeListItem* const i = list->right;
              delete list;
              list = (i == old)?NULL:i;
            }
          }
          ~Arena() {
            cleanup();
          }
        };
        static Arena arena;
        SafeListItem(Tref c, SafeListItem *l, SafeListItem *r)
          : left(l), right(r), head(l->head), content(*(new(content_space) T(c))) { // O(1)
          // We are implementing a ring-list, so there must always be a right
          // and a left neighbour.
          assert(left && "left must not be NULL!");
          assert(right && "right must not be NULL!");
          assert(left->head == right->head && "Cannot join two lists.");
        }
        SafeListItem(SafeListItem const&); // not implemented
      protected:
        // we are actually part of a Head, so don't properly initialise content
        SafeListItem(SafeListHeadItem<T,pool>* head)
          : left(this), right(this), head(head), content(*(static_cast<T*>(0))) {} // O(1)
        ~SafeListItem() {
          if (&content)
            content.~T();
        }
      public:
        T& content;
        bool check() const { // O(1)
          return ((right->left == this) && (left->right == this));
        }
        // If 'this' is not a sentinel element this will work fine, otherwise
        // you will get 'true' for an empty list (only containing the sentinel)
        bool isSingleton() const { // O(1)
          return left == right;
        }
        static SafeListItem* allocate(Tref c, SafeListItem* l, SafeListItem* r) {
          if (arena.list == 0)
            return new SafeListItem(c,l,r);
          SafeListItem* const result = arena.list;
          if (arena.list == arena.list->right) {
            arena.list = 0;
          } else {
            arena.list->left->right = arena.list->right;
            arena.list->right->left = arena.list->left;
            arena.list = arena.list->right;
          }
          return new(result) SafeListItem(c,l,r);
        }
        static void reclaimAll(SafeListItem* i) {
          assert(i && i->left && i->right && "Cannot reclaim nonsense");
          if (pool) {
            DestroySafeListItems<T,pool>::dtorContent(i);
            if (arena.list == 0) {
              arena.list = i;
            } else {
              arena.list->left->right = i;
              i->left->right = arena.list;
              SafeListItem* const left = arena.list->left;
              arena.list->left = i->left;
              i->left = left;
            }
            arena.list->check();
            arena.list->left->check();
            arena.list->right->check();
            // NOTE: calling ~SafeListItem on each item is omitted for efficiency.
            // This is a pointer specialisation anyway!
          } else {
            i->left->right = NULL;
            do {
              SafeListItem* p = i->right;
              delete i;
              i = p;
            } while (i);
          }
        }
    };
    template <class T,bool pool> typename SafeListItem<T,pool>::Arena SafeListItem<T,pool>::arena;

    template <class T, bool pool>
    void DestroySafeListItems<T,pool>::dtorContent(SafeListItem<T,pool>* sli) {
      for (SafeListItem<T,pool>* it = sli->right; it != sli; it = it->right) {
        // we never pool heads, and we never delete them, so we know all items are not 0!
        it->content.T::~T();
      }
    }

    template <class T, bool pool> class SafeListHeadItem : public SafeListItem<T,pool> {
      friend class SafeList<T,pool>;
      friend class SafeListMonad<T,pool>;
      friend class SafeListIterator<T,pool>;
      private:
        SafeList<T,pool> const* const list;
      public:
        SafeListHeadItem(SafeList<T,pool> const* list) : SafeListItem<T,pool>(this), list(list) {
        }
    };

    template <class T, bool pool> class SafeList {
      friend class SafeListIterator<T,pool>;
      friend class SafeListMonad<T,pool>;
      // This is a sentinelled ring-list, to use if you really don't care about
      // the ordering. Also, don't expect set-behaviour.
      private:
        SafeListHeadItem<T,pool> head; // head is always the sentinel!
        size_t _size;
        typedef unsigned Lock;
        // Locks will be optimised because it is private and never set in this class.
        mutable Lock locks;
        Lock getLock() const { // O(1)
          locks++;
          assert(locks && "Lock limit reached (overflow detected). What on earth did you do?");
          return locks;
        }
        Lock releaseLock() const { // O(1)
          assert(locks && "Attempt to unlock a non-locked list.");
          return --locks;
        }
        SafeList(SafeList const& takeover) __attribute__ ((deprecated)) : head(this), _size(0), locks(0) { // O(1)
          assert(0 && "Calling COPY-CTOR of SafeList is not supported.");
        }
      public:
        typedef SafeListIterator<T,pool> iterator;
        SafeList() : head(this), _size(0), locks(0) { // O(1)
          assert(head.check());
          assert(head.list == this);
        }
        size_t size() const {
          return _size;
        }
        ~SafeList() { // O(1)
          assert((!locks) && "Attempt to destroy a locked list.");
          // The list is empty iff head is the only element in the list.
          //if (!(&head == head.left && &head == head.right)) {
          //  std::cout << "[" << this << "] ~SafeList while not empty!!!" << std::endl;
          //  for (SafeListIterator<T> it(*this); it.more(); it.next()) {
          //    std::cout << "[" << this << "]    - " << it.get() << std::endl;
          //  }
          //}
          assert(&head == head.left && &head == head.right && "Attempt to destroy a non-empty list.");
        }
        unsigned char isLocked() const { // O(1)
          return locks;
        }
        SafeListItem<T,pool>* put(typename SafeListItem<T,pool>::Tref c) { // O(1)
          //std::cout << "[" << this << "] put(" << c << ")" << std::endl;
          assert((!locks) && "Attempt to modify locked list by insertion.");
          assert(head.right && "Invalid FL: right is NULL");
          _size++;
          // We insert the element between 'head' and 'head.right'.
          head.right->left = (SafeListItem<T,pool>::allocate(c, &head, head.right));
          head.right = head.right->left;
          assert(head.check() && head.right->check() &&
            "SafeList::put produced an inconsistent result. I cannot recover, sorry.");
          return head.right;
        }
        void drop(SafeListItem<T,pool> *i) { // O(1)
          //std::cout << "[" << this << "] drop(" << i->content << ")" << std::endl;
          assert(i);
          assert(i->head && "Attempt to delete an item without list.");
          assert(i->head == &head && "Attempt to delete foreign item.");
          // This is essentially impossible outside the list, but better safe than sorry.
          assert(i != i->head && "Attempt to delete sentinel element.");
          assert(!locks && "Attempt to modify locked list by deletion.");
          _size -= i != i->right;
          i->left->right = i->right;
          i->right->left = i->left;
          i->left = i;
          i->right = i;
          SafeListItem<T,pool>::reclaimAll(i);
        }
        void dropAll() { // O(1)
          //std::cout << "[" << this << "] dropAll()" << std::endl;
          assert((!locks) && "Attempt to clear locked list.");
          if (_size) {
            _size = 0;
            head.left->right = head.right;
            head.right->left = head.left;
            SafeListItem<T,pool>::reclaimAll(head.right);
            head.left = head.right = &head;
          }
        }
    };

    template <class T, bool pool> class SafeListIterator {
      private:
        SafeListHeadItem<T,pool> const* head;
        SafeListItem<T,pool>* move;
        ssize_t remaining;
      public:
        // use this at your own risk! iterating WILL THROW A SEGFAULT!
        // more() will work, however
        // the reason for this constructor is to delay the assignment (call 'reassign' before using the object)
        SafeListIterator() : head(NULL), move(NULL), remaining(0) {}
        ~SafeListIterator() {
          unassign();
        }
        // for(SafeListIterator it(sl); it.more(); it.next()) {dostuff(it.get());}
        // call 'get' when there are no more elements and get bogus!
        SafeListIterator(SafeList<T,pool> const* sl) : head(NULL), move(NULL), remaining(0) {
          reassign(sl);
        }
        SafeListIterator(SafeList<T,pool> const& sl) : head(NULL), move(NULL), remaining(0) {
          reassign(sl);
        }
        SafeListIterator(SharedSafeList<T,pool> const* sl) : head(NULL), move(NULL), remaining(0) {
          reassign(sl);
        }
        SafeListIterator(SharedSafeList<T,pool> const& sl) : head(NULL), move(NULL), remaining(0) {
          reassign(sl);
        }
        void unassign() {
          if (head) {
            // remove the old lock
            head->list->releaseLock();
            head = NULL;
            move = NULL;
          }
        }
        void reassign(SafeList<T,pool> const& sl) {
          unassign();
          // we are friends with SafeList<T>
          head = &(sl.head);
          sl.getLock();
          restart();
        }
        void reassign(SafeList<T,pool> const* sl) {
          reassign(*sl);
        }
        void reassign(SharedSafeList<T,pool> const& sl) {
          reassign(*(sl.safeList));
        }
        void reassign(SharedSafeList<T,pool> const* sl) {
          reassign(*sl);
        }
        void restart() {
          remaining = head->list->size();
          move = head->right;
        }
        bool more() const {
          assert(remaining >= 0 && "SafeList bounds overrun");
          return move != head;
        }
        void next() {
          assert(remaining-- > 0 && "SafeList bounds overrun");
          move = move->right;
        }
        T get() const {
          assert(remaining > 0 && "SafeList bounds overrun");
          return move->content;
        }
        bool empty() const {
          return move == move->right;
        }
        bool singleton() const {
          return singletonOrEmpty() > empty();
        }
        bool singletonOrEmpty() const {
          // sometimes we already know there is stuff in there
          // (besides the sentinel which does not count)
          return move == move->right->right;
        }
    };

  }
}

