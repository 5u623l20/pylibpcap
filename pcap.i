
/*
 * $Id$
 * Python libpcap
 * Copyright (C) 2001,2002, David Margrave
 * Based PY-libpcap (C) 1998, Aaron L. Rhodes

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the BSD Licence
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 */

%module pcap

#define DOC(NAME, VALUE)\
%{\
static char _doc_##NAME[] = VALUE;\
%}

%include doc.i

#define __doc__ pcap_doc


%{
#include <pcap.h>
#include "pypcap.h"
%}

%include constants.i



%init %{
  /* d is the dictionary for the current module */
  init_errors(d);

%}

/* typemaps */

/* let functions return raw python objects */
%typemap(python, out) PyObject * {
  $result = $1;
}

/* let functions take raw python objects */
%typemap(python, in) PyObject * {
  $1 = $input;
}




%except (python) {
  int err;
  clear_exception();
  $function
  if ((err = check_exception())) {
    set_error(err, get_exception_message());
    return NULL;
  }
  else if(PyErr_Occurred()) {
    return NULL;
  }
}



typedef struct {
  pcap_t *pcap;
  DOC(pcapObject_pcap_set,"set pcapObject pcap attribute")
  DOC(pcapObject_pcap_get,"get pcapObject pcap attribute")
  pcap_dumper_t *pcap_dumper;
  DOC(pcapObject_pcap_dumper_set,"set pcapObject pcap_dumper attribute")
  DOC(pcapObject_pcap_dumper_get,"get pcapObject pcap_dumper attribute")
  PyObject *callback;
  DOC(pcapObject_callback_set,"set pcapObject callback attribute")
  DOC(pcapObject_callback_get,"get pcapObject callback attribute")
  %extend {
    pcapObject(void);
    DOC(new_pcapObject,"create a pcapObject instance")
    ~pcapObject(void);
    DOC(delete_pcapObject,"destroy a pcapObject instance")
    void open_live(char *device, int snaplen, int promisc, int to_ms);
    DOC(pcapObject_open_live,pcapObject_open_live_doc)
    void open_dead(int linktype, int snaplen);
    DOC(pcapObject_open_dead,pcapObject_open_dead_doc)
    void open_offline(char *filename);
    DOC(pcapObject_open_offline,pcapObject_open_offline_doc)
    void dump_open(char *fname);
    DOC(pcapObject_dump_open,pcapObject_dump_open_doc)
    void setnonblock(int nonblock);
    DOC(pcapObject_setnonblock,pcapObject_setnonblock_doc)
    int getnonblock(void);
    DOC(pcapObject_getnonblock,pcapObject_getnonblock_doc)
    /* maybe change netmask to a bpf_u_32, but need a typemap */
    void setfilter(char *str, int optimize, int netmask);
    DOC(pcapObject_setfilter,pcapObject_setfilter_doc)
    void loop(int cnt, PyObject *PyObj);
    DOC(pcapObject_loop,pcapObject_loop_doc)
    void dispatch(int cnt, PyObject *PyObj);
    DOC(pcapObject_dispatch,pcapObject_dispatch_doc)
    PyObject *next(void);
    DOC(pcapObject_next,pcapObject_next_doc)
    int datalink(void);
    DOC(pcapObject_datalink,pcapObject_datalink_doc)
    int snapshot(void);
    DOC(pcapObject_snapshot,pcapObject_snapshot_doc)
    int is_swapped(void);
    DOC(pcapObject_is_swapped,pcapObject_is_swapped_doc)
    int major_version(void);
    DOC(pcapObject_major_version,pcapObject_major_version_doc)
    int minor_version(void);
    DOC(pcapObject_minor_version,pcapObject_minor_version_doc)
    PyObject *stats(void);
    DOC(pcapObject_stats,pcapObject_stats_doc)
    int fileno(void);
    DOC(pcapObject_fileno,pcapObject_fileno_doc)

  }
} pcapObject;


/* functions not associated with a pcapObject instance */
char *lookupdev(void);
DOC(lookupdev,lookupdev_doc)
PyObject *findalldevs(void);
DOC(findalldevs,findalldevs_doc)
PyObject *lookupnet(char *device);
DOC(lookupnet,lookupnet_doc)
void PythonCallBack(u_char *PyFunc,
                    const struct pcap_pkthdr *header,
                    const u_char *packetdata);
DOC(PythonCallBack,"internal function - do not use")

/* useful non-pcap functions */
PyObject *aton(char *cp);
DOC(aton,"aton(addr)\n\nconvert dotted decimal IP string to network byte order int")
char *ntoa(int addr);
DOC(ntoa,"ntoa(addr)\n\nconvert network byte order int to dotted decimal IP string")

