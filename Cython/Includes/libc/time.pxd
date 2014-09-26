# http://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/time.h.html

from posix.types cimport clock_t, clockid_t, suseconds_t, time_t, timer_t
from libc.stddef cimport wchar_t

cdef extern from "time.h" nogil:
    enum: CLOCKS_PER_SEC
    clock_t clock()             # CPU time
    time_t  time(time_t *)      # wall clock time since Unix epoch

    cdef struct tm:
        int  tm_sec
        int  tm_min
        int  tm_hour
        int  tm_mday
        int  tm_mon
        int  tm_year
        int  tm_wday
        int  tm_yday
        int  tm_isdst
        char *tm_zone
        long tm_gmtoff

    int     daylight            # global state
    long    timezone
    char    *tzname[2]
    void    tzset()

    char    *asctime(const tm *)
    char    *asctime_r(const tm *, char *)
    char    *ctime(const time_t *)
    char    *ctime_r(const time_t *, char *)
    double  difftime(time_t, time_t)
    tm      *getdate(const char *)
    tm      *gmtime(const time_t *)
    tm      *gmtime_r(const time_t *, tm *)
    tm      *localtime(const time_t *)
    tm      *localtime_r(const time_t *, tm *)
    time_t  mktime(tm *)
    size_t  strftime(char *, size_t, const char *, const tm *)
    size_t  wcsftime(wchar_t *str, size_t cnt, const wchar_t *fmt, tm *time)
    char    *strptime(const char *, const char *, tm *)     # POSIX not stdC