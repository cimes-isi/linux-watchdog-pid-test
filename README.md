# Linux Watchdog PID Test

This is a simple test for Linux's watchdog daemon monitoring a process.
In this test, the kernel watchdog device `/dev/watchdog` is not opened by the daemon, so the system will not actually shutdown or reboot due to failures.

The test starts a dummy application (script) which just loops infinitely, then launches the watchdog to monitor that application's process ID.
The test script listens for syslog messages from the watchdog.
The dummy application is eventually stopped, at which point the watchdog messages change to indicate that it can no longer ping the dummy application.
After a short period, the test ends.

The user is responsible for verifying that the output from the watchdog logs appear correct.
For example:

```sh
$ sudo ./watchdog-test.sh 
Dummy application is running...
Dummy application is running...
Sep 19 14:20:23 centos7-dev watchdog[38872]: starting daemon (5.13):
Sep 19 14:20:23 centos7-dev watchdog[38872]: int=10s realtime=no sync=no soft=no mla=0 mem=0
Sep 19 14:20:23 centos7-dev watchdog[38872]: ping: no machine to check
Sep 19 14:20:23 centos7-dev watchdog[38872]: file: no file to check
Sep 19 14:20:23 centos7-dev watchdog[38872]: pidfile: /var/run/dummy.pid
Sep 19 14:20:23 centos7-dev watchdog[38872]: interface: no interface to check
Sep 19 14:20:23 centos7-dev watchdog[38872]: test=none(0) repair=none(0) alive=none heartbeat=none temp=none to=root no_act=yes
Sep 19 14:20:23 centos7-dev watchdog[38872]: was able to ping process 38866 (/var/run/dummy.pid).
Dummy application is running...
Dummy application is running...
Dummy application is running...
Dummy application is running...
Sep 19 14:20:28 centos7-dev watchdog[38872]: still alive after 1 interval(s)
Sep 19 14:20:28 centos7-dev watchdog[38872]: was able to ping process 38866 (/var/run/dummy.pid).
Dummy application is running...
Dummy application is running...
Dummy application is running...
Dummy application is running...
Dummy application is running...
Sep 19 14:20:33 centos7-dev watchdog[38872]: still alive after 2 interval(s)
Sep 19 14:20:33 centos7-dev watchdog[38872]: was able to ping process 38866 (/var/run/dummy.pid).
Stopping dummy application, watchdog should fail to ping it now
Dummy application is running...
./watchdog-test.sh: line 31: 38866 Terminated              ./dummy.sh "${DUMMY_APP_PID_FILE}"
Sep 19 14:20:38 centos7-dev watchdog[38872]: still alive after 3 interval(s)
Sep 19 14:20:38 centos7-dev watchdog[38872]: pinging process 38866 (/var/run/dummy.pid) gave errno = 3 = 'No such process'
Sep 19 14:20:43 centos7-dev watchdog[38872]: still alive after 4 interval(s)
Sep 19 14:20:43 centos7-dev watchdog[38872]: pinging process 38866 (/var/run/dummy.pid) gave errno = 3 = 'No such process'
```
