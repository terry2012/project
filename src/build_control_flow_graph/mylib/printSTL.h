#ifndef PRINTSTL_H
#define PRINTSTL_H
#include <stack>
#include <vector>
#include <map>
#include <set>
#include <queue>
#include <ostream>

template <class Container, class Stream>
Stream& printOneValueContainer
    (Stream& outputstream, const Container& container)
{
    typename Container::const_iterator beg = container.begin();

    outputstream << " ["; 
    while(beg != container.end())
    {
        outputstream << " " << *beg++;
    }

    outputstream << " ]";

    return outputstream;
}

template < class Type, class Container >
const Container& container
    (const std::stack<Type, Container>& stack)
{
    struct HackedStack : private std::stack<Type, Container>
    {
        static const Container& container
            (const std::stack<Type, Container>& stack)
        {
            return stack.*&HackedStack::c;
        }
    };

    return HackedStack::container(stack);
}

template < class Type, class Container >
const Container& container
    (const std::queue<Type, Container>& queue)
{
    struct HackedQueue : private std::queue<Type, Container>
    {
        static const Container& container
            (const std::queue<Type, Container>& queue)
        {
            return queue.*&HackedQueue::c;
        }
    };

    return HackedQueue::container(queue);
}
 


template
    < class Type
    , template <class Type, class Container = std::deque<Type> > class Adapter
    , class Stream
    >
Stream& operator<<
    (Stream& outputstream, const Adapter<Type>& adapter)
{
    return printOneValueContainer(outputstream, container(adapter));
}

template<class Stream,class T1,class T2>
Stream& operator<<
    (Stream& outputstream, const struct std::pair<T1,T2>& p)
{
    outputstream << "["<<p.first 
    	<< ","<<p.second<<"]\n";
    return outputstream;
}

template
    < class Type
    , class Stream
    >
Stream& operator<<
    (Stream& outputstream, const std::vector<Type>& v)
{
	 typename std::vector<Type>::const_iterator beg = v.begin();
	  outputstream << " [ "; 
	  while(beg != v.end())
	  {
	      outputstream << " " <<**beg++;
	  }

	 outputstream << " ]\n";
 	return outputstream;
}

template
    < class Type
    , class Stream
    >
Stream& operator<<
    (Stream& outputstream, const std::deque<Type>& v)
{
	 typename std::deque<Type>::const_iterator beg = v.begin();
	//  outputstream << " ["; 
	  while(beg != v.end())
	  {
	      outputstream << " " << *beg++;
	  }

	 // outputstream << " ]";
 	return outputstream;
}

template
    < class Key
    ,	class Value
    , class Stream
    >
Stream& operator<<
    (Stream& outputstream, const std::map<Key,Value>& v)
{
	 typename std::map<Key,Value>::const_iterator beg = v.begin();
	//  outputstream << " ["; 
	  while(beg != v.end())
	  {
	      outputstream << " " << beg->first/*->getName() */<<","<<beg->second<<"\n";
	      beg++;
	  }

	 // outputstream << " ]";
 	return outputstream;
}

 

template
    < class Type 
    , class Stream
    >
Stream& operator<<
    (Stream& outputstream, const std::set<Type  >& v)
{
	 typename std::set<Type>::const_iterator beg = v.begin();
	//  outputstream << "["; 
	  while(beg != v.end())
	  {
	      outputstream << " " << * beg++<<"\n";
	  }

	//  outputstream << " ]";
 	return outputstream;
}
#endif