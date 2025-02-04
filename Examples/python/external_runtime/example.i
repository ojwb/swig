/* File : example.i */
%module(docstring="external runtime") example

%{
#include <iostream>
#include "example.h"
%}

%typemap(in) SWIG_Object pyCallable
{
  if ($input)
  {
    SWIG_Object pyMesh = PyObject_CallMethod($input, const_cast<char *>("mesh"), const_cast<char *>("()"));
    if (!pyMesh)
      throw std::runtime_error("null pyMesh");
    void * ptr = 0;
    if (SWIG_IsOK(SWIG_ConvertPtr(pyMesh, &ptr, SWIG_TypeQuery("Mesh *"), 0)))
    {
      Mesh *mesh = reinterpret_cast< Mesh * >(ptr);
      if (!mesh)
        throw std::runtime_error("null mesh");
      const int value = mesh->value();
      std::cout << "value="<<value<<std::endl;
      if (value != 42)
        throw std::runtime_error("wrong value");
    }
  }
}


%include "example.h"

%inline {

class Function
{
public:
	explicit Function(SWIG_Object pyCallable = 0);
	int meshValue() { return meshValue_;}

private:
	SWIG_Object pyObj_;
	int meshValue_;
};

Function::Function(SWIG_Object pyCallable)
: pyObj_(pyCallable), meshValue_(0)
{
  // stuff happens in the typemap of PyObject * pyCallable
}

}

%inline %{
// The -builtin SWIG option results in SWIGPYTHON_BUILTIN being defined
#ifdef SWIGPYTHON_BUILTIN
bool is_python_builtin() { return true; }
#else
bool is_python_builtin() { return false; }
#endif
%}
