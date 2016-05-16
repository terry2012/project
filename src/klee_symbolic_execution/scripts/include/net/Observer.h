#pragma once

#include <set>
#include <utility>

namespace net {

  template <typename T> class Observable;

  template <typename T> class Observer {
    friend class Observable<T>;
    protected:
      virtual ~Observer() {}
      virtual void notify(Observable<T>* observable) = 0;
      virtual void notifyNew(Observable<T>* observable, Observable<T> const* toldBy) = 0;
      virtual void notifyDie(Observable<T> const* observable) = 0;
  };

  template <typename T> class Observable {
    private:
      typedef typename std::set<Observer<T>*> Subscribers;
      Subscribers subscribers;
      // hide default-ctor and copy-ctor
      Observable() : observed(0) {
      }
      Observable(Observable<T> const& from) : observed(0) {
      }
    protected:
      virtual void change() {
        for (typename Subscribers::iterator it = subscribers.begin(),
                                            en = subscribers.end(); it != en; ++it) {
          (*it)->notify(this);
        }
      }

      virtual void assimilate(Observable<T>* drone) const {
        for (typename Subscribers::const_iterator it = subscribers.begin(),
                                                  en = subscribers.end(); it != en; ++it) {
          (*it)->notifyNew(drone, this);
        }
      }
      // we are only instantiable by our kids
      Observable(T* whoami) : observed(whoami) {
      }
      virtual ~Observable() {
        Subscribers copy;
        copy.swap(subscribers);
        for (typename Subscribers::iterator it = copy.begin(),
                                            en = copy.end(); it != en; ++it) {
          (*it)->notifyDie(this);
        }
      }
    public:
      T* const observed;
      void add(Observer<T>& o) {
        subscribers.insert(&o);
      }
      void add(Observer<T>* o) {
        subscribers.insert(o);
      }
      void remove(Observer<T>& o) {
        subscribers.erase(&o);
      }
      void remove(Observer<T>* o) {
        subscribers.erase(o);
      }
  };

  template <typename T> class AutoObserver : public Observer<T> {
    protected:
      virtual void notifyNew(Observable<T>* observable, Observable<T> const* toldBy) {
        observable->add(this);
      }
      virtual void notifyDie(Observable<T> const* observable) {
      }
  };
}


