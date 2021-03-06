// SWIG file OptimizationAlgorithmImplementation.i

%{
#include "openturns/OptimizationAlgorithmImplementation.hxx"
#include "openturns/PythonWrappingFunctions.hxx"

static void OptimizationAlgorithmImplementation_ProgressCallback(OT::Scalar percent, void * data) {
  PyObject * pyObj = reinterpret_cast<PyObject *>(data);
  OT::ScopedPyObjectPointer point(OT::convert< OT::Scalar, OT::_PyFloat_ >(percent));
  OT::ScopedPyObjectPointer result(PyObject_CallFunctionObjArgs( pyObj, point.get(), NULL ));
}

static OT::Bool OptimizationAlgorithmImplementation_StopCallback(void * data) {
  PyObject * pyObj = reinterpret_cast<PyObject *>(data);
  OT::ScopedPyObjectPointer result(PyObject_CallFunctionObjArgs( pyObj, NULL ));
  return OT::convert< OT::_PyInt_, OT::UnsignedInteger >(result.get());
}
%}

%include OptimizationAlgorithmImplementation_doc.i

%ignore OT::OptimizationAlgorithmImplementation::setProgressCallback(ProgressCallback callBack, void * data);
%ignore OT::OptimizationAlgorithmImplementation::setStopCallback(StopCallback callBack, void * data);

%include openturns/OptimizationAlgorithmImplementation.hxx
namespace OT{ %extend OptimizationAlgorithmImplementation {


OptimizationAlgorithmImplementation(const OptimizationAlgorithmImplementation & other) {
  return new OT::OptimizationAlgorithmImplementation(other);
}

void setProgressCallback(PyObject * callBack) {
  if (PyCallable_Check(callBack)) {
    self->setProgressCallback(&OptimizationAlgorithmImplementation_ProgressCallback, callBack);
  }
  else {
    throw OT::InvalidArgumentException(HERE) << "Argument is not a callable object.";
  }
}

void setStopCallback(PyObject * callBack) {
  if (PyCallable_Check(callBack)) {
    self->setStopCallback(&OptimizationAlgorithmImplementation_StopCallback, callBack);
  }
  else {
    throw OT::InvalidArgumentException(HERE) << "Argument is not a callable object.";
  }
}

} }
