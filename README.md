# indiana-robot
RobotFramework with SSHLibrary etc

```
ejojmjn@ejojmjn-dev:~/indiana-robot[:]$ docker run -v $PWD:/testsuite jljohansson/indiana-docker:alpine
==============================================================================
Testsuite                                                                     
==============================================================================
Testsuite.Udmhealth :: UDM HealthCheck                                        
==============================================================================
Ask NRF for serving AUSF for 240800000100001 :: As AMF                ^C| FAIL |
Execution terminated by signal
------------------------------------------------------------------------------
Testsuite.Udmhealth :: UDM HealthCheck                                | FAIL |
1 critical test, 0 passed, 1 failed
1 test total, 0 passed, 1 failed
==============================================================================
Testsuite                                                             | FAIL |
1 critical test, 0 passed, 1 failed
1 test total, 0 passed, 1 failed
==============================================================================
Output:  /testsuite/output.xml
Log:     /testsuite/log.html
Report:  /testsuite/report.html
Second signal will force exit.
ejojmjn@ejojmjn-dev:~/indiana-robot[:]$ 
```
