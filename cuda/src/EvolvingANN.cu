#include <Python.h>
#include "Brain.h"
#include "Hyperparameters.h"


static PyObject *eann_init(PyObject *self, PyObject *args)
{
    const char *log_dir;

    if (!PyArg_ParseTuple(args, "s", &log_dir))
    {
      printf("This function takes 1 string for log_dir");
      return NULL;
    }
    printf("log dir is: %s", log_dir);
    int success = init(log_dir);
    return PyLong_FromLong((long) success);
}

static PyObject *eann_think(PyObject *self, PyObject *args)
{
  PyObject *obj;
  int *brain_input;

  if (!PyArg_ParseTuple(args, "O", &obj)) {
    printf("argument has to be exactly one list");
    return NULL;
  }

  PyObject *iter = PyObject_GetIter(obj);
  if (!iter) {
    printf("argument has to be a list");
    return NULL;
  }

  int len = Py_SAFE_DOWNCAST(PyObject_Size(obj), Py_ssize_t, int);
  if(len != NUM_INPUTS){
    //error
    printf("ERROR number of provided inputs (%d) does not equal number of input neurons (%d)", len, NUM_INPUTS);
  }
  brain_input = (int*) malloc(sizeof(int) * len);
  for(int element = 0; element < len; element++){
    PyObject *next = PyIter_Next(iter);
    brain_input[element] = (int) PyFloat_AsDouble(next);
  }

  int *outputs = think(brain_input);
  //printf("output_length %d\n", output_length);
  free(brain_input);

  PyObject *output_list = PyList_New(NUM_OUTPUTS);
  for (int i = 0; i < NUM_OUTPUTS; i++) {
    PyList_SET_ITEM(output_list, i, PyFloat_FromDouble((double)outputs[i]));
  }

  return output_list;
}

static PyObject *eann_reward(PyObject *self, PyObject *args)
{
    float reward;

    if (!PyArg_ParseTuple(args, "f", &reward))
    {
      printf("This function takes 1 integer argument reward)");
      return NULL;
    }
    process_reward(reward);
    Py_RETURN_NONE;
}

static PyObject *write_to_tensorboard(PyObject *self, PyObject *args)
{
    write_tensorboard();
    Py_RETURN_NONE;
}

static PyObject *eann_release_memory(PyObject *self, PyObject *args)
{
    release_memory();
    Py_RETURN_NONE;
}

static PyObject *eann_reset_memory(PyObject *self, PyObject *args)
{
    reset_memory();
    Py_RETURN_NONE;
}

static PyMethodDef methods[] = {
    {"init", eann_init, METH_VARARGS, "intitialize brain"},
    {"think", eann_think, METH_VARARGS, "think"},
    {"reward", eann_reward, METH_VARARGS, "reward brain"},
    {"reset_memory", eann_reset_memory, METH_VARARGS, "reset memory"},
    {"release_memory", eann_release_memory, METH_VARARGS, "free all allocated memory"},
    {"write_to_tensorboard", write_to_tensorboard, METH_VARARGS, "writing information to .event file for tensorbard"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef eann_module = {
    PyModuleDef_HEAD_INIT,
    "eann", /* module name */
    NULL, /* module documentation, may be NULL */
    -1,
    methods /* the methods array */
};


PyMODINIT_FUNC PyInit_eann(void)
{
    return PyModule_Create(&eann_module);
}
